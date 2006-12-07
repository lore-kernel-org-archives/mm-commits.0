From: akpm@osdl.org
Subject: - binfmt-fix-uaccess-handling.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:02:52 -0800
Message-ID: <200612072302.kB7N2qVa029900@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51878 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163724AbWLGXDZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:03:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     binfmt: fix uaccess handling
has been removed from the -mm tree.  Its filename was
     binfmt-fix-uaccess-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: binfmt: fix uaccess handling
From: Heiko Carstens <heiko.carstens@de.ibm.com>

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/binfmt_elf.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN fs/binfmt_elf.c~binfmt-fix-uaccess-handling fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~binfmt-fix-uaccess-handling
+++ a/fs/binfmt_elf.c
@@ -243,8 +243,9 @@ create_elf_tables(struct linux_binprm *b
 	if (interp_aout) {
 		argv = sp + 2;
 		envp = argv + argc + 1;
-		__put_user((elf_addr_t)(unsigned long)argv, sp++);
-		__put_user((elf_addr_t)(unsigned long)envp, sp++);
+		if (__put_user((elf_addr_t)(unsigned long)argv, sp++) ||
+		    __put_user((elf_addr_t)(unsigned long)envp, sp++))
+			return -EFAULT;
 	} else {
 		argv = sp;
 		envp = argv + argc + 1;
@@ -254,7 +255,8 @@ create_elf_tables(struct linux_binprm *b
 	p = current->mm->arg_end = current->mm->arg_start;
 	while (argc-- > 0) {
 		size_t len;
-		__put_user((elf_addr_t)p, argv++);
+		if (__put_user((elf_addr_t)p, argv++))
+			return -EFAULT;
 		len = strnlen_user((void __user *)p, PAGE_SIZE*MAX_ARG_PAGES);
 		if (!len || len > PAGE_SIZE*MAX_ARG_PAGES)
 			return 0;
@@ -265,7 +267,8 @@ create_elf_tables(struct linux_binprm *b
 	current->mm->arg_end = current->mm->env_start = p;
 	while (envc-- > 0) {
 		size_t len;
-		__put_user((elf_addr_t)p, envp++);
+		if (__put_user((elf_addr_t)p, envp++))
+			return -EFAULT;
 		len = strnlen_user((void __user *)p, PAGE_SIZE*MAX_ARG_PAGES);
 		if (!len || len > PAGE_SIZE*MAX_ARG_PAGES)
 			return 0;
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
git-s390.patch
s390-workqueue-fixes.patch
scsi-fix-uaccess-handling.patch

