Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5194596E
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291536; cv=none; b=iBWbT9SIw5BF5RxSuKFCQFaTop7fHXqKjjFXXKhHmvhRiLoRz6HsR4zO8YpGCGCsMmn2Mov1vr+PxpFCM7yjwen/Z7vEo4Q4ND3FzHwvnbpNrvnT66lHMyiqzyKaFsTPcaeUbiB8eWOhqzq0/+N8PVvMvQfw8UqqIgZbhj/NAho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291536; c=relaxed/simple;
	bh=H0O6sfb3BF1sIO2px0EOZ2mmSg4UWTu5yGdMxxpYOYE=;
	h=Date:To:From:Subject:Message-Id; b=FJje7PkJ4xFrahqwnrpVQsCkPR9TovLWq02AF5PB4H08CazRTyjPSm6hZ6GDCBlj0RXlXOMjxWKOIQGpD6VY2YWvzIlYpbfjzteuYSlj+8nus+l7PLHv4P7gcctZi+HKT7XiiS2+XD38QWenlbAN9G/W9n/VUS/1AQr0MtB9YZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HE1xGNLA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HE1xGNLA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD74C32782;
	Tue, 25 Jun 2024 04:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291536;
	bh=H0O6sfb3BF1sIO2px0EOZ2mmSg4UWTu5yGdMxxpYOYE=;
	h=Date:To:From:Subject:From;
	b=HE1xGNLAwT8J9yrHlXyf74R3w8JpkOzl5fHBzjAj8VrKPmGXVXk0dhLe/L4BWAFtf
	 5oLdNWgt1e9olaqhJ+Zn4phb+8z/AfFRDIhNqOlFcfo18c8zudQ8iJdXeXfYnWRv1B
	 0w0FpwhrhFLRG7QZVdwM1AguVcETlo0WYyGJ6aI4=
Date: Mon, 24 Jun 2024 21:58:55 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] writeback-factor-out-wb_bg_dirty_limits-to-remove-repeated-code.patch removed from -mm tree
Message-Id: <20240625045856.6AD74C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: writeback: factor out wb_bg_dirty_limits to remove repeated code
has been removed from the -mm tree.  Its filename was
     writeback-factor-out-wb_bg_dirty_limits-to-remove-repeated-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: writeback: factor out wb_bg_dirty_limits to remove repeated code
Date: Tue, 14 May 2024 20:52:47 +0800

Patch series "Add helper functions to remove repeated code and improve
readability of cgroup writeback", v2.

This series adds a lot of helpers to remove repeated code between domain
and wb; dirty limit and dirty background; global domain and wb domain. 
The helpers also improve readability.  More details can be found in the
respective patches.

A simple domain hierarchy is tested:
global domain (> 20G)
	|
cgroup domain1(10G)
	|
	wb1
	|
	fio

Test steps:
/* make it easy to observe */
echo 300000 > /proc/sys/vm/dirty_expire_centisecs
echo 3000 > /proc/sys/vm/dirty_writeback_centisecs

/* create cgroup domain */
cd /sys/fs/cgroup
echo "+memory +io" > cgroup.subtree_control
mkdir group1
cd group1
echo 10G > memory.high
echo 10G > memory.max
echo $$ > cgroup.procs
mkfs.ext4 -F /dev/vdb
mount /dev/vdb /bdi1/

/* run fio to generate dirty pages */
fio -name test -filename=/bdi1/file -size=xxx -ioengine=libaio -bs=4K \
-iodepth=1 -rw=write -direct=0 --time_based -runtime=600 -invalidate=0

When fio size is 1G, the wb is in freerun state and dirty pages are only
written back when dirty inode is expired after 30 seconds.  When fio size
is 2G, the dirty pages keep being written back and bandwidth of fio is
limited.


This patch (of 8):

Similar to wb_dirty_limits which calculates dirty and thresh of wb,
wb_bg_dirty_limits calculates background dirty and background thresh of
wb.  With wb_bg_dirty_limits, we could remove repeated code in
wb_over_bg_thresh.

Link: https://lkml.kernel.org/r/20240514125254.142203-1-shikemeng@huaweicloud.com
Link: https://lkml.kernel.org/r/20240514125254.142203-2-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

--- a/mm/page-writeback.c~writeback-factor-out-wb_bg_dirty_limits-to-remove-repeated-code
+++ a/mm/page-writeback.c
@@ -2087,6 +2087,21 @@ void balance_dirty_pages_ratelimited(str
 }
 EXPORT_SYMBOL(balance_dirty_pages_ratelimited);
 
+/*
+ * Similar to wb_dirty_limits, wb_bg_dirty_limits also calculates dirty
+ * and thresh, but it's for background writeback.
+ */
+static void wb_bg_dirty_limits(struct dirty_throttle_control *dtc)
+{
+	struct bdi_writeback *wb = dtc->wb;
+
+	dtc->wb_bg_thresh = __wb_calc_thresh(dtc, dtc->bg_thresh);
+	if (dtc->wb_bg_thresh < 2 * wb_stat_error())
+		dtc->wb_dirty = wb_stat_sum(wb, WB_RECLAIMABLE);
+	else
+		dtc->wb_dirty = wb_stat(wb, WB_RECLAIMABLE);
+}
+
 /**
  * wb_over_bg_thresh - does @wb need to be written back?
  * @wb: bdi_writeback of interest
@@ -2103,8 +2118,6 @@ bool wb_over_bg_thresh(struct bdi_writeb
 	struct dirty_throttle_control * const gdtc = &gdtc_stor;
 	struct dirty_throttle_control * const mdtc = mdtc_valid(&mdtc_stor) ?
 						     &mdtc_stor : NULL;
-	unsigned long reclaimable;
-	unsigned long thresh;
 
 	/*
 	 * Similar to balance_dirty_pages() but ignores pages being written
@@ -2117,13 +2130,8 @@ bool wb_over_bg_thresh(struct bdi_writeb
 	if (gdtc->dirty > gdtc->bg_thresh)
 		return true;
 
-	thresh = __wb_calc_thresh(gdtc, gdtc->bg_thresh);
-	if (thresh < 2 * wb_stat_error())
-		reclaimable = wb_stat_sum(wb, WB_RECLAIMABLE);
-	else
-		reclaimable = wb_stat(wb, WB_RECLAIMABLE);
-
-	if (reclaimable > thresh)
+	wb_bg_dirty_limits(gdtc);
+	if (gdtc->wb_dirty > gdtc->wb_bg_thresh)
 		return true;
 
 	if (mdtc) {
@@ -2137,13 +2145,8 @@ bool wb_over_bg_thresh(struct bdi_writeb
 		if (mdtc->dirty > mdtc->bg_thresh)
 			return true;
 
-		thresh = __wb_calc_thresh(mdtc, mdtc->bg_thresh);
-		if (thresh < 2 * wb_stat_error())
-			reclaimable = wb_stat_sum(wb, WB_RECLAIMABLE);
-		else
-			reclaimable = wb_stat(wb, WB_RECLAIMABLE);
-
-		if (reclaimable > thresh)
+		wb_bg_dirty_limits(mdtc);
+		if (mdtc->wb_dirty > mdtc->wb_bg_thresh)
 			return true;
 	}
 
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


