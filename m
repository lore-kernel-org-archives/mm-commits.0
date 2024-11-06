Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E036B18785C
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854878; cv=none; b=KqNGDFqYpNUEHhG8U0Se7p2cmxydIWlF9sFa29WAo7zwtfVnfzNmPitnGy92qibLEZQ9tl38KLT406hsV73i0IiEZUAPgKgHvj5tiUOrkUr/+vsUYoF3wW9dabCDwzInH0JXGTpsx8fJKIkpPGs1VI2JX0sgeMn2wGS1FuhTOyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854878; c=relaxed/simple;
	bh=rWCHmKmLNu7DI2GKm95/soVYecjrhwPctkdSH3nsu5Q=;
	h=Date:To:From:Subject:Message-Id; b=S6Ur/fNSc7bssaJhTut1O9HOcUZaixi5r4LDx1MJy8/SvgF2IkAXkWi2/b0AyDTaP7Rhrv8NudlSP7g+FmeBWz9xzZA0TziKY1x+LuvvONIC3UMzyk+1dsViVnFcHjP17ATVirflW773ysypIIJDw6KYfIHoMgYfSGxjZceVaYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xjzLATJ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xjzLATJ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6406C4CECF;
	Wed,  6 Nov 2024 01:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854877;
	bh=rWCHmKmLNu7DI2GKm95/soVYecjrhwPctkdSH3nsu5Q=;
	h=Date:To:From:Subject:From;
	b=xjzLATJ7Hy7nVUTWdHamJB1SEdlw6um16wm4Po7eVGZMVu18KyhLss49RvQllu/h5
	 RgtZPuVi08cKseqLFoHj2/qaWcgNd+dce+fc5DZn8HZnoMSh7rdmxHZSgEsSkYQyFN
	 BA1SEtnyBPLOX1a7FnintsoSL2IHxxjqNBdgMyjQ=
Date: Tue, 05 Nov 2024 17:01:17 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hughd@google.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-v1-no-need-for-memcg-locking-for-writeback-tracking.patch removed from -mm tree
Message-Id: <20241106010117.B6406C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg-v1: no need for memcg locking for writeback tracking
has been removed from the -mm tree.  Its filename was
     memcg-v1-no-need-for-memcg-locking-for-writeback-tracking.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg-v1: no need for memcg locking for writeback tracking
Date: Thu, 24 Oct 2024 18:23:01 -0700

During the era of memcg charge migration, the kernel has to be make
sure that the writeback stat updates do not race with the charge
migration.  Otherwise it might update the writeback stats of the wrong
memcg.  Now with the memcg charge migration gone, there is no more race
for writeback stat updates and the previous locking can be removed.

Link: https://lkml.kernel.org/r/20241025012304.2473312-5-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/page-writeback.c~memcg-v1-no-need-for-memcg-locking-for-writeback-tracking
+++ a/mm/page-writeback.c
@@ -3083,7 +3083,6 @@ bool __folio_end_writeback(struct folio
 	struct address_space *mapping = folio_mapping(folio);
 	bool ret;
 
-	folio_memcg_lock(folio);
 	if (mapping && mapping_use_writeback_tags(mapping)) {
 		struct inode *inode = mapping->host;
 		struct backing_dev_info *bdi = inode_to_bdi(inode);
@@ -3114,7 +3113,6 @@ bool __folio_end_writeback(struct folio
 	lruvec_stat_mod_folio(folio, NR_WRITEBACK, -nr);
 	zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
 	node_stat_mod_folio(folio, NR_WRITTEN, nr);
-	folio_memcg_unlock(folio);
 
 	return ret;
 }
@@ -3127,7 +3125,6 @@ void __folio_start_writeback(struct foli
 
 	VM_BUG_ON_FOLIO(folio_test_writeback(folio), folio);
 
-	folio_memcg_lock(folio);
 	if (mapping && mapping_use_writeback_tags(mapping)) {
 		XA_STATE(xas, &mapping->i_pages, folio_index(folio));
 		struct inode *inode = mapping->host;
@@ -3168,7 +3165,6 @@ void __folio_start_writeback(struct foli
 
 	lruvec_stat_mod_folio(folio, NR_WRITEBACK, nr);
 	zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr);
-	folio_memcg_unlock(folio);
 
 	access_ret = arch_make_folio_accessible(folio);
 	/*
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


