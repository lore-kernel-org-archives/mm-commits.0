From: akpm@linux-foundation.org
Subject: [folded-merged]
 partitions-efi-use-lba-aware-partition-records-checkpatch-fixes.patch
 removed from -mm tree
Date: Wed, 11 Sep 2013 14:04:31 -0700
Message-ID: <5230dadf.sfS+uaYSY9B2Y2OO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49242 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756990Ab3IKVEb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 17:04:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, matt.fleming@intel.com, kzak@redhat.com, davidlohr@hp.com, akpm@linux-foundation.org

Subject: [folded-merged] partitions-efi-use-lba-aware-partition-records-checkpatch-fixes.patch removed from -mm tree
To: akpm@linux-foundation.org,davidlohr@hp.com,kzak@redhat.com,matt.fleming@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 14:04:31 -0700


The patch titled
     Subject: partitions-efi-use-lba-aware-partition-records-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     partitions-efi-use-lba-aware-partition-records-checkpatch-fixes.patch

This patch was dropped because it was folded into partitions-efi-use-lba-aware-partition-records.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: partitions-efi-use-lba-aware-partition-records-checkpatch-fixes

Cc: Davidlohr Bueso <davidlohr@hp.com>

ERROR: code indent should use tabs where possible
#40: FILE: block/partitions/efi.c:154:
+        if (part->os_type == EFI_PMBR_OSTYPE_EFI_GPT &&$

WARNING: please, no spaces at the start of a line
#40: FILE: block/partitions/efi.c:154:
+        if (part->os_type == EFI_PMBR_OSTYPE_EFI_GPT &&$

ERROR: code indent should use tabs where possible
#41: FILE: block/partitions/efi.c:155:
+            le32_to_cpu(part->start_sector) == 1UL)$

WARNING: please, no spaces at the start of a line
#41: FILE: block/partitions/efi.c:155:
+            le32_to_cpu(part->start_sector) == 1UL)$

WARNING: do not add new typedefs
#52: FILE: block/partitions/efi.h:104:
+typedef struct _gpt_record {

ERROR: code indent should use tabs where possible
#53: FILE: block/partitions/efi.h:105:
+        u8      boot_indicator; /* unused by EFI, set to 0x80 for bootable */$

WARNING: please, no spaces at the start of a line
#53: FILE: block/partitions/efi.h:105:
+        u8      boot_indicator; /* unused by EFI, set to 0x80 for bootable */$

ERROR: code indent should use tabs where possible
#54: FILE: block/partitions/efi.h:106:
+        u8      start_head;     /* unused by EFI, pt start in CHS */$

WARNING: please, no spaces at the start of a line
#54: FILE: block/partitions/efi.h:106:
+        u8      start_head;     /* unused by EFI, pt start in CHS */$

ERROR: code indent should use tabs where possible
#55: FILE: block/partitions/efi.h:107:
+        u8      start_sector;   /* unused by EFI, pt start in CHS */$

WARNING: please, no spaces at the start of a line
#55: FILE: block/partitions/efi.h:107:
+        u8      start_sector;   /* unused by EFI, pt start in CHS */$

ERROR: code indent should use tabs where possible
#56: FILE: block/partitions/efi.h:108:
+        u8      start_track;$

WARNING: please, no spaces at the start of a line
#56: FILE: block/partitions/efi.h:108:
+        u8      start_track;$

ERROR: code indent should use tabs where possible
#57: FILE: block/partitions/efi.h:109:
+        u8      os_type;        /* EFI and legacy non-EFI OS types */$

WARNING: please, no spaces at the start of a line
#57: FILE: block/partitions/efi.h:109:
+        u8      os_type;        /* EFI and legacy non-EFI OS types */$

ERROR: code indent should use tabs where possible
#58: FILE: block/partitions/efi.h:110:
+        u8      end_head;       /* unused by EFI, pt end in CHS */$

WARNING: please, no spaces at the start of a line
#58: FILE: block/partitions/efi.h:110:
+        u8      end_head;       /* unused by EFI, pt end in CHS */$

ERROR: code indent should use tabs where possible
#59: FILE: block/partitions/efi.h:111:
+        u8      end_sector;     /* unused by EFI, pt end in CHS */$

WARNING: please, no spaces at the start of a line
#59: FILE: block/partitions/efi.h:111:
+        u8      end_sector;     /* unused by EFI, pt end in CHS */$

ERROR: code indent should use tabs where possible
#60: FILE: block/partitions/efi.h:112:
+        u8      end_track;      /* unused by EFI, pt end in CHS */$

WARNING: please, no spaces at the start of a line
#60: FILE: block/partitions/efi.h:112:
+        u8      end_track;      /* unused by EFI, pt end in CHS */$

ERROR: code indent should use tabs where possible
#61: FILE: block/partitions/efi.h:113:
+        __le32  starting_lba;   /* used by EFI - start addr of the on disk pt */$

WARNING: please, no spaces at the start of a line
#61: FILE: block/partitions/efi.h:113:
+        __le32  starting_lba;   /* used by EFI - start addr of the on disk pt */$

ERROR: code indent should use tabs where possible
#62: FILE: block/partitions/efi.h:114:
+        __le32  size_in_lba;    /* used by EFI - size of pt in LBA */$

WARNING: please, no spaces at the start of a line
#62: FILE: block/partitions/efi.h:114:
+        __le32  size_in_lba;    /* used by EFI - size of pt in LBA */$

WARNING: __packed is preferred over __attribute__((packed))
#63: FILE: block/partitions/efi.h:115:
+} __attribute__ ((packed)) gpt_record;

total: 12 errors, 14 warnings, 40 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/partitions-efi-use-lba-aware-partition-records.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Karel Zak <kzak@redhat.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/partitions/efi.c |    6 +++---
 block/partitions/efi.h |   22 +++++++++++-----------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff -puN block/partitions/efi.c~partitions-efi-use-lba-aware-partition-records-checkpatch-fixes block/partitions/efi.c
--- a/block/partitions/efi.c~partitions-efi-use-lba-aware-partition-records-checkpatch-fixes
+++ a/block/partitions/efi.c
@@ -151,9 +151,9 @@ static u64 last_lba(struct block_device
 
 static inline int pmbr_part_valid(gpt_record *part)
 {
-        if (part->os_type == EFI_PMBR_OSTYPE_EFI_GPT &&
-            le32_to_cpu(part->start_sector) == 1UL)
-                return 1;
+	if (part->os_type == EFI_PMBR_OSTYPE_EFI_GPT &&
+	    le32_to_cpu(part->start_sector) == 1UL)
+		return 1;
         return 0;
 }
 
diff -puN block/partitions/efi.h~partitions-efi-use-lba-aware-partition-records-checkpatch-fixes block/partitions/efi.h
--- a/block/partitions/efi.h~partitions-efi-use-lba-aware-partition-records-checkpatch-fixes
+++ a/block/partitions/efi.h
@@ -102,17 +102,17 @@ typedef struct _gpt_entry {
 } __attribute__ ((packed)) gpt_entry;
 
 typedef struct _gpt_record {
-        u8      boot_indicator; /* unused by EFI, set to 0x80 for bootable */
-        u8      start_head;     /* unused by EFI, pt start in CHS */
-        u8      start_sector;   /* unused by EFI, pt start in CHS */
-        u8      start_track;
-        u8      os_type;        /* EFI and legacy non-EFI OS types */
-        u8      end_head;       /* unused by EFI, pt end in CHS */
-        u8      end_sector;     /* unused by EFI, pt end in CHS */
-        u8      end_track;      /* unused by EFI, pt end in CHS */
-        __le32  starting_lba;   /* used by EFI - start addr of the on disk pt */
-        __le32  size_in_lba;    /* used by EFI - size of pt in LBA */
-} __attribute__ ((packed)) gpt_record;
+	u8	boot_indicator; /* unused by EFI, set to 0x80 for bootable */
+	u8	start_head;     /* unused by EFI, pt start in CHS */
+	u8	start_sector;   /* unused by EFI, pt start in CHS */
+	u8	start_track;
+	u8	os_type;        /* EFI and legacy non-EFI OS types */
+	u8	end_head;       /* unused by EFI, pt end in CHS */
+	u8	end_sector;     /* unused by EFI, pt end in CHS */
+	u8	end_track;      /* unused by EFI, pt end in CHS */
+	__le32	starting_lba;   /* used by EFI - start addr of the on disk pt */
+	__le32	size_in_lba;    /* used by EFI - size of pt in LBA */
+} __packed gpt_record;
 
 
 typedef struct _legacy_mbr {
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
partitions-efi-check-pmbr-records-starting-lba-checkpatch-fixes.patch
partitions-efi-detect-hybrid-mbrs-checkpatch-fixes.patch
partitions-efi-some-style-cleanups-checkpatch-fixes.patch
block-partitions-efic-consistently-use-pr_foo.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page.patch

