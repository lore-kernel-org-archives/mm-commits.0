From: akpm@linux-foundation.org
Subject: - uml-move-sigio-testing-to-sigioc.patch removed from -mm tree
Date: Mon, 07 May 2007 17:06:15 -0700
Message-ID: <200705080006.l4806FRh009166@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754757AbXEHAGr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:06:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: move SIGIO testing to sigio.c
has been removed from the -mm tree.  Its filename was
     uml-move-sigio-testing-to-sigioc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: move SIGIO testing to sigio.c
From: Jeff Dike <jdike@addtoit.com>

This patch narrows the sigio interface.  The boot-time SIGIO testing used to
be in start_up.c, which meant that pty_output_sigio and pty_close_sigio needed
to be global.  By moving that code here, those can become static and the
declarations moved from user_util.h.

os_check_bugs is also here because it only does the SIGIO checking.  If it
does more, it'll probably move back to start_up.c.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/user_util.h |    3 
 arch/um/os-Linux/sigio.c    |  145 ++++++++++++++++++++++++++++++++++
 arch/um/os-Linux/start_up.c |  145 ----------------------------------
 3 files changed, 145 insertions(+), 148 deletions(-)

diff -puN arch/um/include/user_util.h~uml-move-sigio-testing-to-sigioc arch/um/include/user_util.h
--- a/arch/um/include/user_util.h~uml-move-sigio-testing-to-sigioc
+++ a/arch/um/include/user_util.h
@@ -51,9 +51,6 @@ extern unsigned long _stext, _etext, _sd
 extern unsigned long _unprotected_end;
 extern unsigned long brk_start;
 
-extern int pty_output_sigio;
-extern int pty_close_sigio;
-
 extern void *add_signal_handler(int sig, void (*handler)(int));
 extern int linux_main(int argc, char **argv);
 extern void set_cmdline(char *cmd);
diff -puN arch/um/os-Linux/sigio.c~uml-move-sigio-testing-to-sigioc arch/um/os-Linux/sigio.c
--- a/arch/um/os-Linux/sigio.c~uml-move-sigio-testing-to-sigioc
+++ a/arch/um/os-Linux/sigio.c
@@ -8,6 +8,7 @@
 #include <termios.h>
 #include <pty.h>
 #include <signal.h>
+#include <fcntl.h>
 #include <errno.h>
 #include <string.h>
 #include <sched.h>
@@ -20,6 +21,7 @@
 #include "sigio.h"
 #include "os.h"
 #include "um_malloc.h"
+#include "init.h"
 
 /* Protected by sigio_lock(), also used by sigio_cleanup, which is an
  * exitcall.
@@ -320,6 +322,10 @@ out_close1:
 	close(l_write_sigio_fds[1]);
 }
 
+/* Changed during early boot */
+static int pty_output_sigio = 0;
+static int pty_close_sigio = 0;
+
 void maybe_sigio_broken(int fd, int read)
 {
 	int err;
@@ -357,3 +363,142 @@ static void sigio_cleanup(void)
 }
 
 __uml_exitcall(sigio_cleanup);
+
+/* Used as a flag during SIGIO testing early in boot */
+static volatile int got_sigio = 0;
+
+static void __init handler(int sig)
+{
+	got_sigio = 1;
+}
+
+struct openpty_arg {
+	int master;
+	int slave;
+	int err;
+};
+
+static void openpty_cb(void *arg)
+{
+	struct openpty_arg *info = arg;
+
+	info->err = 0;
+	if(openpty(&info->master, &info->slave, NULL, NULL, NULL))
+		info->err = -errno;
+}
+
+static int async_pty(int master, int slave)
+{
+	int flags;
+
+	flags = fcntl(master, F_GETFL);
+	if(flags < 0)
+		return -errno;
+
+	if((fcntl(master, F_SETFL, flags | O_NONBLOCK | O_ASYNC) < 0) ||
+	   (fcntl(master, F_SETOWN, os_getpid()) < 0))
+		return -errno;
+
+	if((fcntl(slave, F_SETFL, flags | O_NONBLOCK) < 0))
+		return -errno;
+
+	return(0);
+}
+
+static void __init check_one_sigio(void (*proc)(int, int))
+{
+	struct sigaction old, new;
+	struct openpty_arg pty = { .master = -1, .slave = -1 };
+	int master, slave, err;
+
+	initial_thread_cb(openpty_cb, &pty);
+	if(pty.err){
+		printk("openpty failed, errno = %d\n", -pty.err);
+		return;
+	}
+
+	master = pty.master;
+	slave = pty.slave;
+
+	if((master == -1) || (slave == -1)){
+		printk("openpty failed to allocate a pty\n");
+		return;
+	}
+
+	/* Not now, but complain so we now where we failed. */
+	err = raw(master);
+	if (err < 0)
+		panic("check_sigio : __raw failed, errno = %d\n", -err);
+
+	err = async_pty(master, slave);
+	if(err < 0)
+		panic("tty_fds : sigio_async failed, err = %d\n", -err);
+
+	if(sigaction(SIGIO, NULL, &old) < 0)
+		panic("check_sigio : sigaction 1 failed, errno = %d\n", errno);
+	new = old;
+	new.sa_handler = handler;
+	if(sigaction(SIGIO, &new, NULL) < 0)
+		panic("check_sigio : sigaction 2 failed, errno = %d\n", errno);
+
+	got_sigio = 0;
+	(*proc)(master, slave);
+
+	close(master);
+	close(slave);
+
+	if(sigaction(SIGIO, &old, NULL) < 0)
+		panic("check_sigio : sigaction 3 failed, errno = %d\n", errno);
+}
+
+static void tty_output(int master, int slave)
+{
+	int n;
+	char buf[512];
+
+	printk("Checking that host ptys support output SIGIO...");
+
+	memset(buf, 0, sizeof(buf));
+
+	while(os_write_file(master, buf, sizeof(buf)) > 0) ;
+	if(errno != EAGAIN)
+		panic("check_sigio : write failed, errno = %d\n", errno);
+	while(((n = os_read_file(slave, buf, sizeof(buf))) > 0) && !got_sigio) ;
+
+	if(got_sigio){
+		printk("Yes\n");
+		pty_output_sigio = 1;
+	}
+	else if(n == -EAGAIN) printk("No, enabling workaround\n");
+	else panic("check_sigio : read failed, err = %d\n", n);
+}
+
+static void tty_close(int master, int slave)
+{
+	printk("Checking that host ptys support SIGIO on close...");
+
+	close(slave);
+	if(got_sigio){
+		printk("Yes\n");
+		pty_close_sigio = 1;
+	}
+	else printk("No, enabling workaround\n");
+}
+
+void __init check_sigio(void)
+{
+	if((os_access("/dev/ptmx", OS_ACC_R_OK) < 0) &&
+	   (os_access("/dev/ptyp0", OS_ACC_R_OK) < 0)){
+		printk("No pseudo-terminals available - skipping pty SIGIO "
+		       "check\n");
+		return;
+	}
+	check_one_sigio(tty_output);
+	check_one_sigio(tty_close);
+}
+
+/* Here because it only does the SIGIO testing for now */
+void __init os_check_bugs(void)
+{
+	check_sigio();
+}
diff -puN arch/um/os-Linux/start_up.c~uml-move-sigio-testing-to-sigioc arch/um/os-Linux/start_up.c
--- a/arch/um/os-Linux/start_up.c~uml-move-sigio-testing-to-sigioc
+++ a/arch/um/os-Linux/start_up.c
@@ -553,148 +553,3 @@ int __init parse_iomem(char *str, int *a
  out:
 	return 1;
 }
-
-
-/* Changed during early boot */
-int pty_output_sigio = 0;
-int pty_close_sigio = 0;
-
-/* Used as a flag during SIGIO testing early in boot */
-static volatile int got_sigio = 0;
-
-static void __init handler(int sig)
-{
-	got_sigio = 1;
-}
-
-struct openpty_arg {
-	int master;
-	int slave;
-	int err;
-};
-
-static void openpty_cb(void *arg)
-{
-	struct openpty_arg *info = arg;
-
-	info->err = 0;
-	if(openpty(&info->master, &info->slave, NULL, NULL, NULL))
-		info->err = -errno;
-}
-
-static int async_pty(int master, int slave)
-{
-	int flags;
-
-	flags = fcntl(master, F_GETFL);
-	if(flags < 0)
-		return -errno;
-
-	if((fcntl(master, F_SETFL, flags | O_NONBLOCK | O_ASYNC) < 0) ||
-	   (fcntl(master, F_SETOWN, os_getpid()) < 0))
-		return -errno;
-
-	if((fcntl(slave, F_SETFL, flags | O_NONBLOCK) < 0))
-		return -errno;
-
-	return(0);
-}
-
-static void __init check_one_sigio(void (*proc)(int, int))
-{
-	struct sigaction old, new;
-	struct openpty_arg pty = { .master = -1, .slave = -1 };
-	int master, slave, err;
-
-	initial_thread_cb(openpty_cb, &pty);
-	if(pty.err){
-		printk("openpty failed, errno = %d\n", -pty.err);
-		return;
-	}
-
-	master = pty.master;
-	slave = pty.slave;
-
-	if((master == -1) || (slave == -1)){
-		printk("openpty failed to allocate a pty\n");
-		return;
-	}
-
-	/* Not now, but complain so we now where we failed. */
-	err = raw(master);
-	if (err < 0)
-		panic("check_sigio : __raw failed, errno = %d\n", -err);
-
-	err = async_pty(master, slave);
-	if(err < 0)
-		panic("tty_fds : sigio_async failed, err = %d\n", -err);
-
-	if(sigaction(SIGIO, NULL, &old) < 0)
-		panic("check_sigio : sigaction 1 failed, errno = %d\n", errno);
-	new = old;
-	new.sa_handler = handler;
-	if(sigaction(SIGIO, &new, NULL) < 0)
-		panic("check_sigio : sigaction 2 failed, errno = %d\n", errno);
-
-	got_sigio = 0;
-	(*proc)(master, slave);
-
-	close(master);
-	close(slave);
-
-	if(sigaction(SIGIO, &old, NULL) < 0)
-		panic("check_sigio : sigaction 3 failed, errno = %d\n", errno);
-}
-
-static void tty_output(int master, int slave)
-{
-	int n;
-	char buf[512];
-
-	printk("Checking that host ptys support output SIGIO...");
-
-	memset(buf, 0, sizeof(buf));
-
-	while(os_write_file(master, buf, sizeof(buf)) > 0) ;
-	if(errno != EAGAIN)
-		panic("check_sigio : write failed, errno = %d\n", errno);
-	while(((n = os_read_file(slave, buf, sizeof(buf))) > 0) && !got_sigio) ;
-
-	if(got_sigio){
-		printk("Yes\n");
-		pty_output_sigio = 1;
-	}
-	else if(n == -EAGAIN) printk("No, enabling workaround\n");
-	else panic("check_sigio : read failed, err = %d\n", n);
-}
-
-static void tty_close(int master, int slave)
-{
-	printk("Checking that host ptys support SIGIO on close...");
-
-	close(slave);
-	if(got_sigio){
-		printk("Yes\n");
-		pty_close_sigio = 1;
-	}
-	else printk("No, enabling workaround\n");
-}
-
-void __init check_sigio(void)
-{
-	if((os_access("/dev/ptmx", OS_ACC_R_OK) < 0) &&
-	   (os_access("/dev/ptyp0", OS_ACC_R_OK) < 0)){
-		printk("No pseudo-terminals available - skipping pty SIGIO "
-		       "check\n");
-		return;
-	}
-	check_one_sigio(tty_output);
-	check_one_sigio(tty_close);
-}
-
-void os_check_bugs(void)
-{
-	check_ptrace();
-	check_sigio();
-}
-
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch
