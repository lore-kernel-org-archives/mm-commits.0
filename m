From: akpm@linux-foundation.org
Subject: - md-handle-writes-to-broken-raid10-arrays-gracefully.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:58:20 -0700
Message-ID: <200707312358.l6VNwKe7029542@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37294 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753503AbXHAAQ6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:16:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agr@powerkom-dd.de, neilb@suse.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     md: handle writes to broken raid10 arrays gracefully
has been removed from the -mm tree.  Its filename was
     md-handle-writes-to-broken-raid10-arrays-gracefully.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md: handle writes to broken raid10 arrays gracefully
From: Arne Redlich <agr@powerkom-dd.de>

When writing to a broken array, raid10 currently happily emits empty bio
lists.  IOW, the master bio will never be completed, sending writers to
UNINTERRUPTIBLE_SLEEP forever.

Signed-off-by: Arne Redlich <agr@powerkom-dd.de>
Acked-by: Neil Brown <neilb@suse.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid10.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/md/raid10.c~md-handle-writes-to-broken-raid10-arrays-gracefully drivers/md/raid10.c
--- a/drivers/md/raid10.c~md-handle-writes-to-broken-raid10-arrays-gracefully
+++ a/drivers/md/raid10.c
@@ -917,6 +917,13 @@ static int make_request(struct request_q
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

origin.patch
