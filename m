From: akpm@linux-foundation.org
Subject: [merged]
 exec-remove-the-no-longer-needed-remove_arg_zero-free_arg_page.patch
 removed from -mm tree
Date: Fri, 27 May 2016 11:43:31 -0700
Message-ID: <57489553.4KGFutwdod3xrLAe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42502 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbcE0Snc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:43:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exec: remove the no longer needed remove_arg_zero()->free_arg_page()
has been removed from the -mm tree.  Its filename was
     exec-remove-the-no-longer-needed-remove_arg_zero-free_arg_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: exec: remove the no longer needed remove_arg_zero()->free_arg_page()

remove_arg_zero() does free_arg_page() for no reason.  This was needed
before and only if CONFIG_MMU=y: see the commit 4fc75ff4 ("exec: fix
remove_arg_zero"), install_arg_page() was called for every page != NULL in
bprm->page[] array.  Today install_arg_page() has already gone and
free_arg_page() is nop after another commit b6a2fea39 ("mm: variable
length argument support").

CONFIG_MMU=n does free_arg_pages() in free_bprm() and thus it doesn't need
remove_arg_zero()->free_arg_page() too; apart from get_arg_page() it never
checks if the page in bprm->page[] was allocated or not, so the "extra"
non-freed page is fine.  OTOH, this free_arg_page() can add the minor
pessimization, the caller is going to do copy_strings_kernel() right after
remove_arg_zero() which will likely need to re-allocate the same page
again.

And as Hujunjie pointed out, the "offset == PAGE_SIZE" check is wrong
because we are going to increment bprm->p once again before return, so
CONFIG_MMU=n "leaks" the page anyway if '0' is the final byte in this
page.

NOTE: remove_arg_zero() assumes that argv[0] is null-terminated but this
is not necessarily true.  copy_strings() does "len = strnlen_user(...)",
then copy_from_user(len) but another thread or debuger can overwrite the
trailing '0' in between.  Afaics nothing really bad can happen because we
must always have the null-terminated bprm->filename copied by the 1st
copy_strings_kernel(), but perhaps we should change this code to check
"bprm->p < bprm->exec" anyway, and/or change copy_strings() to ensure that
the last byte in string is always zero.

Link: http://lkml.kernel.org/r/20160517155335.GA31435@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported by: hujunjie <jj.net@163.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN fs/exec.c~exec-remove-the-no-longer-needed-remove_arg_zero-free_arg_page fs/exec.c
--- a/fs/exec.c~exec-remove-the-no-longer-needed-remove_arg_zero-free_arg_page
+++ a/fs/exec.c
@@ -243,10 +243,6 @@ static void put_arg_page(struct page *pa
 	put_page(page);
 }
 
-static void free_arg_page(struct linux_binprm *bprm, int i)
-{
-}
-
 static void free_arg_pages(struct linux_binprm *bprm)
 {
 }
@@ -1499,9 +1495,6 @@ int remove_arg_zero(struct linux_binprm
 
 		kunmap_atomic(kaddr);
 		put_arg_page(page);
