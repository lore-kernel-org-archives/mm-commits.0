From: akpm@linux-foundation.org
Subject: [to-be-updated] ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 16 Jun 2009 15:41:09 -0700
Message-ID: <200906162241.n5GMfAbv003189@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751473AbZFPWxP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 18:53:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, avi@redhat.com, chrisw@redhat.com, hugh.dickins@tiscali.co.uk, ieidus@redhat.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: Use #include <linux/types.h> instead of <asm/types.h>
#54: FILE: include/linux/ksm.h:11:
+#include <asm/types.h>

ERROR: code indent should use tabs where possible
#65: FILE: include/linux/ksm.h:22:
+        __u64 reserved_bits;$

WARNING: line over 80 characters
#305: FILE: mm/ksm.c:175:
+ * slots_lock protects against removing and adding memory regions while a scanner

WARNING: braces {} are not necessary for single statement blocks
#485: FILE: mm/ksm.c:355:
+		if (mm == rmap_item->mm && rmap_item->address == addr) {
+			return rmap_item;
+		}

ERROR: code indent should use tabs where possible
#522: FILE: mm/ksm.c:392:
+^I ^I^Iif (!rmap_item->next && !rmap_item->prev) {$

WARNING: braces {} are not necessary for any arm of this statement
#857: FILE: mm/ksm.c:727:
+		if (ret) {
[...]
+		} else {
[...]

total: 2 errors, 4 warnings, 1746 lines checked

./patches/ksm-add-ksm-kernel-shared-memory-driver.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Wright <chrisw@redhat.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ksm.h |    2 +-
 mm/ksm.c            |   14 ++++++--------
 2 files changed, 7 insertions(+), 9 deletions(-)

diff -puN include/linux/ksm.h~ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes include/linux/ksm.h
--- a/include/linux/ksm.h~ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes
+++ a/include/linux/ksm.h
@@ -19,7 +19,7 @@ struct ksm_memory_region {
 	__u32 npages; /* number of pages to share */
 	__u32 pad;
 	__u64 addr; /* the begining of the virtual address */
-        __u64 reserved_bits;
+	__u64 reserved_bits;
 };
 
 #define KSMIO 0xAB
diff -puN mm/ksm.c~ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes mm/ksm.c
--- a/mm/ksm.c~ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes
+++ a/mm/ksm.c
@@ -172,8 +172,8 @@ struct rmap_item {
  */
 static LIST_HEAD(slots);
 /*
- * slots_lock protects against removing and adding memory regions while a scanner
- * is in the middle of scanning.
+ * slots_lock protects against removing and adding memory regions while a
+ * scanner is in the middle of scanning.
  */
 static DECLARE_RWSEM(slots_lock);
 
@@ -352,9 +352,8 @@ static struct rmap_item *get_rmap_item(s
 
 	bucket = &rmap_hash[addr % nrmaps_hash];
 	hlist_for_each_entry(rmap_item, node, bucket, link) {
-		if (mm == rmap_item->mm && rmap_item->address == addr) {
+		if (mm == rmap_item->mm && rmap_item->address == addr)
 			return rmap_item;
-		}
 	}
 	return NULL;
 }
@@ -389,7 +388,7 @@ static void remove_rmap_item_from_tree(s
 
 	if (tree_item) {
 		if (rmap_item->stable_tree) {
-	 		if (!rmap_item->next && !rmap_item->prev) {
+			if (!rmap_item->next && !rmap_item->prev) {
 				rb_erase(&tree_item->node, &root_stable_tree);
 				free_tree_item(tree_item);
 				nnodes_stable_tree--;
@@ -724,11 +723,10 @@ static int try_to_merge_two_pages_alloc(
 		 * just one pte pointing to it, in this case we break
 		 * it.
 		 */
-		if (ret) {
+		if (ret)
 			break_cow(mm1, addr1);
-		} else {
+		else
 			ksm_pages_shared += 2;
-		}
 	}
 
 	put_page(kpage);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
firmware_map-fix-hang-with-x86-32bit.patch
mm-consolidate-init_mm-definition.patch
readahead-record-mmap-read-around-states-in-file_ra_state.patch
mm-clean-up-get_user_pages_fast-documentation.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
pagemap-add-page-types-tool.patch
videobuf-dma-contig-zero-copy-userptr-support-v3.patch
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
page-allocator-clean-up-functions-related-to-pages_min.patch
page-allocator-add-inactive-ratio-calculation-function-of-each-zone.patch
mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports.patch
vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails.patch
headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch
remove-put_cpu_no_resched.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb.patch
fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers.patch
fbdev-s1d13xxxfb-add-accelerated-bitblt-functions.patch
linux-next.patch
linux-next-fixups.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
devres-warn-and-return-dont-crash-on-device_del-of-uninitialized-device.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
3x59x-fix-pci-resource-management-checkpatch-fixes.patch
jsm-clean-up-serial-jsm-correctly-support-4-8-port-boards.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
gpio-pca953x-get-platform_data-from-openfirmware-checkpatch-fixes.patch
gpio-pca953x-get-platform_data-from-openfirmware-checkpatch-fixes-gpio-pca953x-get-platform_data-from-openfirmware-cleanups.patch
documentation-changes-perl-is-needed-to-build-the-kernel-fix.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch
char-moxa-prevent-opening-unavailable-ports.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
edac-kconfig-fix-the-meaning-of-edac-abbreviation-fix.patch
kexec-sysrq-simplify-sysrq-c-handler.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
lib-add-lib-gcdc-fix.patch
lib-add-lib-gcdc-fix-fix.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

