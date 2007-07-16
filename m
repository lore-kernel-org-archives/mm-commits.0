From: akpm@linux-foundation.org
Subject: - improve-behaviour-of-spurious-irq-detect.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:56:27 -0700
Message-ID: <200707162056.l6GKuRjI002094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35794 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760887AbXGPVVq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:21:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Improve behaviour of spurious IRQ detect
has been removed from the -mm tree.  Its filename was
     improve-behaviour-of-spurious-irq-detect.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Improve behaviour of spurious IRQ detect
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Currently we handle spurious IRQ activity based upon seeing a lot of
invalid interrupts, and we clear things back on the base of lots of valid
interrupts.

Unfortunately in some cases you get legitimate invalid interrupts caused by
timing asynchronicity between the PCI bus and the APIC bus when disabling
interrupts and pulling other tricks.  In this case although the spurious
IRQs are not a problem our unhandled counters didn't clear and they act as
a slow running timebomb.  (This is effectively what the serial port/tty
problem that was fixed by clearing counters when registering a handler
showed up)

It's easy enough to add a second parameter - time.  This means that if we
see a regular stream of harmless spurious interrupts which are not harming
processing we don't go off and do something stupid like disable the IRQ
after a month of running.  OTOH lockups and performance killers show up a
lot more than 10/second

[akpm@linux-foundation.org: cleanup]
Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/irq.h   |    1 +
 kernel/irq/spurious.c |   12 +++++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff -puN include/linux/irq.h~improve-behaviour-of-spurious-irq-detect include/linux/irq.h
--- a/include/linux/irq.h~improve-behaviour-of-spurious-irq-detect
+++ a/include/linux/irq.h
@@ -161,6 +161,7 @@ struct irq_desc {
 	unsigned int		wake_depth;	/* nested wake enables */
 	unsigned int		irq_count;	/* For detecting broken IRQs */
 	unsigned int		irqs_unhandled;
+	unsigned long		last_unhandled;	/* Aging timer for unhandled count */
 	spinlock_t		lock;
 #ifdef CONFIG_SMP
 	cpumask_t		affinity;
diff -puN kernel/irq/spurious.c~improve-behaviour-of-spurious-irq-detect kernel/irq/spurious.c
--- a/kernel/irq/spurious.c~improve-behaviour-of-spurious-irq-detect
+++ a/kernel/irq/spurious.c
@@ -172,7 +172,17 @@ void note_interrupt(unsigned int irq, st
 		    irqreturn_t action_ret)
 {
 	if (unlikely(action_ret != IRQ_HANDLED)) {
-		desc->irqs_unhandled++;
+		/*
+		 * If we are seeing only the odd spurious IRQ caused by
+		 * bus asynchronicity then don't eventually trigger an error,
+		 * otherwise the couter becomes a doomsday timer for otherwise
+		 * working systems
+		 */
+		if (jiffies - desc->last_unhandled > HZ/10)
+			desc->irqs_unhandled = 1;
+		else
+			desc->irqs_unhandled++;
+		desc->last_unhandled = jiffies;
 		if (unlikely(action_ret != IRQ_NONE))
 			report_bad_irq(irq, desc, action_ret);
 	}
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-powerpc.patch
git-ia64.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
iomap-sort-out-the-broken-address-reporting-caused-by-the-iomap-layer.patch
ata-use-iomap_name.patch
sata_mv-test-patch-for-hightpoint-rocketraid-1740-1742.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
geode-basic-infrastructure-support-for-amd-geode-class.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
blackfin-enable-arbitary-speed-serial-setting.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
sb1250-duartc-sb1250-duart-serial-support.patch
mbcs-remove-lots-of-global-symbols.patch
i2o_cfg_passthru-cleanup.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
stallion-remove-unneeded-lock_kernel.patch
coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
driver-edac-add-mips-and-ppc-visibility.patch
driver-edac-mod-race-fix-i82875p.patch
driver-edac-fix-ignored-return-i82875p.patch
include-linux-pci_id-h-add-amd-northbridge-defines.patch
drivers-edac-fix-edac_device-semaphore-to-mutex.patch
drivers-edac-fix-e752x-reversed-csrows.patch
drivers-edac-fix-e752x-reversed-csrows-fix.patch
drivers-edac-new-pasemi-driver.patch
drivers-edac-new-pasemi-driver-fix.patch
drivers-edac-fix-leaf-sysfs-attribute.patch
drivers-edac-fix-edac_mc-init-apis.patch
drivers-edac-fix-edac_device-init-apis.patch
drivers-edac-fix-edac_mc-sysfs-completion-code.patch
drivers-edac-fix-edac_device-sysfs-completion-code.patch
