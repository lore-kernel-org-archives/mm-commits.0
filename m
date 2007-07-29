From: akpm@linux-foundation.org
Subject: + md-handle-writes-to-broken-raid10-arrays-gracefully.patch added to -mm tree
Date: Sat, 28 Jul 2007 23:52:37 -0700
Message-ID: <200707290652.l6T6qbX6012464@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54995 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759566AbXG2Gwu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:52:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: agr@powerkom-dd.de, neilb@suse.de


The patch titled
     md: handle writes to broken raid10 arrays gracefully
has been added to the -mm tree.  Its filename is
     md-handle-writes-to-broken-raid10-arrays-gracefully.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: handle writes to broken raid10 arrays gracefully
From: Arne Redlich <agr@powerkom-dd.de>

When writing to a broken array, raid10 currently happily emits empty bio
lists.  IOW, the master bio will never be completed, sending writers to
UNINTERRUPTIBLE_SLEEP forever.

Signed-off-by: Arne Redlich <agr@powerkom-dd.de>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid10.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/md/raid10.c~md-handle-writes-to-broken-raid10-arrays-gracefully drivers/md/raid10.c
--- a/drivers/md/raid10.c~md-handle-writes-to-broken-raid10-arrays-gracefully
+++ a/drivers/md/raid10.c
@@ -887,6 +887,13 @@ static int make_request(struct request_q
 		bio_list_add(&bl, mbio);
 	}
 
+	if (unlikely(!atomic_read(&r10_bio->remaining))) {
+		/* the array is dead */
+		md_write_end(mddev);
+		raid_end_bio_io(r10_bio);
+		return 0;
+	}
+
 	bitmap_startwrite(mddev->bitmap, bio->bi_sector, r10_bio->sectors, 0);
 	spin_lock_irqsave(&conf->device_lock, flags);
 	bio_list_merge(&conf->pending_bio_list, &bl);
_

Patches currently in -mm which might be from agr@powerkom-dd.de are

md-handle-writes-to-broken-raid10-arrays-gracefully.patch
