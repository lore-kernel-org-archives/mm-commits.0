From: akpm@linux-foundation.org
Subject: - suppress-aout-library-support-in-elf-binfmt-if-config_binfmt_aout.patch removed from -mm tree
Date: Mon, 05 Nov 2007 22:21:45 -0800
Message-ID: <200711060628.lA66SXqs010185@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43614 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754193AbXKFG2r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2007 01:28:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Suppress AOUT library support in ELF binfmt if !CONFIG_BINFMT_AOUT
has been removed from the -mm tree.  Its filename was
     suppress-aout-library-support-in-elf-binfmt-if-config_binfmt_aout.patch

This patch was dropped because of more allnoconfig breakage

------------------------------------------------------
Subject: Suppress AOUT library support in ELF binfmt if !CONFIG_BINFMT_AOUT
From: David Howells <dhowells@redhat.com>

Suppress AOUT library support in ELF binfmt if CONFIG_BINFMT_AOUT is not
set.

The MN10300 architecture does not support the AOUT binfmt, so the ELF
binfmt should not be permitted to go looking for AOUT libraries to load.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c       |   30 ++++++++++++++++++++++--------
 include/linux/a.out.h |    6 ++++++
 2 files changed, 28 insertions(+), 8 deletions(-)

diff -puN fs/binfmt_elf.c~suppress-aout-library-support-in-elf-binfmt-if-config_binfmt_aout fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~suppress-aout-library-support-in-elf-binfmt-if-config_binfmt_aout
+++ a/fs/binfmt_elf.c
@@ -513,6 +513,7 @@ out:
 	return error;
 }
 
+#ifdef CONFIG_BINFMT_AOUT
 static unsigned long load_aout_interp(struct exec *interp_ex,
 		struct file *interpreter)
 {
@@ -558,6 +559,10 @@ static unsigned long load_aout_interp(st
 out:
 	return elf_entry;
 }
+#else
+extern unsigned long load_aout_interp(struct exec *interp_ex,
+				      struct file *interpreter);
+#endif
 
 /*
  * These are the functions used to load ELF style executables and shared
@@ -565,9 +570,15 @@ out:
  */
 
 #define INTERPRETER_NONE 0
-#define INTERPRETER_AOUT 1
 #define INTERPRETER_ELF 2
 
+#ifdef CONFIG_BINFMT_AOUT
+#define INTERPRETER_AOUT 1
+#define IS_AOUT_INTERP(x) ((x) == INTERPRETER_AOUT)
+#else
+#define IS_AOUT_INTERP(x) (0)
+#endif
+
 #ifndef STACK_RND_MASK
 #define STACK_RND_MASK (0x7ff >> (PAGE_SHIFT - 12))	/* 8MB of VA */
 #endif
@@ -784,6 +795,7 @@ static int load_elf_binary(struct linux_
 	/* Some simple consistency checks for the interpreter */
 	if (elf_interpreter) {
 		static int warn;
+#ifdef CONFIG_BINFMT_AOUT
 		interpreter_type = INTERPRETER_ELF | INTERPRETER_AOUT;
 
 		/* Now figure out which format our binary is */
@@ -791,11 +803,13 @@ static int load_elf_binary(struct linux_
 		    (N_MAGIC(loc->interp_ex) != ZMAGIC) &&
 		    (N_MAGIC(loc->interp_ex) != QMAGIC))
 			interpreter_type = INTERPRETER_ELF;
-
+#else
+		interpreter_type = INTERPRETER_ELF;
+#endif
 		if (memcmp(loc->interp_elf_ex.e_ident, ELFMAG, SELFMAG) != 0)
 			interpreter_type &= ~INTERPRETER_ELF;
 
-		if (interpreter_type == INTERPRETER_AOUT && warn < 10) {
+		if (IS_AOUT_INTERP(interpreter_type) && warn < 10) {
 			printk(KERN_WARNING "a.out ELF interpreter %s is "
 				"deprecated and will not be supported "
 				"after Linux 2.6.25\n", elf_interpreter);
@@ -824,7 +838,7 @@ static int load_elf_binary(struct linux_
 
 	/* OK, we are done with that, now set up the arg stuff,
 	   and then start this sucker up */
-	if ((!bprm->sh_bang) && (interpreter_type == INTERPRETER_AOUT)) {
+	if (IS_AOUT_INTERP(interpreter_type) && !bprm->sh_bang) {
 		char *passed_p = passed_fileno;
 		sprintf(passed_fileno, "%d", elf_exec_fileno);
 
@@ -1013,7 +1027,7 @@ static int load_elf_binary(struct linux_
 	}
 
 	if (elf_interpreter) {
-		if (interpreter_type == INTERPRETER_AOUT) {
+		if (IS_AOUT_INTERP(interpreter_type)) {
 			elf_entry = load_aout_interp(&loc->interp_ex,
 						     interpreter);
 		} else {
@@ -1054,7 +1068,7 @@ static int load_elf_binary(struct linux_
 
 	kfree(elf_phdata);
 
-	if (interpreter_type != INTERPRETER_AOUT)
+	if (!IS_AOUT_INTERP(interpreter_type))
 		sys_close(elf_exec_fileno);
 
 	set_binfmt(&elf_format);
@@ -1070,14 +1084,14 @@ static int load_elf_binary(struct linux_
 	compute_creds(bprm);
 	current->flags &= ~PF_FORKNOEXEC;
 	retval = create_elf_tables(bprm, &loc->elf_ex,
-			  (interpreter_type == INTERPRETER_AOUT),
+			  IS_AOUT_INTERP(interpreter_type),
 			  load_addr, interp_load_addr);
 	if (retval < 0) {
 		send_sig(SIGKILL, current, 0);
 		goto out;
 	}
 	/* N.B. passed_fileno might not be initialized? */
-	if (interpreter_type == INTERPRETER_AOUT)
+	if (IS_AOUT_INTERP(interpreter_type))
 		current->mm->arg_start += strlen(passed_fileno) + 1;
 	current->mm->end_code = end_code;
 	current->mm->start_code = start_code;
diff -puN include/linux/a.out.h~suppress-aout-library-support-in-elf-binfmt-if-config_binfmt_aout include/linux/a.out.h
--- a/include/linux/a.out.h~suppress-aout-library-support-in-elf-binfmt-if-config_binfmt_aout
+++ a/include/linux/a.out.h
@@ -1,6 +1,8 @@
 #ifndef __A_OUT_GNU_H__
 #define __A_OUT_GNU_H__
 
+#ifdef CONFIG_BINFMT_AOUT
+
 #define __GNU_EXEC_MACROS__
 
 #ifndef __STRUCT_EXEC_OVERRIDE__
@@ -265,4 +267,8 @@ struct relocation_info
 #endif /* no N_RELOCATION_INFO_DECLARED.  */
 
 
+#else /* CONFIG_BINFMT_AOUT */
+struct exec {
+};
+#endif /* CONFIG_BINFMT_AOUT */
 #endif /* __A_OUT_GNU_H__ */
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
frv-permit-the-memory-to-be-located-elsewhere-in-nommu-mode.patch
frv-move-dma-macros-to-scatterlisth-for-consistency.patch
suppress-aout-library-support-in-elf-binfmt-if-config_binfmt_aout.patch
suppress-aout-library-support-in-elf-binfmt-if-config_binfmt_aout-fix.patch
mn10300-suppress-aout-library-support-in-elf-binfmt-if-fix.patch
64-bit-i_version-afs-fixes.patch
add-an-err_cast-function-to-complement-err_ptr-and-co.patch
convert-err_ptrptr_errp-instances-to-err_castp.patch
iget-introduce-a-function-to-register-iget-failure.patch
iget-use-iget_failed-in-afs.patch
iget-use-iget_failed-in-gfs2.patch
iget-stop-affs-from-using-iget-and-read_inode-try.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-autofs-from-using-iget-and-read_inode.patch
iget-stop-befs-from-using-iget-and-read_inode-try.patch
iget-stop-bfs-from-using-iget-and-read_inode-try.patch
iget-stop-cifs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
iget-stop-fat-from-using-iget-and-read_inode-try.patch
iget-stop-freevxfs-from-using-iget-and-read_inode.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-fuse-from-using-iget-and-read_inode-try.patch
iget-stop-hfsplus-from-using-iget-and-read_inode.patch
iget-stop-isofs-from-using-read_inode.patch
iget-stop-jffs2-from-using-iget-and-read_inode.patch
iget-stop-jfs-from-using-iget-and-read_inode-try.patch
iget-stop-the-minix-filesystem-from-using-iget-and.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-openpromfs-from-using-iget-and.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-hppfs-from-using-iget-and-read_inode.patch
iget-remove-iget-and-the-read_inode-super-op-as.patch
unexport-asm-pageh.patch
add-cmpxchg_local-to-frv.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
mutex-subsystem-synchro-test-module.patch
