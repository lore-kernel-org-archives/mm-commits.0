From: akpm@linux-foundation.org
Subject: + partitions-read-whole-sector-with-efi-gpt-header.patch added to -mm tree
Date: Fri, 13 Nov 2009 14:20:50 -0800
Message-ID: <200911132220.nADMKo4W018331@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59607 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756596AbZKMWUv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 17:20:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kzak@redhat.com, jens.axboe@oracle.com


The patch titled
     partitions: read whole sector with EFI GPT header
has been added to the -mm tree.  Its filename is
     partitions-read-whole-sector-with-efi-gpt-header.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: partitions: read whole sector with EFI GPT header
From: Karel Zak <kzak@redhat.com>

The size of EFI GPT header is not static, but whole sector is
allocated for the header. The HeaderSize field must be greater
than 92 (= sizeof(struct gpt_header) and must be less than or
equal to the logical block size.

It means we have to read whole sector with the header, because the
header crc32 checksum is calculated according to HeaderSize.

For more details see UEFI standard (version 2.3, May 2009):
  - 5.3.1 GUID Format overview, page 93
  - Table 13. GUID Partition Table Header, page 96

Signed-off-by: Karel Zak <kzak@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/efi.c |    7 ++++---
 fs/partitions/efi.h |    8 ++++++--
 2 files changed, 10 insertions(+), 5 deletions(-)

diff -puN fs/partitions/efi.c~partitions-read-whole-sector-with-efi-gpt-header fs/partitions/efi.c
--- a/fs/partitions/efi.c~partitions-read-whole-sector-with-efi-gpt-header
+++ a/fs/partitions/efi.c
@@ -260,15 +260,16 @@ static gpt_header *
 alloc_read_gpt_header(struct block_device *bdev, u64 lba)
 {
 	gpt_header *gpt;
+	unsigned ssz = bdev_logical_block_size(bdev);
+
 	if (!bdev)
 		return NULL;
 
-	gpt = kzalloc(sizeof (gpt_header), GFP_KERNEL);
+	gpt = kzalloc(ssz, GFP_KERNEL);
 	if (!gpt)
 		return NULL;
 
-	if (read_lba(bdev, lba, (u8 *) gpt,
-		     sizeof (gpt_header)) < sizeof (gpt_header)) {
+	if (read_lba(bdev, lba, (u8 *) gpt, ssz) < ssz) {
 		kfree(gpt);
                 gpt=NULL;
 		return NULL;
diff -puN fs/partitions/efi.h~partitions-read-whole-sector-with-efi-gpt-header fs/partitions/efi.h
--- a/fs/partitions/efi.h~partitions-read-whole-sector-with-efi-gpt-header
+++ a/fs/partitions/efi.h
@@ -37,7 +37,6 @@
 #define EFI_PMBR_OSTYPE_EFI 0xEF
 #define EFI_PMBR_OSTYPE_EFI_GPT 0xEE
 
-#define GPT_BLOCK_SIZE 512
 #define GPT_HEADER_SIGNATURE 0x5452415020494645ULL
 #define GPT_HEADER_REVISION_V1 0x00010000
 #define GPT_PRIMARY_PARTITION_TABLE_LBA 1
@@ -79,7 +78,12 @@ typedef struct _gpt_header {
 	__le32 num_partition_entries;
 	__le32 sizeof_partition_entry;
 	__le32 partition_entry_array_crc32;
-	u8 reserved2[GPT_BLOCK_SIZE - 92];
+
+	/* The rest of the logical block is reserved by UEFI and must be zero.
+	 * EFI standard handles this by:
+	 *
+	 * uint8_t		reserved2[ BlockSize - 92 ];
+	 */
 } __attribute__ ((packed)) gpt_header;
 
 typedef struct _gpt_entry_attributes {
_

Patches currently in -mm which might be from kzak@redhat.com are

partitions-use-sector-size-for-efi-gpt.patch
partitions-read-whole-sector-with-efi-gpt-header.patch

