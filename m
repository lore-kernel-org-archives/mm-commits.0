Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88B0ECF
	for <mm-commits@vger.kernel.org>; Mon, 20 May 2024 00:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716164607; cv=none; b=hJAl0AsCjNsw4HK6VCwLIW2By2JMuoIkcH6LAAhCqJqTdiGoGMNWZkCBv353te4RIr0zWevnTr78mGuA1cy8GtI+9MQD6FFL+BOfM9e2jMb1b1aExbF6Z59SW4yGIRjlHBq1qe6o5ux5xg9mqMGe7GU0CwKGwungyX2N0jQ1Nps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716164607; c=relaxed/simple;
	bh=fJizTAd376S/Ahq8MGdOTC9pYcRhvo4cwxO21S+yG+0=;
	h=Date:To:From:Subject:Message-Id; b=tUDkQa18ibmnY7xSk6jG+FWzTn9qFNgZk2WkWyFSIUNdBMDQZYbJtnLxad5r5HREny1bL1hhTPc9OSJCoEp6oFp8/7ABW0OQfMNWhRzIZO+hYWzNx7I5iF4uVXIF5p2/aC5NrjbwSRJvYOSv3TUiX32HTmKoJWAhOfVhVawRhBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hww0Gi87; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hww0Gi87"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18713C32781;
	Mon, 20 May 2024 00:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716164607;
	bh=fJizTAd376S/Ahq8MGdOTC9pYcRhvo4cwxO21S+yG+0=;
	h=Date:To:From:Subject:From;
	b=Hww0Gi87GQls7xIUES6gbYazCUHXy+Gj5j0mwpT5wL0ee7Gt6h3lzfqhmesq7wlft
	 bERfCJgrlm5bvnb8i0tLMCsawuztrdxP5+eYmjnk9kVGrAKDZ/an/dubWk1xjCo3Nv
	 We3aOriuRbl+k9HlnQme/kRY2kLO9J57PuED1TUA=
Date: Sun, 19 May 2024 17:23:26 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-factor-out-wb_bg_dirty_limits-to-remove-repeated-code.patch added to mm-unstable branch
Message-Id: <20240520002327.18713C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: writeback: factor out wb_bg_dirty_limits to remove repeated code
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-factor-out-wb_bg_dirty_limits-to-remove-repeated-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-factor-out-wb_bg_dirty_limits-to-remove-repeated-code.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

writeback-factor-out-wb_bg_dirty_limits-to-remove-repeated-code.patch
writeback-add-general-function-domain_dirty_avail-to-calculate-dirty-and-avail-of-domain.patch
writeback-factor-out-domain_over_bg_thresh-to-remove-repeated-code.patch
writeback-factor-out-code-of-freerun-to-remove-repeated-code.patch
writeback-factor-out-wb_dirty_freerun-to-remove-more-repeated-freerun-code.patch
writeback-factor-out-balance_domain_limits-to-remove-repeated-code.patch
writeback-factor-out-wb_dirty_exceeded-to-remove-repeated-code.patch
writeback-factor-out-balance_wb_limits-to-remove-repeated-code.patch

