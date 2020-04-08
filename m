From: akpm@linux-foundation.org
Subject: [merged] elf-allocate-less-for-static-executable.patch
 removed from -mm tree
Date: Tue, 07 Apr 2020 19:01:56 -0700
Message-ID: <20200408020156.8Xm8tw7oV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgDHCB5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:01:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/binfmt_elf.c: allocate less for static executable
has been removed from the -mm tree.  Its filename was
     elf-allocate-less-for-static-executable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: fs/binfmt_elf.c: allocate less for static executable

PT_INTERP ELF header can be spared if executable is static.

Link: http://lkml.kernel.org/r/20200219185012.GB4871@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/fs/binfmt_elf.c~elf-allocate-less-for-static-executable
+++ a/fs/binfmt_elf.c
@@ -699,17 +699,11 @@ static int load_elf_binary(struct linux_
 	unsigned long reloc_func_desc __maybe_unused = 0;
 	int executable_stack = EXSTACK_DEFAULT;
 	struct elfhdr *elf_ex = (struct elfhdr *)bprm->buf;
-	struct elfhdr *interp_elf_ex;
+	struct elfhdr *interp_elf_ex = NULL;
 	struct arch_elf_state arch_state = INIT_ARCH_ELF_STATE;
 	struct mm_struct *mm;
 	struct pt_regs *regs;
 
-	interp_elf_ex = kmalloc(sizeof(*interp_elf_ex), GFP_KERNEL);
-	if (!interp_elf_ex) {
-		retval = -ENOMEM;
-		goto out_ret;
-	}
-
 	retval = -ENOEXEC;
 	/* First of all, some simple consistency checks */
 	if (memcmp(elf_ex->e_ident, ELFMAG, SELFMAG) != 0)
@@ -769,6 +763,12 @@ static int load_elf_binary(struct linux_
 		 */
 		would_dump(bprm, interpreter);
 
+		interp_elf_ex = kmalloc(sizeof(*interp_elf_ex), GFP_KERNEL);
+		if (!interp_elf_ex) {
+			retval = -ENOMEM;
+			goto out_free_ph;
+		}
+
 		/* Get the exec headers */
 		retval = elf_read(interpreter, interp_elf_ex,
 				  sizeof(*interp_elf_ex), 0);
@@ -1074,6 +1074,8 @@ out_free_interp:
 
 		allow_write_access(interpreter);
 		fput(interpreter);
+
+		kfree(interp_elf_ex);
 	} else {
 		elf_entry = e_entry;
 		if (BAD_ADDR(elf_entry)) {
@@ -1152,12 +1154,11 @@ out_free_interp:
 	start_thread(regs, elf_entry, bprm->p);
 	retval = 0;
 out:
-	kfree(interp_elf_ex);
-out_ret:
 	return retval;
 
 	/* error cleanup */
 out_free_dentry:
+	kfree(interp_elf_ex);
 	kfree(interp_elf_phdata);
 	allow_write_access(interpreter);
 	if (interpreter)
_

Patches currently in -mm which might be from adobriyan@gmail.com are

ramfs-support-o_tmpfile.patch
