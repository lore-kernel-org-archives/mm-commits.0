From: akpm@osdl.org
Subject: - correct-misc_register-return-code-handling-in-several-drivers.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:03:53 -0800
Message-ID: <200612072303.kB7N3rQj030000@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52070 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163848AbWLGXEb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:04:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nhorman@tuxdriver.com, benh@kernel.crashing.org, bjorn.helgaas@hp.com, dtor@mail.ru, kjhall@us.ibm.com, olh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Correct misc_register return code handling in several drivers
has been removed from the -mm tree.  Its filename was
     correct-misc_register-return-code-handling-in-several-drivers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Correct misc_register return code handling in several drivers
From: Neil Horman <nhorman@tuxdriver.com>

Clean up several code points in which the return code from misc_register is
not handled properly.

Several modules failed to deregister various hooks when misc_register fails,
and this patch cleans them up.  Also there are a few modules that legitimately
don't care about the failure status of misc register.  These drivers however
unilaterally call misc_deregister on module unload.

Since misc_register doesn't initialize the list_head in the init_routine if it
fails, the deregister operation is at risk for oopsing when list_del is
called.  The initial solution was to manually init the list in the miscdev
structure in each of those modules, but the consensus in this thread was to
consolodate and do that universally inside misc_register.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Kylene Jo Hall <kjhall@us.ibm.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Olaf Hering <olh@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/misc.c             |    2 ++
 drivers/char/mmtimer.c          |   23 ++++++++++++++++++-----
 drivers/char/tpm/tpm.c          |    1 +
 drivers/input/misc/hp_sdc_rtc.c |    4 +++-
 drivers/macintosh/apm_emu.c     |    3 ++-
 5 files changed, 26 insertions(+), 7 deletions(-)

diff -puN drivers/char/misc.c~correct-misc_register-return-code-handling-in-several-drivers drivers/char/misc.c
--- a/drivers/char/misc.c~correct-misc_register-return-code-handling-in-several-drivers
+++ a/drivers/char/misc.c
@@ -199,6 +199,8 @@ int misc_register(struct miscdevice * mi
 	dev_t dev;
 	int err = 0;
 
+	INIT_LIST_HEAD(&misc->list);
+
 	down(&misc_sem);
 	list_for_each_entry(c, &misc_list, list) {
 		if (c->minor == misc->minor) {
diff -puN drivers/char/mmtimer.c~correct-misc_register-return-code-handling-in-several-drivers drivers/char/mmtimer.c
--- a/drivers/char/mmtimer.c~correct-misc_register-return-code-handling-in-several-drivers
+++ a/drivers/char/mmtimer.c
@@ -680,7 +680,7 @@ static int __init mmtimer_init(void)
 	if (sn_rtc_cycles_per_second < 100000) {
 		printk(KERN_ERR "%s: unable to determine clock frequency\n",
 		       MMTIMER_NAME);
-		return -1;
+		goto out1;
 	}
 
 	mmtimer_femtoperiod = ((unsigned long)1E15 + sn_rtc_cycles_per_second /
@@ -689,13 +689,13 @@ static int __init mmtimer_init(void)
 	if (request_irq(SGI_MMTIMER_VECTOR, mmtimer_interrupt, IRQF_PERCPU, MMTIMER_NAME, NULL)) {
 		printk(KERN_WARNING "%s: unable to allocate interrupt.",
 			MMTIMER_NAME);
-		return -1;
+		goto out1;
 	}
 
 	if (misc_register(&mmtimer_miscdev)) {
 		printk(KERN_ERR "%s: failed to register device\n",
 		       MMTIMER_NAME);
-		return -1;
+		goto out2;
 	}
 
 	/* Get max numbered node, calculate slots needed */
@@ -709,16 +709,18 @@ static int __init mmtimer_init(void)
 	if (timers == NULL) {
 		printk(KERN_ERR "%s: failed to allocate memory for device\n",
 				MMTIMER_NAME);
-		return -1;
+		goto out3;
 	}
 
+	memset(timers,0,(sizeof(mmtimer_t *)*maxn));
+
 	/* Allocate mmtimer_t's for each online node */
 	for_each_online_node(node) {
 		timers[node] = kmalloc_node(sizeof(mmtimer_t)*NUM_COMPARATORS, GFP_KERNEL, node);
 		if (timers[node] == NULL) {
 			printk(KERN_ERR "%s: failed to allocate memory for device\n",
 				MMTIMER_NAME);
-			return -1;
+			goto out4;
 		}
 		for (i=0; i< NUM_COMPARATORS; i++) {
 			mmtimer_t * base = timers[node] + i;
@@ -739,6 +741,17 @@ static int __init mmtimer_init(void)
 	       sn_rtc_cycles_per_second/(unsigned long)1E6);
 
 	return 0;
+
+out4:
+	for_each_online_node(node) {
+		kfree(timers[node]);
+	}
+out3:
+	misc_deregister(&mmtimer_miscdev);
+out2:
+	free_irq(SGI_MMTIMER_VECTOR, NULL);
+out1:
+	return -1;
 }
 
 module_init(mmtimer_init);
diff -puN drivers/char/tpm/tpm.c~correct-misc_register-return-code-handling-in-several-drivers drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c~correct-misc_register-return-code-handling-in-several-drivers
+++ a/drivers/char/tpm/tpm.c
@@ -1155,6 +1155,7 @@ struct tpm_chip *tpm_register_hardware(s
 
 	if (sysfs_create_group(&dev->kobj, chip->vendor.attr_group)) {
 		list_del(&chip->list);
+		misc_deregister(&chip->vendor.miscdev);
 		put_device(dev);
 		clear_bit(chip->dev_num, dev_mask);
 		kfree(chip);
diff -puN drivers/input/misc/hp_sdc_rtc.c~correct-misc_register-return-code-handling-in-several-drivers drivers/input/misc/hp_sdc_rtc.c
--- a/drivers/input/misc/hp_sdc_rtc.c~correct-misc_register-return-code-handling-in-several-drivers
+++ a/drivers/input/misc/hp_sdc_rtc.c
@@ -695,7 +695,9 @@ static int __init hp_sdc_rtc_init(void)
 
 	if ((ret = hp_sdc_request_timer_irq(&hp_sdc_rtc_isr)))
 		return ret;
-	misc_register(&hp_sdc_rtc_dev);
+	if (misc_register(&hp_sdc_rtc_dev) != 0)
+		printk(KERN_INFO "Could not register misc. dev for i8042 rtc\n");
+
         create_proc_read_entry ("driver/rtc", 0, NULL,
 				hp_sdc_rtc_read_proc, NULL);
 
diff -puN drivers/macintosh/apm_emu.c~correct-misc_register-return-code-handling-in-several-drivers drivers/macintosh/apm_emu.c
--- a/drivers/macintosh/apm_emu.c~correct-misc_register-return-code-handling-in-several-drivers
+++ a/drivers/macintosh/apm_emu.c
@@ -529,7 +529,8 @@ static int __init apm_emu_init(void)
 	if (apm_proc)
 		apm_proc->owner = THIS_MODULE;
 
-	misc_register(&apm_device);
+	if (misc_register(&apm_device) != 0)
+		printk(KERN_INFO "Could not create misc. device for apm\n");
 
 	pmu_register_sleep_notifier(&apm_sleep_notifier);
 
_

Patches currently in -mm which might be from nhorman@tuxdriver.com are

origin.patch
netpoll-make-arp-replies-through-netpoll-use-mac-address-of-sender.patch

