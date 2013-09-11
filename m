From: akpm@linux-foundation.org
Subject: [folded-merged]
 partitions-efi-some-style-cleanups-checkpatch-fixes.patch removed from -mm
 tree
Date: Wed, 11 Sep 2013 14:05:47 -0700
Message-ID: <5230db2b.T3rYVh67KnIj9mcZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49260 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996Ab3IKVFs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 17:05:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, matt.fleming@intel.com, kzak@redhat.com, davidlohr@hp.com, akpm@linux-foundation.org

Subject: [folded-merged] partitions-efi-some-style-cleanups-checkpatch-fixes.patch removed from -mm tree
To: akpm@linux-foundation.org,davidlohr@hp.com,kzak@redhat.com,matt.fleming@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 14:05:47 -0700


The patch titled
     Subject: partitions-efi-some-style-cleanups-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     partitions-efi-some-style-cleanups-checkpatch-fixes.patch

This patch was dropped because it was folded into partitions-efi-some-style-cleanups.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: partitions-efi-some-style-cleanups-checkpatch-fixes

Cc: Davidlohr Bueso <davidlohr@hp.com>

ERROR: code indent should use tabs where possible
#34: FILE: block/partitions/efi.c:295:
+                     (u8 *) pte, count) < count) {$

WARNING: please, no spaces at the start of a line
#34: FILE: block/partitions/efi.c:295:
+                     (u8 *) pte, count) < count) {$

WARNING: line over 80 characters
#44: FILE: block/partitions/efi.c:620:
+		good_agpt = is_gpt_valid(state, le64_to_cpu(pgpt->alternate_lba),

ERROR: code indent should use tabs where possible
#55: FILE: block/partitions/efi.c:638:
+                        printk(KERN_WARNING "Alternate GPT is invalid, using primary GPT.\n");$

WARNING: please, no spaces at the start of a line
#55: FILE: block/partitions/efi.c:638:
+                        printk(KERN_WARNING "Alternate GPT is invalid, using primary GPT.\n");$

WARNING: Prefer netdev_warn(netdev, ... then dev_warn(dev, ... then pr_warn(...  to printk(KERN_WARNING ...
#55: FILE: block/partitions/efi.c:638:
+                        printk(KERN_WARNING "Alternate GPT is invalid, using primary GPT.\n");

ERROR: code indent should use tabs where possible
#65: FILE: block/partitions/efi.c:647:
+                printk(KERN_WARNING "Primary GPT is invalid, using alternate GPT.\n");$

WARNING: please, no spaces at the start of a line
#65: FILE: block/partitions/efi.c:647:
+                printk(KERN_WARNING "Primary GPT is invalid, using alternate GPT.\n");$

WARNING: Prefer netdev_warn(netdev, ... then dev_warn(dev, ... then pr_warn(...  to printk(KERN_WARNING ...
#65: FILE: block/partitions/efi.c:647:
+                printk(KERN_WARNING "Primary GPT is invalid, using alternate GPT.\n");

WARNING: line over 80 characters
#75: FILE: block/partitions/efi.c:709:
+		if (!efi_guidcmp(ptes[i].partition_type_guid, PARTITION_LINUX_RAID_GUID))

total: 3 errors, 7 warnings, 55 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/partitions-efi-some-style-cleanups.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Karel Zak <kzak@redhat.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/partitions/efi.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN block/partitions/efi.c~partitions-efi-some-style-cleanups-checkpatch-fixes block/partitions/efi.c
--- a/block/partitions/efi.c~partitions-efi-some-style-cleanups-checkpatch-fixes
+++ a/block/partitions/efi.c
@@ -292,7 +292,7 @@ static gpt_entry *alloc_read_gpt_entries
 		return NULL;
 
 	if (read_lba(state, le64_to_cpu(gpt->partition_entry_lba),
-                     (u8 *) pte, count) < count) {
+			(u8 *) pte, count) < count) {
 		kfree(pte);
                 pte=NULL;
 		return NULL;
@@ -617,7 +617,8 @@ static int find_valid_gpt(struct parsed_
 	good_pgpt = is_gpt_valid(state, GPT_PRIMARY_PARTITION_TABLE_LBA,
 				 &pgpt, &pptes);
         if (good_pgpt)
-		good_agpt = is_gpt_valid(state, le64_to_cpu(pgpt->alternate_lba),
+		good_agpt = is_gpt_valid(state,
+					 le64_to_cpu(pgpt->alternate_lba),
 					 &agpt, &aptes);
         if (!good_agpt && force_gpt)
                 good_agpt = is_gpt_valid(state, lastlba, &agpt, &aptes);
@@ -634,9 +635,8 @@ static int find_valid_gpt(struct parsed_
                 *ptes = pptes;
                 kfree(agpt);
                 kfree(aptes);
-                if (!good_agpt) {
+		if (!good_agpt)
                         printk(KERN_WARNING "Alternate GPT is invalid, using primary GPT.\n");
-                }
                 return 1;
         }
         else if (good_agpt) {
@@ -644,7 +644,7 @@ static int find_valid_gpt(struct parsed_
                 *ptes = aptes;
                 kfree(pgpt);
                 kfree(pptes);
-                printk(KERN_WARNING "Primary GPT is invalid, using alternate GPT.\n");
+		printk(KERN_WARNING "Primary GPT is invalid, using alternate GPT.\n");
                 return 1;
         }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
block-support-embedded-device-command-line-partition.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size.patch
mm-swapfilec-convert-to-pr_foo.patch
mm-vmstats-track-tlb-flush-stats-on-up-too.patch
swap-make-swap-discard-async.patch
swap-make-cluster-allocation-per-cpu.patch
mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache.patch
mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy.patch
vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters.patch
genalloc-fix-overflow-of-ending-address-of-memory-chunk.patch
mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages.patch
mm-hotplug-verify-hotplug-memory-range.patch
mm-fix-aio-performance-regression-for-database-caused-by-thp.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page.patch
mm-vmscan-fix-do_try_to_free_pages-livelock.patch
mm-page-writebackc-add-strictlimit-feature.patch
mm-madvisec-madvise_hwpoison-remove-local-ret.patch
lib-crc32-update-the-comments-of-crc32_bele_generic.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
partitions-efi-use-lba-aware-partition-records.patch
partitions-efi-check-pmbr-records-starting-lba.patch
partitions-efi-detect-hybrid-mbrs.patch
partitions-efi-some-style-cleanups.patch
block-partitions-efic-consistently-use-pr_foo.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page.patch

