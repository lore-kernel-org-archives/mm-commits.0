Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B000155352
	for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2024 19:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713814752; cv=none; b=hdWLVTe4YaQWCvOPQOxt+bX/m4y4HLKA51M6jE5zYHe5HslsIU+cVhLYk0Fl/b7ENBfBK5effcAafbPoWfdPmbElXKftYGmmtABv99bN5vf5KbhpDXGqOTlFVTF25GoXi/B2nS4j6/jS3wrqD2YcTxQhB1rgMCduY1eELy9lj4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713814752; c=relaxed/simple;
	bh=/Jp+I9OIUSpPqQh+6maA28/bmhNddZjsivdbg11tUHA=;
	h=Date:To:From:Subject:Message-Id; b=bLd048Rlo8sBpNiCqfJClzz/GOzfrvB/AEtHLFPSWtrbwCB+wYEHRLTmQUS4SH9IkVf5Z12VNpiurwpt3wRp8Jg3tjkuajSfe/8VktjTUlbFYdGqlyTLTh8Ljm0ASI2gJeLKhjLctUQGj94E7+Alb4AyfhHc8zO4F50jtzDCwtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oAJdzjBq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oAJdzjBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0258EC113CC;
	Mon, 22 Apr 2024 19:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713814752;
	bh=/Jp+I9OIUSpPqQh+6maA28/bmhNddZjsivdbg11tUHA=;
	h=Date:To:From:Subject:From;
	b=oAJdzjBqXbWjaIQG/pWUINIJl0N+y7Th4Kf6Mzyoeoue518i0ki2g0zr9yWuSrM9J
	 XuY9nhQspdE8s0Iw9Rf4oFrksmeLovrWD8L/OTp3UG1JT4tr4DalI80KoX9yMqcxvj
	 wxDpZTbzNGlRj1zTkWmOulLoZe+OCi1NO5253WtA=
Date: Mon, 22 Apr 2024 12:39:11 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,mjguzik@gmail.com,jack@suse.cz,dsterba@suse.com,dhowells@redhat.com,bfoster@redhat.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-rename-nr_reclaimable-to-nr_dirty-in-balance_dirty_pages.patch added to mm-unstable branch
Message-Id: <20240422193912.0258EC113CC@smtp.kernel.org>
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
Date: Tue, 23 Apr 2024 00:48:08 +0800

Commit 8d92890bd6b85 ("mm/writeback: discard NR_UNSTABLE_NFS, use
NR_WRITEBACK instead") removed NR_UNSTABLE_NFS and nr_reclaimable only
contains dirty page now.  Rename nr_reclaimable to nr_dirty properly.

Link: https://lkml.kernel.org/r/20240422164808.13627-5-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Brian Foster <bfoster@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
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
writeback-add-wb_monitorpy-script-to-monitor-writeback-info-on-bdi.patch
writeback-rename-nr_reclaimable-to-nr_dirty-in-balance_dirty_pages.patch

