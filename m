From: akpm@linux-foundation.org
Subject: + remove-clockevents_releaserequest_device.patch added to -mm tree
Date: Tue, 29 May 2007 13:48:11 -0700
Message-ID: <200705292048.l4TKmBJb011183@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36271 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760882AbXE2Us7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 16:48:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     Remove clockevents_{release,request}_device
has been added to the -mm tree.  Its filename is
     remove-clockevents_releaserequest_device.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove clockevents_{release,request}_device
From: Andi Kleen <ak@suse.de>

Not called by anything in tree.

Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/clockevents.c |   41 ------------------------------------
 1 files changed, 41 deletions(-)

diff -puN kernel/time/clockevents.c~remove-clockevents_releaserequest_device kernel/time/clockevents.c
--- a/kernel/time/clockevents.c~remove-clockevents_releaserequest_device
+++ a/kernel/time/clockevents.c
@@ -205,47 +205,6 @@ void clockevents_exchange_device(struct 
 }
 
 /**
- * clockevents_request_device
- */
-struct clock_event_device *clockevents_request_device(unsigned int features,
-						      cpumask_t cpumask)
-{
-	struct clock_event_device *cur, *dev = NULL;
-	struct list_head *tmp;
-
-	spin_lock(&clockevents_lock);
-
-	list_for_each(tmp, &clockevent_devices) {
-		cur = list_entry(tmp, struct clock_event_device, list);
-
-		if ((cur->features & features) == features &&
-		    cpus_equal(cpumask, cur->cpumask)) {
-			if (!dev || dev->rating < cur->rating)
-				dev = cur;
-		}
-	}
-
-	clockevents_exchange_device(NULL, dev);
-
-	spin_unlock(&clockevents_lock);
-
-	return dev;
-}
-
-/**
- * clockevents_release_device
- */
-void clockevents_release_device(struct clock_event_device *dev)
-{
-	spin_lock(&clockevents_lock);
-
-	clockevents_exchange_device(dev, NULL);
-	clockevents_notify_released();
-
-	spin_unlock(&clockevents_lock);
-}
-
-/**
  * clockevents_notify - notification about relevant events
  */
 void clockevents_notify(unsigned long reason, void *arg)
_

Patches currently in -mm which might be from ak@suse.de are

smpboot-cachesize-comparison-fix-in-smp_tune_scheduling.patch
remove-pci_dac_dma_-apis.patch
git-pciseg.patch
x86_64-mm-xen-attempt-to-patch-inline-versions-of-common-operations.patch
xen-build-fix.patch
fix-x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
fix-x86_64-mm-xen-xen-smp-guest-support.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
quicklist-support-for-x86_64.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
x86_64-fix-e820_hole_size-based-on-address-ranges.patch
x86_64-acpi-disable-srat-when-numa-emulation-succeeds.patch
x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa-2.patch
x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
i386-hpet-check-if-the-counter-works.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
i386-pci-fixup-for-siemens-nixdorf-ag-fsc-multiprocessor-interrupt-controllers.patch
x86_64-fix-smp_call_function_single-return-value.patch
x86_64-o_excl-on-dev-mcelog.patch
x86_64-support-poll-on-dev-mcelog.patch
x86_64-mcelog-tolerant-level-cleanup.patch
x86_64-mce-poll-at-idle_start-and-printk-fix.patch
i386-fix-machine-rebooting.patch
x86_64-ratelimit-segfault-reporting-rate.patch
work-around-dell-e520-bios-reboot-bug.patch
x86_64-allocate-sparsemem-memmap-above-4g.patch
msi-fix-the-ordering-of-msix-irqs.patch
msi-mask-the-msix-vector-before-we-unmap-it.patch
serial-set-dtr-in-uart-for-kernel-serial-console.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
remove-clockevents_releaserequest_device.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-guest-code.patch
lguest-the-host-code.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-block-driver.patch
lguest-the-block-driver-tidyups-update.patch
lguest-the-documentation-example-launcher.patch
fallocate-implementation-on-i86-x86_64-and-powerpc.patch
