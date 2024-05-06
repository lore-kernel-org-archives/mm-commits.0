Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C6628EB
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714956383; cv=none; b=A+pdPvqWJWHhtLNF2b6GXO15pZJvD9KDlgJluAESDOSjaRF2kyzb2wwCrEMClZfpTIkg1WVQ5D26AJ0jA9bcCUHoNNdqZYPUCuiJthcjHjhwkGYRm6mh9PA76+1OyY3kqBjTiCdCaAHbizO2dRBPmYpFSIh2giG9CHxIS4tqhHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714956383; c=relaxed/simple;
	bh=KMnnHaaUnZVhXDifawJ6qV9aaGRA2RtTJ3lbp1zlrec=;
	h=Date:To:From:Subject:Message-Id; b=N0Z3f2Z/MHi5Pkh0Bv6b3TDHg5oZKOo4mk1LUZxsVCBMUSgXsJHVVjMKrbDAwAomONNG3MFzauaWYtcZ8jImli/OlTniWCHcU7S3lwjrXxh9JtIrDaBx/cZpXjOaiJlITzvoozp2mFtCEbQMQkM8OxcgV/k+c9ee9o70ZuNSd78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oPZ4C5Se; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oPZ4C5Se"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B870FC113CC;
	Mon,  6 May 2024 00:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714956382;
	bh=KMnnHaaUnZVhXDifawJ6qV9aaGRA2RtTJ3lbp1zlrec=;
	h=Date:To:From:Subject:From;
	b=oPZ4C5SeYRew8DeRLrQ9bmd3pTobdwzkciBTP1+0HgfEbXLsY2HRfWoQF4NkSzGqo
	 CIIbigMVdyAOWaT2jH/JdqIQY8WX5mN6CJgqYPdOEv0NFvPcpr4gT/FZc/9C+TRMHu
	 s46M63mNbth0y/+Zvqc8J577CJ7TeJgHPPGAIHo0=
Date: Sun, 05 May 2024 17:46:22 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,sj@kernel.org,sfr@canb.auug.org.au,mjguzik@gmail.com,jack@suse.cz,dsterba@suse.com,dhowells@redhat.com,bfoster@redhat.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi-fix.patch removed from -mm tree
Message-Id: <20240506004622.B870FC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: writeback: fix build problems of "writeback: support retrieving per group debug writeback stats of bdi"
has been removed from the -mm tree.  Its filename was
     writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi-fix.patch

This patch was dropped because it was folded into writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi.patch

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: writeback: fix build problems of "writeback: support retrieving per group debug writeback stats of bdi"
Date: Tue, 23 Apr 2024 11:46:41 +0800

Fix two build problems:
1. implicit declaration of function 'cgroup_ino'.
2. unused variable 'stats'.

After this fix, No build problem is found when CGROUPS is disabled.
The wb_stats could be successfully retrieved when CGROUP_WRITEBACK is
disabled:
cat wb_stats
WbCgIno:                    1
WbWriteback:                0 kB
WbReclaimable:         685440 kB
WbDirtyThresh:      195530960 kB
WbDirtied:             691488 kB
WbWritten:               6048 kB
WbWriteBandwidth:      102400 kBps
b_dirty:                    2
b_io:                       0
b_more_io:                  0
b_dirty_time:               0
state:                      5

cat wb_stats
WbCgIno:                    1
WbWriteback:                0 kB
WbReclaimable:         818944 kB
WbDirtyThresh:      195527484 kB
WbDirtied:             824992 kB
WbWritten:               6048 kB
WbWriteBandwidth:      102400 kBps
b_dirty:                    2
b_io:                       0
b_more_io:                  0
b_dirty_time:               0
state:                      5

Link: https://lkml.kernel.org/r/20240423034643.141219-4-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reported-by: SeongJae Park <sj@kernel.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au> 
Cc: Brian Foster <bfoster@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/backing-dev.c~writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi-fix
+++ a/mm/backing-dev.c
@@ -172,7 +172,11 @@ static void wb_stats_show(struct seq_fil
 		   "b_more_io:         %10lu\n"
 		   "b_dirty_time:      %10lu\n"
 		   "state:             %10lx\n\n",
+#ifdef CONFIG_CGROUP_WRITEBACK
 		   cgroup_ino(wb->memcg_css->cgroup),
+#else
+		   1ul,
+#endif
 		   K(stats->nr_writeback),
 		   K(stats->nr_reclaimable),
 		   K(stats->wb_thresh),
@@ -192,7 +196,6 @@ static int cgwb_debug_stats_show(struct
 	unsigned long background_thresh;
 	unsigned long dirty_thresh;
 	struct bdi_writeback *wb;
-	struct wb_stats stats;
 
 	global_dirty_limits(&background_thresh, &dirty_thresh);
 
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

writeback-collect-stats-of-all-wb-of-bdi-in-bdi_debug_stats_show.patch
writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi.patch
writeback-add-wb_monitorpy-script-to-monitor-writeback-info-on-bdi.patch
writeback-rename-nr_reclaimable-to-nr_dirty-in-balance_dirty_pages.patch
mm-enable-__wb_calc_thresh-to-calculate-dirty-background-threshold.patch
mm-correct-calculation-of-wbs-bg_thresh-in-cgroup-domain.patch
mm-call-__wb_calc_thresh-instead-of-wb_calc_thresh-in-wb_over_bg_thresh.patch
mm-remove-stale-comment-__folio_mark_dirty.patch

