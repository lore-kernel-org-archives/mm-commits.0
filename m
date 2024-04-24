Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAF515ECC7
	for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2024 22:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713996552; cv=none; b=haE5ad6Dfx4jjNmOJQfS2mRJyn9E1rl9AWLu3zG7oZewv9GCVPT2Dl7wjnjMMiaq91AdBIkltv32iltRSxMM4ewIdxMIj9Y2Wpcx+k0FO3P5ZNi5Q+HncA/cmcJzFzIYBgA7RSR8P5nIQWfIqcKO4lLKfhUoZSFAhffVMHJU4X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713996552; c=relaxed/simple;
	bh=IxgzrEDsyBxjMhsdOQMKlbn0sR6dLOcjRXLiqzEFqCs=;
	h=Date:To:From:Subject:Message-Id; b=cURCrAII1gH5VLBFezhJbwehaXPWD4vMakwiWpFRDcKxg2IwHyA26WXbnq/uMAVvjqPEtVp3cOyz7Os+mL1NEUbP8CjDLnzJhgmkT2Kh4atTpP5ZpZa9CIXb29GKu90UvfvU6xwRl5yel2eGliM1NPFgagLSItzl/cjDhRbCwks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eNM7+VcW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eNM7+VcW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEBDBC113CD;
	Wed, 24 Apr 2024 22:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713996551;
	bh=IxgzrEDsyBxjMhsdOQMKlbn0sR6dLOcjRXLiqzEFqCs=;
	h=Date:To:From:Subject:From;
	b=eNM7+VcWj26oHwzEys0RvIzl9qu00r1QKCluixnWC/f2ILmC5cZIyXKXC1njxbELt
	 qngsdovPrnPH02pfH30e6oXaMmCD8h3Ab8DxLf4nrwp8LZPDAPK7uuwx7PmiMbwrZr
	 GtuxoqLwDRvsDUH77gYXr3YJq6Zfulo0m5oLfqy8=
Date: Wed, 24 Apr 2024 15:09:11 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,sj@kernel.org,sfr@canb.auug.org.au,mjguzik@gmail.com,jack@suse.cz,dsterba@suse.com,dhowells@redhat.com,bfoster@redhat.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-rename-nr_reclaimable-to-nr_dirty-in-balance_dirty_pages.patch added to mm-unstable branch
Message-Id: <20240424220911.BEBDBC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: writeback: rename nr_reclaimable to nr_dirty in balance_dirty_pages
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-rename-nr_reclaimable-to-nr_dirty-in-balance_dirty_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-rename-nr_reclaimable-to-nr_dirty-in-balance_dirty_pages.patch

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
Subject: writeback: rename nr_reclaimable to nr_dirty in balance_dirty_pages
Date: Tue, 23 Apr 2024 11:46:43 +0800

Commit 8d92890bd6b85 ("mm/writeback: discard NR_UNSTABLE_NFS, use
NR_WRITEBACK instead") removed NR_UNSTABLE_NFS and nr_reclaimable only
contains dirty page now.  Rename nr_reclaimable to nr_dirty properly.

Link: https://lkml.kernel.org/r/20240423034643.141219-6-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Brian Foster <bfoster@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/page-writeback.c~writeback-rename-nr_reclaimable-to-nr_dirty-in-balance_dirty_pages
+++ a/mm/page-writeback.c
@@ -1694,7 +1694,7 @@ static int balance_dirty_pages(struct bd
 	struct dirty_throttle_control * const mdtc = mdtc_valid(&mdtc_stor) ?
 						     &mdtc_stor : NULL;
 	struct dirty_throttle_control *sdtc;
-	unsigned long nr_reclaimable;	/* = file_dirty */
+	unsigned long nr_dirty;
 	long period;
 	long pause;
 	long max_pause;
@@ -1715,9 +1715,9 @@ static int balance_dirty_pages(struct bd
 		unsigned long m_thresh = 0;
 		unsigned long m_bg_thresh = 0;
 
-		nr_reclaimable = global_node_page_state(NR_FILE_DIRTY);
+		nr_dirty = global_node_page_state(NR_FILE_DIRTY);
 		gdtc->avail = global_dirtyable_memory();
-		gdtc->dirty = nr_reclaimable + global_node_page_state(NR_WRITEBACK);
+		gdtc->dirty = nr_dirty + global_node_page_state(NR_WRITEBACK);
 
 		domain_dirty_limits(gdtc);
 
@@ -1768,7 +1768,7 @@ static int balance_dirty_pages(struct bd
 		 * In normal mode, we start background writeout at the lower
 		 * background_thresh, to keep the amount of dirty memory low.
 		 */
-		if (!laptop_mode && nr_reclaimable > gdtc->bg_thresh &&
+		if (!laptop_mode && nr_dirty > gdtc->bg_thresh &&
 		    !writeback_in_progress(wb))
 			wb_start_background_writeback(wb);
 
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

writeback-collect-stats-of-all-wb-of-bdi-in-bdi_debug_stats_show.patch
writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi.patch
writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi-fix.patch
writeback-add-wb_monitorpy-script-to-monitor-writeback-info-on-bdi.patch
writeback-rename-nr_reclaimable-to-nr_dirty-in-balance_dirty_pages.patch

