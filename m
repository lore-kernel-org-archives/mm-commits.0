From: akpm@linux-foundation.org
Subject: - fat-detect-media-without-partition-table-correctly.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:01:49 -0700
Message-ID: <200804282201.m3SM1nCg018898@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965796AbYD1WB4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 18:01:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fseidel@suse.de, adilger@sun.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     fat: detect media without partition table correctly
has been removed from the -mm tree.  Its filename was
     fat-detect-media-without-partition-table-correctly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fat: detect media without partition table correctly
From: Frank Seidel <fseidel@suse.de>

I received a complaint that some FAT formated medias (e.g.  sd memory cards)
trigger a "unknown partition table" message even though there is no partition
table and they work correctly, while in general (when e.g.  formated with
mkdosfs or even Windows Vista) this message is not shown.

Currently this seems only to happen when the medias get formatted with Windows
XP (and possibly Win 2000).  Then the boot indicator byte contains garbage
(part of text message) and so do the other parts checked by msdos_paritition
which then later triggers this message.

References: novell bug #364365

Most fat formatted media without partition table contains zeros in the boot
indication and the other tested bytes and so falls through the checks in
msdos_partition, leading it to return with 1 (all is fine).

But some (e.g.  WinXP formatted) fat fomated medias don't use boot_ind and so
the check fails and causes a "unkown partition table" warning eventhough there
is none and everything would be fine.

This additional check directly verifies if there is a fat formatted medium
without a partition table.

Signed-off-by: Frank Seidel <fseidel@suse.de>
Cc: Andreas Dilger <adilger@sun.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/msdos.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff -puN fs/partitions/msdos.c~fat-detect-media-without-partition-table-correctly fs/partitions/msdos.c
--- a/fs/partitions/msdos.c~fat-detect-media-without-partition-table-correctly
+++ a/fs/partitions/msdos.c
@@ -18,7 +18,7 @@
  *
  *  Re-organised Feb 1998 Russell King
  */
-
+#include <linux/msdos_fs.h>
 
 #include "check.h"
 #include "msdos.h"
@@ -419,6 +419,7 @@ int msdos_partition(struct parsed_partit
 	Sector sect;
 	unsigned char *data;
 	struct partition *p;
+	struct fat_boot_sector *fb;
 	int slot;
 
 	data = read_dev_sector(bdev, 0, &sect);
@@ -444,8 +445,21 @@ int msdos_partition(struct parsed_partit
 	p = (struct partition *) (data + 0x1be);
 	for (slot = 1; slot <= 4; slot++, p++) {
 		if (p->boot_ind != 0 && p->boot_ind != 0x80) {
-			put_dev_sector(sect);
-			return 0;
+			/*
+			 * Even without a valid boot inidicator value
+			 * its still possible this is valid FAT filesystem
+			 * without a partition table.
+			 */
+			fb = (struct fat_boot_sector *) data;
+			if (slot == 1 && fb->reserved && fb->fats
+				&& fat_valid_media(fb->media)) {
+				printk("\n");
+				put_dev_sector(sect);
+				return 1;
+			} else {
+				put_dev_sector(sect);
+				return 0;
+			}
 		}
 	}
 
_

Patches currently in -mm which might be from fseidel@suse.de are

origin.patch

