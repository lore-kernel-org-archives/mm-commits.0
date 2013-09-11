From: akpm@linux-foundation.org
Subject: + partitions-efi-account-for-pmbr-size-in-lba.patch added to -mm
 tree
Date: Tue, 10 Sep 2013 17:09:05 -0700
Message-ID: <522fb4a1.kTWsFWIWTw9HC7Xz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40590 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab3IKAJG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Sep 2013 20:09:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, matt.fleming@intel.com, kzak@redhat.com, davidlohr@hp.com

Subject: + partitions-efi-account-for-pmbr-size-in-lba.patch added to -mm tree
To: davidlohr@hp.com,kzak@redhat.com,matt.fleming@intel.com
From: akpm@linux-foundation.org
Date: Tue, 10 Sep 2013 17:09:05 -0700


The patch titled
     Subject: partitions/efi: account for pmbr size in lba
has been added to the -mm tree.  Its filename is
     partitions-efi-account-for-pmbr-size-in-lba.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/partitions-efi-account-for-pmbr-size-in-lba.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/partitions-efi-account-for-pmbr-size-in-lba.patch

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
Subject: partitions/efi: account for pmbr size in lba

The partition that has the 0xEE (GPT protective), must have the size in
lba field set to the lesser of the size of the disk minus one or
0xFFFFFFFF for larger disks.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Reviewed-by: Karel Zak <kzak@redhat.com>
Acked-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/partitions/efi.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff -puN block/partitions/efi.c~partitions-efi-account-for-pmbr-size-in-lba block/partitions/efi.c
--- a/block/partitions/efi.c~partitions-efi-account-for-pmbr-size-in-lba
+++ a/block/partitions/efi.c
@@ -166,6 +166,7 @@ invalid:
 /**
  * is_pmbr_valid(): test Protective MBR for validity
  * @mbr: pointer to a legacy mbr structure
+ * @total_sectors: amount of sectors in the device
  *
  * Description: Checks for a valid protective or hybrid
  * master boot record (MBR). The validity of a pMBR depends
@@ -180,9 +181,9 @@ invalid:
  * Returns 0 upon invalid MBR, or GPT_MBR_PROTECTIVE or
  * GPT_MBR_HYBRID depending on the device layout.
  */
-static int is_pmbr_valid(legacy_mbr *mbr)
+static int is_pmbr_valid(legacy_mbr *mbr, sector_t total_sectors)
 {
-	int i, ret = 0; /* invalid by default */
+	int i, part = 0, ret = 0; /* invalid by default */
 
 	if (!mbr || le16_to_cpu(mbr->signature) != MSDOS_MBR_SIGNATURE)
 		goto done;
@@ -190,6 +191,7 @@ static int is_pmbr_valid(legacy_mbr *mbr
 	for (i = 0; i < 4; i++) {
 		ret = pmbr_part_valid(&mbr->partition_record[i]);
 		if (ret == GPT_MBR_PROTECTIVE) {
+			part = i;
 			/*
 			 * Ok, we at least know that there's a protective MBR,
 			 * now check if there are other partition types for
@@ -206,6 +208,18 @@ check_hybrid:
 		if ((mbr->partition_record[i].os_type != EFI_PMBR_OSTYPE_EFI_GPT) &&
 		    (mbr->partition_record[i].os_type != 0x00))
 			ret = GPT_MBR_HYBRID;
+
+	/*
+	 * Protective MBRs take up the lesser of the whole disk
+	 * or 2 TiB (32bit LBA), ignoring the rest of the disk.
+	 *
+	 * Hybrid MBRs do not necessarily comply with this.
+	 */
+	if (ret == GPT_MBR_PROTECTIVE) {
+		if (le32_to_cpu(mbr->partition_record[part].size_in_lba) !=
+		    min((uint32_t) total_sectors - 1, 0xFFFFFFFF))
+			ret = 0;
+	}
 done:
 	return ret;
 }
@@ -567,6 +581,7 @@ static int find_valid_gpt(struct parsed_
 	gpt_header *pgpt = NULL, *agpt = NULL;
 	gpt_entry *pptes = NULL, *aptes = NULL;
 	legacy_mbr *legacymbr;
+	sector_t total_sectors = i_size_read(state->bdev->bd_inode) >> 9;
 	u64 lastlba;
 
 	if (!ptes)
@@ -580,7 +595,7 @@ static int find_valid_gpt(struct parsed_
 			goto fail;
 
 		read_lba(state, 0, (u8 *) legacymbr, sizeof (*legacymbr));
-		good_pmbr = is_pmbr_valid(legacymbr);
+		good_pmbr = is_pmbr_valid(legacymbr, total_sectors);
 		kfree(legacymbr);
 
 		if (!good_pmbr)
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

