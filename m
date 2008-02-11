From: akpm@linux-foundation.org
Subject: + usbatm-switch-to-kthread-api-stop-using-kill_proc.patch added to -mm tree
Date: Mon, 11 Feb 2008 13:31:07 -0800
Message-ID: <200802112131.m1BLV7vP001366@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35429 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752871AbYBKWWg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Feb 2008 17:22:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, baldrick.bulk@free.fr, greg@kroah.com


The patch titled
     Usbatm: switch to kthread API, stop using kill_proc()
has been added to the -mm tree.  Its filename is
     usbatm-switch-to-kthread-api-stop-using-kill_proc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
revert-proc-fix-the-threaded-proc-self.patch
use-find_task_by_vpid-in-audit-code.patch
ia64-fix-ptrace-inside-a-namespace.patch
mips-use-find_task_by_vpid-in-system-calls.patch
usbatm-switch-to-kthread-api-stop-using-kill_proc.patch
deprecate-find_task_by_pid-kgdb.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
reiser4.patch
