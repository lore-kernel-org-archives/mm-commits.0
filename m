From: akpm@linux-foundation.org
Subject: + uml-remove-dead-code-about-os_usr1_signal-and-os_usr1_process.patch added to -mm tree
Date: Mon, 05 Mar 2007 20:26:31 -0800
Message-ID: <200703060426.l264QVjh011748@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50195 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933945AbXCFE0e (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 23:26:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: blaisorblade@yahoo.it, jdike@addtoit.com


The patch titled
     um: remove dead code about os_usr1_signal() and os_usr1_process()
has been added to the -mm tree.  Its filename is
     uml-remove-dead-code-about-os_usr1_signal-and-os_usr1_process.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: um: remove dead code about os_usr1_signal() and os_usr1_process()
From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

os_usr1_signal() is totally unused, os_usr1_process() is used only by TT mode.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: Jeff Dike <jdike@addtoit.com>
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
x86_64-fix-2618-regression-ptrace_oldsetoptions-should-be-accepted.patch
uml-hostfs-fix-double-free.patch
uml-hostfs-make-hostfs=-option-work-as-a-jail-as-intended.patch
uml-fix-a-memory-leak-in-the-multicast-driver.patch
uml-remove-dead-code-about-os_usr1_signal-and-os_usr1_process.patch
uml-mark-both-consoles-as-con_anytime.patch
uml-fix-confusion-irq-early-reenabling.patch
uml-activate_fd-return-enomem-only-when-appropriate.patch
uml-fix-errno-usage.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-fix-prototypes.patch
git-gccbug.patch
