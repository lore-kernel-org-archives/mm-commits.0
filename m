From: akpm@linux-foundation.org
Subject: [merged] swapfile-avoid-dereferencing-bd_disk-during-swap_entry_free-for-network-storage.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:17:41 -0700
Message-ID: <20120801201742.5D8FB20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:43672 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022Ab2HAURq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:17:46 -0400
Received: by bkcjc3 with SMTP id jc3so345285bkc.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:17:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, Trond.Myklebust@netapp.com, a.p.zijlstra@chello.nl, davem@davemloft.net, dfeng@redhat.com, emunson@mgebm.net, eparis@redhat.com, hch@infradead.org, jmorris@namei.org, michaelc@cs.wisc.edu, neilb@suse.de, riel@redhat.com, sebastian@breakpoint.cc, mm-commits@vger.kernel.org


The patch titled
     Subject: swapfile: avoid dereferencing bd_disk during swap_entry_free for network storage
has been removed from the -mm tree.  Its filename was
     swapfile-avoid-dereferencing-bd_disk-during-swap_entry_free-for-network-storage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: swapfile: avoid dereferencing bd_disk during swap_entry_free for network storage

Commit b3a27d ("swap: Add swap slot free callback to
block_device_operations") dereferences p->bdev->bd_disk but this is a NULL
dereference if using swap-over-NFS.  This patch checks SWP_BLKDEV on the
swap_info_struct before dereferencing.

With reference to this callback, Christoph Hellwig stated "Please just
remove the callback entirely.  It has no user outside the staging tree and
was added clearly against the rules for that staging tree".  This would
also be my preference but there was not an obvious way of keeping zram in
staging/ happy.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Eric Paris <eparis@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Neil Brown <neilb@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/swapfile.c~swapfile-avoid-dereferencing-bd_disk-during-swap_entry_free-for-network-storage mm/swapfile.c
--- a/mm/swapfile.c~swapfile-avoid-dereferencing-bd_disk-during-swap_entry_free-for-network-storage
+++ a/mm/swapfile.c
@@ -549,7 +549,6 @@ static unsigned char swap_entry_free(str
 
 	/* free if no reference */
 	if (!usage) {
-		struct gendisk *disk = p->bdev->bd_disk;
 		if (offset < p->lowest_bit)
 			p->lowest_bit = offset;
 		if (offset > p->highest_bit)
@@ -560,9 +559,12 @@ static unsigned char swap_entry_free(str
 		nr_swap_pages++;
 		p->inuse_pages--;
 		frontswap_invalidate_page(p->type, offset);
-		if ((p->flags & SWP_BLKDEV) &&
-				disk->fops->swap_slot_free_notify)
-			disk->fops->swap_slot_free_notify(p->bdev, offset);
+		if (p->flags & SWP_BLKDEV) {
+			struct gendisk *disk = p->bdev->bd_disk;
+			if (disk->fops->swap_slot_free_notify)
+				disk->fops->swap_slot_free_notify(p->bdev,
+								  offset);
+		}
 	}
 
 	return usage;
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch

