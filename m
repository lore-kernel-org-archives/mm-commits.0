From: akpm@linux-foundation.org
Subject: - uml-move-register-initialization.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:38:30 -0800
Message-ID: <200802052238.m15McB42012930@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45987 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762286AbYBEWlX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: move register initialization
has been removed from the -mm tree.  Its filename was
     uml-move-register-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: move register initialization
From: Jeff Dike <jdike@addtoit.com>

Calling init_registers inside the skas3 checking causes mysterious crashes if
it doesn't happen because the skas3 checking is bypassed.  This patch moves it
to os_early_checks.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/start_up.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN arch/um/os-Linux/start_up.c~uml-move-register-initialization arch/um/os-Linux/start_up.c
--- a/arch/um/os-Linux/start_up.c~uml-move-register-initialization
+++ a/arch/um/os-Linux/start_up.c
@@ -342,6 +342,8 @@ static void __init check_coredump_limit(
 
 void __init os_early_checks(void)
 {
+	int pid;
+
 	/* Print out the core dump limits early */
 	check_coredump_limit();
 
@@ -351,6 +353,11 @@ void __init os_early_checks(void)
 	 * kernel is running.
 	 */
 	check_tmpexec();
+
+	pid = start_ptraced_child();
+	if (init_registers(pid))
+		fatal("Failed to initialize default registers");
+	stop_ptraced_child(pid, 1, 1);
 }
 
 static int __init noprocmm_cmd_param(char *str, int* add)
@@ -412,9 +419,6 @@ static inline void check_skas3_ptrace_fa
 			non_fatal("found\n");
 	}
 
-	if (init_registers(pid))
-		fatal("Failed to initialize default registers");
-
 	stop_ptraced_child(pid, 1, 1);
 }
 
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
