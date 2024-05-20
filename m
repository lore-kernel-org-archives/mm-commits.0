Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4818A23BB
	for <mm-commits@vger.kernel.org>; Mon, 20 May 2024 00:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716164609; cv=none; b=TUq7DN+KHZIHan1dWF+cayNOoato5SRyeFu0HjKHjSwdnMh4mgzMyafM9l+CDPYozj1gwKPSMMxQzxouzj3bzm/qzS7n+YndfNUztUBU4b2nMu2heS0Dw0dhrGzZJ4p8qMbgSSyedpnWBpa5kKbCSscbqRU4Zxg+6Mbd+9JhG+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716164609; c=relaxed/simple;
	bh=wXZ/FLx8r1QvHgXury4BqP0fS4yA2h8sQiq5V3D0G/A=;
	h=Date:To:From:Subject:Message-Id; b=NJYjyb39b1Clff3gPuTBMhnh7C1HiMfCaypxud/HY7YJsTof+XMx3V29tZ8uiQXO5YcP4dnqSoyAdkuDGNrvVuUPlHtEeDmQxBUtXuaFkr/AUkrcTW32GruT7UIwruHR5KqvPGRHwl6ZM8Dbiti0yl3t3FGgmEuJPuiV+PLwx2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vGbZLCMH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vGbZLCMH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23F7C32781;
	Mon, 20 May 2024 00:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716164609;
	bh=wXZ/FLx8r1QvHgXury4BqP0fS4yA2h8sQiq5V3D0G/A=;
	h=Date:To:From:Subject:From;
	b=vGbZLCMHKK+6eW83LmXnw2DBTAlx1NHawm4NFG9x3HDZ0dXP33+Wnz/gwH/+/FAvx
	 orZ3bNxPfx4XK4MAuHUkP23su7F3Uv4D0iW6w8X3dW/NPsro2gjgGJPS0r9GWZgsi/
	 LXjjGXjmPPJpPG4PJSbsJDPObQdMRpak7CNWe89w=
Date: Sun, 19 May 2024 17:23:28 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-add-general-function-domain_dirty_avail-to-calculate-dirty-and-avail-of-domain.patch added to mm-unstable branch
Message-Id: <20240520002328.E23F7C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: writeback: add general function domain_dirty_avail to calculate dirty and avail of domain
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-add-general-function-domain_dirty_avail-to-calculate-dirty-and-avail-of-domain.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-add-general-function-domain_dirty_avail-to-calculate-dirty-and-avail-of-domain.patch

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
Subject: writeback: add general function domain_dirty_avail to calculate dirty and avail of domain
Date: Tue, 14 May 2024 20:52:48 +0800

Add general function domain_dirty_avail to calculate dirty and avail for
either dirty limit or background writeback in either global domain or wb
domain.

Link: https://lkml.kernel.org/r/20240514125254.142203-3-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   65 +++++++++++++++++++++---------------------
 1 file changed, 34 insertions(+), 31 deletions(-)

--- a/mm/page-writeback.c~writeback-add-general-function-domain_dirty_avail-to-calculate-dirty-and-avail-of-domain
+++ a/mm/page-writeback.c
@@ -837,6 +837,34 @@ static void mdtc_calc_avail(struct dirty
 	mdtc->avail = filepages + min(headroom, other_clean);
 }
 
+static inline bool dtc_is_global(struct dirty_throttle_control *dtc)
+{
+	return mdtc_gdtc(dtc) == NULL;
+}
+
+/*
+ * Dirty background will ignore pages being written as we're trying to
+ * decide whether to put more under writeback.
+ */
+static void domain_dirty_avail(struct dirty_throttle_control *dtc,
+			       bool include_writeback)
+{
+	if (dtc_is_global(dtc)) {
+		dtc->avail = global_dirtyable_memory();
+		dtc->dirty = global_node_page_state(NR_FILE_DIRTY);
+		if (include_writeback)
+			dtc->dirty += global_node_page_state(NR_WRITEBACK);
+	} else {
+		unsigned long filepages = 0, headroom = 0, writeback = 0;
+
+		mem_cgroup_wb_stats(dtc->wb, &filepages, &headroom, &dtc->dirty,
+				    &writeback);
+		if (include_writeback)
+			dtc->dirty += writeback;
+		mdtc_calc_avail(dtc, filepages, headroom);
+	}
+}
+
 /**
  * __wb_calc_thresh - @wb's share of dirty threshold
  * @dtc: dirty_throttle_context of interest
@@ -899,16 +927,9 @@ unsigned long cgwb_calc_thresh(struct bd
 {
 	struct dirty_throttle_control gdtc = { GDTC_INIT_NO_WB };
 	struct dirty_throttle_control mdtc = { MDTC_INIT(wb, &gdtc) };
-	unsigned long filepages = 0, headroom = 0, writeback = 0;
 
-	gdtc.avail = global_dirtyable_memory();
-	gdtc.dirty = global_node_page_state(NR_FILE_DIRTY) +
-		     global_node_page_state(NR_WRITEBACK);
-
-	mem_cgroup_wb_stats(wb, &filepages, &headroom,
-			    &mdtc.dirty, &writeback);
-	mdtc.dirty += writeback;
-	mdtc_calc_avail(&mdtc, filepages, headroom);
+	domain_dirty_avail(&gdtc, true);
+	domain_dirty_avail(&mdtc, true);
 	domain_dirty_limits(&mdtc);
 
 	return __wb_calc_thresh(&mdtc, mdtc.thresh);
@@ -1719,9 +1740,8 @@ static int balance_dirty_pages(struct bd
 		unsigned long m_bg_thresh = 0;
 
 		nr_dirty = global_node_page_state(NR_FILE_DIRTY);
-		gdtc->avail = global_dirtyable_memory();
-		gdtc->dirty = nr_dirty + global_node_page_state(NR_WRITEBACK);
 
+		domain_dirty_avail(gdtc, true);
 		domain_dirty_limits(gdtc);
 
 		if (unlikely(strictlimit)) {
@@ -1737,17 +1757,11 @@ static int balance_dirty_pages(struct bd
 		}
 
 		if (mdtc) {
-			unsigned long filepages, headroom, writeback;
-
 			/*
 			 * If @wb belongs to !root memcg, repeat the same
 			 * basic calculations for the memcg domain.
 			 */
-			mem_cgroup_wb_stats(wb, &filepages, &headroom,
-					    &mdtc->dirty, &writeback);
-			mdtc->dirty += writeback;
-			mdtc_calc_avail(mdtc, filepages, headroom);
-
+			domain_dirty_avail(mdtc, true);
 			domain_dirty_limits(mdtc);
 
 			if (unlikely(strictlimit)) {
@@ -2119,14 +2133,8 @@ bool wb_over_bg_thresh(struct bdi_writeb
 	struct dirty_throttle_control * const mdtc = mdtc_valid(&mdtc_stor) ?
 						     &mdtc_stor : NULL;
 
-	/*
-	 * Similar to balance_dirty_pages() but ignores pages being written
-	 * as we're trying to decide whether to put more under writeback.
-	 */
-	gdtc->avail = global_dirtyable_memory();
-	gdtc->dirty = global_node_page_state(NR_FILE_DIRTY);
+	domain_dirty_avail(gdtc, false);
 	domain_dirty_limits(gdtc);
-
 	if (gdtc->dirty > gdtc->bg_thresh)
 		return true;
 
@@ -2135,13 +2143,8 @@ bool wb_over_bg_thresh(struct bdi_writeb
 		return true;
 
 	if (mdtc) {
-		unsigned long filepages, headroom, writeback;
-
-		mem_cgroup_wb_stats(wb, &filepages, &headroom, &mdtc->dirty,
-				    &writeback);
-		mdtc_calc_avail(mdtc, filepages, headroom);
+		domain_dirty_avail(mdtc, false);
 		domain_dirty_limits(mdtc);	/* ditto, ignore writeback */
-
 		if (mdtc->dirty > mdtc->bg_thresh)
 			return true;
 
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

