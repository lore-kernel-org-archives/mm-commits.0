From: akpm@linux-foundation.org
Subject: - delay-creation-of-khcvd-thread.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:01:12 -0700
Message-ID: <200710180701.l9I71Cka031158@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49900 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757167AbXJRHiM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:38:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, benh@kernel.crashing.org, jeremy@goop.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Delay creation of khcvd thread
has been removed from the -mm tree.  Its filename was
     delay-creation-of-khcvd-thread.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Delay creation of khcvd thread
From: Rusty Russell <rusty@rustcorp.com.au>

This changes hvc_init() to be called only when someone actually uses the
hvc_console driver.  Dave Jones complained when profiling bootup.

hvc_console used to only be for Power aka pSeries: now lguest and Xen both
want it built-in in case the kernel is a guest under one of those, even
though usually it will be a native boot.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/Kconfig       |    4 +-
 drivers/char/hvc_console.c |   56 +++++++++++++++++++++++++----------
 2 files changed, 42 insertions(+), 18 deletions(-)

diff -puN drivers/char/Kconfig~delay-creation-of-khcvd-thread drivers/char/Kconfig
--- a/drivers/char/Kconfig~delay-creation-of-khcvd-thread
+++ a/drivers/char/Kconfig
@@ -585,8 +585,8 @@ config TIPAR
 config HVC_DRIVER
 	bool
 	help
-	  Users of pSeries machines that want to utilize the hvc console front-end
-	  module for their backend console driver should select this option.
+	  Generic "hypervisor virtual console" infrastructure for various
+	  hypervisors (pSeries, Xen, lguest).
 	  It will automatically be selected if one of the back-end console drivers
 	  is selected.
 
diff -puN drivers/char/hvc_console.c~delay-creation-of-khcvd-thread drivers/char/hvc_console.c
--- a/drivers/char/hvc_console.c~delay-creation-of-khcvd-thread
+++ a/drivers/char/hvc_console.c
@@ -69,6 +69,8 @@ static struct task_struct *hvc_task;
 /* Picks up late kicks after list walk but before schedule() */
 static int hvc_kicked;
 
+static int hvc_init(void);
+
 #ifdef CONFIG_MAGIC_SYSRQ
 static int sysrq_pressed;
 #endif
@@ -754,6 +756,13 @@ struct hvc_struct __devinit *hvc_alloc(u
 	struct hvc_struct *hp;
 	int i;
 
+	/* We wait until a driver actually comes along */
+	if (!hvc_driver) {
+		int err = hvc_init();
+		if (err)
+			return ERR_PTR(err);
+	}
+
 	hp = kmalloc(ALIGN(sizeof(*hp), sizeof(long)) + outbuf_size,
 			GFP_KERNEL);
 	if (!hp)
@@ -829,16 +838,18 @@ int __devexit hvc_remove(struct hvc_stru
 	return 0;
 }
 
-/* Driver initialization.  Follow console initialization.  This is where the TTY
- * interfaces start to become available. */
-static int __init hvc_init(void)
+/* Driver initialization: called as soon as someone uses hvc_alloc(). */
+static int hvc_init(void)
 {
 	struct tty_driver *drv;
+	int err;
 
 	/* We need more than hvc_count adapters due to hotplug additions. */
 	drv = alloc_tty_driver(HVC_ALLOC_TTY_ADAPTERS);
-	if (!drv)
-		return -ENOMEM;
+	if (!drv) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	drv->owner = THIS_MODULE;
 	drv->driver_name = "hvc";
@@ -854,30 +865,43 @@ static int __init hvc_init(void)
 	 * added later. */
 	hvc_task = kthread_run(khvcd, NULL, "khvcd");
 	if (IS_ERR(hvc_task)) {
-		panic("Couldn't create kthread for console.\n");
-		put_tty_driver(drv);
-		return -EIO;
+		printk(KERN_ERR "Couldn't create kthread for console.\n");
+		err = PTR_ERR(hvc_task);
+		goto put_tty;
 	}
 
-	if (tty_register_driver(drv))
-		panic("Couldn't register hvc console driver\n");
+	err = tty_register_driver(drv);
+	if (err) {
+		printk(KERN_ERR "Couldn't register hvc console driver\n");
+		goto stop_thread;
+	}
 
+	/* FIXME: This mb() seems completely random.  Remove it. */
 	mb();
 	hvc_driver = drv;
 	return 0;
+
+put_tty:
+	put_tty_driver(hvc_driver);
+stop_thread:
+	kthread_stop(hvc_task);
+	hvc_task = NULL;
+out:
+	return err;
 }
-module_init(hvc_init);
 
 /* This isn't particularly necessary due to this being a console driver
  * but it is nice to be thorough.
  */
 static void __exit hvc_exit(void)
 {
-	kthread_stop(hvc_task);
+	if (hvc_driver) {
+		kthread_stop(hvc_task);
 
-	tty_unregister_driver(hvc_driver);
-	/* return tty_struct instances allocated in hvc_init(). */
-	put_tty_driver(hvc_driver);
-	unregister_console(&hvc_con_driver);
+		tty_unregister_driver(hvc_driver);
+		/* return tty_struct instances allocated in hvc_init(). */
+		put_tty_driver(hvc_driver);
+		unregister_console(&hvc_con_driver);
+	}
 }
 module_exit(hvc_exit);
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
git-kvm.patch
git-x86.patch
update-boot-spec-to-207.patch
add-weak-for-creating-weak-asm-labels.patch
i386-paravirt-boot-sequence.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
linux-kernel-markers.patch
linux-kernel-markers-checkpatch-fixes.patch
linux-kernel-markers-coding-style-fixes.patch
linux-kernel-markers-samples-coding-style-fix.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
