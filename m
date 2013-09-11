From: akpm@linux-foundation.org
Subject: [folded-merged]
 partitions-efi-check-pmbr-records-starting-lba-checkpatch-fixes.patch
 removed from -mm tree
Date: Wed, 11 Sep 2013 14:05:09 -0700
Message-ID: <5230db05.R/EH6SILHL8jpAKQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49251 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967Ab3IKVFK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 17:05:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, matt.fleming@intel.com, kzak@redhat.com, davidlohr@hp.com, akpm@linux-foundation.org

Subject: [folded-merged] partitions-efi-check-pmbr-records-starting-lba-checkpatch-fixes.patch removed from -mm tree
To: akpm@linux-foundation.org,davidlohr@hp.com,kzak@redhat.com,matt.fleming@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 14:05:09 -0700


The patch titled
     Subject: partitions-efi-check-pmbr-records-starting-lba-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     partitions-efi-check-pmbr-records-starting-lba-checkpatch-fixes.patch

This patch was dropped because it was folded into partitions-efi-check-pmbr-records-starting-lba.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: partitions-efi-check-pmbr-records-starting-lba-checkpatch-fixes

Cc: Davidlohr Bueso <davidlohr@hp.com>

ERROR: code indent should use tabs where possible
#27: FILE: block/partitions/efi.c:154:
+        if (part->os_type != EFI_PMBR_OSTYPE_EFI_GPT)$

WARNING: please, no spaces at the start of a line
#27: FILE: block/partitions/efi.c:154:
+        if (part->os_type != EFI_PMBR_OSTYPE_EFI_GPT)$

ERROR: code indent should use tabs where possible
#28: FILE: block/partitions/efi.c:155:
+                goto invalid;$

WARNING: please, no spaces at the start of a line
#28: FILE: block/partitions/efi.c:155:
+                goto invalid;$

ERROR: code indent should use tabs where possible
#30: FILE: block/partitions/efi.c:157:
+        /* set to 0x00000001 (i.e., the LBA of the GPT Partition Header) */$

ERROR: code indent should use tabs where possible
#31: FILE: block/partitions/efi.c:158:
+        if (le32_to_cpu(part->starting_lba) != GPT_PRIMARY_PARTITION_TABLE_LBA)$

WARNING: please, no spaces at the start of a line
#31: FILE: block/partitions/efi.c:158:
+        if (le32_to_cpu(part->starting_lba) != GPT_PRIMARY_PARTITION_TABLE_LBA)$

ERROR: code indent should use tabs where possible
#32: FILE: block/partitions/efi.c:159:
+                goto invalid;$

WARNING: please, no spaces at the start of a line
#32: FILE: block/partitions/efi.c:159:
+                goto invalid;$

ERROR: code indent should use tabs where possible
#34: FILE: block/partitions/efi.c:161:
+        if (le32_to_cpu(part->start_sector) != 1UL)$

WARNING: please, no spaces at the start of a line
#34: FILE: block/partitions/efi.c:161:
+        if (le32_to_cpu(part->start_sector) != 1UL)$

ERROR: code indent should use tabs where possible
#35: FILE: block/partitions/efi.c:162:
+                goto invalid;$

WARNING: please, no spaces at the start of a line
#35: FILE: block/partitions/efi.c:162:
+                goto invalid;$

ERROR: code indent should use tabs where possible
#37: FILE: block/partitions/efi.c:164:
+        return 1;$

WARNING: please, no spaces at the start of a line
#37: FILE: block/partitions/efi.c:164:
+        return 1;$

total: 8 errors, 7 warnings, 21 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/partitions-efi-check-pmbr-records-starting-lba.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Karel Zak <kzak@redhat.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/partitions/efi.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN block/partitions/efi.c~partitions-efi-check-pmbr-records-starting-lba-checkpatch-fixes block/partitions/efi.c
--- a/block/partitions/efi.c~partitions-efi-check-pmbr-records-starting-lba-checkpatch-fixes
+++ a/block/partitions/efi.c
@@ -151,19 +151,19 @@ static u64 last_lba(struct block_device
 
 static inline int pmbr_part_valid(gpt_mbr_record *part)
 {
-        if (part->os_type != EFI_PMBR_OSTYPE_EFI_GPT)
-                goto invalid;
+	if (part->os_type != EFI_PMBR_OSTYPE_EFI_GPT)
+		goto invalid;
 
-        /* set to 0x00000001 (i.e., the LBA of the GPT Partition Header) */
-        if (le32_to_cpu(part->starting_lba) != GPT_PRIMARY_PARTITION_TABLE_LBA)
-                goto invalid;
+	/* set to 0x00000001 (i.e., the LBA of the GPT Partition Header) */
+	if (le32_to_cpu(part->starting_lba) != GPT_PRIMARY_PARTITION_TABLE_LBA)
+		goto invalid;
 
-        if (le32_to_cpu(part->start_sector) != 1UL)
-                goto invalid;
+	if (le32_to_cpu(part->start_sector) != 1UL)
+		goto invalid;
 
-        return 1;
+	return 1;
 invalid:
-        return 0;
+	return 0;
 }
 
 /**
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
partitions-efi-detect-hybrid-mbrs-checkpatch-fixes.patch
partitions-efi-some-style-cleanups-checkpatch-fixes.patch
block-partitions-efic-consistently-use-pr_foo.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page.patch

