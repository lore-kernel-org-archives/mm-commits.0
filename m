Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F76133EE
	for <mm-commits@vger.kernel.org>; Mon, 20 May 2024 00:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716164612; cv=none; b=gmDTbijoS2+gHLdA5Nx64Zx3ypzbwJXljx80XRtVuTS0anC1/NSnKXVwvH9MWStn31Na0ktXrN/bLEDtMfmUoYBOloWMC3AxR3XsoX6L6EqWglJkMoEMmgK5GZzrQd0p9cGC0eb9im4W/dWGNkv4gbd4Mka2Rs8EZbfOCzv9Arg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716164612; c=relaxed/simple;
	bh=bmz82ntxNXYjJ9qJEIXhsyEHls2bE9P1qV0PerwO/hg=;
	h=Date:To:From:Subject:Message-Id; b=SABCEJr4w9sBBsR8wXhXKrypNe9tLgayqJ23eyfJJYyEh23+8qOCrUmAt6FcMe9qYZmuCEqT55HspKYeJUaTRTh/bBRq/eS53ME7Dn4qCsYbj6M01/IobriFRU0Rzove6ZX7yMJXrNN9ZwO5SwDzQSgd4+IpB4pJ/d171tZgKho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LFT2e9Yg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LFT2e9Yg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74471C32781;
	Mon, 20 May 2024 00:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716164612;
	bh=bmz82ntxNXYjJ9qJEIXhsyEHls2bE9P1qV0PerwO/hg=;
	h=Date:To:From:Subject:From;
	b=LFT2e9Ygj+HpIIw64JR3VbiLF4b9EWiq9QMPwFFvtSM5uxENUgcSc8HfPnnY4DE9j
	 KMkBLbJpWhfpEVYGWyVM52EPajlXRl+0O6VOUF5vkitZa0QESQm7g9Zr2G/K2x5A7i
	 /5ViUNeM2Rg0pscA4RF4cLZk4CdnTWPJCAL1s7AM=
Date: Sun, 19 May 2024 17:23:31 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-factor-out-code-of-freerun-to-remove-repeated-code.patch added to mm-unstable branch
Message-Id: <20240520002332.74471C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: writeback: factor out code of freerun to remove repeated code
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-factor-out-code-of-freerun-to-remove-repeated-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-factor-out-code-of-freerun-to-remove-repeated-code.patch

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

writeback-factor-out-wb_bg_dirty_limits-to-remove-repeated-code.patch
writeback-add-general-function-domain_dirty_avail-to-calculate-dirty-and-avail-of-domain.patch
writeback-factor-out-domain_over_bg_thresh-to-remove-repeated-code.patch
writeback-factor-out-code-of-freerun-to-remove-repeated-code.patch
writeback-factor-out-wb_dirty_freerun-to-remove-more-repeated-freerun-code.patch
writeback-factor-out-balance_domain_limits-to-remove-repeated-code.patch
writeback-factor-out-wb_dirty_exceeded-to-remove-repeated-code.patch
writeback-factor-out-balance_wb_limits-to-remove-repeated-code.patch

