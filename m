Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F685F869
	for <mm-commits@vger.kernel.org>; Wed, 17 Apr 2024 21:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713388599; cv=none; b=utueOv6gWXcQvQENZbhieVUCOGtETIo8HUZJlv0KeHSyjTy5WHliKgxRzj+96R48ciHg2YHkggKp/y9eLAspMuSYFZfK8Hr3aK3Dqf2i0QJrUJzbr7ZCn4ErtXyQa65+jV+PbJ95IZXIrKOp86g2Y9ADmkpB9E9r6PcNSW6/wPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713388599; c=relaxed/simple;
	bh=S/dk8lSRR7lGgrVclOK0C3kAO6H6YGGnc0M0eNWpgBg=;
	h=Date:To:From:Subject:Message-Id; b=R0N+lIwkKMSQU7yfvsqbpr78Ft/1olgPMgVQU96v1xSHzR9gYj2iAYxWlfAy/K160Ieuz5tcD629+k2+wqanhoodAaxLfDMujBfmBRvI3stqLjt9m8tp47usoDNBUeK6GKiCPr8v4/D2frtUMwPjSNaUQvR3LuXmltxpcu2fWhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I6Gz+KZZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I6Gz+KZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784F7C072AA;
	Wed, 17 Apr 2024 21:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713388598;
	bh=S/dk8lSRR7lGgrVclOK0C3kAO6H6YGGnc0M0eNWpgBg=;
	h=Date:To:From:Subject:From;
	b=I6Gz+KZZL9/rIOlDtcllW9fEpWK/y8gaa/V1lfZkrkZBF50Cycc0qBjRdvlXSp9VT
	 47XqPjUnjJJgvLR5w2HvMZC1uT28h5GRMzi/vLLpWQRa0/tM7xKseQ9cd2UVDCjGIZ
	 V/87YF/ghGy9P1NxoaBaMEUtESyZaQeSWEXX/D10=
Date: Wed, 17 Apr 2024 14:16:37 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,vitaly.wool@konsulko.com,sjenning@redhat.com,rjones@redhat.com,nphamcs@gmail.com,ddstreet@ieee.org,christian@heusel.eu,chengming.zhou@linux.dev,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + null-pointer-dereference-while-shrinking-zswap.patch added to mm-hotfixes-unstable branch
Message-Id: <20240417211638.784F7C072AA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Re: Null pointer dereference while shrinking zswap
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     null-pointer-dereference-while-shrinking-zswap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/null-pointer-dereference-while-shrinking-zswap.patch

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
Subject: Re: Null pointer dereference while shrinking zswap
Date: Wed, 17 Apr 2024 10:33:24 -0400

temp version of this fix, for testing

Link: https://lkml.kernel.org/r/20240417143324.GA1055428@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Tested-by: Richard W.M. Jones <rjones@redhat.com>
Tested-By: Christian Heusel <christian@heusel.eu>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

--- a/mm/zswap.c~null-pointer-dereference-while-shrinking-zswap
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

null-pointer-dereference-while-shrinking-zswap.patch
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

