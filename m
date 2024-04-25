Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD57E14EC73
	for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2024 17:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714065922; cv=none; b=sfDj7zj6v61YHwdpjspsgEr9qn/B7epyCBJRNxQjLivGN2x/USVn2UGTn7STB8z7BnUlP34pl1RlHR0rbTfOGhM4Vmar+QKr25eutB3oTpMy8LKyiBOq8KVsVkJeCOP+INtOn6XKbQs/5pDGFSXeOMrch9HgOxcYs8oA6canst0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714065922; c=relaxed/simple;
	bh=oHwQn6vLqeSFlDlNoVPwp/9AsQr4YTEF/vtd8MxVhx0=;
	h=Date:To:From:Subject:Message-Id; b=QHDyj943qddtBQr1xfsN/+H0iUUvT+RD1qVjjS7S/yQnla7XmleabSkeTYMIdtO0E9YMEUA99vSfEGt3+BT/j3DYX6jeIVuoLMmJwFrdsn/6iN7awQincGS8X9qOG0X0TuUumqD8rX2OKfCeFErRPy23Z+4br7WwXI5ZvX1rhCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z1A78grR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z1A78grR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79DDC2BD10;
	Thu, 25 Apr 2024 17:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714065922;
	bh=oHwQn6vLqeSFlDlNoVPwp/9AsQr4YTEF/vtd8MxVhx0=;
	h=Date:To:From:Subject:From;
	b=Z1A78grRndR0Ntv2ctr5zTUd0433m5qZUg7u91+1sHeyTsoAfgyZ+wZa5UJY6nSi1
	 V6aljfHL5jntdw64N45GimYQkh61HYeLh/A7+n3lm82NTOaVPIwiL7oGa9ExznlAAx
	 nxFLy6zyhjpNc0xXqRFqBXi360/exgSj5NYJZ4+A=
Date: Thu, 25 Apr 2024 10:25:22 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,mszeredi@redhat.com,jack@suse.cz,hcochran@kernelspring.com,axboe@kernel.dk,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-stale-comment-__folio_mark_dirty.patch added to mm-unstable branch
Message-Id: <20240425172522.A79DDC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove stale comment __folio_mark_dirty
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-stale-comment-__folio_mark_dirty.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-stale-comment-__folio_mark_dirty.patch

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
Subject: mm: remove stale comment __folio_mark_dirty
Date: Thu, 25 Apr 2024 21:17:24 +0800

The __folio_mark_dirty will not mark inode dirty any longer.  Remove the
stale comment of it.

Link: https://lkml.kernel.org/r/20240425131724.36778-5-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Howard Cochran <hcochran@kernelspring.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/page-writeback.c~mm-remove-stale-comment-__folio_mark_dirty
+++ a/mm/page-writeback.c
@@ -2721,8 +2721,7 @@ void folio_account_cleaned(struct folio
 }
 
 /*
- * Mark the folio dirty, and set it dirty in the page cache, and mark
- * the inode dirty.
+ * Mark the folio dirty, and set it dirty in the page cache.
  *
  * If warn is true, then emit a warning if the folio is not uptodate and has
  * not been truncated.
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

