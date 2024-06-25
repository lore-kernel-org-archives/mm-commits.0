Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBE0143725
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291541; cv=none; b=q56TkuCivAHyTMABUCEyV4Bf6HpknkPcbUrVZInGYQoVkZCwwisIUaJiR1ykAvAi/TzA5/hw+DLCfBj0RjuklaeROwPH0p8CV5ufu0/gvuL8coQgBndclyZB/XO2wWAQfnndVnqqYHYYTv9wsgmu/SpzuYtw7bFcswfIND4CrfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291541; c=relaxed/simple;
	bh=O9RFXJReBhsQKgnvM+6yiJp+q9Z5fNnXAfG/6Z0p0jM=;
	h=Date:To:From:Subject:Message-Id; b=B4mBIyYldnPx3gerhASWYV+dQZsoHm89g7zNCGZ9EBnUUcL1w69hTCnqeIP7XaEZ8jOlcdreW8NhI7Z/qPvuLopwP9Xo9ysPPLLFLnQhD9tbJItLWJBo50vfLGNF3GsCGQsuV8/MUxxA75XL4mQPYnSYPdYPI/1JrfoPM9nkhd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1CiBGOu+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1CiBGOu+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70A9C32782;
	Tue, 25 Jun 2024 04:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291540;
	bh=O9RFXJReBhsQKgnvM+6yiJp+q9Z5fNnXAfG/6Z0p0jM=;
	h=Date:To:From:Subject:From;
	b=1CiBGOu+GEnjOtNgL6es6oW1UgPD5xFhoEiEvFgY+moFvB/vJLRA9dn72h6R+6TAf
	 Dqr1MBtLAmsJyl8xn3CBcWffc8zUdFE7hoZotV4u2MCNS9Nz8Bt+8Vc7B86eWWEIj2
	 NFfcHolkfsXceEZKfHPOieZqhvePURCFcJRjrGSs=
Date: Mon, 24 Jun 2024 21:59:00 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] writeback-factor-out-code-of-freerun-to-remove-repeated-code.patch removed from -mm tree
Message-Id: <20240625045900.D70A9C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: writeback: factor out code of freerun to remove repeated code
has been removed from the -mm tree.  Its filename was
     writeback-factor-out-code-of-freerun-to-remove-repeated-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: writeback: factor out code of freerun to remove repeated code
Date: Tue, 14 May 2024 20:52:50 +0800

Factor out code of freerun into new helper functions domain_poll_intv and
domain_dirty_freerun to remove repeated code.

Link: https://lkml.kernel.org/r/20240514125254.142203-5-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   89 +++++++++++++++++++++++-------------------
 1 file changed, 49 insertions(+), 40 deletions(-)

--- a/mm/page-writeback.c~writeback-factor-out-code-of-freerun-to-remove-repeated-code
+++ a/mm/page-writeback.c
@@ -139,6 +139,7 @@ struct dirty_throttle_control {
 	unsigned long		wb_bg_thresh;
 
 	unsigned long		pos_ratio;
+	bool			freerun;
 };
 
 /*
@@ -1702,6 +1703,49 @@ static inline void wb_dirty_limits(struc
 	}
 }
 
+static unsigned long domain_poll_intv(struct dirty_throttle_control *dtc,
+				      bool strictlimit)
+{
+	unsigned long dirty, thresh;
+
+	if (strictlimit) {
+		dirty = dtc->wb_dirty;
+		thresh = dtc->wb_thresh;
+	} else {
+		dirty = dtc->dirty;
+		thresh = dtc->thresh;
+	}
+
+	return dirty_poll_interval(dirty, thresh);
+}
+
+/*
+ * Throttle it only when the background writeback cannot catch-up. This avoids
+ * (excessively) small writeouts when the wb limits are ramping up in case of
+ * !strictlimit.
+ *
+ * In strictlimit case make decision based on the wb counters and limits. Small
+ * writeouts when the wb limits are ramping up are the price we consciously pay
+ * for strictlimit-ing.
+ */
+static void domain_dirty_freerun(struct dirty_throttle_control *dtc,
+				 bool strictlimit)
+{
+	unsigned long dirty, thresh, bg_thresh;
+
+	if (unlikely(strictlimit)) {
+		wb_dirty_limits(dtc);
+		dirty = dtc->wb_dirty;
+		thresh = dtc->wb_thresh;
+		bg_thresh = dtc->wb_bg_thresh;
+	} else {
+		dirty = dtc->dirty;
+		thresh = dtc->thresh;
+		bg_thresh = dtc->bg_thresh;
+	}
+	dtc->freerun = dirty <= dirty_freerun_ceiling(thresh, bg_thresh);
+}
+
 /*
  * balance_dirty_pages() must be called by processes which are generating dirty
  * data.  It looks at the number of dirty pages in the machine and will force
@@ -1734,27 +1778,12 @@ static int balance_dirty_pages(struct bd
 
 	for (;;) {
 		unsigned long now = jiffies;
-		unsigned long dirty, thresh, bg_thresh;
-		unsigned long m_dirty = 0;	/* stop bogus uninit warnings */
-		unsigned long m_thresh = 0;
-		unsigned long m_bg_thresh = 0;
 
 		nr_dirty = global_node_page_state(NR_FILE_DIRTY);
 
 		domain_dirty_avail(gdtc, true);
 		domain_dirty_limits(gdtc);
-
-		if (unlikely(strictlimit)) {
-			wb_dirty_limits(gdtc);
-
-			dirty = gdtc->wb_dirty;
-			thresh = gdtc->wb_thresh;
-			bg_thresh = gdtc->wb_bg_thresh;
-		} else {
-			dirty = gdtc->dirty;
-			thresh = gdtc->thresh;
-			bg_thresh = gdtc->bg_thresh;
-		}
+		domain_dirty_freerun(gdtc, strictlimit);
 
 		if (mdtc) {
 			/*
@@ -1763,17 +1792,7 @@ static int balance_dirty_pages(struct bd
 			 */
 			domain_dirty_avail(mdtc, true);
 			domain_dirty_limits(mdtc);
-
-			if (unlikely(strictlimit)) {
-				wb_dirty_limits(mdtc);
-				m_dirty = mdtc->wb_dirty;
-				m_thresh = mdtc->wb_thresh;
-				m_bg_thresh = mdtc->wb_bg_thresh;
-			} else {
-				m_dirty = mdtc->dirty;
-				m_thresh = mdtc->thresh;
-				m_bg_thresh = mdtc->bg_thresh;
-			}
+			domain_dirty_freerun(mdtc, strictlimit);
 		}
 
 		/*
@@ -1790,31 +1809,21 @@ static int balance_dirty_pages(struct bd
 			wb_start_background_writeback(wb);
 
 		/*
-		 * Throttle it only when the background writeback cannot
-		 * catch-up. This avoids (excessively) small writeouts
-		 * when the wb limits are ramping up in case of !strictlimit.
-		 *
-		 * In strictlimit case make decision based on the wb counters
-		 * and limits. Small writeouts when the wb limits are ramping
-		 * up are the price we consciously pay for strictlimit-ing.
-		 *
 		 * If memcg domain is in effect, @dirty should be under
 		 * both global and memcg freerun ceilings.
 		 */
-		if (dirty <= dirty_freerun_ceiling(thresh, bg_thresh) &&
-		    (!mdtc ||
-		     m_dirty <= dirty_freerun_ceiling(m_thresh, m_bg_thresh))) {
+		if (gdtc->freerun && (!mdtc || mdtc->freerun)) {
 			unsigned long intv;
 			unsigned long m_intv;
 
 free_running:
-			intv = dirty_poll_interval(dirty, thresh);
+			intv = domain_poll_intv(gdtc, strictlimit);
 			m_intv = ULONG_MAX;
 
 			current->dirty_paused_when = now;
 			current->nr_dirtied = 0;
 			if (mdtc)
-				m_intv = dirty_poll_interval(m_dirty, m_thresh);
+				m_intv = domain_poll_intv(mdtc, strictlimit);
 			current->nr_dirtied_pause = min(intv, m_intv);
 			break;
 		}
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


