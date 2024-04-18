Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9129A4F8A3;
	Thu, 18 Apr 2024 19:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713467000; cv=none; b=IGxvbP1tJ98fsIq6gt9zdznVl5jo1qw6iEbgF+aP9685rnGxNVyIua2KmvQA1fUQ1JREEqbLtT09GS+DZxnBbLvSvhnrMCHgspDeOZb4/WZkXpQ93vczRjQFycMUTlcOQtZLuY5FzWkVvNlRFHFNcRNqpLtSto5fWlaHdjqEVSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713467000; c=relaxed/simple;
	bh=VZtGpaqMkzB76SNGwLTn/euqnQq0FB7DHkLA0nWRmK8=;
	h=Date:To:From:Subject:Message-Id; b=Zxqw48H487KJT9ZD6xPjQzH5qeiJiD2Jkj71/eDY/L9rivMc++Vy9y/MUtoBN4mDM0Sxc/W30alKLW0wgAYyTiIZvn1JzwlYRW87tQoIEtiNRuR4/jtUa7g/dN1m1YXN2m1y9+1W+HBeAfVnOwhlG6PITiuXnuohBAV/mrZFw/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XaOmHb6E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XaOmHb6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14DB9C113CC;
	Thu, 18 Apr 2024 19:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713467000;
	bh=VZtGpaqMkzB76SNGwLTn/euqnQq0FB7DHkLA0nWRmK8=;
	h=Date:To:From:Subject:From;
	b=XaOmHb6EaDMSsbSYy+b1mckBnnMJvcTguyD6l+5wpmYa+pjJJZWhADH/A1n6B0yBh
	 lKe3gcmMnuLDvljBGb60otAowsohZdixp5XPEWdGmnwdPisGcI5jUOfBDLq4wA/sjz
	 rwQVT/58o7f8d3FCGrc/4RVVYYdFZYW+8kp3CHKo=
Date: Thu, 18 Apr 2024 12:03:19 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,vitaly.wool@konsulko.com,stable@vger.kernel.org,sjenning@redhat.com,rjones@redhat.com,nphamcs@gmail.com,ddstreet@ieee.org,christian@heusel.eu,chengming.zhou@linux.dev,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-fix-shrinker-null-crash-with-cgroup_disable=memory.patch added to mm-hotfixes-unstable branch
Message-Id: <20240418190320.14DB9C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: fix shrinker NULL crash with cgroup_disable=memory
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-zswap-fix-shrinker-null-crash-with-cgroup_disable=memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-fix-shrinker-null-crash-with-cgroup_disable=memory.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Richard W.M. Jones <rjones@redhat.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
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

mm-zswap-fix-shrinker-null-crash-with-cgroup_disable=memory.patch
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

