Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8882A12E61;
	Thu, 25 Apr 2024 02:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714012522; cv=none; b=e+/LtnXuEZR1O988Eu85CKrM8rzObylOR4BJR51DrmkU4++aE3C/xoIkZ7vOdO2kC3YFDOY3AW8zDEm3HlSXDZCwBz7LTFA9I/QP5NvL/7vVZ+7HbrPaEp0RXfdknxV0SdUuFo+SJUKw5xf56u14yINhDEh+Dx9V6t7WC6OFxgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714012522; c=relaxed/simple;
	bh=SYJNkyWVWixL0gc5jowP9EXwnLb+05RTNyJCwACYzrM=;
	h=Date:To:From:Subject:Message-Id; b=tVKWgZlLCElFCxfKd2D8mTIgZrNPS8PYN5XsPJZKClrQ/LbdCWLampPWEu/CU67s6F5FZFeTXTkZViMSSW01eC6E+iOcwADwfbfvnDFBrW4inEQR3KttIKX46Krem6D5pyKbLd4dLoKImN551r5E2QEG9ZB7Sltsm+6tSTUJcJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fTxCveN2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fTxCveN2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B98C113CD;
	Thu, 25 Apr 2024 02:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714012522;
	bh=SYJNkyWVWixL0gc5jowP9EXwnLb+05RTNyJCwACYzrM=;
	h=Date:To:From:Subject:From;
	b=fTxCveN2TqJqnIY6szeCto7QNDgpw/OzEJFEoMU0GhfIX2tW1I/8gJAryUlgjGZFQ
	 sSnXmdm2JGIDnCz+CEXlSlMausOS2eavz4pRTGpGWGN/Wm2MQ2Y8KoJTd0U3qN8z5s
	 FMo7Zde63p1DVjyFVsDVTcvcJmVIK8ZLSsqT50/4=
Date: Wed, 24 Apr 2024 19:35:21 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,vitaly.wool@konsulko.com,stable@vger.kernel.org,sjenning@redhat.com,rjones@redhat.com,nphamcs@gmail.com,ddstreet@ieee.org,christian@heusel.eu,chengming.zhou@linux.dev,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-zswap-fix-shrinker-null-crash-with-cgroup_disable=memory.patch removed from -mm tree
Message-Id: <20240425023522.12B98C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: fix shrinker NULL crash with cgroup_disable=memory
has been removed from the -mm tree.  Its filename was
     mm-zswap-fix-shrinker-null-crash-with-cgroup_disable=memory.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: fix shrinker NULL crash with cgroup_disable=memory
Date: Thu, 18 Apr 2024 08:26:28 -0400

Christian reports a NULL deref in zswap that he bisected down to the zswap
shrinker.  The issue also cropped up in the bug trackers of libguestfs [1]
and the Red Hat bugzilla [2].

The problem is that when memcg is disabled with the boot time flag, the
zswap shrinker might get called with sc->memcg == NULL.  This is okay in
many places, like the lruvec operations.  But it crashes in
memcg_page_state() - which is only used due to the non-node accounting of
cgroup's the zswap memory to begin with.

Nhat spotted that the memcg can be NULL in the memcg-disabled case, and I
was then able to reproduce the crash locally as well.

[1] https://github.com/libguestfs/libguestfs/issues/139
[2] https://bugzilla.redhat.com/show_bug.cgi?id=2275252

Link: https://lkml.kernel.org/r/20240418124043.GC1055428@cmpxchg.org
Link: https://lkml.kernel.org/r/20240417143324.GA1055428@cmpxchg.org
Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Christian Heusel <christian@heusel.eu>
Debugged-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Tested-by: Christian Heusel <christian@heusel.eu>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Richard W.M. Jones <rjones@redhat.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: <stable@vger.kernel.org>	[v6.8]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

--- a/mm/zswap.c~mm-zswap-fix-shrinker-null-crash-with-cgroup_disable=memory
+++ a/mm/zswap.c
@@ -1331,15 +1331,22 @@ static unsigned long zswap_shrinker_coun
 	if (!gfp_has_io_fs(sc->gfp_mask))
 		return 0;
 
-#ifdef CONFIG_MEMCG_KMEM
-	mem_cgroup_flush_stats(memcg);
-	nr_backing = memcg_page_state(memcg, MEMCG_ZSWAP_B) >> PAGE_SHIFT;
-	nr_stored = memcg_page_state(memcg, MEMCG_ZSWAPPED);
-#else
-	/* use pool stats instead of memcg stats */
-	nr_backing = zswap_pool_total_size >> PAGE_SHIFT;
-	nr_stored = atomic_read(&zswap_nr_stored);
-#endif
+	/*
+	 * For memcg, use the cgroup-wide ZSWAP stats since we don't
+	 * have them per-node and thus per-lruvec. Careful if memcg is
+	 * runtime-disabled: we can get sc->memcg == NULL, which is ok
+	 * for the lruvec, but not for memcg_page_state().
+	 *
+	 * Without memcg, use the zswap pool-wide metrics.
+	 */
+	if (!mem_cgroup_disabled()) {
+		mem_cgroup_flush_stats(memcg);
+		nr_backing = memcg_page_state(memcg, MEMCG_ZSWAP_B) >> PAGE_SHIFT;
+		nr_stored = memcg_page_state(memcg, MEMCG_ZSWAPPED);
+	} else {
+		nr_backing = zswap_pool_total_size >> PAGE_SHIFT;
+		nr_stored = atomic_read(&zswap_nr_stored);
+	}
 
 	if (!nr_stored)
 		return 0;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-zswap-optimize-zswap-pool-size-tracking.patch
mm-zpool-return-pool-size-in-pages.patch
mm-page_alloc-remove-pcppage-migratetype-caching.patch
mm-page_alloc-optimize-free_unref_folios.patch
mm-page_alloc-fix-up-block-types-when-merging-compatible-blocks.patch
mm-page_alloc-move-free-pages-when-converting-block-during-isolation.patch
mm-page_alloc-fix-move_freepages_block-range-error.patch
mm-page_alloc-fix-freelist-movement-during-block-conversion.patch
mm-page_alloc-close-migratetype-race-between-freeing-and-stealing.patch
mm-page_isolation-prepare-for-hygienic-freelists.patch
mm-page_isolation-prepare-for-hygienic-freelists-fix.patch
mm-page_alloc-consolidate-free-page-accounting.patch
mm-page_alloc-consolidate-free-page-accounting-fix.patch
mm-page_alloc-consolidate-free-page-accounting-fix-2.patch
mm-page_alloc-batch-vmstat-updates-in-expand.patch

