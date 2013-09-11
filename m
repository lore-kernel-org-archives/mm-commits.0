From: akpm@linux-foundation.org
Subject: [folded-merged]
 partitions-efi-detect-hybrid-mbrs-checkpatch-fixes.patch removed from -mm
 tree
Date: Wed, 11 Sep 2013 14:05:29 -0700
Message-ID: <5230db19.QiYw52naMCcENgap%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49256 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757269Ab3IKVFa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 17:05:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, matt.fleming@intel.com, kzak@redhat.com, davidlohr@hp.com, akpm@linux-foundation.org

Subject: [folded-merged] partitions-efi-detect-hybrid-mbrs-checkpatch-fixes.patch removed from -mm tree
To: akpm@linux-foundation.org,davidlohr@hp.com,kzak@redhat.com,matt.fleming@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 14:05:29 -0700


The patch titled
     Subject: partitions-efi-detect-hybrid-mbrs-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     partitions-efi-detect-hybrid-mbrs-checkpatch-fixes.patch

This patch was dropped because it was folded into partitions-efi-detect-hybrid-mbrs.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: partitions-efi-detect-hybrid-mbrs-checkpatch-fixes

Cc: Davidlohr Bueso <davidlohr@hp.com>

WARNING: line over 80 characters
#92: FILE: block/partitions/efi.c:206:
+		if ((mbr->partition_record[i].os_type != EFI_PMBR_OSTYPE_EFI_GPT) &&

WARNING: space prohibited between function name and open parenthesis '('
#116: FILE: block/partitions/efi.c:578:
+		legacymbr = kzalloc(sizeof (*legacymbr), GFP_KERNEL);

WARNING: space prohibited between function name and open parenthesis '('
#120: FILE: block/partitions/efi.c:582:
+		read_lba(state, 0, (u8 *) legacymbr, sizeof (*legacymbr));

WARNING: line over 80 characters
#128: FILE: block/partitions/efi.c:590:
+			 good_pmbr == GPT_MBR_PROTECTIVE ? "protective" : "hybrid");

total: 0 errors, 4 warnings, 105 lines checked

./patches/partitions-efi-detect-hybrid-mbrs.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Karel Zak <kzak@redhat.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/partitions/efi.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN block/partitions/efi.c~partitions-efi-detect-hybrid-mbrs-checkpatch-fixes block/partitions/efi.c
--- a/block/partitions/efi.c~partitions-efi-detect-hybrid-mbrs-checkpatch-fixes
+++ a/block/partitions/efi.c
@@ -203,7 +203,8 @@ static int is_pmbr_valid(legacy_mbr *mbr
 		goto done;
 check_hybrid:
 	for (i = 0; i < 4; i++)
-		if ((mbr->partition_record[i].os_type != EFI_PMBR_OSTYPE_EFI_GPT) &&
+		if ((mbr->partition_record[i].os_type !=
+			EFI_PMBR_OSTYPE_EFI_GPT) &&
 		    (mbr->partition_record[i].os_type != 0x00))
 			ret = GPT_MBR_HYBRID;
 done:
@@ -575,11 +576,11 @@ static int find_valid_gpt(struct parsed_
 	lastlba = last_lba(state->bdev);
         if (!force_gpt) {
 		/* This will be added to the EFI Spec. per Intel after v1.02. */
-		legacymbr = kzalloc(sizeof (*legacymbr), GFP_KERNEL);
+		legacymbr = kzalloc(sizeof(*legacymbr), GFP_KERNEL);
 		if (!legacymbr)
 			goto fail;
 
-		read_lba(state, 0, (u8 *) legacymbr, sizeof (*legacymbr));
+		read_lba(state, 0, (u8 *)legacymbr, sizeof(*legacymbr));
 		good_pmbr = is_pmbr_valid(legacymbr);
 		kfree(legacymbr);
 
@@ -587,7 +588,8 @@ static int find_valid_gpt(struct parsed_
 			goto fail;
 
 		pr_debug("Device has a %s MBR\n",
-			 good_pmbr == GPT_MBR_PROTECTIVE ? "protective" : "hybrid");
+			 good_pmbr == GPT_MBR_PROTECTIVE ?
+						"protective" : "hybrid");
 	}
 
 	good_pgpt = is_gpt_valid(state, GPT_PRIMARY_PARTITION_TABLE_LBA,
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
partitions-efi-some-style-cleanups-checkpatch-fixes.patch
block-partitions-efic-consistently-use-pr_foo.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page.patch

