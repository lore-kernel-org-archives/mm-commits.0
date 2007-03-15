From: akpm@linux-foundation.org
Subject: - uml-remove-dead-code-about-os_usr1_signal-and-os_usr1_process.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:56:03 -0800
Message-ID: <200703152156.l2FLu3AR027516@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42229 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbXCOV4G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:56:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: blaisorblade@yahoo.it, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     um: remove dead code about os_usr1_signal() and os_usr1_process()
has been removed from the -mm tree.  Its filename was
     uml-remove-dead-code-about-os_usr1_signal-and-os_usr1_process.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: um: remove dead code about os_usr1_signal() and os_usr1_process()
From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

os_usr1_signal() is totally unused, os_usr1_process() is used only by TT mode.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Acked-by: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/os.h       |    3 ++-
 arch/um/os-Linux/process.c |    3 +++
 arch/um/os-Linux/signal.c  |    5 -----
 3 files changed, 5 insertions(+), 6 deletions(-)

diff -puN arch/um/include/os.h~uml-remove-dead-code-about-os_usr1_signal-and-os_usr1_process arch/um/include/os.h
--- a/arch/um/include/os.h~uml-remove-dead-code-about-os_usr1_signal-and-os_usr1_process
+++ a/arch/um/include/os.h
@@ -192,7 +192,9 @@ extern int os_process_parent(int pid);
 extern void os_stop_process(int pid);
 extern void os_kill_process(int pid, int reap_child);
 extern void os_kill_ptraced_process(int pid, int reap_child);
+#ifdef UML_CONFIG_MODE_TT
 extern void os_usr1_process(int pid);
+#endif
 extern long os_ptrace_ldt(long pid, long addr, long data);
 
 extern int os_getpid(void);
@@ -261,7 +263,6 @@ extern void block_signals(void);
 extern void unblock_signals(void);
 extern int get_signals(void);
 extern int set_signals(int enable);
-extern void os_usr1_signal(int on);
 
 /* trap.c */
 extern void os_fill_handlinfo(struct kern_handlers h);
diff -puN arch/um/os-Linux/process.c~uml-remove-dead-code-about-os_usr1_signal-and-os_usr1_process arch/um/os-Linux/process.c
--- a/arch/um/os-Linux/process.c~uml-remove-dead-code-about-os_usr1_signal-and-os_usr1_process
+++ a/arch/um/os-Linux/process.c
@@ -21,6 +21,7 @@
 #include "longjmp.h"
 #include "skas_ptrace.h"
 #include "kern_constants.h"
+#include "uml-config.h"
 
 #define ARBITRARY_ADDR -1
 #define FAILURE_PID    -1
@@ -131,10 +132,12 @@ void os_kill_ptraced_process(int pid, in
 		CATCH_EINTR(waitpid(pid, NULL, 0));
 }
 
+#ifdef UML_CONFIG_MODE_TT
 void os_usr1_process(int pid)
 {
 	kill(pid, SIGUSR1);
 }
+#endif
 
 /* Don't use the glibc version, which caches the result in TLS. It misses some
  * syscalls, and also breaks with clone(), which does not unshare the TLS.
diff -puN arch/um/os-Linux/signal.c~uml-remove-dead-code-about-os_usr1_signal-and-os_usr1_process arch/um/os-Linux/signal.c
--- a/arch/um/os-Linux/signal.c~uml-remove-dead-code-about-os_usr1_signal-and-os_usr1_process
+++ a/arch/um/os-Linux/signal.c
@@ -243,8 +243,3 @@ int set_signals(int enable)
 
 	return ret;
 }
-
-void os_usr1_signal(int on)
-{
-	change_sig(SIGUSR1, on);
-}
_

Patches currently in -mm which might be from blaisorblade@yahoo.it are

origin.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
uml-fix-prototypes.patch
git-gccbug.patch
