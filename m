From: akpm@osdl.org
Subject: + usbatm-update-to-use-the-kthread-api.patch added to -mm tree
Date: Tue, 12 Dec 2006 17:18:50 -0800
Message-ID: <200612130118.kBD1IoD8023703@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37222 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932390AbWLMBT4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Dec 2006 20:19:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, duncan.sands@math.u-psud.fr, greg@kroah.com


The patch titled
     usbatm: Update to use the kthread api
has been added to the -mm tree.  Its filename is
     usbatm-update-to-use-the-kthread-api.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: usbatm: Update to use the kthread api
From: Eric W. Biederman <ebiederm@xmission.com>

During driver initialization if the driver has an expensive initialization
routine usbatm starts a separate kernel thread for it.

In the driver cleanup routine the code waits to ensure the initialization
routine has finished.

Switching to the kthread api allowed some of the thread management code to be
removed.

In addition the kill_proc(SIGTERM, ...) in usbatm_usb_disconnect was removed
because it was absolutely pointless.  The kernel thread did not handle SIGTERM
or any pending signals, so despite marking the signal as pending it would
never have been handled.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>
Cc: Duncan Sands <duncan.sands@math.u-psud.fr>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/usb/atm/usbatm.c |   24 ++++++------------------
 drivers/usb/atm/usbatm.h |    2 --
 2 files changed, 6 insertions(+), 20 deletions(-)

diff -puN drivers/usb/atm/usbatm.c~usbatm-update-to-use-the-kthread-api drivers/usb/atm/usbatm.c
--- a/drivers/usb/atm/usbatm.c~usbatm-update-to-use-the-kthread-api
+++ a/drivers/usb/atm/usbatm.c
@@ -81,6 +81,7 @@
 #include <linux/stat.h>
 #include <linux/timer.h>
 #include <linux/wait.h>
+#include <linux/kthread.h>
 
 #ifdef VERBOSE_DEBUG
 static int usbatm_print_packet(const unsigned char *data, int len);
@@ -999,35 +1000,26 @@ static int usbatm_do_heavy_init(void *ar
 	struct usbatm_data *instance = arg;
 	int ret;
 
-	daemonize(instance->driver->driver_name);
-	allow_signal(SIGTERM);
-	instance->thread_pid = current->pid;
-
-	complete(&instance->thread_started);
-
 	ret = instance->driver->heavy_init(instance, instance->usb_intf);
 
 	if (!ret)
 		ret = usbatm_atm_init(instance);
 
-	mutex_lock(&instance->serialize);
-	instance->thread_pid = -1;
-	mutex_unlock(&instance->serialize);
 
 	complete_and_exit(&instance->thread_exited, ret);
 }
 
 static int usbatm_heavy_init(struct usbatm_data *instance)
 {
-	int ret = kernel_thread(usbatm_do_heavy_init, instance, CLONE_KERNEL);
-
-	if (ret < 0) {
+	struct task_struct *thread;
+	thread = kthread_run(usbatm_do_heavy_init, instance,
+				instance->driver->driver_name);
+	if (IS_ERR(thread)) {
+		int ret = PTR_ERR(thread);
 		usb_err(instance, "%s: failed to create kernel_thread (%d)!\n", __func__, ret);
 		return ret;
 	}
 
-	wait_for_completion(&instance->thread_started);
-
 	return 0;
 }
 
@@ -1109,8 +1101,6 @@ int usbatm_usb_probe(struct usb_interfac
 	kref_init(&instance->refcount);		/* dropped in usbatm_usb_disconnect */
 	mutex_init(&instance->serialize);
 
-	instance->thread_pid = -1;
-	init_completion(&instance->thread_started);
 	init_completion(&instance->thread_exited);
 
 	INIT_LIST_HEAD(&instance->vcc_list);
@@ -1272,8 +1262,6 @@ void usbatm_usb_disconnect(struct usb_in
 
 	mutex_lock(&instance->serialize);
 	instance->disconnected = 1;
-	if (instance->thread_pid >= 0)
-		kill_proc(instance->thread_pid, SIGTERM, 1);
 	mutex_unlock(&instance->serialize);
 
 	wait_for_completion(&instance->thread_exited);
diff -puN drivers/usb/atm/usbatm.h~usbatm-update-to-use-the-kthread-api drivers/usb/atm/usbatm.h
--- a/drivers/usb/atm/usbatm.h~usbatm-update-to-use-the-kthread-api
+++ a/drivers/usb/atm/usbatm.h
@@ -176,8 +176,6 @@ struct usbatm_data {
 	int disconnected;
 
 	/* heavy init */
-	int thread_pid;
-	struct completion thread_started;
 	struct completion thread_exited;
 
 	/* ATM device */
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
revert-identifier-to-nsproxy.patch
vt-fix-comments-to-not-refer-to-kill_proc.patch
usbatm-update-to-use-the-kthread-api.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
n_r3964-use-struct-pid-to-track-user-space-clients.patch
smbfs-make-conn_pid-a-struct-pid.patch
ncpfs-use-struct-pid-to-track-the-userspace-watchdog-process.patch
ncpfs-ensure-we-free-wdog_pid-on-parse_option-or-fill_inode-failure.patch
vt-refactor-console-sak-processing.patch
sysctl_ms_jiffies-fix-oldlen-semantics.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
updated-i386-cleanup-apic-code.patch
updated-i386-rework-local-apic-calibration.patch
updated-dynticks-fix-nmi-watchdog.patch
clockevents-core-check-for-clock-event-device-handler-being-non-null-before-calling-it.patch
pidhash-temporary-debug-checks.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch

