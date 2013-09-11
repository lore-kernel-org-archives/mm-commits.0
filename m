From: akpm@linux-foundation.org
Subject: + partitions-efi-use-lba-aware-partition-records.patch added to
 -mm tree
Date: Tue, 10 Sep 2013 17:09:00 -0700
Message-ID: <522fb49c.rKToc26wpDP70dqB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40571 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab3IKAJB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Sep 2013 20:09:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, matt.fleming@intel.com, kzak@redhat.com, davidlohr@hp.com

Subject: + partitions-efi-use-lba-aware-partition-records.patch added to -mm tree
To: davidlohr@hp.com,kzak@redhat.com,matt.fleming@intel.com
From: akpm@linux-foundation.org
Date: Tue, 10 Sep 2013 17:09:00 -0700


The patch titled
     Subject: partitions/efi: use lba-aware partition records
has been added to the -mm tree.  Its filename is
     partitions-efi-use-lba-aware-partition-records.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/partitions-efi-use-lba-aware-partition-records.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/partitions-efi-use-lba-aware-partition-records.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: partitions/efi: use lba-aware partition records

The kernel's GPT implementation currently uses the generic 'struct
partition' type for dealing with legacy MBR partition records.  While this
is is useful for disklabels that we designed for CHS addressing, such as
msdos, it doesn't adapt well to newer standards that use LBA instead, such
as GUID partition tables.  Furthermore, these generic partition structures
do not have all the required fields to properly follow the UEFI specs.

While a CHS address can be translated to LBA, it's much simpler and
cleaner to just replace the partition type.  This patch adds a new
'gpt_record' type that is fully compliant with EFI and will allow, in the
next patches, to add more checks to properly verify a protective MBR,
which is paramount to probing a device that makes use of GPT.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Reviewed-by: Karel Zak <kzak@redhat.com>
Acked-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/partitions/efi.c |    7 +++----
 block/partitions/efi.h |   16 +++++++++++++++-
 2 files changed, 18 insertions(+), 5 deletions(-)

diff -puN block/partitions/efi.c~partitions-efi-use-lba-aware-partition-records block/partitions/efi.c
--- a/block/partitions/efi.c~partitions-efi-use-lba-aware-partition-records
+++ a/block/partitions/efi.c
@@ -149,11 +149,10 @@ static u64 last_lba(struct block_device
 		       bdev_logical_block_size(bdev)) - 1ULL;
 }
 
-static inline int
-pmbr_part_valid(struct partition *part)
+static inline int pmbr_part_valid(gpt_record *part)
 {
-        if (part->sys_ind == EFI_PMBR_OSTYPE_EFI_GPT &&
-            le32_to_cpu(part->start_sect) == 1UL)
+        if (part->os_type == EFI_PMBR_OSTYPE_EFI_GPT &&
+            le32_to_cpu(part->start_sector) == 1UL)
                 return 1;
         return 0;
 }
diff -puN block/partitions/efi.h~partitions-efi-use-lba-aware-partition-records block/partitions/efi.h
--- a/block/partitions/efi.h~partitions-efi-use-lba-aware-partition-records
+++ a/block/partitions/efi.h
@@ -101,11 +101,25 @@ typedef struct _gpt_entry {
 	efi_char16_t partition_name[72 / sizeof (efi_char16_t)];
 } __attribute__ ((packed)) gpt_entry;
 
+typedef struct _gpt_record {
+        u8      boot_indicator; /* unused by EFI, set to 0x80 for bootable */
+        u8      start_head;     /* unused by EFI, pt start in CHS */
+        u8      start_sector;   /* unused by EFI, pt start in CHS */
+        u8      start_track;
+        u8      os_type;        /* EFI and legacy non-EFI OS types */
+        u8      end_head;       /* unused by EFI, pt end in CHS */
+        u8      end_sector;     /* unused by EFI, pt end in CHS */
+        u8      end_track;      /* unused by EFI, pt end in CHS */
+        __le32  starting_lba;   /* used by EFI - start addr of the on disk pt */
+        __le32  size_in_lba;    /* used by EFI - size of pt in LBA */
+} __attribute__ ((packed)) gpt_record;
+
+
 typedef struct _legacy_mbr {
 	u8 boot_code[440];
 	__le32 unique_mbr_signature;
 	__le16 unknown;
-	struct partition partition_record[4];
+	gpt_record partition_record[4];
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
partitions-efi-use-lba-aware-partition-records-fix.patch
partitions-efi-check-pmbr-records-starting-lba.patch
partitions-efi-do-not-require-gpt-partition-to-begin-at-sector-1.patch
partitions-efi-detect-hybrid-mbrs.patch
partitions-efi-account-for-pmbr-size-in-lba.patch
partitions-efi-compare-first-and-last-usable-lbas.patch
partitions-efi-delete-annoying-emacs-style-comments.patch
partitions-efi-some-style-cleanups.patch

