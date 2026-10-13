Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FE63019C8
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865959; cv=none; b=L4O4FDyhkhKCeVXHqGRRlzO9iq5NNZYStqoB9+FWqUdqV5s4QxxnTxHWNagr1LhM+BByl8DD1TMFXjy2YZhVJ4hIS6yWIevefR4D6epzVJzBp8mUHSEEN/jG20+e0ee+dhRnXh7IaQmBBWdcHrJ9SdQgB79qBGRXt/aCquXdr70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865959; c=relaxed/simple;
	bh=ElD/MpJAmruxn7uzH88cFvYzF49pCPyAaYt+X6bt/J4=;
	h=Date:To:From:Subject:Message-Id; b=qyZtVFNQk2WEaPc6jk0Nbljs57mq76vaMud6RWENsM3KV6kPVgLKbpF4RPx0ebsKtI1MKaLzx9x4X98SOzfUreVAKhMx5d4DOCqddF+bIQ2vBHe1dFnbvITU/T0JwLq0Qd9xDY51z2RMDywJpdnl4i+wgRLOKF1WZ8CErzBL+v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e8XjDuKx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e8XjDuKx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 885181F00893;
	Tue, 13 Oct 2026 04:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865958;
	bh=4BwPynG8yfIqL6LRvbpqrrr5Tdj2SRJGlKy22wUIctw=;
	h=Date:To:From:Subject;
	b=e8XjDuKxksgoQRYo67qsW7aWsECoAToC151B66tNyy7JojDDdYgWR9Yw6b5TH06uA
	 lO0eySVhQ/Ua+7tV9tSRnpndOIm83IOIlsTOiWW+feifqsIyen1KxpJa93sK3Xl/Yl
	 tgRGwYNFPkVbwGNa2SEjlotnjae36dCg1/kFkvpQ=
Date: Mon, 12 Oct 2026 21:32:38 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,riel@surriel.com,muchun.song@linux.dev,mhocko@kernel.org,jack@suse.cz,hannes@cmpxchg.org,david@kernel.org,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-filemap-move-lruvec-accounting-outside-the-xarray-lock.patch removed from -mm tree
Message-Id: <20261013043238.885181F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: filemap: move lruvec accounting outside the xarray lock
has been removed from the -mm tree.  Its filename was
     mm-filemap-move-lruvec-accounting-outside-the-xarray-lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Vishal Moola (Fractile) <vishal.moola@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
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

mm-remove-the-unused-zone-unaccepted_cleanup.patch
mm-zswap-use-separate-compression-and-decompression-requests.patch
mm-zswap-use-stack-requests-for-synchronous-decompression.patch

