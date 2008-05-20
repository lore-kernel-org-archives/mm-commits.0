From: akpm@linux-foundation.org
Subject: + brd-dont-show-ramdisks-in-proc-partitions.patch added to -mm tree
Date: Tue, 20 May 2008 12:04:44 -0700
Message-ID: <200805201904.m4KJ4iZ6006453@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932814AbYETTFi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 15:05:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hawk@pld-linux.org, npiggin@suse.de


The patch titled
     brd: don't show ramdisks in /proc/partitions
has been added to the -mm tree.  Its filename is
     brd-dont-show-ramdisks-in-proc-partitions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: brd: don't show ramdisks in /proc/partitions
From: Marcin Krol <hawk@pld-linux.org>

In 2.6.25, ramdisk devices show up in /proc/partitions, which is a
behaviour change from the old rd.c.  Add GENHD_FL_SUPPRESS_PARTITION_INFO,
which was present in rd.c.

Signed-off-by: Marcin Krol <hawk@pld-linux.org>
Signed-off-by: Nick Piggin <npiggin@suse.de>
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

brd-dont-show-ramdisks-in-proc-partitions.patch

