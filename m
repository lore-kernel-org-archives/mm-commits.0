From: akpm@linux-foundation.org
Subject: + group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch added to -mm tree
Date: Thu, 10 May 2007 02:24:16 -0700
Message-ID: <200705100927.l4A9RFsl017152@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759431AbXEJJ23 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 05:28:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, apw@shadowen.org, clameter@sgi.com, mel@csn.ul.ie


The patch titled
     group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix
has been added to the -mm tree.  Its filename is
     group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/dcache.c~group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix fs/dcache.c
diff -puN fs/ext2/super.c~group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix fs/ext2/super.c
diff -puN fs/ext3/super.c~group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix fs/ext3/super.c
diff -puN fs/ntfs/inode.c~group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix fs/ntfs/inode.c
diff -puN fs/reiserfs/super.c~group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix fs/reiserfs/super.c
diff -puN mm/slab.c~group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix mm/slab.c
diff -puN mm/slub.c~group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix mm/slub.c
--- a/mm/slub.c~group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix
+++ a/mm/slub.c
@@ -946,8 +946,8 @@ static struct page *allocate_slab(struct
 	if (s->flags & SLAB_CACHE_DMA)
 		flags |= SLUB_DMA;
 
-	if (s->flags & SLAB_ACCOUNT_RECLAIM)
-		gfpflags |= __GFP_RECLAIMABLE;
+	if (s->flags & SLAB_RECLAIM_ACCOUNT)
+		flags |= __GFP_RECLAIMABLE;
 
 	if (node == -1)
 		page = alloc_pages(flags, s->order);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-md-improve-partition-detection-in-md-array.patch
git-acpi.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
git-avr32.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
cinergyt2-fix-file-release-handler.patch
git-hid-fixup.patch
git-ia64-sa_interrupt-is-deprecated.patch
sn-validate-smp_affinity-mask-on-intr-redirect-fix.patch
sn-validate-smp_affinity-mask-on-intr-redirect-fix-2.patch
git-ieee1394.patch
sbp2-include-fixes.patch
ieee1394-iso-needs-schedh.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
git-battery.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
auerswald-fix-file-release-handler.patch
git-watchdog.patch
git-wireless.patch
git-wireless-fixup.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-add-support-for-picopower-irq-router-fix.patch
blacklist-dell-optiplex-320-from-using-the-hpet.patch
x86_64-rename-and-export-bad_srat-to-kernel-code-fix.patch
x86_64-extract-helper-function-from-e820_register_active_regions-fix.patch
xfs-clean-up-shrinker-games.patch
change-zonelist-order-v6-zonelist-fix.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
m32r-fix-switch_to-macro-to-push-pop-frame-pointer-if-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
upper-32-bits.patch
lib-hexdump.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
synclink_gt-add-compat_ioctl-fix.patch
tty-add-compat_ioctl.patch
mpc52xx-psc-spi-master-driver-update-tidy.patch
linux-kernel-markers-architecture-independant-code-update-fix.patch
linux-kernel-markers-powerpc-optimization-fix.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-documentation-update.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-eventfd-core.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
ntfs-use-zero_user_page.patch
pm3fb-preliminary-24-to-26-port-fix.patch
linuxpps-pulse-per-second-support-for-linux-fix.patch
reiser4.patch
integrity-new-hooks.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-tpm-internal-kernel-interface.patch
w1-build-fix.patch
