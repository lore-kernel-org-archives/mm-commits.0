From: akpm@linux-foundation.org
Subject: [merged] exec-account-for-argv-envp-pointers.patch removed
 from -mm tree
Date: Mon, 26 Jun 2017 13:22:54 -0700
Message-ID: <20170626202254.jNNe7-QuV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51400 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751934AbdFZUWz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Jun 2017 16:22:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, mhocko@suse.com, mm-commits@vger.kernel.org, qsa@qualys.com, riel@redhat.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: fs/exec.c: account for argv/envp pointers
has been removed from the -mm tree.  Its filename was
     exec-account-for-argv-envp-pointers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from keescook@chromium.org are

mm-allow-slab_nomerge-to-be-set-at-build-time.patch
binfmt_elf-use-elf_et_dyn_base-only-for-pie.patch
arm-reduce-elf_et_dyn_base.patch
arm64-move-elf_et_dyn_base-to-4gb-4mb.patch
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
kexec_file-adjust-declaration-of-kexec_purgatory.patch
ib-rxe-do-not-copy-extra-stack-memory-to-skb.patch

