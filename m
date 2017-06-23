From: akpm@linux-foundation.org
Subject: [patch 8/8] fs/exec.c: account for argv/envp pointers
Date: Fri, 23 Jun 2017 15:08:57 -0700
Message-ID: <594d9179.2uuOaozXe/6vn6cY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33062 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752606AbdFWWI7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2017 18:08:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, keescook@chromium.org, mhocko@suse.com, qsa@qualys.com, riel@redhat.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk

From: Kees Cook <keescook@chromium.org>
Subject: fs/exec.c: account for argv/envp pointers

When limiting the argv/envp strings during exec to 1/4 of the stack limit,
the storage of the pointers to the strings was not included.  This means
that an exec with huge numbers of tiny strings could eat 1/4 of the stack
limit in strings and then additional space would be later used by the
pointers to the strings.  For example, on 32-bit with a 8MB stack rlimit,
an exec with 1677721 single-byte strings would consume less than 2MB of
stack, the max (8MB / 4) amount allowed, but the pointers to the strings
would consume the remaining additional stack space (1677721 * 4 ==
6710884).  The result (1677721 + 6710884 == 8388605) would exhaust stack
space entirely.  Controlling this stack exhaustion could result in
pathological behavior in setuid binaries (CVE-2017-1000365).

[akpm@linux-foundation.org: additional commenting from Kees]
Fixes: b6a2fea39318 ("mm: variable length argument support")
Link: http://lkml.kernel.org/r/20170622001720.GA32173@beast
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Qualys Security Advisory <qsa@qualys.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff -puN fs/exec.c~exec-account-for-argv-envp-pointers fs/exec.c
--- a/fs/exec.c~exec-account-for-argv-envp-pointers
+++ a/fs/exec.c
@@ -220,8 +220,26 @@ static struct page *get_arg_page(struct
 
 	if (write) {
 		unsigned long size = bprm->vma->vm_end - bprm->vma->vm_start;
+		unsigned long ptr_size;
 		struct rlimit *rlim;
 
+		/*
+		 * Since the stack will hold pointers to the strings, we
+		 * must account for them as well.
+		 *
+		 * The size calculation is the entire vma while each arg page is
+		 * built, so each time we get here it's calculating how far it
+		 * is currently (rather than each call being just the newly
+		 * added size from the arg page).  As a result, we need to
+		 * always add the entire size of the pointers, so that on the
+		 * last call to get_arg_page() we'll actually have the entire
+		 * correct size.
+		 */
+		ptr_size = (bprm->argc + bprm->envc) * sizeof(void *);
+		if (ptr_size > ULONG_MAX - size)
+			goto fail;
+		size += ptr_size;
+
 		acct_arg_size(bprm, size / PAGE_SIZE);
 
 		/*
@@ -239,13 +257,15 @@ static struct page *get_arg_page(struct
 		 *    to work from.
 		 */
 		rlim = current->signal->rlim;
-		if (size > ACCESS_ONCE(rlim[RLIMIT_STACK].rlim_cur) / 4) {
-			put_page(page);
-			return NULL;
-		}
+		if (size > READ_ONCE(rlim[RLIMIT_STACK].rlim_cur) / 4)
+			goto fail;
 	}
 
 	return page;
+
+fail:
+	put_page(page);
+	return NULL;
 }
 
 static void put_arg_page(struct page *page)
_
