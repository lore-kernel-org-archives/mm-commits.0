Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FF3235358
	for <mm-commits@vger.kernel.org>; Wed,  9 Sep 2026 01:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788917291; cv=none; b=loSBrUGCJbA4wDELsNthY5lvc0U99mDQoMJsfM6lX06xutlidzpHkcOcRjn3j9x4pGz/6uLKa5YfT/C5By6RJma7OUvPBPC9UKhuY0wJePn2KF3JFdxMSj2nNpPhr4Rra820hYH8p8IXd681/JgyEs1Wyduhlsq7JphQ9jXJIXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788917291; c=relaxed/simple;
	bh=2h2KQE8kwt0RHTFoDKWTlG19C9KBucziKZVl/JZRz/o=;
	h=Date:To:From:Subject:Message-Id; b=fS+yKiF4MkMeNg7yTnZzMumXzU3fvLokEH52gceAd+noVmRrau8ZZqL0WqNJTAXAeEp6tS2uET/l5KKwvY8enl6T5WUe4UNPlGJ8keH2UvavGKLExciFXLOSuO6RV4QqOFLX3AUPDlGM94JGN+9U6h2FXjYYvTMUHEJ2e2XB+l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=azUy51Ay; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="azUy51Ay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336211F00A3A;
	Wed,  9 Sep 2026 01:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788917289;
	bh=h41HCiv9yVeJenhxcY+JO+riiMlSdEqnTFrShd3R4v0=;
	h=Date:To:From:Subject;
	b=azUy51Ay5z5aggod1L0BRbw5VuFVRy3m7giEFhRcxjn2b08k2nILTEbVrV3dZQomz
	 wE27RDR8n3IlAyx/LDaQ7vsOW5M855Cvj40xIu905cnVAITWcP6TAzY+Ms9QoV/JAX
	 vaR6hA1xp7I0huPHqnvfgFglxfO4LHBhzqSpKhww=
Date: Tue, 08 Sep 2026 18:28:08 -0700
To: mm-commits@vger.kernel.org,zhangbo56@xiaomi.com,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,zhangbo0325@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-avoid-anon-scanning-for-gfp_noio-with-low-swapcache.patch added to mm-new branch
Message-Id: <20260909012809.336211F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan: avoid anon scanning for GFP_NOIO with low swapcache
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-avoid-anon-scanning-for-gfp_noio-with-low-swapcache.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-avoid-anon-scanning-for-gfp_noio-with-low-swapcache.patch

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
From: Bo Zhang <zhangbo0325@gmail.com>
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
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

Patches currently in -mm which might be from zhangbo0325@gmail.com are

mm-vmscan-avoid-anon-scanning-for-gfp_noio-with-low-swapcache.patch

