Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB804AC149
	for <mm-commits@vger.kernel.org>; Wed, 16 Sep 2026 22:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789597904; cv=none; b=ZkC9gjeZIYXDsSWuJ5Rqcz/khwfjpLMKjc4QZ4qXimpalAX3v23bw+oBKplycM+HMx9ey2Wvqddh86atz2k5nS5lk3921oMIi2VPAlQWLhrBqyMYfggF5hyCCflPMbK8+aMgbD6d3+lmFKjr//pTnDZxQfaYXD6/jYOsoeHCqUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789597904; c=relaxed/simple;
	bh=Wqcm6hW5PVGFJx9FH/Kr9GggmrRep/YnPiXj4q2yhBs=;
	h=Date:To:From:Subject:Message-Id; b=is5kNZBeiD6d8jfIPkH64ZBmS8FZHz6NeFlb62OVlnVluxi4s4XdNcXqNMMh4s0rNRbOctAUiEkY2pzxWEcT1IkClvt7VLn79ppcplv33V7IBiSh79oE6LdIK9/26HRtp3oci3y49Q4M/7hrWwYoZ8dIVP84JgCWMOd9CLFlBII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xrZkxMEu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xrZkxMEu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028621F000FF;
	Wed, 16 Sep 2026 22:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789597894;
	bh=YHVPRLNFDkJ/ggkmyLEPK/5ONRmgH7mpqI+pL7YvSEU=;
	h=Date:To:From:Subject;
	b=xrZkxMEudRp499NsIq7zsrWF5gtv5iFq0asrTqOrP4oBTIGCAyVhw81b/avJmE6n3
	 Kgj5L8wro14dmhLoXtF1aYcHMizg7GtwT9vYVd3GdG3+rRtVjdkgBKb5hEh8vWM5Lb
	 lnkC35H75Zi5At+F53hJPB9CE49zKJuWsL9pWYuE=
Date: Wed, 16 Sep 2026 15:31:33 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,riel@surriel.com,muchun.song@linux.dev,mhocko@kernel.org,jack@suse.cz,hannes@cmpxchg.org,david@kernel.org,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-move-lruvec-accounting-outside-the-xarray-lock.patch added to mm-new branch
Message-Id: <20260916223134.028621F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: filemap: move lruvec accounting outside the xarray lock
has been added to the -mm mm-new branch.  Its filename is
     mm-filemap-move-lruvec-accounting-outside-the-xarray-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-move-lruvec-accounting-outside-the-xarray-lock.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

--- a/mm/filemap.c~mm-filemap-move-lruvec-accounting-outside-the-xarray-lock
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
mm-filemap-move-lruvec-accounting-outside-the-xarray-lock.patch

