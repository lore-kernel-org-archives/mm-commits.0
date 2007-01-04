From: akpm@osdl.org
Subject: + relax-check-for-aix-in-msdos-partition-table.patch added to -mm tree
Date: Thu, 04 Jan 2007 11:01:13 -0800
Message-ID: <200701041901.l04J1D30028010@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44062 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932241AbXADTBz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 14:01:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olh@suse.de, anton@samba.org, hirofumi@mail.parknet.co.jp


The patch titled
     relax check for AIX in msdos partition table
has been added to the -mm tree.  Its filename is
     relax-check-for-aix-in-msdos-partition-table.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: relax check for AIX in msdos partition table
From: Olaf Hering <olh@suse.de>

The patch to identify AIX disks and ignore them has caused at least one
machine to fail to find the root partition on 2.6.19. The patch is:

http://lkml.org/lkml/2006/7/31/117

The problem is some disk formatters do not blow away the first 4 bytes
of the disk. If the disk we are installing to used to have AIX on it,
then the first 4 bytes will still have IBMA in EBCDIC.

The install in question was debian etch. Im not sure what the best fix
is, perhaps the AIX detection code could check more than the first 4
bytes.

The whole partition info for primary partitions is in this block:

  dd if=/dev/sdb count=$(( 4 * 16 )) bs=1 skip=$(( 0x1be ))

All other data do not matter, beside the 0x55aa marker at the end of the
first block.

Signed-off-by: Olaf Hering <olh@suse.de>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Anton Blanchard <anton@samba.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/partitions/msdos.c |   12 +++++++++++-
 include/linux/genhd.h |    2 ++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff -puN fs/partitions/msdos.c~relax-check-for-aix-in-msdos-partition-table fs/partitions/msdos.c
--- a/fs/partitions/msdos.c~relax-check-for-aix-in-msdos-partition-table
+++ a/fs/partitions/msdos.c
@@ -63,15 +63,25 @@ msdos_magic_present(unsigned char *p)
 #define AIX_LABEL_MAGIC4	0xC1
 static int aix_magic_present(unsigned char *p, struct block_device *bdev)
 {
+	struct partition *pt = (struct partition *) (p + 0x1be);
 	Sector sect;
 	unsigned char *d;
-	int ret = 0;
+	int slot, ret = 0;
 
 	if (p[0] != AIX_LABEL_MAGIC1 &&
 		p[1] != AIX_LABEL_MAGIC2 &&
 		p[2] != AIX_LABEL_MAGIC3 &&
 		p[3] != AIX_LABEL_MAGIC4)
 		return 0;
+	/* Assume the partition table is valid if Linux partitions exists */
+	for (slot = 1; slot <= 4; slot++, pt++) {
+		if (pt->sys_ind == LINUX_SWAP_PARTITION ||
+			pt->sys_ind == LINUX_RAID_PARTITION ||
+			pt->sys_ind == LINUX_DATA_PARTITION ||
+			pt->sys_ind == LINUX_LVM_PARTITION ||
+			is_extended_partition(pt))
+			return 0;
+	}
 	d = read_dev_sector(bdev, 7, &sect);
 	if (d) {
 		if (d[0] == '_' && d[1] == 'L' && d[2] == 'V' && d[3] == 'M')
diff -puN include/linux/genhd.h~relax-check-for-aix-in-msdos-partition-table include/linux/genhd.h
--- a/include/linux/genhd.h~relax-check-for-aix-in-msdos-partition-table
+++ a/include/linux/genhd.h
@@ -21,6 +21,8 @@ enum {
 	WIN98_EXTENDED_PARTITION = 0x0f,
 
 	LINUX_SWAP_PARTITION = 0x82,
+	LINUX_DATA_PARTITION = 0x83,
+	LINUX_LVM_PARTITION = 0x8e,
 	LINUX_RAID_PARTITION = 0xfd,	/* autodetect RAID partition */
 
 	SOLARIS_X86_PARTITION =	LINUX_SWAP_PARTITION,
_

Patches currently in -mm which might be from olh@suse.de are

relax-check-for-aix-in-msdos-partition-table.patch
