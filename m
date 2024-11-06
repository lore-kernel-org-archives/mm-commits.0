Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948091E48A
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854862; cv=none; b=kGLwNC7vBc/T0em2n4t4Bjiqd4o0Tv69ZJDkSOv775s3KIBIYxokG+yffa8Fi+zkl7yeitCFKcCbZ9VutOzkkybfGOwZgAYoY3S7fj89LihbOdf8RPWPojMRAJ230O9fB1Evyiwnzv2eBCbcbIFhWBE0IIMp5RvfwB16GIyDvm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854862; c=relaxed/simple;
	bh=s0FOmfm+PExpmEDccTadh4PWHVO1ipc4mLOnwwOInZg=;
	h=Date:To:From:Subject:Message-Id; b=nVLocag/EaiM6Q7iHzRRD4flylod+TrD/OIxq6Sqw/usGiAmEDzcW19G+K44hbMhs2n7qiFVFmSuSTzDFb2yCGdXDvM60VazDuZZbdZ06FgA8lEfdLx13ofcj+O+2oOcAlGrsrj/OjgI5OL8WJwQmNvzmWI9ZVK6YrKNJDfIWcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=apDk1vsY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="apDk1vsY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686F1C4CECF;
	Wed,  6 Nov 2024 01:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854862;
	bh=s0FOmfm+PExpmEDccTadh4PWHVO1ipc4mLOnwwOInZg=;
	h=Date:To:From:Subject:From;
	b=apDk1vsYX8GldLbwmtCujvW6Qd8ktqV9NEekZf/f6Qa3fS92CzyRWrWNVsmlpnVrM
	 mS3BVwTMUS2LGxWLHSyWgC8naD+o7kNRTeYzqq6RdU+tXPNhzbGg4yZYPb/IFtXwkX
	 wanOGJ59XPwHwBGY8JhQXXtPskZ36w3cOLn2iqMk=
Date: Tue, 05 Nov 2024 17:01:01 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,jimzhao.ai@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page-writeback-raise-wb_thresh-to-prevent-write-blocking-with-strictlimit.patch removed from -mm tree
Message-Id: <20241106010102.686F1C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page-writeback: raise wb_thresh to prevent write blocking with strictlimit
has been removed from the -mm tree.  Its filename was
     mm-page-writeback-raise-wb_thresh-to-prevent-write-blocking-with-strictlimit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jim Zhao <jimzhao.ai@gmail.com>
Subject: mm/page-writeback: raise wb_thresh to prevent write blocking with strictlimit
Date: Wed, 23 Oct 2024 18:00:32 +0800

With the strictlimit flag, wb_thresh acts as a hard limit in
balance_dirty_pages() and wb_position_ratio().  When device write
operations are inactive, wb_thresh can drop to 0, causing writes to be
blocked.  The issue occasionally occurs in fuse fs, particularly with
network backends, the write thread is blocked frequently during a period. 
To address it, this patch raises the minimum wb_thresh to a controllable
level, similar to the non-strictlimit case.

Link: https://lkml.kernel.org/r/20241023100032.62952-1-jimzhao.ai@gmail.com
Signed-off-by: Jim Zhao <jimzhao.ai@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

--- a/mm/page-writeback.c~mm-page-writeback-raise-wb_thresh-to-prevent-write-blocking-with-strictlimit
+++ a/mm/page-writeback.c
@@ -917,7 +917,9 @@ static unsigned long __wb_calc_thresh(st
 				      unsigned long thresh)
 {
 	struct wb_domain *dom = dtc_dom(dtc);
+	struct bdi_writeback *wb = dtc->wb;
 	u64 wb_thresh;
+	u64 wb_max_thresh;
 	unsigned long numerator, denominator;
 	unsigned long wb_min_ratio, wb_max_ratio;
 
@@ -931,11 +933,28 @@ static unsigned long __wb_calc_thresh(st
 	wb_thresh *= numerator;
 	wb_thresh = div64_ul(wb_thresh, denominator);
 
-	wb_min_max_ratio(dtc->wb, &wb_min_ratio, &wb_max_ratio);
+	wb_min_max_ratio(wb, &wb_min_ratio, &wb_max_ratio);
 
 	wb_thresh += (thresh * wb_min_ratio) / (100 * BDI_RATIO_SCALE);
-	if (wb_thresh > (thresh * wb_max_ratio) / (100 * BDI_RATIO_SCALE))
-		wb_thresh = thresh * wb_max_ratio / (100 * BDI_RATIO_SCALE);
+	wb_max_thresh = thresh * wb_max_ratio / (100 * BDI_RATIO_SCALE);
+	if (wb_thresh > wb_max_thresh)
+		wb_thresh = wb_max_thresh;
+
+	/*
+	 * With strictlimit flag, the wb_thresh is treated as
+	 * a hard limit in balance_dirty_pages() and wb_position_ratio().
+	 * It's possible that wb_thresh is close to zero, not because
+	 * the device is slow, but because it has been inactive.
+	 * To prevent occasional writes from being blocked, we raise wb_thresh.
+	 */
+	if (unlikely(wb->bdi->capabilities & BDI_CAP_STRICTLIMIT)) {
+		unsigned long limit = hard_dirty_limit(dom, dtc->thresh);
+		u64 wb_scale_thresh = 0;
+
+		if (limit > dtc->dirty)
+			wb_scale_thresh = (limit - dtc->dirty) / 100;
+		wb_thresh = max(wb_thresh, min(wb_scale_thresh, wb_max_thresh / 4));
+	}
 
 	return wb_thresh;
 }
_

Patches currently in -mm which might be from jimzhao.ai@gmail.com are


