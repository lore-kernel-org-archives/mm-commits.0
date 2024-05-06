Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E164036B01
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957118; cv=none; b=XhzbtD72ECxg3ADC2Com/BdF7hEwSqTRG/NzgzluyNivn7jizenMF92SCDorPuBQirHoWQXNubi2KislDJ7sUwk8L31wYPgOBbWxjrhRb9daT+552e0QTyMsyWwfhb4ePnWjuCa16YmJ2g6aIrlx9imou2X0LuKstc/TSieY4wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957118; c=relaxed/simple;
	bh=4IAyhp/mc83sD6tEuepUipeanlsx9qdj7HfG+1K9TTE=;
	h=Date:To:From:Subject:Message-Id; b=EMRA5i76ufkEEc9kVv25GQq2YzjcLn/drsoxS5qUhtu4JQOvUb7qJvdyR/jzX/Xfsw1UWn6VHn6krN04qCvwDyntuZ8dZ0juSaoN2j92gtk7RQq0rvpCYyETAqLZxkSUuK+YH/d6OZGKVjSE1p1Mp3cNc3xzhr2jekzfg92XMOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hWuDZLaj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hWuDZLaj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B79DDC116B1;
	Mon,  6 May 2024 00:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957117;
	bh=4IAyhp/mc83sD6tEuepUipeanlsx9qdj7HfG+1K9TTE=;
	h=Date:To:From:Subject:From;
	b=hWuDZLajhUG5WnmcMenpiC+HQXZSaGM3qJExXfm1ZUuIUgKnWa7fWI1yjtbsKnPPW
	 xjLNBrTEhJzwdCaU52JnpYd+H5Jtf8Tc+oP5SFm5WIjpXE2vjENySEGpPPz0klqnao
	 Pvpokonmetn51LP0k+oKAghc36ayYiW90LqR2hlI=
Date: Sun, 05 May 2024 17:58:37 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,sj@kernel.org,sfr@canb.auug.org.au,mjguzik@gmail.com,jack@suse.cz,dsterba@suse.com,dhowells@redhat.com,bfoster@redhat.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] writeback-rename-nr_reclaimable-to-nr_dirty-in-balance_dirty_pages.patch removed from -mm tree
Message-Id: <20240506005837.B79DDC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: writeback: rename nr_reclaimable to nr_dirty in balance_dirty_pages
has been removed from the -mm tree.  Its filename was
     writeback-rename-nr_reclaimable-to-nr_dirty-in-balance_dirty_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


