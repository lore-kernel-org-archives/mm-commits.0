From: akpm@linux-foundation.org
Subject: [merged] fs-partition-msdos-fix-unusable-extended-partition-for-512b-sector.patch removed from -mm tree
Date: Fri, 26 Mar 2010 12:37:34 -0400
Message-ID: <201003261938.o2QJcXRh016695@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48396 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752796Ab0CZTih (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 15:38:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, Daniel.Taylor@wdc.com, hpa@zytor.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     fs/partition/msdos: fix unusable extended partition for > 512B sector
has been removed from the -mm tree.  Its filename was
     fs-partition-msdos-fix-unusable-extended-partition-for-512b-sector.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/partition/msdos: fix unusable extended partition for > 512B sector
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Smaller size than a minimum blocksize can't be used, after all it's
handled like 0 size.

For extended partition itself, this makes sure to use bigger size than one
logical sector size at least.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Daniel Taylor <Daniel.Taylor@wdc.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/msdos.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN fs/partitions/msdos.c~fs-partition-msdos-fix-unusable-extended-partition-for-512b-sector fs/partitions/msdos.c
--- a/fs/partitions/msdos.c~fs-partition-msdos-fix-unusable-extended-partition-for-512b-sector
+++ a/fs/partitions/msdos.c
@@ -492,9 +492,16 @@ int msdos_partition(struct parsed_partit
 		if (!size)
 			continue;
 		if (is_extended_partition(p)) {
-			/* prevent someone doing mkfs or mkswap on an
-			   extended partition, but leave room for LILO */
-			put_partition(state, slot, start, size == 1 ? 1 : 2);
+			/*
+			 * prevent someone doing mkfs or mkswap on an
+			 * extended partition, but leave room for LILO
+			 * FIXME: this uses one logical sector for > 512b
+			 * sector, although it may not be enough/proper.
+			 */
+			sector_t n = 2;
+			n = min(size, max(sector_size, n));
+			put_partition(state, slot, start, n);
+
 			printk(" <");
 			parse_extended(state, bdev, start, size);
 			printk(" >");
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

origin.patch
linux-next.patch

