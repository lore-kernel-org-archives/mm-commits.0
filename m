Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1EB4A5C3F
	for <mm-commits@vger.kernel.org>; Wed, 16 Sep 2026 22:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789597759; cv=none; b=R4eLIBQih8+LizC+IRbdPBaZ04w1gIGoSGRRdOqvuHUDF/ZkI8LZ/LMxjfQpYC4j2wBA/9gDWrbTko1fYcPf1PBlQNdeU9V2bseFzK9hUx3nS81+7zx1rJCgTsllY5fJcZ4G2bYtznZ961iW/HUJ9vJGcCN34RCRIlYK5A67TOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789597759; c=relaxed/simple;
	bh=D2s9WVviLlP4wVGRKezV1g65qtkNIbOaf+Um0uKXYW0=;
	h=Date:To:From:Subject:Message-Id; b=ezoWTjPcPjb0iRGjkYeKkSZJw1ZJrULWDGz3Tr13BeDhqaNBzwVCfFTPmvP6IFfR7eIm4dbajm1U06bTIQZ3JyipqAUz6sM/y1qDzLjOf4pLvY+Z1668Vs+0tsFSxxoWQgu9cOOg8pJdLQrLSA6LhoBRc/GVzrMpd39U7/8Y3rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ANbYaJl5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ANbYaJl5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2411F000FF;
	Wed, 16 Sep 2026 22:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789597752;
	bh=Ut3TcV5Ek3zRBBtrnBHrGMIRXPEzFCY4+/TZRpHtIII=;
	h=Date:To:From:Subject;
	b=ANbYaJl5bSJdQ5//HmmUmsWpN+3bTNeWYq8TJhiErHM1bEuYZ8WS45vOuQWolROLg
	 3awcneGeCZM8WID8rQKkfUsl1O9/8sSRfsuJBsjzuiKqmp6efrCgtv/wV9FYXQx//H
	 H+tc48CnaWgPPKdOsoykMvG27UlSsxLBjR2olJrs=
Date: Wed, 16 Sep 2026 15:29:11 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,riel@surriel.com,muchun.song@linux.dev,mhocko@kernel.org,jack@suse.cz,hannes@cmpxchg.org,david@kernel.org,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] mm-filemap-move-lruvec-accounting-outside-the-xarray-lock-v5.patch removed from -mm tree
Message-Id: <20260916222912.3E2411F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: filemap: move lruvec accounting outside the xarray lock
has been removed from the -mm tree.  Its filename was
     mm-filemap-move-lruvec-accounting-outside-the-xarray-lock-v5.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Usama Arif <usama.arif@linux.dev>
Subject: mm: filemap: move lruvec accounting outside the xarray lock
Date: Wed, 16 Sep 2026 05:51:22 -0700

__filemap_add_folio() inserts a folio and updates mapping->nrpages while
holding mapping->i_pages.xa_lock with interrupts disabled.  The XArray
insertion and nrpages update require the lock, but the lruvec statistic
updates do not.  With CONFIG_MEMCG, those calls also update per-CPU memcg
and lruvec counters and notify cgroup rstat, extending the critical
section.

Move the lruvec accounting after a successful XArray insertion and after
xas_unlock_irq().  The page-cache references pin the folio, while the
folio lock keeps folio->mapping stable and prevents removal until
accounting is complete.  This moves one lruvec update for ordinary folios
and a second for PMD-mappable folios out of the serialized section.

In a 30-second system-wide perf lock contention -ab capture on a
production host, the hottest caller-stack record attributed to
__filemap_add_folio() had 20,867 contentions and 557.930 ms total wait. 
That was 14% of the 3.998 seconds of aggregate lock wait in the capture. 
Moving lruvec accuting outside of critical section should help optimize
it.

Link: https://lore.kernel.org/20260916125122.2696271-1-usama.arif@linux.dev
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
---

 mm/filemap.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/mm/filemap.c~mm-filemap-move-lruvec-accounting-outside-the-xarray-lock-v5
+++ a/mm/filemap.c
@@ -918,14 +918,6 @@ noinline int __filemap_add_folio(struct
 
 		mapping->nrpages += nr;
 
-		/* hugetlb pages do not participate in page cache accounting */
-		if (!huge) {
-			lruvec_stat_mod_folio(folio, NR_FILE_PAGES, nr);
-			if (folio_test_pmd_mappable(folio))
-				lruvec_stat_mod_folio(folio,
-						NR_FILE_THPS, nr);
-		}
-
 unlock:
 		xas_unlock_irq(&xas);
 
@@ -942,6 +934,13 @@ unlock:
 	if (xas_error(&xas))
 		goto error;
 
+	/* hugetlb pages do not participate in page cache accounting */
+	if (!huge) {
+		lruvec_stat_mod_folio(folio, NR_FILE_PAGES, nr);
+		if (folio_test_pmd_mappable(folio))
+			lruvec_stat_mod_folio(folio, NR_FILE_THPS, nr);
+	}
+
 	trace_mm_filemap_add_to_page_cache(folio);
 	return 0;
 error:
_

Patches currently in -mm which might be from usama.arif@linux.dev are

mm-zswap-dont-fail-a-large-folio-swapin-whose-range-is-not-in-zswap.patch

