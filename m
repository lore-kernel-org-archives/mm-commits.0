From: akpm@linux-foundation.org
Subject: + uml-remove-user_utilh.patch added to -mm tree
Date: Thu, 22 Mar 2007 14:44:40 -0700
Message-ID: <200703222144.l2MLiefl031102@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53114 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161110AbXCVVor (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 17:44:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: memove user_util.h
has been added to the -mm tree.  Its filename is
     uml-remove-user_utilh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: memove user_util.h
From: Jeff Dike <jdike@addtoit.com>

user_util.h isn't needed any more, so delete it and remove all includes of it.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/chan_kern.c              |    1 
 arch/um/drivers/chan_user.c              |    1 
 arch/um/drivers/cow_sys.h                |    1 
 arch/um/drivers/daemon_user.c            |    1 
 arch/um/drivers/fd.c                     |    1 
 arch/um/drivers/harddog_user.c           |    1 
 arch/um/drivers/line.c                   |    1 
 arch/um/drivers/mcast_user.c             |    1 
 arch/um/drivers/mconsole_kern.c          |    1 
 arch/um/drivers/mconsole_user.c          |    1 
 arch/um/drivers/mmapper_kern.c           |    1 
 arch/um/drivers/net_kern.c               |    1 
 arch/um/drivers/net_user.c               |    1 
 arch/um/drivers/port_user.c              |    1 
 arch/um/drivers/pty.c                    |    1 
 arch/um/drivers/slip_user.c              |    1 
 arch/um/drivers/slirp_user.c             |    1 
 arch/um/drivers/ssl.c                    |    1 
 arch/um/drivers/stdio_console.c          |    1 
 arch/um/drivers/tty.c                    |    1 
 arch/um/drivers/ubd_kern.c               |    1 
 arch/um/drivers/ubd_user.c               |    1 
 arch/um/drivers/xterm.c                  |    1 
 arch/um/include/user_util.h              |   29 ---------------------
 arch/um/kernel/exec.c                    |    1 
 arch/um/kernel/init_task.c               |    1 
 arch/um/kernel/initrd.c                  |    1 
 arch/um/kernel/irq.c                     |    1 
 arch/um/kernel/ksyms.c                   |    1 
 arch/um/kernel/mem.c                     |    1 
 arch/um/kernel/physmem.c                 |    1 
 arch/um/kernel/process.c                 |    1 
 arch/um/kernel/reboot.c                  |    1 
 arch/um/kernel/signal.c                  |    1 
 arch/um/kernel/skas/process.c            |    1 
 arch/um/kernel/skas/tlb.c                |    1 
 arch/um/kernel/smp.c                     |    1 
 arch/um/kernel/syscall.c                 |    1 
 arch/um/kernel/sysrq.c                   |    1 
 arch/um/kernel/time.c                    |    1 
 arch/um/kernel/tlb.c                     |    1 
 arch/um/kernel/trap.c                    |    1 
 arch/um/kernel/tt/exec_kern.c            |    1 
 arch/um/kernel/tt/exec_user.c            |    1 
 arch/um/kernel/tt/gdb.c                  |    1 
 arch/um/kernel/tt/mem.c                  |    1 
 arch/um/kernel/tt/mem_user.c             |    1 
 arch/um/kernel/tt/process_kern.c         |    1 
 arch/um/kernel/tt/ptproxy/proxy.c        |    1 
 arch/um/kernel/tt/ptproxy/ptrace.c       |    1 
 arch/um/kernel/tt/ptproxy/sysdep.c       |    1 
 arch/um/kernel/tt/ptproxy/wait.c         |    1 
 arch/um/kernel/tt/syscall_user.c         |    1 
 arch/um/kernel/tt/tlb.c                  |    1 
 arch/um/kernel/tt/tracer.c               |    1 
 arch/um/kernel/tt/trap_user.c            |    1 
 arch/um/kernel/tt/uaccess_user.c         |    1 
 arch/um/kernel/um_arch.c                 |    1 
 arch/um/os-Linux/drivers/ethertap_user.c |    1 
 arch/um/os-Linux/drivers/tuntap_user.c   |    1 
 arch/um/os-Linux/file.c                  |    1 
 arch/um/os-Linux/helper.c                |    1 
 arch/um/os-Linux/irq.c                   |    1 
 arch/um/os-Linux/main.c                  |    1 
 arch/um/os-Linux/mem.c                   |    1 
 arch/um/os-Linux/process.c               |    1 
 arch/um/os-Linux/sigio.c                 |    1 
 arch/um/os-Linux/signal.c                |    1 
 arch/um/os-Linux/skas/mem.c              |    1 
 arch/um/os-Linux/skas/process.c          |    1 
 arch/um/os-Linux/skas/trap.c             |    1 
 arch/um/os-Linux/start_up.c              |    1 
 arch/um/os-Linux/sys-i386/tls.c          |    1 
 arch/um/os-Linux/time.c                  |    1 
 arch/um/os-Linux/trap.c                  |    1 
 arch/um/os-Linux/tt.c                    |    1 
 arch/um/os-Linux/util.c                  |    1 
 arch/um/sys-i386/bugs.c                  |    1 
 arch/um/sys-i386/ptrace_user.c           |    1 
 arch/um/sys-ppc/sigcontext.c             |    1 
 80 files changed, 108 deletions(-)

diff -puN arch/um/drivers/chan_kern.c~uml-remove-user_utilh arch/um/drivers/chan_kern.c
--- a/arch/um/drivers/chan_kern.c~uml-remove-user_utilh
+++ a/arch/um/drivers/chan_kern.c
@@ -12,7 +12,6 @@
 #include <linux/tty_flip.h>
 #include <asm/irq.h>
 #include "chan_kern.h"
-#include "user_util.h"
 #include "kern.h"
 #include "irq_user.h"
 #include "sigio.h"
diff -puN arch/um/drivers/chan_user.c~uml-remove-user_utilh arch/um/drivers/chan_user.c
--- a/arch/um/drivers/chan_user.c~uml-remove-user_utilh
+++ a/arch/um/drivers/chan_user.c
@@ -14,7 +14,6 @@
 #include <sys/ioctl.h>
 #include <sys/socket.h>
 #include "kern_util.h"
-#include "user_util.h"
 #include "chan_user.h"
 #include "user.h"
 #include "os.h"
diff -puN arch/um/drivers/cow_sys.h~uml-remove-user_utilh arch/um/drivers/cow_sys.h
--- a/arch/um/drivers/cow_sys.h~uml-remove-user_utilh
+++ a/arch/um/drivers/cow_sys.h
@@ -2,7 +2,6 @@
 #define __COW_SYS_H__
 
 #include "kern_util.h"
-#include "user_util.h"
 #include "os.h"
 #include "user.h"
 #include "um_malloc.h"
diff -puN arch/um/drivers/daemon_user.c~uml-remove-user_utilh arch/um/drivers/daemon_user.c
--- a/arch/um/drivers/daemon_user.c~uml-remove-user_utilh
+++ a/arch/um/drivers/daemon_user.c
@@ -14,7 +14,6 @@
 #include "net_user.h"
 #include "daemon.h"
 #include "kern_util.h"
-#include "user_util.h"
 #include "user.h"
 #include "os.h"
 #include "um_malloc.h"
diff -puN arch/um/drivers/fd.c~uml-remove-user_utilh arch/um/drivers/fd.c
--- a/arch/um/drivers/fd.c~uml-remove-user_utilh
+++ a/arch/um/drivers/fd.c
@@ -9,7 +9,6 @@
 #include <termios.h>
 #include <errno.h>
 #include "user.h"
-#include "user_util.h"
 #include "chan_user.h"
 #include "os.h"
 #include "um_malloc.h"
diff -puN arch/um/drivers/harddog_user.c~uml-remove-user_utilh arch/um/drivers/harddog_user.c
--- a/arch/um/drivers/harddog_user.c~uml-remove-user_utilh
+++ a/arch/um/drivers/harddog_user.c
@@ -6,7 +6,6 @@
 #include <stdio.h>
 #include <unistd.h>
 #include <errno.h>
-#include "user_util.h"
 #include "user.h"
 #include "mconsole.h"
 #include "os.h"
diff -puN arch/um/drivers/line.c~uml-remove-user_utilh arch/um/drivers/line.c
--- a/arch/um/drivers/line.c~uml-remove-user_utilh
+++ a/arch/um/drivers/line.c
@@ -13,7 +13,6 @@
 #include "irq_user.h"
 #include "line.h"
 #include "kern.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "os.h"
 #include "irq_kern.h"
diff -puN arch/um/drivers/mcast_user.c~uml-remove-user_utilh arch/um/drivers/mcast_user.c
--- a/arch/um/drivers/mcast_user.c~uml-remove-user_utilh
+++ a/arch/um/drivers/mcast_user.c
@@ -20,7 +20,6 @@
 #include "net_user.h"
 #include "mcast.h"
 #include "kern_util.h"
-#include "user_util.h"
 #include "user.h"
 #include "os.h"
 #include "um_malloc.h"
diff -puN arch/um/drivers/mconsole_kern.c~uml-remove-user_utilh arch/um/drivers/mconsole_kern.c
--- a/arch/um/drivers/mconsole_kern.c~uml-remove-user_utilh
+++ a/arch/um/drivers/mconsole_kern.c
@@ -25,7 +25,6 @@
 #include "linux/console.h"
 #include "asm/irq.h"
 #include "asm/uaccess.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "kern.h"
 #include "mconsole.h"
diff -puN arch/um/drivers/mconsole_user.c~uml-remove-user_utilh arch/um/drivers/mconsole_user.c
--- a/arch/um/drivers/mconsole_user.c~uml-remove-user_utilh
+++ a/arch/um/drivers/mconsole_user.c
@@ -17,7 +17,6 @@
 #include "sysdep/ptrace.h"
 #include "mconsole.h"
 #include "os.h"
-#include "user_util.h"
 
 static struct mconsole_command commands[] = {
 	/* With uts namespaces, uts information becomes process-specific, so
diff -puN arch/um/drivers/mmapper_kern.c~uml-remove-user_utilh arch/um/drivers/mmapper_kern.c
--- a/arch/um/drivers/mmapper_kern.c~uml-remove-user_utilh
+++ a/arch/um/drivers/mmapper_kern.c
@@ -15,7 +15,6 @@
 #include <linux/miscdevice.h>
 #include <asm/uaccess.h>
 #include "mem_user.h"
-#include "user_util.h"
  
 /* These are set in mmapper_init, which is called at boot time */
 static unsigned long mmapper_size;
diff -puN arch/um/drivers/net_kern.c~uml-remove-user_utilh arch/um/drivers/net_kern.c
--- a/arch/um/drivers/net_kern.c~uml-remove-user_utilh
+++ a/arch/um/drivers/net_kern.c
@@ -21,7 +21,6 @@
 #include "linux/ethtool.h"
 #include "linux/platform_device.h"
 #include "asm/uaccess.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "net_kern.h"
 #include "net_user.h"
diff -puN arch/um/drivers/net_user.c~uml-remove-user_utilh arch/um/drivers/net_user.c
--- a/arch/um/drivers/net_user.c~uml-remove-user_utilh
+++ a/arch/um/drivers/net_user.c
@@ -14,7 +14,6 @@
 #include <sys/wait.h>
 #include <sys/time.h>
 #include "user.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "net_user.h"
 #include "os.h"
diff -puN arch/um/drivers/port_user.c~uml-remove-user_utilh arch/um/drivers/port_user.c
--- a/arch/um/drivers/port_user.c~uml-remove-user_utilh
+++ a/arch/um/drivers/port_user.c
@@ -13,7 +13,6 @@
 #include <sys/socket.h>
 #include <sys/un.h>
 #include <netinet/in.h>
-#include "user_util.h"
 #include "kern_util.h"
 #include "user.h"
 #include "chan_user.h"
diff -puN arch/um/drivers/pty.c~uml-remove-user_utilh arch/um/drivers/pty.c
--- a/arch/um/drivers/pty.c~uml-remove-user_utilh
+++ a/arch/um/drivers/pty.c
@@ -11,7 +11,6 @@
 #include <termios.h>
 #include "chan_user.h"
 #include "user.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "os.h"
 #include "um_malloc.h"
diff -puN arch/um/drivers/slip_user.c~uml-remove-user_utilh arch/um/drivers/slip_user.c
--- a/arch/um/drivers/slip_user.c~uml-remove-user_utilh
+++ a/arch/um/drivers/slip_user.c
@@ -8,7 +8,6 @@
 #include <sys/termios.h>
 #include <sys/wait.h>
 #include <sys/signal.h>
-#include "user_util.h"
 #include "kern_util.h"
 #include "user.h"
 #include "net_user.h"
diff -puN arch/um/drivers/slirp_user.c~uml-remove-user_utilh arch/um/drivers/slirp_user.c
--- a/arch/um/drivers/slirp_user.c~uml-remove-user_utilh
+++ a/arch/um/drivers/slirp_user.c
@@ -7,7 +7,6 @@
 #include <errno.h>
 #include <sys/wait.h>
 #include <sys/signal.h>
-#include "user_util.h"
 #include "kern_util.h"
 #include "user.h"
 #include "net_user.h"
diff -puN arch/um/drivers/ssl.c~uml-remove-user_utilh arch/um/drivers/ssl.c
--- a/arch/um/drivers/ssl.c~uml-remove-user_utilh
+++ a/arch/um/drivers/ssl.c
@@ -15,7 +15,6 @@
 #include "line.h"
 #include "ssl.h"
 #include "chan_kern.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "kern.h"
 #include "init.h"
diff -puN arch/um/drivers/stdio_console.c~uml-remove-user_utilh arch/um/drivers/stdio_console.c
--- a/arch/um/drivers/stdio_console.c~uml-remove-user_utilh
+++ a/arch/um/drivers/stdio_console.c
@@ -22,7 +22,6 @@
 #include "stdio_console.h"
 #include "line.h"
 #include "chan_kern.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "irq_user.h"
 #include "mconsole_kern.h"
diff -puN arch/um/drivers/tty.c~uml-remove-user_utilh arch/um/drivers/tty.c
--- a/arch/um/drivers/tty.c~uml-remove-user_utilh
+++ a/arch/um/drivers/tty.c
@@ -8,7 +8,6 @@
 #include <errno.h>
 #include <unistd.h>
 #include "chan_user.h"
-#include "user_util.h"
 #include "user.h"
 #include "os.h"
 #include "um_malloc.h"
diff -puN arch/um/drivers/ubd_kern.c~uml-remove-user_utilh arch/um/drivers/ubd_kern.c
--- a/arch/um/drivers/ubd_kern.c~uml-remove-user_utilh
+++ a/arch/um/drivers/ubd_kern.c
@@ -39,7 +39,6 @@
 #include "asm/irq.h"
 #include "asm/types.h"
 #include "asm/tlbflush.h"
-#include "user_util.h"
 #include "mem_user.h"
 #include "kern_util.h"
 #include "kern.h"
diff -puN arch/um/drivers/ubd_user.c~uml-remove-user_utilh arch/um/drivers/ubd_user.c
--- a/arch/um/drivers/ubd_user.c~uml-remove-user_utilh
+++ a/arch/um/drivers/ubd_user.c
@@ -16,7 +16,6 @@
 #include <sys/mman.h>
 #include <sys/param.h>
 #include "asm/types.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "user.h"
 #include "ubd_user.h"
diff -puN arch/um/drivers/xterm.c~uml-remove-user_utilh arch/um/drivers/xterm.c
--- a/arch/um/drivers/xterm.c~uml-remove-user_utilh
+++ a/arch/um/drivers/xterm.c
@@ -14,7 +14,6 @@
 #include <sys/socket.h>
 #include "kern_util.h"
 #include "chan_user.h"
-#include "user_util.h"
 #include "user.h"
 #include "os.h"
 #include "xterm.h"
diff -puN arch/um/include/user_util.h~uml-remove-user_utilh /dev/null
--- a/arch/um/include/user_util.h
+++ /dev/null
@@ -1,29 +0,0 @@
-/*
- * Copyright (C) 2000, 2001, 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#ifndef __USER_UTIL_H__
-#define __USER_UTIL_H__
-
-#include "sysdep/ptrace.h"
-
-extern int mode_tt;
-
-extern int grantpt(int __fd);
-extern int unlockpt(int __fd);
-
-extern void *add_signal_handler(int sig, void (*handler)(int));
-extern void input_cb(void (*proc)(void *), void *arg, int arg_len);
-extern int switcheroo(int fd, int prot, void *from, void *to, int size);
-extern void do_exec(int old_pid, int new_pid);
-extern void tracer_panic(char *msg, ...)
-	__attribute__ ((format (printf, 1, 2)));
-extern int detach(int pid, int sig);
-extern int attach(int pid);
-extern void kill_child_dead(int pid);
-extern int cont(int pid);
-extern void check_sigio(void);
-extern int raw(int fd);
-
-#endif
diff -puN arch/um/kernel/exec.c~uml-remove-user_utilh arch/um/kernel/exec.c
--- a/arch/um/kernel/exec.c~uml-remove-user_utilh
+++ a/arch/um/kernel/exec.c
@@ -10,7 +10,6 @@
 #include "asm/pgtable.h"
 #include "asm/tlbflush.h"
 #include "asm/uaccess.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "as-layout.h"
 #include "mem_user.h"
diff -puN arch/um/kernel/init_task.c~uml-remove-user_utilh arch/um/kernel/init_task.c
--- a/arch/um/kernel/init_task.c~uml-remove-user_utilh
+++ a/arch/um/kernel/init_task.c
@@ -10,7 +10,6 @@
 #include "linux/mqueue.h"
 #include "asm/uaccess.h"
 #include "asm/pgtable.h"
-#include "user_util.h"
 #include "mem_user.h"
 #include "os.h"
 
diff -puN arch/um/kernel/initrd.c~uml-remove-user_utilh arch/um/kernel/initrd.c
--- a/arch/um/kernel/initrd.c~uml-remove-user_utilh
+++ a/arch/um/kernel/initrd.c
@@ -7,7 +7,6 @@
 #include "linux/bootmem.h"
 #include "linux/initrd.h"
 #include "asm/types.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "initrd.h"
 #include "init.h"
diff -puN arch/um/kernel/irq.c~uml-remove-user_utilh arch/um/kernel/irq.c
--- a/arch/um/kernel/irq.c~uml-remove-user_utilh
+++ a/arch/um/kernel/irq.c
@@ -25,7 +25,6 @@
 #include "asm/system.h"
 #include "asm/errno.h"
 #include "asm/uaccess.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "irq_user.h"
 #include "irq_kern.h"
diff -puN arch/um/kernel/ksyms.c~uml-remove-user_utilh arch/um/kernel/ksyms.c
--- a/arch/um/kernel/ksyms.c~uml-remove-user_utilh
+++ a/arch/um/kernel/ksyms.c
@@ -17,7 +17,6 @@
 #include "asm/tlbflush.h"
 #include "kern_util.h"
 #include "as-layout.h"
-#include "user_util.h"
 #include "mem_user.h"
 #include "os.h"
 
diff -puN arch/um/kernel/mem.c~uml-remove-user_utilh arch/um/kernel/mem.c
--- a/arch/um/kernel/mem.c~uml-remove-user_utilh
+++ a/arch/um/kernel/mem.c
@@ -13,7 +13,6 @@
 #include "asm/page.h"
 #include "asm/fixmap.h"
 #include "asm/pgalloc.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "as-layout.h"
 #include "kern.h"
diff -puN arch/um/kernel/physmem.c~uml-remove-user_utilh arch/um/kernel/physmem.c
--- a/arch/um/kernel/physmem.c~uml-remove-user_utilh
+++ a/arch/um/kernel/physmem.c
@@ -14,7 +14,6 @@
 #include "asm/pgtable.h"
 #include "kern_util.h"
 #include "as-layout.h"
-#include "user_util.h"
 #include "mode_kern.h"
 #include "mem.h"
 #include "mem_user.h"
diff -puN arch/um/kernel/process.c~uml-remove-user_utilh arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~uml-remove-user_utilh
+++ a/arch/um/kernel/process.c
@@ -32,7 +32,6 @@
 #include "asm/tlbflush.h"
 #include "asm/uaccess.h"
 #include "asm/user.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "as-layout.h"
 #include "kern.h"
diff -puN arch/um/kernel/reboot.c~uml-remove-user_utilh arch/um/kernel/reboot.c
--- a/arch/um/kernel/reboot.c~uml-remove-user_utilh
+++ a/arch/um/kernel/reboot.c
@@ -6,7 +6,6 @@
 #include "linux/module.h"
 #include "linux/sched.h"
 #include "asm/smp.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "kern.h"
 #include "os.h"
diff -puN arch/um/kernel/signal.c~uml-remove-user_utilh arch/um/kernel/signal.c
--- a/arch/um/kernel/signal.c~uml-remove-user_utilh
+++ a/arch/um/kernel/signal.c
@@ -17,7 +17,6 @@
 #include "asm/signal.h"
 #include "asm/uaccess.h"
 #include "asm/unistd.h"
-#include "user_util.h"
 #include "asm/ucontext.h"
 #include "kern_util.h"
 #include "signal_kern.h"
diff -puN arch/um/kernel/skas/process.c~uml-remove-user_utilh arch/um/kernel/skas/process.c
--- a/arch/um/kernel/skas/process.c~uml-remove-user_utilh
+++ a/arch/um/kernel/skas/process.c
@@ -16,7 +16,6 @@
 #include "as-layout.h"
 #include "skas.h"
 #include "os.h"
-#include "user_util.h"
 #include "tlb.h"
 #include "kern.h"
 #include "mode.h"
diff -puN arch/um/kernel/skas/tlb.c~uml-remove-user_utilh arch/um/kernel/skas/tlb.c
--- a/arch/um/kernel/skas/tlb.c~uml-remove-user_utilh
+++ a/arch/um/kernel/skas/tlb.c
@@ -10,7 +10,6 @@
 #include "asm/page.h"
 #include "asm/pgtable.h"
 #include "asm/mmu.h"
-#include "user_util.h"
 #include "mem_user.h"
 #include "mem.h"
 #include "skas.h"
diff -puN arch/um/kernel/smp.c~uml-remove-user_utilh arch/um/kernel/smp.c
--- a/arch/um/kernel/smp.c~uml-remove-user_utilh
+++ a/arch/um/kernel/smp.c
@@ -21,7 +21,6 @@ DEFINE_PER_CPU(struct mmu_gather, mmu_ga
 #include "asm/smp.h"
 #include "asm/processor.h"
 #include "asm/spinlock.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "kern.h"
 #include "irq_user.h"
diff -puN arch/um/kernel/syscall.c~uml-remove-user_utilh arch/um/kernel/syscall.c
--- a/arch/um/kernel/syscall.c~uml-remove-user_utilh
+++ a/arch/um/kernel/syscall.c
@@ -18,7 +18,6 @@
 #include "asm/mman.h"
 #include "asm/uaccess.h"
 #include "kern_util.h"
-#include "user_util.h"
 #include "sysdep/syscalls.h"
 #include "mode_kern.h"
 #include "choose-mode.h"
diff -puN arch/um/kernel/sysrq.c~uml-remove-user_utilh arch/um/kernel/sysrq.c
--- a/arch/um/kernel/sysrq.c~uml-remove-user_utilh
+++ a/arch/um/kernel/sysrq.c
@@ -10,7 +10,6 @@
 #include "asm/page.h"
 #include "asm/processor.h"
 #include "sysrq.h"
-#include "user_util.h"
 
 /* Catch non-i386 SUBARCH's. */
 #if !defined(CONFIG_UML_X86) || defined(CONFIG_64BIT)
diff -puN arch/um/kernel/time.c~uml-remove-user_utilh arch/um/kernel/time.c
--- a/arch/um/kernel/time.c~uml-remove-user_utilh
+++ a/arch/um/kernel/time.c
@@ -18,7 +18,6 @@
 #include "asm/param.h"
 #include "asm/current.h"
 #include "kern_util.h"
-#include "user_util.h"
 #include "mode.h"
 #include "os.h"
 
diff -puN arch/um/kernel/tlb.c~uml-remove-user_utilh arch/um/kernel/tlb.c
--- a/arch/um/kernel/tlb.c~uml-remove-user_utilh
+++ a/arch/um/kernel/tlb.c
@@ -10,7 +10,6 @@
 #include "choose-mode.h"
 #include "mode_kern.h"
 #include "as-layout.h"
-#include "user_util.h"
 #include "tlb.h"
 #include "mem.h"
 #include "mem_user.h"
diff -puN arch/um/kernel/trap.c~uml-remove-user_utilh arch/um/kernel/trap.c
--- a/arch/um/kernel/trap.c~uml-remove-user_utilh
+++ a/arch/um/kernel/trap.c
@@ -18,7 +18,6 @@
 #include "asm/current.h"
 #include "asm/irq.h"
 #include "sysdep/sigcontext.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "as-layout.h"
 #include "arch.h"
diff -puN arch/um/kernel/tt/exec_kern.c~uml-remove-user_utilh arch/um/kernel/tt/exec_kern.c
--- a/arch/um/kernel/tt/exec_kern.c~uml-remove-user_utilh
+++ a/arch/um/kernel/tt/exec_kern.c
@@ -10,7 +10,6 @@
 #include "asm/uaccess.h"
 #include "asm/pgalloc.h"
 #include "asm/tlbflush.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "irq_user.h"
 #include "mem_user.h"
diff -puN arch/um/kernel/tt/exec_user.c~uml-remove-user_utilh arch/um/kernel/tt/exec_user.c
--- a/arch/um/kernel/tt/exec_user.c~uml-remove-user_utilh
+++ a/arch/um/kernel/tt/exec_user.c
@@ -10,7 +10,6 @@
 #include <errno.h>
 #include <sys/wait.h>
 #include <signal.h>
-#include "user_util.h"
 #include "kern_util.h"
 #include "user.h"
 #include "ptrace_user.h"
diff -puN arch/um/kernel/tt/gdb.c~uml-remove-user_utilh arch/um/kernel/tt/gdb.c
--- a/arch/um/kernel/tt/gdb.c~uml-remove-user_utilh
+++ a/arch/um/kernel/tt/gdb.c
@@ -17,7 +17,6 @@
 #include "user.h"
 #include "debug.h"
 #include "kern_util.h"
-#include "user_util.h"
 #include "tt.h"
 #include "sysdep/thread.h"
 #include "os.h"
diff -puN arch/um/kernel/tt/mem.c~uml-remove-user_utilh arch/um/kernel/tt/mem.c
--- a/arch/um/kernel/tt/mem.c~uml-remove-user_utilh
+++ a/arch/um/kernel/tt/mem.c
@@ -8,7 +8,6 @@
 #include "asm/uaccess.h"
 #include "mem_user.h"
 #include "kern_util.h"
-#include "user_util.h"
 #include "kern.h"
 #include "tt.h"
 
diff -puN arch/um/kernel/tt/mem_user.c~uml-remove-user_utilh arch/um/kernel/tt/mem_user.c
--- a/arch/um/kernel/tt/mem_user.c~uml-remove-user_utilh
+++ a/arch/um/kernel/tt/mem_user.c
@@ -11,7 +11,6 @@
 #include <sys/mman.h>
 #include "tt.h"
 #include "mem_user.h"
-#include "user_util.h"
 #include "os.h"
 
 void remap_data(void *segment_start, void *segment_end, int w)
diff -puN arch/um/kernel/tt/process_kern.c~uml-remove-user_utilh arch/um/kernel/tt/process_kern.c
--- a/arch/um/kernel/tt/process_kern.c~uml-remove-user_utilh
+++ a/arch/um/kernel/tt/process_kern.c
@@ -14,7 +14,6 @@
 #include "asm/tlbflush.h"
 #include "irq_user.h"
 #include "kern_util.h"
-#include "user_util.h"
 #include "os.h"
 #include "kern.h"
 #include "sigcontext.h"
diff -puN arch/um/kernel/tt/ptproxy/proxy.c~uml-remove-user_utilh arch/um/kernel/tt/ptproxy/proxy.c
--- a/arch/um/kernel/tt/ptproxy/proxy.c~uml-remove-user_utilh
+++ a/arch/um/kernel/tt/ptproxy/proxy.c
@@ -26,7 +26,6 @@ Jeff Dike (jdike@karaya.com) : Modified 
 #include "sysdep.h"
 #include "wait.h"
 
-#include "user_util.h"
 #include "user.h"
 #include "os.h"
 #include "tempfile.h"
diff -puN arch/um/kernel/tt/ptproxy/ptrace.c~uml-remove-user_utilh arch/um/kernel/tt/ptproxy/ptrace.c
--- a/arch/um/kernel/tt/ptproxy/ptrace.c~uml-remove-user_utilh
+++ a/arch/um/kernel/tt/ptproxy/ptrace.c
@@ -16,7 +16,6 @@ Jeff Dike (jdike@karaya.com) : Modified 
 
 #include "ptproxy.h"
 #include "debug.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "ptrace_user.h"
 #include "tt.h"
diff -puN arch/um/kernel/tt/ptproxy/sysdep.c~uml-remove-user_utilh arch/um/kernel/tt/ptproxy/sysdep.c
--- a/arch/um/kernel/tt/ptproxy/sysdep.c~uml-remove-user_utilh
+++ a/arch/um/kernel/tt/ptproxy/sysdep.c
@@ -13,7 +13,6 @@ terms and conditions.
 #include <sys/types.h>
 #include <linux/unistd.h>
 #include "ptrace_user.h"
-#include "user_util.h"
 #include "user.h"
 #include "os.h"
 
diff -puN arch/um/kernel/tt/ptproxy/wait.c~uml-remove-user_utilh arch/um/kernel/tt/ptproxy/wait.c
--- a/arch/um/kernel/tt/ptproxy/wait.c~uml-remove-user_utilh
+++ a/arch/um/kernel/tt/ptproxy/wait.c
@@ -13,7 +13,6 @@ terms and conditions.
 #include "ptproxy.h"
 #include "sysdep.h"
 #include "wait.h"
-#include "user_util.h"
 #include "ptrace_user.h"
 #include "sysdep/ptrace.h"
 #include "sysdep/sigcontext.h"
diff -puN arch/um/kernel/tt/syscall_user.c~uml-remove-user_utilh arch/um/kernel/tt/syscall_user.c
--- a/arch/um/kernel/tt/syscall_user.c~uml-remove-user_utilh
+++ a/arch/um/kernel/tt/syscall_user.c
@@ -11,7 +11,6 @@
 #include "sigcontext.h"
 #include "ptrace_user.h"
 #include "task.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "syscall.h"
 #include "tt.h"
diff -puN arch/um/kernel/tt/tlb.c~uml-remove-user_utilh arch/um/kernel/tt/tlb.c
--- a/arch/um/kernel/tt/tlb.c~uml-remove-user_utilh
+++ a/arch/um/kernel/tt/tlb.c
@@ -12,7 +12,6 @@
 #include "asm/pgtable.h"
 #include "asm/uaccess.h"
 #include "asm/tlbflush.h"
-#include "user_util.h"
 #include "mem_user.h"
 #include "os.h"
 #include "tlb.h"
diff -puN arch/um/kernel/tt/tracer.c~uml-remove-user_utilh arch/um/kernel/tt/tracer.c
--- a/arch/um/kernel/tt/tracer.c~uml-remove-user_utilh
+++ a/arch/um/kernel/tt/tracer.c
@@ -19,7 +19,6 @@
 #include "sigcontext.h"
 #include "sysdep/sigcontext.h"
 #include "os.h"
-#include "user_util.h"
 #include "mem_user.h"
 #include "process.h"
 #include "kern_util.h"
diff -puN arch/um/kernel/tt/trap_user.c~uml-remove-user_utilh arch/um/kernel/tt/trap_user.c
--- a/arch/um/kernel/tt/trap_user.c~uml-remove-user_utilh
+++ a/arch/um/kernel/tt/trap_user.c
@@ -8,7 +8,6 @@
 #include <signal.h>
 #include "sysdep/ptrace.h"
 #include "sysdep/sigcontext.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "task.h"
 #include "tt.h"
diff -puN arch/um/kernel/tt/uaccess_user.c~uml-remove-user_utilh arch/um/kernel/tt/uaccess_user.c
--- a/arch/um/kernel/tt/uaccess_user.c~uml-remove-user_utilh
+++ a/arch/um/kernel/tt/uaccess_user.c
@@ -5,7 +5,6 @@
  */
 
 #include <string.h>
-#include "user_util.h"
 #include "uml_uaccess.h"
 #include "task.h"
 #include "kern_util.h"
diff -puN arch/um/kernel/um_arch.c~uml-remove-user_utilh arch/um/kernel/um_arch.c
--- a/arch/um/kernel/um_arch.c~uml-remove-user_utilh
+++ a/arch/um/kernel/um_arch.c
@@ -26,7 +26,6 @@
 #include "asm/setup.h"
 #include "ubd_user.h"
 #include "asm/current.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "as-layout.h"
 #include "arch.h"
diff -puN arch/um/os-Linux/drivers/ethertap_user.c~uml-remove-user_utilh arch/um/os-Linux/drivers/ethertap_user.c
--- a/arch/um/os-Linux/drivers/ethertap_user.c~uml-remove-user_utilh
+++ a/arch/um/os-Linux/drivers/ethertap_user.c
@@ -16,7 +16,6 @@
 #include <net/if.h>
 #include "user.h"
 #include "kern_util.h"
-#include "user_util.h"
 #include "net_user.h"
 #include "etap.h"
 #include "os.h"
diff -puN arch/um/os-Linux/drivers/tuntap_user.c~uml-remove-user_utilh arch/um/os-Linux/drivers/tuntap_user.c
--- a/arch/um/os-Linux/drivers/tuntap_user.c~uml-remove-user_utilh
+++ a/arch/um/os-Linux/drivers/tuntap_user.c
@@ -18,7 +18,6 @@
 #include "net_user.h"
 #include "tuntap.h"
 #include "kern_util.h"
-#include "user_util.h"
 #include "user.h"
 #include "os.h"
 
diff -puN arch/um/os-Linux/file.c~uml-remove-user_utilh arch/um/os-Linux/file.c
--- a/arch/um/os-Linux/file.c~uml-remove-user_utilh
+++ a/arch/um/os-Linux/file.c
@@ -18,7 +18,6 @@
 #include "os.h"
 #include "user.h"
 #include "kern_util.h"
-#include "user_util.h"
 
 static void copy_stat(struct uml_stat *dst, struct stat64 *src)
 {
diff -puN arch/um/os-Linux/helper.c~uml-remove-user_utilh arch/um/os-Linux/helper.c
--- a/arch/um/os-Linux/helper.c~uml-remove-user_utilh
+++ a/arch/um/os-Linux/helper.c
@@ -13,7 +13,6 @@
 #include <sys/wait.h>
 #include "user.h"
 #include "kern_util.h"
-#include "user_util.h"
 #include "os.h"
 #include "um_malloc.h"
 
diff -puN arch/um/os-Linux/irq.c~uml-remove-user_utilh arch/um/os-Linux/irq.c
--- a/arch/um/os-Linux/irq.c~uml-remove-user_utilh
+++ a/arch/um/os-Linux/irq.c
@@ -11,7 +11,6 @@
 #include <sys/poll.h>
 #include <sys/types.h>
 #include <sys/time.h>
-#include "user_util.h"
 #include "kern_util.h"
 #include "user.h"
 #include "process.h"
diff -puN arch/um/os-Linux/main.c~uml-remove-user_utilh arch/um/os-Linux/main.c
--- a/arch/um/os-Linux/main.c~uml-remove-user_utilh
+++ a/arch/um/os-Linux/main.c
@@ -13,7 +13,6 @@
 #include <sys/mman.h>
 #include <sys/user.h>
 #include <asm/page.h>
-#include "user_util.h"
 #include "kern_util.h"
 #include "as-layout.h"
 #include "mem_user.h"
diff -puN arch/um/os-Linux/mem.c~uml-remove-user_utilh arch/um/os-Linux/mem.c
--- a/arch/um/os-Linux/mem.c~uml-remove-user_utilh
+++ a/arch/um/os-Linux/mem.c
@@ -11,7 +11,6 @@
 #include <sys/statfs.h>
 #include "kern_util.h"
 #include "user.h"
-#include "user_util.h"
 #include "mem_user.h"
 #include "init.h"
 #include "os.h"
diff -puN arch/um/os-Linux/process.c~uml-remove-user_utilh arch/um/os-Linux/process.c
--- a/arch/um/os-Linux/process.c~uml-remove-user_utilh
+++ a/arch/um/os-Linux/process.c
@@ -14,7 +14,6 @@
 #include "ptrace_user.h"
 #include "os.h"
 #include "user.h"
-#include "user_util.h"
 #include "process.h"
 #include "irq_user.h"
 #include "kern_util.h"
diff -puN arch/um/os-Linux/sigio.c~uml-remove-user_utilh arch/um/os-Linux/sigio.c
--- a/arch/um/os-Linux/sigio.c~uml-remove-user_utilh
+++ a/arch/um/os-Linux/sigio.c
@@ -17,7 +17,6 @@
 #include "init.h"
 #include "user.h"
 #include "kern_util.h"
-#include "user_util.h"
 #include "sigio.h"
 #include "os.h"
 #include "um_malloc.h"
diff -puN arch/um/os-Linux/signal.c~uml-remove-user_utilh arch/um/os-Linux/signal.c
--- a/arch/um/os-Linux/signal.c~uml-remove-user_utilh
+++ a/arch/um/os-Linux/signal.c
@@ -11,7 +11,6 @@
 #include <stdarg.h>
 #include <string.h>
 #include <sys/mman.h>
-#include "user_util.h"
 #include "user.h"
 #include "signal_kern.h"
 #include "sysdep/sigcontext.h"
diff -puN arch/um/os-Linux/skas/mem.c~uml-remove-user_utilh arch/um/os-Linux/skas/mem.c
--- a/arch/um/os-Linux/skas/mem.c~uml-remove-user_utilh
+++ a/arch/um/os-Linux/skas/mem.c
@@ -17,7 +17,6 @@
 #include "os.h"
 #include "proc_mm.h"
 #include "ptrace_user.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "task.h"
 #include "registers.h"
diff -puN arch/um/os-Linux/skas/process.c~uml-remove-user_utilh arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-remove-user_utilh
+++ a/arch/um/os-Linux/skas/process.c
@@ -18,7 +18,6 @@
 #include <asm/types.h>
 #include "user.h"
 #include "sysdep/ptrace.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "skas.h"
 #include "stub-data.h"
diff -puN arch/um/os-Linux/skas/trap.c~uml-remove-user_utilh arch/um/os-Linux/skas/trap.c
--- a/arch/um/os-Linux/skas/trap.c~uml-remove-user_utilh
+++ a/arch/um/os-Linux/skas/trap.c
@@ -5,7 +5,6 @@
 
 #include <signal.h>
 #include <errno.h>
-#include "user_util.h"
 #include "kern_util.h"
 #include "as-layout.h"
 #include "task.h"
diff -puN arch/um/os-Linux/start_up.c~uml-remove-user_utilh arch/um/os-Linux/start_up.c
--- a/arch/um/os-Linux/start_up.c~uml-remove-user_utilh
+++ a/arch/um/os-Linux/start_up.c
@@ -21,7 +21,6 @@
 #include <asm/unistd.h>
 #include <asm/page.h>
 #include <sys/types.h>
-#include "user_util.h"
 #include "kern_util.h"
 #include "user.h"
 #include "signal_kern.h"
diff -puN arch/um/os-Linux/sys-i386/tls.c~uml-remove-user_utilh arch/um/os-Linux/sys-i386/tls.c
--- a/arch/um/os-Linux/sys-i386/tls.c~uml-remove-user_utilh
+++ a/arch/um/os-Linux/sys-i386/tls.c
@@ -6,7 +6,6 @@
 
 #include "sysdep/tls.h"
 #include "user.h"
-#include "user_util.h"
 
 /* Checks whether host supports TLS, and sets *tls_min according to the value
  * valid on the host.
diff -puN arch/um/os-Linux/time.c~uml-remove-user_utilh arch/um/os-Linux/time.c
--- a/arch/um/os-Linux/time.c~uml-remove-user_utilh
+++ a/arch/um/os-Linux/time.c
@@ -10,7 +10,6 @@
 #include <sys/time.h>
 #include <signal.h>
 #include <errno.h>
-#include "user_util.h"
 #include "kern_util.h"
 #include "user.h"
 #include "process.h"
diff -puN arch/um/os-Linux/trap.c~uml-remove-user_utilh arch/um/os-Linux/trap.c
--- a/arch/um/os-Linux/trap.c~uml-remove-user_utilh
+++ a/arch/um/os-Linux/trap.c
@@ -6,7 +6,6 @@
 #include <stdlib.h>
 #include <signal.h>
 #include "kern_util.h"
-#include "user_util.h"
 #include "os.h"
 #include "mode.h"
 #include "longjmp.h"
diff -puN arch/um/os-Linux/tt.c~uml-remove-user_utilh arch/um/os-Linux/tt.c
--- a/arch/um/os-Linux/tt.c~uml-remove-user_utilh
+++ a/arch/um/os-Linux/tt.c
@@ -18,7 +18,6 @@
 #include <asm/ptrace.h>
 #include <asm/unistd.h>
 #include <asm/page.h>
-#include "user_util.h"
 #include "kern_util.h"
 #include "user.h"
 #include "signal_kern.h"
diff -puN arch/um/os-Linux/util.c~uml-remove-user_utilh arch/um/os-Linux/util.c
--- a/arch/um/os-Linux/util.c~uml-remove-user_utilh
+++ a/arch/um/os-Linux/util.c
@@ -21,7 +21,6 @@
 #include <sched.h>
 #include <termios.h>
 #include <string.h>
-#include "user_util.h"
 #include "kern_util.h"
 #include "user.h"
 #include "mem_user.h"
diff -puN arch/um/sys-i386/bugs.c~uml-remove-user_utilh arch/um/sys-i386/bugs.c
--- a/arch/um/sys-i386/bugs.c~uml-remove-user_utilh
+++ a/arch/um/sys-i386/bugs.c
@@ -13,7 +13,6 @@
 #include "sysdep/ptrace.h"
 #include "task.h"
 #include "os.h"
-#include "user_util.h"
 
 #define MAXTOKEN 64
 
diff -puN arch/um/sys-i386/ptrace_user.c~uml-remove-user_utilh arch/um/sys-i386/ptrace_user.c
--- a/arch/um/sys-i386/ptrace_user.c~uml-remove-user_utilh
+++ a/arch/um/sys-i386/ptrace_user.c
@@ -15,7 +15,6 @@
 #include "user.h"
 #include "os.h"
 #include "uml-config.h"
-#include "user_util.h"
 
 int ptrace_getregs(long pid, unsigned long *regs_out)
 {
diff -puN arch/um/sys-ppc/sigcontext.c~uml-remove-user_utilh arch/um/sys-ppc/sigcontext.c
--- a/arch/um/sys-ppc/sigcontext.c~uml-remove-user_utilh
+++ a/arch/um/sys-ppc/sigcontext.c
@@ -1,7 +1,6 @@
 #include "asm/ptrace.h"
 #include "asm/sigcontext.h"
 #include "sysdep/ptrace.h"
-#include "user_util.h"
 
 /*
  * Overrides for Emacs so that we follow Linus's tabbing style.
_

Patches currently in -mm which might be from jdike@addtoit.com are

div64_64-common-code.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
array_size-check-for-type-uml-fix.patch
uml-fix-prototypes.patch
uml-move-sigio-testing-to-sigioc.patch
uml-create-archh.patch
uml-create-as-layouth.patch
uml-move-remaining-useful-contents-of-user_utilh.patch
uml-remove-user_utilh.patch
uml-add-missing-__init-declarations.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
