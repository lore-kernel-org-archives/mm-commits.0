From: akpm@linux-foundation.org
Subject: + partitions-use-sector-size-for-efi-gpt.patch added to -mm tree
Date: Fri, 13 Nov 2009 14:20:43 -0800
Message-ID: <200911132220.nADMKhKH018070@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43795 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756587AbZKMWUp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 17:20:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kzak@redhat.com, jens.axboe@oracle.com


The patch titled
     partitions: use sector size for EFI GPT
has been added to the -mm tree.  Its filename is
     partitions-use-sector-size-for-efi-gpt.patch

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
Subject: partitions: use sector size for EFI GPT
From: Karel Zak <kzak@redhat.com>

Currently, kernel uses strictly 512-byte sectors for EFI GPT parsing.
That's wrong.

UEFI standard (version 2.3, May 2009, 5.3.1 GUID Format overview, page
95) defines that LBA is always based on the logical block size. It
means bdev_logical_block_size() (aka BLKSSZGET) for Linux.

This patch removes static sector size from EFI GPT parser.

The problem is reproducible with the latest GNU Parted:

 # modprobe scsi_debug dev_size_mb=50 sector_size=4096

  # ./parted /dev/sdb print
  Model: Linux scsi_debug (scsi)
  Disk /dev/sdb: 52.4MB
  Sector size (logical/physical): 4096B/4096B
  Partition Table: gpt

  Number  Start   End     Size    File system  Name     Flags
   1      24.6kB  3002kB  2978kB               primary
   2      3002kB  6001kB  2998kB               primary
   3      6001kB  9003kB  3002kB               primary

  # blockdev --rereadpt /dev/sdb
  # dmesg | tail -1
   sdb: unknown partition table      <---- !!!

with this patch:

  # blockdev --rereadpt /dev/sdb
  # dmesg | tail -1
   sdb: sdb1 sdb2 sdb3

Signed-off-by: Karel Zak <kzak@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/efi.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff -puN fs/partitions/efi.c~partitions-use-sector-size-for-efi-gpt fs/partitions/efi.c
--- a/fs/partitions/efi.c~partitions-use-sector-size-for-efi-gpt
+++ a/fs/partitions/efi.c
@@ -1,7 +1,9 @@
 /************************************************************
  * EFI GUID Partition Table handling
- * Per Intel EFI Specification v1.02
- * http://developer.intel.com/technology/efi/efi.htm
+ *
+ * http://www.uefi.org/specs/
+ * http://www.intel.com/technology/efi/
+ *
  * efi.[ch] by Matt Domsch <Matt_Domsch@dell.com>
  *   Copyright 2000,2001,2002,2004 Dell Inc.
  *
@@ -141,7 +143,7 @@ last_lba(struct block_device *bdev)
 {
 	if (!bdev || !bdev->bd_inode)
 		return 0;
-	return (bdev->bd_inode->i_size >> 9) - 1ULL;
+	return (bdev->bd_inode->i_size / bdev_logical_block_size(bdev)) - 1ULL;
 }
 
 static inline int
@@ -188,6 +190,7 @@ static size_t
 read_lba(struct block_device *bdev, u64 lba, u8 * buffer, size_t count)
 {
 	size_t totalreadcount = 0;
+	sector_t n = lba * (bdev_logical_block_size(bdev) / 512);
 
 	if (!bdev || !buffer || lba > last_lba(bdev))
                 return 0;
@@ -195,7 +198,7 @@ read_lba(struct block_device *bdev, u64 
 	while (count) {
 		int copied = 512;
 		Sector sect;
-		unsigned char *data = read_dev_sector(bdev, lba++, &sect);
+		unsigned char *data = read_dev_sector(bdev, n++, &sect);
 		if (!data)
 			break;
 		if (copied > count)
@@ -601,6 +604,7 @@ efi_partition(struct parsed_partitions *
 	gpt_header *gpt = NULL;
 	gpt_entry *ptes = NULL;
 	u32 i;
+	unsigned ssz = bdev_logical_block_size(bdev) / 512;
 
 	if (!find_valid_gpt(bdev, &gpt, &ptes) || !gpt || !ptes) {
 		kfree(gpt);
@@ -611,13 +615,14 @@ efi_partition(struct parsed_partitions *
 	pr_debug("GUID Partition Table is valid!  Yea!\n");
 
 	for (i = 0; i < le32_to_cpu(gpt->num_partition_entries) && i < state->limit-1; i++) {
+		u64 start = le64_to_cpu(ptes[i].starting_lba);
+		u64 size = le64_to_cpu(ptes[i].ending_lba) -
+			   le64_to_cpu(ptes[i].starting_lba) + 1ULL;
+
 		if (!is_pte_valid(&ptes[i], last_lba(bdev)))
 			continue;
 
-		put_partition(state, i+1, le64_to_cpu(ptes[i].starting_lba),
-				 (le64_to_cpu(ptes[i].ending_lba) -
-                                  le64_to_cpu(ptes[i].starting_lba) +
-				  1ULL));
+		put_partition(state, i+1, start * ssz, size * ssz);
 
 		/* If this is a RAID volume, tell md */
 		if (!efi_guidcmp(ptes[i].partition_type_guid,
_

Patches currently in -mm which might be from kzak@redhat.com are

partitions-use-sector-size-for-efi-gpt.patch
partitions-read-whole-sector-with-efi-gpt-header.patch

