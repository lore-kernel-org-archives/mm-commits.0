Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D4B3C769F
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439128; cv=none; b=peu9T2Tax1GNRtQ/ex0ewdeblFFKoJ2jEZTtkRtCtpRfZsNFKwNb58+smDWHLt9n1PDVbI6taI1xX36pWu5ONyYWgW9iyordco6Cq3al5L92g4hXlWihmHtYdHYpc8qrynu5w7uzNzgQL3SN+CY+aC4N+pxLSwDzmGPhcAx2wCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439128; c=relaxed/simple;
	bh=9sBL1rt085h1jcsuAkqQO1tP/ycmQB36tFbk6Ac25kk=;
	h=Date:To:From:Subject:Message-Id; b=o30Hh24bxTbfGzGremFjVRG+7gquQh6NXzNlTsa2ehGM8xRXWZnTp64mIXdM+6NHqGleVZV6uvB3EHMdS5rmSPzKbV2yiPiH7gjyH9GiZd6qgCNfU5OQ15Jup+k3LgYW7js/akES0h6EG/heIw0MSRJekYzQ8NrzU6dKItAdASY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hYyjoO3b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hYyjoO3b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9771F00893;
	Tue,  2 Jun 2026 22:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439127;
	bh=BOxg8vXAbnEC75SkARLxGHQ9FGHWMi3hw7+qokEN7qU=;
	h=Date:To:From:Subject;
	b=hYyjoO3b2Pe1jH2aGPt56pgO1mRDuI0eN54kWwaeNKDbOpt3wklhunteGD1qbeENa
	 TeaIzrVX8ijNuwReVcDQEaXU5BUyJMhji7zJbOYRe4WHDHZc5zKDU2w1x2AQV7jMZN
	 T/38abQ0qHNG11KWlG/6JSt7jmLTsPpH7HFlJvsI=
Date: Tue, 02 Jun 2026 15:25:26 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,chengkaitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-use-zone_pcp_disable-for-poison-handling.patch removed from -mm tree
Message-Id: <20260602222527.3C9771F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: use zone_pcp_disable() for poison handling
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-use-zone_pcp_disable-for-poison-handling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: mm/memory-failure: use zone_pcp_disable() for poison handling
Date: Thu, 14 May 2026 16:57:54 +0800

__page_handle_poison() used drain_all_pages() instead of
zone_pcp_disable() because dissolve_free_hugetlb_folio() could restore HVO
vmemmap pages and decrement hugetlb_optimize_vmemmap_key.  That static key
update took cpu_hotplug_lock through static_key_slow_dec(), while
zone_pcp_disable() holds pcp_batch_high_lock.  CPU hotplug takes the locks
in the opposite order through page_alloc_cpu_online/dead(), so the
combination could deadlock.

That dependency no longer exists.  Commit da3e2d1ca43d ("mm/hugetlb:
remove hugetlb_optimize_vmemmap_key static key") removed the HVO static
key and the static_branch_dec() from hugetlb_vmemmap_restore_folio().  The
dissolve_free_hugetlb_folio() path no longer reaches
static_key_slow_dec().

Use zone_pcp_disable() again while dissolving the hugetlb folio and taking
the target page off the buddy allocator.  This prevents the drained PCP
lists from being refilled before take_page_off_buddy() runs, making the
page isolation deterministic.

Link: https://lore.kernel.org/20260514085754.84097-1-kaitao.cheng@linux.dev
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-use-zone_pcp_disable-for-poison-handling
+++ a/mm/memory-failure.c
@@ -172,23 +172,11 @@ static int __page_handle_poison(struct p
 {
 	int ret;
 
-	/*
-	 * zone_pcp_disable() can't be used here. It will
-	 * hold pcp_batch_high_lock and dissolve_free_hugetlb_folio() might hold
-	 * cpu_hotplug_lock via static_key_slow_dec() when hugetlb vmemmap
-	 * optimization is enabled. This will break current lock dependency
-	 * chain and leads to deadlock.
-	 * Disabling pcp before dissolving the page was a deterministic
-	 * approach because we made sure that those pages cannot end up in any
-	 * PCP list. Draining PCP lists expels those pages to the buddy system,
-	 * but nothing guarantees that those pages do not get back to a PCP
-	 * queue if we need to refill those.
-	 */
+	zone_pcp_disable(page_zone(page));
 	ret = dissolve_free_hugetlb_folio(page_folio(page));
-	if (!ret) {
-		drain_all_pages(page_zone(page));
+	if (!ret)
 		ret = take_page_off_buddy(page);
-	}
+	zone_pcp_enable(page_zone(page));
 
 	return ret;
 }
_

Patches currently in -mm which might be from chengkaitao@kylinos.cn are

mm-cma_sysfs-skip-inactive-cma-areas-in-sysfs.patch
mm-page_isolation-avoid-unsafe-folio-reads-while-scanning-compound-pages.patch

