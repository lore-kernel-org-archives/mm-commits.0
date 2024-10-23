Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFDE22615
	for <mm-commits@vger.kernel.org>; Wed, 23 Oct 2024 23:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729725931; cv=none; b=VGUEqK2PoWFXAOTZqXBReTnf6Uj/N6Usd/xo+hRvCs0lmrCj1veZBwu12tIVchd2C1LujU78fxv+UZvst/tW4F7b8uxU2lPoMt3TxgSMlf4ppZNgzGw1r2eYV/igC6Co6qmmm5OpC5QzZ6Q9LxIGsmfudOrS3U5tzSrpXOI/Qaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729725931; c=relaxed/simple;
	bh=gaXsdKzkrEQiyhPQE6BMagI6jHzizFtjaJu5rWWm+Vk=;
	h=Date:To:From:Subject:Message-Id; b=L/XiCMTogWt59oeizLn3M9k1Leheiy1a495nAPS+HXABMMK7KHHh37xRrpc8t2LDj+S/Jfnz9H3YDxs4baQe8qiODDIeYtCo+46qIlHOm6YyqxO0XRCWcPbZjZhFQRW24A8Fn3THbKwgVbpWLDXWiMJHnWQ4RVgdcDyqGpguSr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iwecUWSt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iwecUWSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D085C4CEC6;
	Wed, 23 Oct 2024 23:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729725931;
	bh=gaXsdKzkrEQiyhPQE6BMagI6jHzizFtjaJu5rWWm+Vk=;
	h=Date:To:From:Subject:From;
	b=iwecUWStGoIIuLb17Xk/RJs/1y6uQywFp/On5ZMJXKJGmb1eASCOIdNpgIvNcCwC2
	 MQ8SUyRJdCGjB6nRy4ZDfZ/AkDVanW3V1O4I8yREfpxDYavrVOmeC+81UCjNjZT7b9
	 dnd6OSYOpBkt2mpK9Jo/5PGvOiSvQjlCxrQdnp3w=
Date: Wed, 23 Oct 2024 16:25:30 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,jimzhao.ai@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page-writeback-raise-wb_thresh-to-prevent-write-blocking-with-strictlimit.patch added to mm-unstable branch
Message-Id: <20241023232531.1D085C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page-writeback: raise wb_thresh to prevent write blocking with strictlimit
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page-writeback-raise-wb_thresh-to-prevent-write-blocking-with-strictlimit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page-writeback-raise-wb_thresh-to-prevent-write-blocking-with-strictlimit.patch

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

mm-page-writeback-raise-wb_thresh-to-prevent-write-blocking-with-strictlimit.patch

