Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FBB4071DE
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525473; cv=none; b=lImw3WLqQTvcRCM7SPfUxgrkFlSTP9oU19539pBGQHh8L0Eczbaq8xl2IlDDtrjoyKX4HaPUytm2JuiD6GVsZ32Wc9MEdS8tnW7On4YwgHjSXYzvbFXYDy4leJCV/kFc/+V17FDMloySmhC0iiaCMk5vAVPzHqey2bCJ8vK7soo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525473; c=relaxed/simple;
	bh=DNHeJYGbAxRe78T9yp+CIPlCjzTvYkpuGMmHJEno2Gk=;
	h=Date:To:From:Subject:Message-Id; b=prYBVQbs1QL2Bssis4w7kSnaP4VZ+oKOfjNujEnQDqToLrU9Ysn9D3AXvmIv/oBkvTsjKJMr+OC22CQU7vq/eqqBe3ovbbsC7IU+lFTpomR/9wClJ9GUo3LmsVkGeMWi/8uu51T6ETps5CATGOfAF9lAWJr8q0eR8Q1ZUvYOG9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nfoaduHa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nfoaduHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB1D1F000FF;
	Fri,  9 Oct 2026 05:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525471;
	bh=XD7zfu0t76t4Ly4bK6GgddhMqw9Uj4SVDx6w0Hm0oQ8=;
	h=Date:To:From:Subject;
	b=nfoaduHa+QdMSEZveeP8heAbzh0CxdJot37CQ6FyteYcE7mhHxG9oNL54zazex90j
	 +HDM4W8qAk+g7S4YtsRZYJJttIv9Q7B7lZaBJRsPmrLXNOE5KE35873u5TmtY+TeVD
	 WWK3ycxlJbZ5kKSCFnJ3FWO7AZy9Cw/AD89Va3Og=
Date: Thu, 08 Oct 2026 22:57:51 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,zhangbo56@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-avoid-anon-scanning-for-gfp_noio-with-low-swapcache.patch removed from -mm tree
Message-Id: <20261009055751.ACB1D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmscan: avoid anon scanning for GFP_NOIO with low swapcache
has been removed from the -mm tree.  Its filename was
     mm-vmscan-avoid-anon-scanning-for-gfp_noio-with-low-swapcache.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bo Zhang <zhangbo56@xiaomi.com>
Subject: mm: vmscan: avoid anon scanning for GFP_NOIO with low swapcache
Date: Tue, 8 Sep 2026 14:26:49 +0800

We have observed some cases where memory is allocated with GFP_NOIO, so we
cannot reclaim any anon folios unless they are in swapcache.  We can end
up spending more than 150 ms looping in `shrink_folio_list()` scanning
non-swapcache folios without reclaiming a single folio.  This is pure
overhead.

This is particularly true on systems using zRAM, where swapcache is
relatively rare.  So let's check whether anon reclaim is allowed by GFP_IO
and whether there is enough swapcache to make it worthwhile.  If the
swapcache is extremely low, we're essentially searching for a needle in a
haystack, so let's avoid scanning anon in the first place.

On Android this is triggered by dm-verity hash-block reads through
dm-bufio, which legitimately use GFP_NOIO because they run underneath the
IO path:

  verity_verify_io -> verity_hash_for_block -> verity_verify_level
    -> dm_bufio_read_with_ioprio -> new_read -> __bufio_new
      -> alloc_buffer
         gfp: GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN

Such a reclaimer can land on a memcg with a large, unswapped anon LRU and
a tiny file LRU (e.g.  inactive_anon ~335 MB vs inactive_file ~4 MB, with
negligible swapcache).  shrink_lruvec() then keeps feeding that huge anon
list into shrink_folio_list() - ~2400 shrink_folio_list() calls, ~93,000
anon folios scanned - where every folio is kept because it needs IO.  The
150+ ms above is one such single shrink_lruvec() pass (not accumulated
across a reclaim cycle), and it reclaims nothing; the actual progress
comes entirely from the file side.

Aging anon alongside file does have some value for a later __GFP_IO
reclaimer, so it is not strictly pure overhead.  But that aging is only
deferred, not lost: kswapd and other __GFP_IO reclaimers still walk and
age anon.  Spending ~168 ms aging memory that this context cannot reclaim
is not a worthwhile trade-off in a latency-sensitive path.

To stay conservative, this only skips anon when the swapcache is really
tiny - below 1/64 of the anon LRU - i.e.  when essentially no anon on the
list can be reclaimed without IO.  Whenever there is a meaningful amount
of swapcached anon, the normal path is used and anon is scanned and aged
as before.

Note this only addresses the traditional active/inactive LRU.  MGLRU
selects anon vs file scanning in its own path and is not covered here;
fixing the MGLRU case is left as a TODO.

Link: https://lore.kernel.org/20260908062649.1045883-1-zhangbo56@xiaomi.com
Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
---

 mm/vmscan.c |   62 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 57 insertions(+), 5 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-avoid-anon-scanning-for-gfp_noio-with-low-swapcache
+++ a/mm/vmscan.c
@@ -362,20 +362,72 @@ static bool can_demote(int nid, struct s
 	return !nodes_empty(allowed_mask);
 }
 
+#ifdef CONFIG_SWAP
+static inline bool reclaimable_anon_is_low(struct mem_cgroup *memcg,
+		int nid, struct scan_control *sc)
+{
+	pg_data_t *pgdat = NODE_DATA(nid);
+	unsigned long anon_pages, swapcache;
+
+	/*
+	 * A GFP_NOIO reclaimer can only reclaim anon that is already in the
+	 * swapcache (adding anon to the swapcache needs IO). When swapcache is
+	 * far below the anon LRU, scanning anon reclaims nothing and only burns
+	 * CPU. The 1/64 threshold keeps this to the case where anon is
+	 * effectively unreclaimable.
+	 */
+	if (!sc || (sc->gfp_mask & __GFP_IO))
+		return false;
+
+	/*
+	 * FIXME: MGLRU doesn't fully respect can_reclaim_anon_pages() for the
+	 * scanning type, so only apply this to the traditional LRU for now.
+	 */
+	if (lru_gen_enabled())
+		return false;
+
+	if (memcg) {
+		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
+
+		anon_pages = lruvec_page_state(lruvec, NR_INACTIVE_ANON) +
+			     lruvec_page_state(lruvec, NR_ACTIVE_ANON);
+		swapcache = lruvec_page_state(lruvec, NR_SWAPCACHE);
+	} else {
+		anon_pages = node_page_state(pgdat, NR_INACTIVE_ANON) +
+			     node_page_state(pgdat, NR_ACTIVE_ANON);
+		swapcache = node_page_state(pgdat, NR_SWAPCACHE);
+	}
+
+	return swapcache < (anon_pages >> 6);
+}
+#else
+static inline bool reclaimable_anon_is_low(struct mem_cgroup *memcg,
+		int nid, struct scan_control *sc)
+{
+	return true;
+}
+#endif /* CONFIG_SWAP */
+
 static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
 					  int nid,
 					  struct scan_control *sc)
 {
 	if (memcg == NULL) {
 		/*
-		 * For non-memcg reclaim, is there
-		 * space in any swap device?
+		 * For non-memcg reclaim, is there space in any swap device?
+		 * And under GFP_NOIO, is there enough swapcached anon to make
+		 * scanning anon worthwhile?
 		 */
-		if (get_nr_swap_pages() > 0)
+		if (get_nr_swap_pages() > 0 &&
+		    !reclaimable_anon_is_low(memcg, nid, sc))
 			return true;
 	} else {
-		/* Is the memcg below its swap limit? */
-		if (mem_cgroup_get_nr_swap_pages(memcg) > 0)
+		/*
+		 * Is the memcg below its swap limit, and under GFP_NOIO does
+		 * it have enough swapcached anon to make scanning worthwhile?
+		 */
+		if (mem_cgroup_get_nr_swap_pages(memcg) > 0 &&
+		    !reclaimable_anon_is_low(memcg, nid, sc))
 			return true;
 	}
 
_

Patches currently in -mm which might be from zhangbo56@xiaomi.com are


