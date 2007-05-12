From: akpm@linux-foundation.org
Subject: - arm-stacktrace-fix.patch removed from -mm tree
Date: Fri, 11 May 2007 22:36:06 -0700
Message-ID: <200705120536.l4C5a6um002349@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757430AbXELFgR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:36:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hch@lst.de, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     arm: stacktrace fix
has been removed from the -mm tree.  Its filename was
     arm-stacktrace-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: arm: stacktrace fix
From: Andrew Morton <akpm@linux-foundation.org>

ab1b6f03a10ba1f5638188ab06bf46e33ac3a160 said

 - remove the unused task argument to save_stack_trace, it's always current

then broke arm:

arch/arm/kernel/stacktrace.c:56: error: conflicting types for 'save_stack_trace'
include/linux/stacktrace.h:11: error: previous declaration of 'save_stack_trace' was here
arch/arm/kernel/stacktrace.c:56: error: conflicting types for 'save_stack_trace'
include/linux/stacktrace.h:11: error: previous declaration of 'save_stack_trace' was here

Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/stacktrace.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff -puN arch/arm/kernel/stacktrace.c~arm-stacktrace-fix arch/arm/kernel/stacktrace.c
--- a/arch/arm/kernel/stacktrace.c~arm-stacktrace-fix
+++ a/arch/arm/kernel/stacktrace.c
@@ -52,21 +52,15 @@ static int save_trace(struct stackframe 
 	return trace->nr_entries >= trace->max_entries;
 }
 
-void save_stack_trace(struct stack_trace *trace, struct task_struct *task)
+void save_stack_trace(struct stack_trace *trace)
 {
 	struct stack_trace_data data;
 	unsigned long fp, base;
 
 	data.trace = trace;
 	data.skip = trace->skip;
-
-	if (task) {
-		base = (unsigned long)task_stack_page(task);
-		fp = 0; /* FIXME */
-	} else {
-		base = (unsigned long)task_stack_page(current);
-		asm("mov %0, fp" : "=r" (fp));
-	}
+	base = (unsigned long)task_stack_page(current);
+	asm("mov %0, fp" : "=r" (fp));
 
 	walk_stackframe(fp, base, base + THREAD_SIZE, save_trace, &data);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ntfs-use-zero_user_page.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa.patch
git-alsa-fixup.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
git-arm.patch
git-avr32.patch
git-dvb-fixup.patch
cinergyt2-fix-file-release-handler.patch
i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder.patch
git-gfs2-nmw.patch
git-hid-fixup.patch
git-ieee1394.patch
git-leds.patch
git-leds-fixup.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
git-mips-fixup.patch
fix-race-condition-about-network-device-name-fix.patch
git-battery.patch
git-nfs-server-cluster-locking-api-fixup.patch
git-ocfs2.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
auerswald-fix-file-release-handler.patch
git-wireless.patch
git-wireless-fixup.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-fix.patch
git-newsetup-fixup.patch
xfs-clean-up-shrinker-games.patch
remove-slab_ctor_constructor-fix.patch
change-zonelist-order-v6-zonelist-fix.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
alpha-support-graphics-on-non-zero-pci-domains-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
add-lzo1x-compression-support-to-the-kernel-fix.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
crc7-support-fix.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
reiser4.patch
integrity-new-hooks.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-tpm-internal-kernel-interface.patch
w1-build-fix.patch
check_dirty_inode_list.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
