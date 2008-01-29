From: akpm@linux-foundation.org
Subject: - remove-ibcs-support.patch removed from -mm tree
Date: Mon, 28 Jan 2008 17:50:40 -0800
Message-ID: <200801290150.m0T1oeCn027586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43677 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755962AbYA2B7e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 20:59:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@suse.de, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Remove iBCS support
has been removed from the -mm tree.  Its filename was
     remove-ibcs-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Remove iBCS support
From: Andi Kleen <andi@firstfloor.org>

Remove ibcs2 support in ELF loader too

ibcs2 support has never been supported on 2.6 kernels as far as I know, and
if it has it must have been an external patch.  Anyways, if anybody applies
an external patch they could as well readd the ibcs checking code to the
ELF loader in the same patch.  But there is no reason to keep this code
running in all Linux kernels.  This will save at least two strcmps each ELF
execution.

No deprecation period because it could not have been used anyway.

Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff -puN fs/binfmt_elf.c~remove-ibcs-support fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~remove-ibcs-support
+++ a/fs/binfmt_elf.c
@@ -610,7 +610,6 @@ static int load_elf_binary(struct linux_
 	int load_addr_set = 0;
 	char * elf_interpreter = NULL;
 	unsigned int interpreter_type = INTERPRETER_NONE;
-	unsigned char ibcs2_interpreter = 0;
 	unsigned long error;
 	struct elf_phdr *elf_ppnt, *elf_phdata;
 	unsigned long elf_bss, elf_brk;
@@ -728,14 +727,6 @@ static int load_elf_binary(struct linux_
 			if (elf_interpreter[elf_ppnt->p_filesz - 1] != '\0')
 				goto out_free_interp;
 
-			/* If the program interpreter is one of these two,
-			 * then assume an iBCS2 image. Otherwise assume
-			 * a native linux image.
-			 */
-			if (strcmp(elf_interpreter,"/usr/lib/libc.so.1") == 0 ||
-			    strcmp(elf_interpreter,"/usr/lib/ld.so.1") == 0)
-				ibcs2_interpreter = 1;
-
 			/*
 			 * The early SET_PERSONALITY here is so that the lookup
 			 * for the interpreter happens in the namespace of the 
@@ -755,7 +746,7 @@ static int load_elf_binary(struct linux_
 			 * switch really is going to happen - do this in
 			 * flush_thread().	- akpm
 			 */
-			SET_PERSONALITY(loc->elf_ex, ibcs2_interpreter);
+			SET_PERSONALITY(loc->elf_ex, 0);
 
 			interpreter = open_exec(elf_interpreter);
 			retval = PTR_ERR(interpreter);
@@ -837,7 +828,7 @@ static int load_elf_binary(struct linux_
 			goto out_free_dentry;
 	} else {
 		/* Executables without an interpreter also need a personality  */
-		SET_PERSONALITY(loc->elf_ex, ibcs2_interpreter);
+		SET_PERSONALITY(loc->elf_ex, 0);
 	}
 
 	/* OK, we are done with that, now set up the arg stuff,
@@ -871,7 +862,7 @@ static int load_elf_binary(struct linux_
 
 	/* Do this immediately, since STACK_TOP as used in setup_arg_pages
 	   may depend on the personality.  */
-	SET_PERSONALITY(loc->elf_ex, ibcs2_interpreter);
+	SET_PERSONALITY(loc->elf_ex, 0);
 	if (elf_read_implies_exec(loc->elf_ex, executable_stack))
 		current->personality |= READ_IMPLIES_EXEC;
 
_

Patches currently in -mm which might be from andi@firstfloor.org are

git-x86.patch
allow-executables-larger-than-2gb.patch
