From: akpm@linux-foundation.org
Subject: - lguest-the-host-code-dont-signal-like-crazy-use-lhreq_break-command.patch removed from -mm tree
Date: Thu, 07 Jun 2007 23:14:56 -0700
Message-ID: <200706080614.l586Euvx020993@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46939 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755432AbXFHGPI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 02:15:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest: don't signal like crazy, use LHREQ_BREAK command
has been removed from the -mm tree.  Its filename was
     lguest-the-host-code-dont-signal-like-crazy-use-lhreq_break-command.patch

This patch was dropped because it was folded into lguest-the-host-code.patch

------------------------------------------------------
Subject: lguest: don't signal like crazy, use LHREQ_BREAK command
From: Rusty Russell <rusty@rustcorp.com.au>

We currently use a "waker" process: a child of the launcher which selects() on
the incoming file descriptors.  It sends a SIGUSR1 to the launcher whenever
select() returns to kick the launcher out of the kernel.

This has nasty side-effects: the waker needs to keep sending signals to avoid
the race, so we nice it to try to make sure the launcher runs soon.  Also the
launcher blocks SIGUSR1 when it's not running the guest, so it doesn't have to
deal with other interrupted reads...

It's better to explicitly tell the kernel to break out of the guest, and this
is what we do, with a new LHREQ_BREAK command.  This makes the launcher return
-EAGAIN from reading /dev/lguest, and blocks the waker until the launcher
calls LHREQ_BREAK, avoiding the race.

We also take precautions against simultaneous writes or reads on the
/dev/lguest fd.  As only root can open these file descriptors it's not much of
a problem, but we want to relax that restriction eventually.

The main improvement is in consistency, rather than raw benchmark
results:

Before:
Time for one context switch via pipe: 9265 (4534 - 9495)
Time for one Copy-on-Write fault: 67687 (14898 - 159125)
Time to exec client once: 1102812 (795843 - 1128250)
Time for one fork/exit/wait: 712000 (400625 - 723156)
Time for gettimeofday(): 16681 (16378 - 35835)
Time to send 4 MB from host: 141317343 (140165578 - 141469500)
Time for one int-0x80 syscall: 272 (272 - 575)
Time for one syscall via libc: 275 (274 - 904)
Time for two PTE updates: 16232 (6430 - 16316)
Time to read from disk (256 kB): 16786750 (16597500 - 31493250)
Time for one disk read: 192656 (189312 - 958687)
Time for inter-guest pingpong: 110453 (104492 - 316429)

After:
Time for one context switch via pipe: 4687 (4563 - 4857)
Time for one Copy-on-Write fault: 44523 (11628 - 77855)
Time to exec client once: 814765 (805796 - 829875)
Time for one fork/exit/wait: 405875 (400562 - 434750)
Time for gettimeofday(): 16644 (16203 - 16931)
Time to send 4 MB from host: 136530000 (121522250 - 151629000)
Time for one int-0x80 syscall: 273 (272 - 274)
Time for one syscall via libc: 279 (277 - 279)
Time for two PTE updates: 6439 (6395 - 6528)
Time to read from disk (256 kB): 16787000 (16641250 - 16861250)
Time for one disk read: 192187 (190515 - 193843)
Time for inter-guest pingpong: 111093 (109203 - 136554)

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/core.c           |    7 +++
 drivers/lguest/lg.h             |    5 ++
 drivers/lguest/lguest_user.c    |   55 ++++++++++++++++++++++++++----
 include/linux/lguest_launcher.h |    1 
 4 files changed, 61 insertions(+), 7 deletions(-)

diff -puN drivers/lguest/core.c~lguest-the-host-code-dont-signal-like-crazy-use-lhreq_break-command drivers/lguest/core.c
--- a/drivers/lguest/core.c~lguest-the-host-code-dont-signal-like-crazy-use-lhreq_break-command
+++ a/drivers/lguest/core.c
@@ -313,7 +313,12 @@ int run_guest(struct lguest *lg, unsigne
 		}
 
 		if (signal_pending(current))
-			return -EINTR;
+			return -ERESTARTSYS;
+
+		/* If Waker set break_out, return to Launcher. */
+		if (lg->break_out)
+			return -EAGAIN;
+
 		maybe_do_interrupt(lg);
 
 		try_to_freeze();
diff -puN drivers/lguest/lg.h~lguest-the-host-code-dont-signal-like-crazy-use-lhreq_break-command drivers/lguest/lg.h
--- a/drivers/lguest/lg.h~lguest-the-host-code-dont-signal-like-crazy-use-lhreq_break-command
+++ a/drivers/lguest/lg.h
@@ -16,6 +16,7 @@
 #include <linux/futex.h>
 #include <linux/lguest.h>
 #include <linux/lguest_launcher.h>
+#include <linux/wait.h>
 #include <linux/err.h>
 #include <asm/semaphore.h>
 #include "irq_vectors.h"
@@ -138,6 +139,10 @@ struct lguest
 	u32 esp1;
 	u8 ss1;
 
+	/* Do we need to stop what we're doing and return to userspace? */
+	int break_out;
+	wait_queue_head_t break_wq;
+
 	/* Bitmap of what has changed: see CHANGED_* above. */
 	int changed;
 	struct lguest_pages *last_pages;
diff -puN drivers/lguest/lguest_user.c~lguest-the-host-code-dont-signal-like-crazy-use-lhreq_break-command drivers/lguest/lguest_user.c
--- a/drivers/lguest/lguest_user.c~lguest-the-host-code-dont-signal-like-crazy-use-lhreq_break-command
+++ a/drivers/lguest/lguest_user.c
@@ -30,6 +30,30 @@ static long user_get_dma(struct lguest *
 	return udma;
 }
 
+/* To force the Guest to stop running and return to the Launcher, the
+ * Waker sets writes LHREQ_BREAK and the value "1" to /dev/lguest.  The
+ * Launcher then writes LHREQ_BREAK and "0" to release the Waker. */
+static int break_guest_out(struct lguest *lg, const u32 __user *input)
+{
+	unsigned long on;
+
+	/* Fetch whether they're turning break on or off.. */
+	if (get_user(on, input) != 0)
+		return -EFAULT;
+
+	if (on) {
+		lg->break_out = 1;
+		/* Pop it out (may be running on different CPU) */
+		wake_up_process(lg->tsk);
+		/* Wait for them to reset it */
+		return wait_event_interruptible(lg->break_wq, !lg->break_out);
+	} else {
+		lg->break_out = 0;
+		wake_up(&lg->break_wq);
+		return 0;
+	}
+}
+
 /* + irq */
 static int user_send_irq(struct lguest *lg, const u32 __user *input)
 {
@@ -50,6 +74,10 @@ static ssize_t read(struct file *file, c
 	if (!lg)
 		return -EINVAL;
 
+	/* If you're not the task which owns the guest, go away. */
+	if (current != lg->tsk)
+		return -EPERM;
+
 	if (lg->dead) {
 		size_t len;
 
@@ -75,13 +103,20 @@ static int initialize(struct file *file,
 	int err, i;
 	u32 args[4];
 
-	if (file->private_data)
-		return -EBUSY;
+	/* We grab the Big Lguest lock, which protects the global array
+	 * "lguests" and multiple simultaneous initializations. */
+	mutex_lock(&lguest_lock);
 
-	if (copy_from_user(args, input, sizeof(args)) != 0)
-		return -EFAULT;
+	if (file->private_data) {
+		err = -EBUSY;
+		goto unlock;
+	}
+
+	if (copy_from_user(args, input, sizeof(args)) != 0) {
+		err = -EFAULT;
+		goto unlock;
+	}
 
-	mutex_lock(&lguest_lock);
 	i = find_free_guest();
 	if (i < 0) {
 		err = -ENOSPC;
@@ -107,10 +142,12 @@ static int initialize(struct file *file,
 	lg->tsk = current;
 	get_task_struct(lg->tsk);
 	lg->mm = get_task_mm(lg->tsk);
+	init_waitqueue_head(&lg->break_wq);
 	lg->last_pages = NULL;
+	file->private_data = lg;
+
 	mutex_unlock(&lguest_lock);
 
-	file->private_data = lg;
 	return sizeof(args);
 
 free_regs:
@@ -137,6 +174,10 @@ static ssize_t write(struct file *file, 
 	if (lg && lg->dead)
 		return -ENOENT;
 
+	/* If you're not the task which owns the Guest, you can only break */
+	if (lg && current != lg->tsk && req != LHREQ_BREAK)
+		return -EPERM;
+
 	switch (req) {
 	case LHREQ_INITIALIZE:
 		return initialize(file, (const u32 __user *)input);
@@ -144,6 +185,8 @@ static ssize_t write(struct file *file, 
 		return user_get_dma(lg, (const u32 __user *)input);
 	case LHREQ_IRQ:
 		return user_send_irq(lg, (const u32 __user *)input);
+	case LHREQ_BREAK:
+		return break_guest_out(lg, (const u32 __user *)input);
 	default:
 		return -EINVAL;
 	}
diff -puN include/linux/lguest_launcher.h~lguest-the-host-code-dont-signal-like-crazy-use-lhreq_break-command include/linux/lguest_launcher.h
--- a/include/linux/lguest_launcher.h~lguest-the-host-code-dont-signal-like-crazy-use-lhreq_break-command
+++ a/include/linux/lguest_launcher.h
@@ -68,5 +68,6 @@ enum lguest_req
 	LHREQ_INITIALIZE, /* + pfnlimit, pgdir, start, pageoffset */
 	LHREQ_GETDMA, /* + addr (returns &lguest_dma, irq in ->used_len) */
 	LHREQ_IRQ, /* + irq */
+	LHREQ_BREAK, /* + on/off flag (on blocks until someone does off) */
 };
 #endif /* _ASM_LGUEST_USER */
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

git-kbuild.patch
paravirt-helper-to-disable-all-io-space.patch
paravirt-helper-to-disable-all-io-space-fix.patch
xen-disable-all-non-virtual-devices.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
use-menuconfig-objects-ii-module-menu.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-the-host-code.patch
lguest-the-host-code-dont-signal-like-crazy-use-lhreq_break-command.patch
lguest-the-host-code-use-tsc.patch
lguest-the-host-code-use-hrtimers.patch
lguest-the-host-code-update-for-mm-simplify-boot_params.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-makefile-and-kconfig-tidyups.patch
lguest-the-console-driver.patch
lguest-the-console-driver-tidyups.patch
lguest-the-net-driver.patch
lguest-the-net-driver-tidyups.patch
lguest-the-net-driver-tidyups-update.patch
lguest-the-net-driver-include-fix.patch
lguest-the-block-driver.patch
lguest-the-block-driver-tidyups.patch
lguest-the-block-driver-tidyups-update.patch
lguest-the-documentation-example-launcher.patch
lguest-the-documentation-example-launcher-example-launcher-fix.patch
lguest-dont-signal-like-crazy-use-lhreq_break-command-doc.patch
lguest-documentation-infrastructure-and-chapter-i.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
