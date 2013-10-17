From: akpm@linux-foundation.org
Subject: [merged]
 mm-bouncec-wix-a-regression-where-ms_snap_stable-stable-pages-snapshotting-was-ignored.patch removed from -mm tree
Date: Thu, 17 Oct 2013 11:12:21 -0700
Message-ID: <52602885.TNBLOhJKMw/ap3H7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44197 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758395Ab3JQSMW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Oct 2013 14:12:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, mgorman@suse.de, koverstreet@google.com, darrick.wong@oracle.com

Subject: [merged] mm-bouncec-wix-a-regression-where-ms_snap_stable-stable-pages-snapshotting-was-ignored.patch removed from -mm tree
To: darrick.wong@oracle.com,koverstreet@google.com,mgorman@suse.de,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 17 Oct 2013 11:12:21 -0700


The patch titled
     Subject: mm/bounce.c: fix a regression where MS_SNAP_STABLE (stable pages snapshotting) was ignored
has been removed from the -mm tree.  Its filename was
     mm-bouncec-wix-a-regression-where-ms_snap_stable-stable-pages-snapshotting-was-ignored.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: mm/bounce.c: fix a regression where MS_SNAP_STABLE (stable pages snapshotting) was ignored

The "force" parameter in __blk_queue_bounce was being ignored, which means
that stable page snapshots are not always happening (on ext3).  This of
course leads to DIF disks reporting checksum errors, so fix this
regression.

The regression was introduced in 6bc454d1 ("bounce: Refactor
__blk_queue_bounce to not use bi_io_vec")

Reported-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Kent Overstreet <koverstreet@google.com>
Cc: <stable@vger.kernel.org>	[3.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bounce.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/bounce.c~mm-bouncec-wix-a-regression-where-ms_snap_stable-stable-pages-snapshotting-was-ignored mm/bounce.c
--- a/mm/bounce.c~mm-bouncec-wix-a-regression-where-ms_snap_stable-stable-pages-snapshotting-was-ignored
+++ a/mm/bounce.c
@@ -204,6 +204,8 @@ static void __blk_queue_bounce(struct re
 	struct bio_vec *to, *from;
 	unsigned i;
 
+	if (force)
+		goto bounce;
 	bio_for_each_segment(from, *bio_orig, i)
 		if (page_to_pfn(from->bv_page) > queue_bounce_pfn(q))
 			goto bounce;
_

Patches currently in -mm which might be from darrick.wong@oracle.com are


