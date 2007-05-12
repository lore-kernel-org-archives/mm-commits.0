From: akpm@linux-foundation.org
Subject: - small-cleanup-in-gpt-partition-handling.patch removed from -mm tree
Date: Fri, 11 May 2007 22:33:44 -0700
Message-ID: <200705120533.l4C5XiJa002137@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39825 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754854AbXELFdt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:33:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olaf@aepfle.de, mm-commits@vger.kernel.org


The patch titled
     small cleanup in gpt partition handling
has been removed from the -mm tree.  Its filename was
     small-cleanup-in-gpt-partition-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: small cleanup in gpt partition handling
From: Olaf Hering <olaf@aepfle.de>

Remove unused argument in is_pmbr_valid()
Remove unneeded initialization of local variable legacy_mbr

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/efi.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN fs/partitions/efi.c~small-cleanup-in-gpt-partition-handling fs/partitions/efi.c
--- a/fs/partitions/efi.c~small-cleanup-in-gpt-partition-handling
+++ a/fs/partitions/efi.c
@@ -152,7 +152,7 @@ last_lba(struct block_device *bdev)
 }
 
 static inline int
-pmbr_part_valid(struct partition *part, u64 lastlba)
+pmbr_part_valid(struct partition *part)
 {
         if (part->sys_ind == EFI_PMBR_OSTYPE_EFI_GPT &&
             le32_to_cpu(part->start_sect) == 1UL)
@@ -163,7 +163,6 @@ pmbr_part_valid(struct partition *part, 
 /**
  * is_pmbr_valid(): test Protective MBR for validity
  * @mbr: pointer to a legacy mbr structure
- * @lastlba: last_lba for the whole device
  *
  * Description: Returns 1 if PMBR is valid, 0 otherwise.
  * Validity depends on two things:
@@ -171,13 +170,13 @@ pmbr_part_valid(struct partition *part, 
  *  2) One partition of type 0xEE is found
  */
 static int
-is_pmbr_valid(legacy_mbr *mbr, u64 lastlba)
+is_pmbr_valid(legacy_mbr *mbr)
 {
 	int i;
 	if (!mbr || le16_to_cpu(mbr->signature) != MSDOS_MBR_SIGNATURE)
                 return 0;
 	for (i = 0; i < 4; i++)
-		if (pmbr_part_valid(&mbr->partition_record[i], lastlba))
+		if (pmbr_part_valid(&mbr->partition_record[i]))
                         return 1;
 	return 0;
 }
@@ -516,7 +515,7 @@ find_valid_gpt(struct block_device *bdev
 	int good_pgpt = 0, good_agpt = 0, good_pmbr = 0;
 	gpt_header *pgpt = NULL, *agpt = NULL;
 	gpt_entry *pptes = NULL, *aptes = NULL;
-	legacy_mbr *legacymbr = NULL;
+	legacy_mbr *legacymbr;
 	u64 lastlba;
 	if (!bdev || !gpt || !ptes)
 		return 0;
@@ -528,9 +527,8 @@ find_valid_gpt(struct block_device *bdev
                 if (legacymbr) {
                         read_lba(bdev, 0, (u8 *) legacymbr,
                                  sizeof (*legacymbr));
-                        good_pmbr = is_pmbr_valid(legacymbr, lastlba);
+                        good_pmbr = is_pmbr_valid(legacymbr);
                         kfree(legacymbr);
-                        legacymbr=NULL;
                 }
                 if (!good_pmbr)
                         goto fail;
_

Patches currently in -mm which might be from olaf@aepfle.de are

origin.patch
keep-track-of-network-interface-renaming.patch
