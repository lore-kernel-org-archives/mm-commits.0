From: akpm@linux-foundation.org
Subject: + dm-bounce_pfn-limit-added.patch added to -mm tree
Date: Tue, 30 Oct 2007 13:11:42 -0700
Message-ID: <200710302011.l9UKBgXH025890@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47632 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754115AbXJ3UNI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 16:13:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vvs@sw.ru, agk@redhat.com, jens.axboe@oracle.com, stable@kernel.org


The patch titled
     dm: bounce_pfn limit added
has been added to the -mm tree.  Its filename is
     dm-bounce_pfn-limit-added.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dm: bounce_pfn limit added
From: Vasily Averin <vvs@sw.ru>

Device mapper uses its own bounce_pfn that may differ from one on underlying
device. In that way dm can build incorrect requests that contain sg elements
greater than underlying device is able to handle.

This is the cause of slab corruption in i2o layer, occurred on i386 arch when
very long direct IO requests are addressed to dm-over-i2o device.

Signed-off-by: Vasily Averin <vvs@sw.ru>
Cc: <stable@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-table.c         |    7 +++++++
 include/linux/device-mapper.h |    1 +
 2 files changed, 8 insertions(+)

diff -puN drivers/md/dm-table.c~dm-bounce_pfn-limit-added drivers/md/dm-table.c
--- a/drivers/md/dm-table.c~dm-bounce_pfn-limit-added
+++ a/drivers/md/dm-table.c
@@ -102,6 +102,8 @@ static void combine_restrictions_low(str
 	lhs->seg_boundary_mask =
 		min_not_zero(lhs->seg_boundary_mask, rhs->seg_boundary_mask);
 
+	lhs->bounce_pfn = min_not_zero(lhs->bounce_pfn, rhs->bounce_pfn);
+
 	lhs->no_cluster |= rhs->no_cluster;
 }
 
@@ -566,6 +568,8 @@ void dm_set_device_limits(struct dm_targ
 		min_not_zero(rs->seg_boundary_mask,
 			     q->seg_boundary_mask);
 
+	rs->bounce_pfn = min_not_zero(rs->bounce_pfn, q->bounce_pfn);
+
 	rs->no_cluster |= !test_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
 }
 EXPORT_SYMBOL_GPL(dm_set_device_limits);
@@ -707,6 +711,8 @@ static void check_for_valid_limits(struc
 		rs->max_segment_size = MAX_SEGMENT_SIZE;
 	if (!rs->seg_boundary_mask)
 		rs->seg_boundary_mask = -1;
+	if (!rs->bounce_pfn)
+		rs->bounce_pfn = -1;
 }
 
 int dm_table_add_target(struct dm_table *t, const char *type,
@@ -891,6 +897,7 @@ void dm_table_set_restrictions(struct dm
 	q->hardsect_size = t->limits.hardsect_size;
 	q->max_segment_size = t->limits.max_segment_size;
 	q->seg_boundary_mask = t->limits.seg_boundary_mask;
+	q->bounce_pfn = t->limits.bounce_pfn;
 	if (t->limits.no_cluster)
 		q->queue_flags &= ~(1 << QUEUE_FLAG_CLUSTER);
 	else
diff -puN include/linux/device-mapper.h~dm-bounce_pfn-limit-added include/linux/device-mapper.h
--- a/include/linux/device-mapper.h~dm-bounce_pfn-limit-added
+++ a/include/linux/device-mapper.h
@@ -116,6 +116,7 @@ struct io_restrictions {
 	unsigned short		hardsect_size;
 	unsigned int		max_segment_size;
 	unsigned long		seg_boundary_mask;
+	unsigned long		bounce_pfn;
 	unsigned char		no_cluster; /* inverted so that 0 is default */
 };
 
_

Patches currently in -mm which might be from vvs@sw.ru are

i2o-debug-messages-corrected.patch
dm-bounce_pfn-limit-added.patch
