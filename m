From: akpm@linux-foundation.org
Subject: - usbatm-switch-to-kthread-api-stop-using-kill_proc.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:23:12 -0800
Message-ID: <200802232023.m1NKNCIY013495@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42231 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763368AbYBWU3i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:29:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, baldrick.bulk@free.fr, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Usbatm: switch to kthread API, stop using kill_proc()
has been removed from the -mm tree.  Its filename was
     usbatm-switch-to-kthread-api-stop-using-kill_proc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Usbatm: switch to kthread API, stop using kill_proc()
From: Pavel Emelyanov <xemul@openvz.org>

First, we kill one more user of kernel_thread, which is scheduled for
removal.  Second - we kill one of the last users of kill_proc - the
function which is also to be removed, because it uses a pid_t which is not
safe now.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Tested-by: Duncan Sands <baldrick.bulk@free.fr>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/atm/usbatm.c |   25 ++++++++++++++-----------
 drivers/usb/atm/usbatm.h |    2 +-
 2 files changed, 15 insertions(+), 12 deletions(-)

diff -puN drivers/usb/atm/usbatm.c~usbatm-switch-to-kthread-api-stop-using-kill_proc drivers/usb/atm/usbatm.c
--- a/drivers/usb/atm/usbatm.c~usbatm-switch-to-kthread-api-stop-using-kill_proc
+++ a/drivers/usb/atm/usbatm.c
@@ -80,6 +80,7 @@
 #include <linux/stat.h>
 #include <linux/timer.h>
 #include <linux/wait.h>
+#include <linux/kthread.h>
 
 #ifdef VERBOSE_DEBUG
 static int usbatm_print_packet(const unsigned char *data, int len);
@@ -1014,10 +1015,7 @@ static int usbatm_do_heavy_init(void *ar
 	struct usbatm_data *instance = arg;
 	int ret;
 
-	daemonize(instance->driver->driver_name);
 	allow_signal(SIGTERM);
-	instance->thread_pid = current->pid;
-
 	complete(&instance->thread_started);
 
 	ret = instance->driver->heavy_init(instance, instance->usb_intf);
@@ -1026,7 +1024,7 @@ static int usbatm_do_heavy_init(void *ar
 		ret = usbatm_atm_init(instance);
 
 	mutex_lock(&instance->serialize);
-	instance->thread_pid = -1;
+	instance->thread = NULL;
 	mutex_unlock(&instance->serialize);
 
 	complete_and_exit(&instance->thread_exited, ret);
@@ -1034,13 +1032,18 @@ static int usbatm_do_heavy_init(void *ar
 
 static int usbatm_heavy_init(struct usbatm_data *instance)
 {
-	int ret = kernel_thread(usbatm_do_heavy_init, instance, CLONE_FS | CLONE_FILES);
+	struct task_struct *t;
 
-	if (ret < 0) {
-		usb_err(instance, "%s: failed to create kernel_thread (%d)!\n", __func__, ret);
-		return ret;
+	t = kthread_create(usbatm_do_heavy_init, instance,
+			instance->driver->driver_name);
+	if (IS_ERR(t)) {
+		usb_err(instance, "%s: failed to create kernel_thread (%ld)!\n",
+				__func__, PTR_ERR(t));
+		return PTR_ERR(t);
 	}
 
+	instance->thread = t;
+	wake_up_process(t);
 	wait_for_completion(&instance->thread_started);
 
 	return 0;
@@ -1124,7 +1127,7 @@ int usbatm_usb_probe(struct usb_interfac
 	kref_init(&instance->refcount);		/* dropped in usbatm_usb_disconnect */
 	mutex_init(&instance->serialize);
 
-	instance->thread_pid = -1;
+	instance->thread = NULL;
 	init_completion(&instance->thread_started);
 	init_completion(&instance->thread_exited);
 
@@ -1287,8 +1290,8 @@ void usbatm_usb_disconnect(struct usb_in
 
 	mutex_lock(&instance->serialize);
 	instance->disconnected = 1;
-	if (instance->thread_pid >= 0)
-		kill_proc(instance->thread_pid, SIGTERM, 1);
+	if (instance->thread != NULL)
+		send_sig(SIGTERM, instance->thread, 1);
 	mutex_unlock(&instance->serialize);
 
 	wait_for_completion(&instance->thread_exited);
diff -puN drivers/usb/atm/usbatm.h~usbatm-switch-to-kthread-api-stop-using-kill_proc drivers/usb/atm/usbatm.h
--- a/drivers/usb/atm/usbatm.h~usbatm-switch-to-kthread-api-stop-using-kill_proc
+++ a/drivers/usb/atm/usbatm.h
@@ -176,7 +176,7 @@ struct usbatm_data {
 	int disconnected;
 
 	/* heavy init */
-	int thread_pid;
+	struct task_struct *thread;
 	struct completion thread_started;
 	struct completion thread_exited;
 
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
use-find_task_by_vpid-in-audit-code.patch
ia64-fix-ptrace-inside-a-namespace.patch
git-net.patch
udf-fix-anchor-point-detection.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch
