From: akpm@linux-foundation.org
Subject: + exec-account-for-argv-envp-pointers.patch added to -mm tree
Date: Thu, 22 Jun 2017 14:26:45 -0700
Message-ID: <594c3615.ZbP/r33PDoIcBo8w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49490 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753443AbdFVV0q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 22 Jun 2017 17:26:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, qsa@qualys.com, riel@redhat.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/exec.c: account for argv/envp pointers
has been added to the -mm tree.  Its filename is
     exec-account-for-argv-envp-pointers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exec-account-for-argv-envp-pointers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exec-account-for-argv-envp-pointers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Fixes: b6a2fea39318 ("mm: variable length argument support")
Link: http://lkml.kernel.org/r/20170622001720.GA32173@beast
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Qualys Security Advisory <qsa@qualys.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff -puN fs/exec.c~exec-account-for-argv-envp-pointers fs/exec.c
--- a/fs/exec.c~exec-account-for-argv-envp-pointers
+++ a/fs/exec.c
@@ -220,8 +220,18 @@ static struct page *get_arg_page(struct
 
 	if (write) {
 		unsigned long size = bprm->vma->vm_end - bprm->vma->vm_start;
+		unsigned long ptr_size;
 		struct rlimit *rlim;
 
+		/*
+		 * Since the stack will hold pointers to the strings, we
+		 * must account for them as well.
+		 */
+		ptr_size = (bprm->argc + bprm->envc) * sizeof(void *);
+		if (ptr_size > ULONG_MAX - size)
+			goto fail;
+		size += ptr_size;
+
 		acct_arg_size(bprm, size / PAGE_SIZE);
 
 		/*
@@ -239,13 +249,15 @@ static struct page *get_arg_page(struct
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

Patches currently in -mm which might be from keescook@chromium.org are

exec-account-for-argv-envp-pointers.patch
binfmt_elf-use-elf_et_dyn_base-only-for-pie.patch
arm-reduce-elf_et_dyn_base.patch
arm64-reduce-elf_et_dyn_base.patch
powerpc-reduce-elf_et_dyn_base.patch
s390-reduce-elf_et_dyn_base.patch
binfmt_elf-safely-increment-argv-pointers.patch
ipc-drop-non-rcu-allocation.patch
ipc-sem-do-not-use-ipc_rcu_free.patch
ipc-shm-do-not-use-ipc_rcu_free.patch
ipc-msg-do-not-use-ipc_rcu_free.patch
ipc-util-drop-ipc_rcu_free.patch
ipc-sem-avoid-ipc_rcu_alloc.patch
ipc-shm-avoid-ipc_rcu_alloc.patch
ipc-msg-avoid-ipc_rcu_alloc.patch
ipc-util-drop-ipc_rcu_alloc.patch
ipc-move-atomic_set-to-where-it-is-needed.patch
ipc-shm-remove-special-shm_alloc-free.patch
ipc-msg-remove-special-msg_alloc-free.patch
ipc-sem-drop-__sem_free.patch
efi-avoid-fortify-checks-in-efi-stub.patch
x86-power-64-use-char-arrays-for-asm-function-names.patch
kexec_file-adjust-declaration-of-kexec_purgatory.patch
ib-rxe-do-not-copy-extra-stack-memory-to-skb.patch

