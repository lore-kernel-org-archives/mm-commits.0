From: akpm@linux-foundation.org
Subject: +
 mm-bouncec-wix-a-regression-where-ms_snap_stable-stable-pages-snapshotting-was-ignored.patch added to -mm tree
Date: Mon, 23 Sep 2013 15:16:34 -0700
Message-ID: <5240bdc2.lTB54ZFj55UGz+tg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56233 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab3IWWQh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Sep 2013 18:16:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, mgorman@suse.de, koverstreet@google.com, darrick.wong@oracle.com

Subject: + mm-bouncec-wix-a-regression-where-ms_snap_stable-stable-pages-snapshotting-was-ignored.patch added to -mm tree
To: darrick.wong@oracle.com,koverstreet@google.com,mgorman@suse.de,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 23 Sep 2013 15:16:34 -0700


The patch titled
     Subject: mm/bounce.c: wix a regression where MS_SNAP_STABLE (stable pages snapshotting) was ignored
has been added to the -mm tree.  Its filename is
     mm-bouncec-wix-a-regression-where-ms_snap_stable-stable-pages-snapshotting-was-ignored.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-bouncec-wix-a-regression-where-ms_snap_stable-stable-pages-snapshotting-was-ignored.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-bouncec-wix-a-regression-where-ms_snap_stable-stable-pages-snapshotting-was-ignored.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: mm/bounce.c: wix a regression where MS_SNAP_STABLE (stable pages snapshotting) was ignored

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

mm-bouncec-wix-a-regression-where-ms_snap_stable-stable-pages-snapshotting-was-ignored.patch

