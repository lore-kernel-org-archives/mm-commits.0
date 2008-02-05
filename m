From: akpm@linux-foundation.org
Subject: - uml-dont-allow-processes-to-call-into-stub.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:37:48 -0800
Message-ID: <200802052237.m15MbTeP012856@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55428 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762336AbYBEWlR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: don't allow processes to call into stub
has been removed from the -mm tree.  Its filename was
     uml-dont-allow-processes-to-call-into-stub.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: don't allow processes to call into stub
From: Jeff Dike <jdike@addtoit.com>

Kill a process that tries to branch into a stub and execute a system
call.  There are no security implications here - a system call in a
stub is treated the same as a system call anywhere else.  But if a
process is trying to branch into a stub, either it is trying something
nasty or it has gone haywire, so it's a good idea to get rid of it in
either case.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/skas/process.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/um/os-Linux/skas/process.c~uml-dont-allow-processes-to-call-into-stub arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-dont-allow-processes-to-call-into-stub
+++ a/arch/um/os-Linux/skas/process.c
@@ -146,6 +146,9 @@ static void handle_trap(int pid, struct 
 {
 	int err, status;
 
+	if ((UPT_IP(regs) >= STUB_START) && (UPT_IP(regs) < STUB_END))
+		fatal_sigsegv();
+
 	/* Mark this as a syscall */
 	UPT_SYSCALL_NR(regs) = PT_SYSCALL_NR(regs->gp);
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
