Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536D814EC60
	for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2024 17:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714065921; cv=none; b=sEkohhYYsh0KmV4HB1Xay+BQf0tlauQrvVAJ2I0Y+BlzmM7jOGjhxwDWmDvMGduGzI7VF7vD6MY5Tuv/IHXjQXSfyZUDIJQ2dUq2ox8sa2QTTCsoU9Vgc/lTXcadYRAI17d7wicBTai/oZXu5lpsavTEmtObZESETXigEo/l15o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714065921; c=relaxed/simple;
	bh=YsW3pYXDjiujusu+p5LEoI+cwLyZCft0vEgSjz+zxPQ=;
	h=Date:To:From:Subject:Message-Id; b=hOrlCj3xaYFhZ8rRUL37JZwiuF6y1+x+qVugxWnbRVn4pUhlll7VmDAXFpGXn5BZc+GqSh4OJ7UuggYOPJgsufvnDvlP76sS7ZsLDsWRsCtxwlJKmHjTWQBe4AMzOpzpg1xjCy7hnSXKfENbDaWXWveuj0sRzazTpRXk0UP9Dd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G0MT4Kf4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G0MT4Kf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C92C113CC;
	Thu, 25 Apr 2024 17:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714065920;
	bh=YsW3pYXDjiujusu+p5LEoI+cwLyZCft0vEgSjz+zxPQ=;
	h=Date:To:From:Subject:From;
	b=G0MT4Kf4H0JnabMc/cPonnfo954wSb/wnhpFMDAyZ17Z7lAk5kkEp2QZ8RJzPYwqZ
	 BZHFbLuDu9kgD1gw9aewS17pPHnVeau4zgKXB5sjkRHunHSEa2D3J1Wn5ZRKIP/hdE
	 B0NWL8dmvhqhq0Tzn4h2HiH45LAmi9ad3/yHSt8s=
Date: Thu, 25 Apr 2024 10:25:20 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,mszeredi@redhat.com,jack@suse.cz,hcochran@kernelspring.com,axboe@kernel.dk,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-call-__wb_calc_thresh-instead-of-wb_calc_thresh-in-wb_over_bg_thresh.patch added to mm-unstable branch
Message-Id: <20240425172520.C3C92C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: call __wb_calc_thresh instead of wb_calc_thresh in wb_over_bg_thresh
has been added to the -mm mm-unstable branch.  Its filename is
     mm-call-__wb_calc_thresh-instead-of-wb_calc_thresh-in-wb_over_bg_thresh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-call-__wb_calc_thresh-instead-of-wb_calc_thresh-in-wb_over_bg_thresh.patch

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
Subject: mm: call __wb_calc_thresh instead of wb_calc_thresh in wb_over_bg_thresh
Date: Thu, 25 Apr 2024 21:17:23 +0800

Call __wb_calc_thresh to calculate wb bg_thresh of gdtc in
wb_over_bg_thresh to remove unnecessary wrap in wb_calc_thresh.

Link: https://lkml.kernel.org/r/20240425131724.36778-4-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Howard Cochran <hcochran@kernelspring.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page-writeback.c~mm-call-__wb_calc_thresh-instead-of-wb_calc_thresh-in-wb_over_bg_thresh
+++ a/mm/page-writeback.c
@@ -2117,7 +2117,7 @@ bool wb_over_bg_thresh(struct bdi_writeb
 	if (gdtc->dirty > gdtc->bg_thresh)
 		return true;
 
-	thresh = wb_calc_thresh(gdtc->wb, gdtc->bg_thresh);
+	thresh = __wb_calc_thresh(gdtc, gdtc->bg_thresh);
 	if (thresh < 2 * wb_stat_error())
 		reclaimable = wb_stat_sum(wb, WB_RECLAIMABLE);
 	else
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

writeback-collect-stats-of-all-wb-of-bdi-in-bdi_debug_stats_show.patch
writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi.patch
writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi-fix.patch
writeback-add-wb_monitorpy-script-to-monitor-writeback-info-on-bdi.patch
writeback-rename-nr_reclaimable-to-nr_dirty-in-balance_dirty_pages.patch
mm-enable-__wb_calc_thresh-to-calculate-dirty-background-threshold.patch
mm-correct-calculation-of-wbs-bg_thresh-in-cgroup-domain.patch
mm-call-__wb_calc_thresh-instead-of-wb_calc_thresh-in-wb_over_bg_thresh.patch
mm-remove-stale-comment-__folio_mark_dirty.patch

