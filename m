From: akpm@linux-foundation.org
Subject: - brd-dont-show-ramdisks-in-proc-partitions.patch removed from -mm tree
Date: Tue, 27 May 2008 00:27:38 -0700
Message-ID: <200805270727.m4R7Rc4s014787@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755985AbYE0H2j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 03:28:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hawk@pld-linux.org, npiggin@suse.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     brd: don't show ramdisks in /proc/partitions
has been removed from the -mm tree.  Its filename was
     brd-dont-show-ramdisks-in-proc-partitions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: brd: don't show ramdisks in /proc/partitions
From: Marcin Krol <hawk@pld-linux.org>

In 2.6.25, ramdisk devices show up in /proc/partitions, which is a
behaviour change from the old rd.c.  Add GENHD_FL_SUPPRESS_PARTITION_INFO,
which was present in rd.c.

All kernels prior to 2.6.25 weren't displaying ramdisks in
/proc/partitions.  Since there are many userspace tools using information
from /proc/partitions some of them may now behave incorrectly (I didn't
tested any though).  For example before 2.6.25 /proc/partitions was empty
if no block devices like hard disks and such were detected by kernel.  Now
all 16 ramdisks are always visible there.  Some software may rely on such
information (I mean, on empty /proc/partitions).

There was quite similar situation back in 2004, and ramdisks were excluded
back from displaying.  Thats why I called this a regression (maybe a bit
unfortunate).  See this patch for info:
http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.3-rc2/2.6.3-rc2-mm1/broken-out/nbd-proc-partitions-fix.patch

I also think that someone somewhere (long time ago) excluded ramdisks from
/proc/partitions for good reasons.  It is possible that now such new
"feature" is harmless, but I think there are more chances that someone
will say "hey, /proc/partitions has changed, now my software doesn't work"
then "hey where did my new 2.6.25 feature go".  nbd devices are also
excluded, maybe for very same (unknown to me) reasons.

Signed-off-by: Marcin Krol <hawk@pld-linux.org>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/brd.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/block/brd.c~brd-dont-show-ramdisks-in-proc-partitions drivers/block/brd.c
--- a/drivers/block/brd.c~brd-dont-show-ramdisks-in-proc-partitions
+++ a/drivers/block/brd.c
@@ -447,6 +447,7 @@ static struct brd_device *brd_alloc(int 
 	disk->fops		= &brd_fops;
 	disk->private_data	= brd;
 	disk->queue		= brd->brd_queue;
+	disk->flags |= GENHD_FL_SUPPRESS_PARTITION_INFO;
 	sprintf(disk->disk_name, "ram%d", i);
 	set_capacity(disk, rd_size * 2);
 
_

Patches currently in -mm which might be from hawk@pld-linux.org are


