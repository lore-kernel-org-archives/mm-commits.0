From: akpm@linux-foundation.org
Subject: + fs-partition-msdos-fix-unusable-extended-partition-for-512b-sector.patch added to -mm tree
Date: Fri, 12 Mar 2010 15:44:26 -0800
Message-ID: <201003122344.o2CNiQg1014872@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934726Ab0CLXoa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Mar 2010 18:44:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp, Daniel.Taylor@wdc.com, hpa@zytor.com, stable@kernel.org


The patch titled
     fs/partition/msdos: fix unusable extended partition for > 512B sector
has been added to the -mm tree.  Its filename is
     fs-partition-msdos-fix-unusable-extended-partition-for-512b-sector.patch

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

devmem-dont-allow-seek-to-last-page.patch
drivers-char-memc-cleanups.patch
linux-next.patch
fs-partitions-msdos-add-support-for-large-disks.patch
fs-partition-msdos-fix-unusable-extended-partition-for-512b-sector.patch

