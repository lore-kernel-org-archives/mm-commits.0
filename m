From: akpm@linux-foundation.org
Subject: [folded-merged]
 partitions-efi-use-lba-aware-partition-records-fix.patch removed from -mm
 tree
Date: Wed, 11 Sep 2013 14:04:52 -0700
Message-ID: <5230daf4.ptLqEmDo2UZfJt93%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49247 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674Ab3IKVEx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 17:04:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, matt.fleming@intel.com, kzak@redhat.com, davidlohr@hp.com

Subject: [folded-merged] partitions-efi-use-lba-aware-partition-records-fix.patch removed from -mm tree
To: davidlohr@hp.com,kzak@redhat.com,matt.fleming@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 14:04:52 -0700


The patch titled
     Subject: partitions/efi: rename gpt_record structure
has been removed from the -mm tree.  Its filename was
     partitions-efi-use-lba-aware-partition-records-fix.patch

This patch was dropped because it was folded into partitions-efi-use-lba-aware-partition-records.patch

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: partitions/efi: rename gpt_record structure

Since the gpt_record structure is an MBR-specific
type, rename it to gpt_mbr_record for obvious
reading.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Suggested-by: Karel Zak <kzak@redhat.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/partitions/efi.c |    2 +-
 block/partitions/efi.h |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN block/partitions/efi.c~partitions-efi-use-lba-aware-partition-records-fix block/partitions/efi.c
--- a/block/partitions/efi.c~partitions-efi-use-lba-aware-partition-records-fix
+++ a/block/partitions/efi.c
@@ -149,7 +149,7 @@ static u64 last_lba(struct block_device
 		       bdev_logical_block_size(bdev)) - 1ULL;
 }
 
-static inline int pmbr_part_valid(gpt_record *part)
+static inline int pmbr_part_valid(gpt_mbr_record *part)
 {
 	if (part->os_type == EFI_PMBR_OSTYPE_EFI_GPT &&
 	    le32_to_cpu(part->start_sector) == 1UL)
diff -puN block/partitions/efi.h~partitions-efi-use-lba-aware-partition-records-fix block/partitions/efi.h
--- a/block/partitions/efi.h~partitions-efi-use-lba-aware-partition-records-fix
+++ a/block/partitions/efi.h
@@ -101,7 +101,7 @@ typedef struct _gpt_entry {
 	efi_char16_t partition_name[72 / sizeof (efi_char16_t)];
 } __attribute__ ((packed)) gpt_entry;
 
-typedef struct _gpt_record {
+typedef struct _gpt_mbr_record {
 	u8	boot_indicator; /* unused by EFI, set to 0x80 for bootable */
 	u8	start_head;     /* unused by EFI, pt start in CHS */
 	u8	start_sector;   /* unused by EFI, pt start in CHS */
@@ -112,14 +112,14 @@ typedef struct _gpt_record {
 	u8	end_track;      /* unused by EFI, pt end in CHS */
 	__le32	starting_lba;   /* used by EFI - start addr of the on disk pt */
 	__le32	size_in_lba;    /* used by EFI - size of pt in LBA */
-} __packed gpt_record;
+} __packed gpt_mbr_record;
 
 
 typedef struct _legacy_mbr {
 	u8 boot_code[440];
 	__le32 unique_mbr_signature;
 	__le16 unknown;
-	gpt_record partition_record[4];
+	gpt_mbr_record partition_record[4];
 	__le16 signature;
 } __attribute__ ((packed)) legacy_mbr;
 
_

Patches currently in -mm which might be from davidlohr@hp.com are

hugepage-mention-libhugetlbfs-in-doc.patch
mm-hugetlb-protect-reserved-pages-when-soft-offlining-a-hugepage.patch
mm-hugetlb-change-variable-name-reservations-to-resv.patch
mm-hugetlb-fix-subpool-accounting-handling.patch
mm-hugetlb-remove-useless-check-about-mapping-type.patch
mm-hugetlb-grab-a-page_table_lock-after-page_cache_release.patch
mm-hugetlb-return-a-reserved-page-to-a-reserved-pool-if-failed.patch
partitions-efi-use-lba-aware-partition-records.patch
partitions-efi-check-pmbr-records-starting-lba.patch
partitions-efi-check-pmbr-records-starting-lba-checkpatch-fixes.patch
partitions-efi-do-not-require-gpt-partition-to-begin-at-sector-1.patch
partitions-efi-detect-hybrid-mbrs.patch
partitions-efi-detect-hybrid-mbrs-checkpatch-fixes.patch
partitions-efi-account-for-pmbr-size-in-lba.patch
partitions-efi-compare-first-and-last-usable-lbas.patch
partitions-efi-delete-annoying-emacs-style-comments.patch
partitions-efi-some-style-cleanups.patch
partitions-efi-some-style-cleanups-checkpatch-fixes.patch
block-partitions-efic-consistently-use-pr_foo.patch

