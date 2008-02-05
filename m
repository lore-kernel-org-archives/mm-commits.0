From: akpm@linux-foundation.org
Subject: - uml-style-fixes-in-arch-um-os-linux.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:37:07 -0800
Message-ID: <200802052236.m15Mamgi012734@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57795 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762450AbYBEWmO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: syle fixes in arch/um/os-Linux
has been removed from the -mm tree.  Its filename was
     uml-style-fixes-in-arch-um-os-linux.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: syle fixes in arch/um/os-Linux
From: Jeff Dike <jdike@addtoit.com>

Style fixes in arch/um/os-Linux/irq.c and arch/um/os-Linux/sigio.c:
	Updated copyrights
	trimmed includes
	added severity indicators to printks
	CodingStyle fixes
	turned an bunch of panics into printks
	call some libc functions directly instead of going through the
os_* wrappers

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/irq.c   |   27 +---
 arch/um/os-Linux/sigio.c |  241 +++++++++++++++++++++----------------
 2 files changed, 150 insertions(+), 118 deletions(-)

diff -puN arch/um/os-Linux/irq.c~uml-style-fixes-in-arch-um-os-linux arch/um/os-Linux/irq.c
--- a/arch/um/os-Linux/irq.c~uml-style-fixes-in-arch-um-os-linux
+++ a/arch/um/os-Linux/irq.c
@@ -1,22 +1,19 @@
 /*
- * Copyright (C) 2000, 2001, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
 #include <stdlib.h>
-#include <unistd.h>
 #include <errno.h>
+#include <poll.h>
 #include <signal.h>
 #include <string.h>
-#include <sys/poll.h>
-#include <sys/types.h>
-#include <sys/time.h>
-#include "user.h"
-#include "process.h"
-#include "sigio.h"
 #include "irq_user.h"
+#include "kern_constants.h"
 #include "os.h"
+#include "process.h"
 #include "um_malloc.h"
+#include "user.h"
 
 /*
  * Locked by irq_lock in arch/um/kernel/irq.c.  Changed by os_create_pollfd
@@ -35,7 +32,7 @@ int os_waiting_for_events(struct irq_fd 
 	if (n < 0) {
 		err = -errno;
 		if (errno != EINTR)
-			printk("sigio_handler: os_waiting_for_events:"
+			printk(UM_KERN_ERR "os_waiting_for_events:"
 			       " poll returned %d, errno = %d\n", n, errno);
 		return err;
 	}
@@ -94,24 +91,26 @@ void os_free_irq_by_cb(int (*test)(struc
 			struct irq_fd *old_fd = *prev;
 			if ((pollfds[i].fd != -1) &&
 			    (pollfds[i].fd != (*prev)->fd)) {
-				printk("os_free_irq_by_cb - mismatch between "
-				       "active_fds and pollfds, fd %d vs %d\n",
+				printk(UM_KERN_ERR "os_free_irq_by_cb - "
+				       "mismatch between active_fds and "
+				       "pollfds, fd %d vs %d\n",
 				       (*prev)->fd, pollfds[i].fd);
 				goto out;
 			}
 
 			pollfds_num--;
 
-			/* This moves the *whole* array after pollfds[i]
+			/*
+			 * This moves the *whole* array after pollfds[i]
 			 * (though it doesn't spot as such)!
 			 */
 			memmove(&pollfds[i], &pollfds[i + 1],
 			       (pollfds_num - i) * sizeof(pollfds[0]));
-			if(*last_irq_ptr2 == &old_fd->next)
+			if (*last_irq_ptr2 == &old_fd->next)
 				*last_irq_ptr2 = prev;
 
 			*prev = (*prev)->next;
-			if(old_fd->type == IRQ_WRITE)
+			if (old_fd->type == IRQ_WRITE)
 				ignore_sigio_fd(old_fd->fd);
 			kfree(old_fd);
 			continue;
diff -puN arch/um/os-Linux/sigio.c~uml-style-fixes-in-arch-um-os-linux arch/um/os-Linux/sigio.c
--- a/arch/um/os-Linux/sigio.c~uml-style-fixes-in-arch-um-os-linux
+++ a/arch/um/os-Linux/sigio.c
@@ -1,33 +1,33 @@
 /*
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
 #include <unistd.h>
-#include <stdlib.h>
-#include <termios.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <poll.h>
 #include <pty.h>
+#include <sched.h>
 #include <signal.h>
-#include <fcntl.h>
-#include <errno.h>
 #include <string.h>
-#include <sched.h>
-#include <sys/socket.h>
-#include <sys/poll.h>
-#include "init.h"
-#include "user.h"
+#include "kern_constants.h"
 #include "kern_util.h"
-#include "sigio.h"
+#include "init.h"
 #include "os.h"
+#include "sigio.h"
 #include "um_malloc.h"
+#include "user.h"
 
-/* Protected by sigio_lock(), also used by sigio_cleanup, which is an
+/*
+ * Protected by sigio_lock(), also used by sigio_cleanup, which is an
  * exitcall.
  */
 static int write_sigio_pid = -1;
 static unsigned long write_sigio_stack;
 
-/* These arrays are initialized before the sigio thread is started, and
+/*
+ * These arrays are initialized before the sigio thread is started, and
  * the descriptors closed after it is killed.  So, it can't see them change.
  * On the UML side, they are changed under the sigio_lock.
  */
@@ -42,7 +42,8 @@ struct pollfds {
 	int used;
 };
 
-/* Protected by sigio_lock().  Used by the sigio thread, but the UML thread
+/*
+ * Protected by sigio_lock().  Used by the sigio thread, but the UML thread
  * synchronizes with it.
  */
 static struct pollfds current_poll;
@@ -56,23 +57,26 @@ static int write_sigio_thread(void *unus
 	int i, n, respond_fd;
 	char c;
 
-        signal(SIGWINCH, SIG_IGN);
+	signal(SIGWINCH, SIG_IGN);
 	fds = &current_poll;
-	while(1){
+	while (1) {
 		n = poll(fds->poll, fds->used, -1);
-		if(n < 0){
-			if(errno == EINTR) continue;
-			printk("write_sigio_thread : poll returned %d, "
-			       "errno = %d\n", n, errno);
+		if (n < 0) {
+			if (errno == EINTR)
+				continue;
+			printk(UM_KERN_ERR "write_sigio_thread : poll returned "
+			       "%d, errno = %d\n", n, errno);
 		}
-		for(i = 0; i < fds->used; i++){
+		for (i = 0; i < fds->used; i++) {
 			p = &fds->poll[i];
-			if(p->revents == 0) continue;
-			if(p->fd == sigio_private[1]){
+			if (p->revents == 0)
+				continue;
+			if (p->fd == sigio_private[1]) {
 				CATCH_EINTR(n = read(sigio_private[1], &c,
 						     sizeof(c)));
-				if(n != sizeof(c))
-					printk("write_sigio_thread : "
+				if (n != sizeof(c))
+					printk(UM_KERN_ERR
+					       "write_sigio_thread : "
 					       "read on socket failed, "
 					       "err = %d\n", errno);
 				tmp = current_poll;
@@ -88,9 +92,10 @@ static int write_sigio_thread(void *unus
 			}
 
 			CATCH_EINTR(n = write(respond_fd, &c, sizeof(c)));
-			if(n != sizeof(c))
-				printk("write_sigio_thread : write on socket "
-				       "failed, err = %d\n", errno);
+			if (n != sizeof(c))
+				printk(UM_KERN_ERR "write_sigio_thread : "
+				       "write on socket failed, err = %d\n",
+				       errno);
 		}
 	}
 
@@ -101,12 +106,13 @@ static int need_poll(struct pollfds *pol
 {
 	struct pollfd *new;
 
-	if(n <= polls->size)
+	if (n <= polls->size)
 		return 0;
 
 	new = kmalloc(n * sizeof(struct pollfd), UM_GFP_ATOMIC);
-	if(new == NULL){
-		printk("need_poll : failed to allocate new pollfds\n");
+	if (new == NULL) {
+		printk(UM_KERN_ERR "need_poll : failed to allocate new "
+		       "pollfds\n");
 		return -ENOMEM;
 	}
 
@@ -118,7 +124,8 @@ static int need_poll(struct pollfds *pol
 	return 0;
 }
 
-/* Must be called with sigio_lock held, because it's needed by the marked
+/*
+ * Must be called with sigio_lock held, because it's needed by the marked
  * critical section.
  */
 static void update_thread(void)
@@ -128,15 +135,17 @@ static void update_thread(void)
 	char c;
 
 	flags = set_signals(0);
-	n = write(sigio_private[0], &c, sizeof(c));
-	if(n != sizeof(c)){
-		printk("update_thread : write failed, err = %d\n", errno);
+	CATCH_EINTR(n = write(sigio_private[0], &c, sizeof(c)));
+	if (n != sizeof(c)) {
+		printk(UM_KERN_ERR "update_thread : write failed, err = %d\n",
+		       errno);
 		goto fail;
 	}
 
 	CATCH_EINTR(n = read(sigio_private[0], &c, sizeof(c)));
-	if(n != sizeof(c)){
-		printk("update_thread : read failed, err = %d\n", errno);
+	if (n != sizeof(c)) {
+		printk(UM_KERN_ERR "update_thread : read failed, err = %d\n",
+		       errno);
 		goto fail;
 	}
 
@@ -163,23 +172,23 @@ int add_sigio_fd(int fd)
 	int err = 0, i, n;
 
 	sigio_lock();
-	for(i = 0; i < all_sigio_fds.used; i++){
-		if(all_sigio_fds.poll[i].fd == fd)
+	for (i = 0; i < all_sigio_fds.used; i++) {
+		if (all_sigio_fds.poll[i].fd == fd)
 			break;
 	}
-	if(i == all_sigio_fds.used)
+	if (i == all_sigio_fds.used)
 		goto out;
 
 	p = &all_sigio_fds.poll[i];
 
-	for(i = 0; i < current_poll.used; i++){
-		if(current_poll.poll[i].fd == fd)
+	for (i = 0; i < current_poll.used; i++) {
+		if (current_poll.poll[i].fd == fd)
 			goto out;
 	}
 
 	n = current_poll.used;
 	err = need_poll(&next_poll, n + 1);
-	if(err)
+	if (err)
 		goto out;
 
 	memcpy(next_poll.poll, current_poll.poll,
@@ -197,27 +206,29 @@ int ignore_sigio_fd(int fd)
 	struct pollfd *p;
 	int err = 0, i, n = 0;
 
-	/* This is called from exitcalls elsewhere in UML - if
+	/*
+	 * This is called from exitcalls elsewhere in UML - if
 	 * sigio_cleanup has already run, then update_thread will hang
 	 * or fail because the thread is no longer running.
 	 */
-	if(write_sigio_pid == -1)
+	if (write_sigio_pid == -1)
 		return -EIO;
 
 	sigio_lock();
-	for(i = 0; i < current_poll.used; i++){
-		if(current_poll.poll[i].fd == fd) break;
+	for (i = 0; i < current_poll.used; i++) {
+		if (current_poll.poll[i].fd == fd)
+			break;
 	}
-	if(i == current_poll.used)
+	if (i == current_poll.used)
 		goto out;
 
 	err = need_poll(&next_poll, current_poll.used - 1);
-	if(err)
+	if (err)
 		goto out;
 
-	for(i = 0; i < current_poll.used; i++){
+	for (i = 0; i < current_poll.used; i++) {
 		p = &current_poll.poll[i];
-		if(p->fd != fd)
+		if (p->fd != fd)
 			next_poll.poll[n++] = *p;
 	}
 	next_poll.used = current_poll.used - 1;
@@ -234,7 +245,8 @@ static struct pollfd *setup_initial_poll
 
 	p = kmalloc(sizeof(struct pollfd), UM_GFP_KERNEL);
 	if (p == NULL) {
-		printk("setup_initial_poll : failed to allocate poll\n");
+		printk(UM_KERN_ERR "setup_initial_poll : failed to allocate "
+		       "poll\n");
 		return NULL;
 	}
 	*p = ((struct pollfd) { .fd		= fd,
@@ -260,27 +272,29 @@ static void write_sigio_workaround(void)
 		return;
 
 	err = os_pipe(l_write_sigio_fds, 1, 1);
-	if(err < 0){
-		printk("write_sigio_workaround - os_pipe 1 failed, "
+	if (err < 0) {
+		printk(UM_KERN_ERR "write_sigio_workaround - os_pipe 1 failed, "
 		       "err = %d\n", -err);
 		return;
 	}
 	err = os_pipe(l_sigio_private, 1, 1);
-	if(err < 0){
-		printk("write_sigio_workaround - os_pipe 2 failed, "
+	if (err < 0) {
+		printk(UM_KERN_ERR "write_sigio_workaround - os_pipe 2 failed, "
 		       "err = %d\n", -err);
 		goto out_close1;
 	}
 
 	p = setup_initial_poll(l_sigio_private[1]);
-	if(!p)
+	if (!p)
 		goto out_close2;
 
 	sigio_lock();
 
-	/* Did we race? Don't try to optimize this, please, it's not so likely
-	 * to happen, and no more than once at the boot. */
-	if(write_sigio_pid != -1)
+	/*
+	 * Did we race? Don't try to optimize this, please, it's not so likely
+	 * to happen, and no more than once at the boot.
+	 */
+	if (write_sigio_pid != -1)
 		goto out_free;
 
 	current_poll = ((struct pollfds) { .poll 	= p,
@@ -332,19 +346,19 @@ void maybe_sigio_broken(int fd, int read
 {
 	int err;
 
-	if(!isatty(fd))
+	if (!isatty(fd))
 		return;
 
-	if((read || pty_output_sigio) && (!read || pty_close_sigio))
+	if ((read || pty_output_sigio) && (!read || pty_close_sigio))
 		return;
 
 	write_sigio_workaround();
 
 	sigio_lock();
 	err = need_poll(&all_sigio_fds, all_sigio_fds.used + 1);
-	if(err){
-		printk("maybe_sigio_broken - failed to add pollfd for "
-		       "descriptor %d\n", fd);
+	if (err) {
+		printk(UM_KERN_ERR "maybe_sigio_broken - failed to add pollfd "
+		       "for descriptor %d\n", fd);
 		goto out;
 	}
 
@@ -387,7 +401,7 @@ static void openpty_cb(void *arg)
 	struct openpty_arg *info = arg;
 
 	info->err = 0;
-	if(openpty(&info->master, &info->slave, NULL, NULL, NULL))
+	if (openpty(&info->master, &info->slave, NULL, NULL, NULL))
 		info->err = -errno;
 }
 
@@ -396,14 +410,14 @@ static int async_pty(int master, int sla
 	int flags;
 
 	flags = fcntl(master, F_GETFL);
-	if(flags < 0)
+	if (flags < 0)
 		return -errno;
 
-	if((fcntl(master, F_SETFL, flags | O_NONBLOCK | O_ASYNC) < 0) ||
-	   (fcntl(master, F_SETOWN, os_getpid()) < 0))
+	if ((fcntl(master, F_SETFL, flags | O_NONBLOCK | O_ASYNC) < 0) ||
+	    (fcntl(master, F_SETOWN, os_getpid()) < 0))
 		return -errno;
 
-	if((fcntl(slave, F_SETFL, flags | O_NONBLOCK) < 0))
+	if ((fcntl(slave, F_SETFL, flags | O_NONBLOCK) < 0))
 		return -errno;
 
 	return 0;
@@ -416,34 +430,49 @@ static void __init check_one_sigio(void 
 	int master, slave, err;
 
 	initial_thread_cb(openpty_cb, &pty);
-	if(pty.err){
-		printk("openpty failed, errno = %d\n", -pty.err);
+	if (pty.err) {
+		printk(UM_KERN_ERR "check_one_sigio failed, errno = %d\n",
+		       -pty.err);
 		return;
 	}
 
 	master = pty.master;
 	slave = pty.slave;
 
-	if((master == -1) || (slave == -1)){
-		printk("openpty failed to allocate a pty\n");
+	if ((master == -1) || (slave == -1)) {
+		printk(UM_KERN_ERR "check_one_sigio failed to allocate a "
+		       "pty\n");
 		return;
 	}
 
 	/* Not now, but complain so we now where we failed. */
 	err = raw(master);
-	if (err < 0)
-		panic("check_sigio : __raw failed, errno = %d\n", -err);
+	if (err < 0) {
+		printk(UM_KERN_ERR "check_one_sigio : raw failed, errno = %d\n",
+		      -err);
+		return;
+	}
 
 	err = async_pty(master, slave);
-	if(err < 0)
-		panic("tty_fds : sigio_async failed, err = %d\n", -err);
+	if (err < 0) {
+		printk(UM_KERN_ERR "check_one_sigio : sigio_async failed, "
+		       "err = %d\n", -err);
+		return;
+	}
+
+	if (sigaction(SIGIO, NULL, &old) < 0) {
+		printk(UM_KERN_ERR "check_one_sigio : sigaction 1 failed, "
+		       "errno = %d\n", errno);
+		return;
+	}
 
-	if(sigaction(SIGIO, NULL, &old) < 0)
-		panic("check_sigio : sigaction 1 failed, errno = %d\n", errno);
 	new = old;
 	new.sa_handler = handler;
-	if(sigaction(SIGIO, &new, NULL) < 0)
-		panic("check_sigio : sigaction 2 failed, errno = %d\n", errno);
+	if (sigaction(SIGIO, &new, NULL) < 0) {
+		printk(UM_KERN_ERR "check_one_sigio : sigaction 2 failed, "
+		       "errno = %d\n", errno);
+		return;
+	}
 
 	got_sigio = 0;
 	(*proc)(master, slave);
@@ -451,8 +480,9 @@ static void __init check_one_sigio(void 
 	close(master);
 	close(slave);
 
-	if(sigaction(SIGIO, &old, NULL) < 0)
-		panic("check_sigio : sigaction 3 failed, errno = %d\n", errno);
+	if (sigaction(SIGIO, &old, NULL) < 0)
+		printk(UM_KERN_ERR "check_one_sigio : sigaction 3 failed, "
+		       "errno = %d\n", errno);
 }
 
 static void tty_output(int master, int slave)
@@ -460,42 +490,45 @@ static void tty_output(int master, int s
 	int n;
 	char buf[512];
 
-	printk("Checking that host ptys support output SIGIO...");
+	printk(UM_KERN_INFO "Checking that host ptys support output SIGIO...");
 
 	memset(buf, 0, sizeof(buf));
 
-	while(write(master, buf, sizeof(buf)) > 0) ;
-	if(errno != EAGAIN)
-		panic("tty_output : write failed, errno = %d\n", errno);
-	while(((n = read(slave, buf, sizeof(buf))) > 0) && !got_sigio) ;
+	while (write(master, buf, sizeof(buf)) > 0) ;
+	if (errno != EAGAIN)
+		printk(UM_KERN_ERR "tty_output : write failed, errno = %d\n",
+		       errno);
+	while (((n = read(slave, buf, sizeof(buf))) > 0) && !got_sigio)
+		;
 
-	if(got_sigio){
-		printk("Yes\n");
+	if (got_sigio) {
+		printk(UM_KERN_CONT "Yes\n");
 		pty_output_sigio = 1;
-	}
-	else if(n == -EAGAIN)
-		printk("No, enabling workaround\n");
-	else panic("tty_output : read failed, err = %d\n", n);
+	} else if (n == -EAGAIN)
+		printk(UM_KERN_CONT "No, enabling workaround\n");
+	else
+		printk(UM_KERN_CONT "tty_output : read failed, err = %d\n", n);
 }
 
 static void tty_close(int master, int slave)
 {
-	printk("Checking that host ptys support SIGIO on close...");
+	printk(UM_KERN_INFO "Checking that host ptys support SIGIO on "
+	       "close...");
 
 	close(slave);
-	if(got_sigio){
-		printk("Yes\n");
+	if (got_sigio) {
+		printk(UM_KERN_CONT "Yes\n");
 		pty_close_sigio = 1;
-	}
-	else printk("No, enabling workaround\n");
+	} else
+		printk(UM_KERN_CONT "No, enabling workaround\n");
 }
 
 void __init check_sigio(void)
 {
-	if((os_access("/dev/ptmx", OS_ACC_R_OK) < 0) &&
-	   (os_access("/dev/ptyp0", OS_ACC_R_OK) < 0)){
-		printk("No pseudo-terminals available - skipping pty SIGIO "
-		       "check\n");
+	if ((access("/dev/ptmx", R_OK) < 0) &&
+	    (access("/dev/ptyp0", R_OK) < 0)) {
+		printk(UM_KERN_WARNING "No pseudo-terminals available - "
+		       "skipping pty SIGIO check\n");
 		return;
 	}
 	check_one_sigio(tty_output);
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
