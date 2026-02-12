Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED1535B130;
	Thu, 12 Feb 2026 22:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770934088; cv=none; b=rUHKs6BJ+D9RglGN0Mx2DJK83WRtZLn3Zpj1tH77m2t17U507gdZKgrIzXx6t0OAcREsWpt9Te/P1qibKqup0S30z7D90ZLEh53If8prvsYZXEzjDwtEiurU5W+efn5zcyrNB3jg4gtK6LNiowmUfpp5N1rIbf7SAiYV4qv4QPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770934088; c=relaxed/simple;
	bh=Brq5txyD/TtlaK9XjU6cgkvdg5BDOJrg62F6j94AYGA=;
	h=Date:To:From:Subject:Message-Id; b=oOYHo5jtLQroTFo5HMJY8nt0uMQsfOjQTJiAu1dveY6N93plwQf2GqW5bWaapiXAxXMtmbgUZ+PnT+ob5apjtrIN1y/3r5LCcA7lzFum5QUzxh37VbtzyUXEjwg2LBhHbO9l0HtE90fAne8NVVaA2s7FIjPEJX9CSJlsDlGgPog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kJ2sDE31; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kJ2sDE31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87125C4CEF7;
	Thu, 12 Feb 2026 22:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770934087;
	bh=Brq5txyD/TtlaK9XjU6cgkvdg5BDOJrg62F6j94AYGA=;
	h=Date:To:From:Subject:From;
	b=kJ2sDE31kwMNAzzclbMUDiJvR59Mlo69RIfR1z2pxa/CJT9odkUAiVToTUwZxGco8
	 xwHO1Fdl78ZoatsowFPp8xoCPSimHLge6d1VpkCtK4jwsd4Oh08xPYCfwVqoyNvPfi
	 hCcSHgE29IO3K7uCfHsKzBezFnEuYutMqpSzs9i0=
Date: Thu, 12 Feb 2026 14:08:12 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,stable@vger.kernel.org,lance.yang@linux.dev,gavinguo@igalia.com,david@kernel.org,baolin.wang@linux.alibaba.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-huge_memory-fix-early-failure-try_to_migrate-when-split-huge-pmd-for-shared-thp.patch removed from -mm tree
Message-Id: <20260212220807.87125C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: fix early failure try_to_migrate() when split huge pmd for shared thp
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-fix-early-failure-try_to_migrate-when-split-huge-pmd-for-shared-thp.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/huge_memory: fix early failure try_to_migrate() when split huge pmd for shared thp
Date: Thu, 5 Feb 2026 03:31:13 +0000

Commit 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and
split_huge_pmd_locked()") return false unconditionally after
split_huge_pmd_locked() which may fail early during try_to_migrate() for
shared thp.  This will lead to unexpected folio split failure.

One way to reproduce:

    Create an anonymous thp range and fork 512 children, so we have a
    thp shared mapped in 513 processes. Then trigger folio split with
    /sys/kernel/debug/split_huge_pages debugfs to split the thp folio to
    order 0.

Without the above commit, we can successfully split to order 0.  With the
above commit, the folio is still a large folio.

The reason is the above commit return false after split pmd
unconditionally in the first process and break try_to_migrate().

On memory pressure or failure, we would try to reclaim unused memory or
limit bad memory after folio split.  If failed to split it, we will leave
some more memory unusable than expected.

The tricky thing in the above reproduction method is current debugfs
interface leverage function split_huge_pages_pid(), which will iterate the
whole pmd range and do folio split on each base page address.  This means
it will try 512 times, and each time split one pmd from pmd mapped to pte
mapped thp.  If there are less than 512 shared mapped process, the folio
is still split successfully at last.  But in real world, we usually try it
for once.

This patch fixes this by restarting page_vma_mapped_walk() after
split_huge_pmd_locked().  We cannot simply return "true" to fix the
problem, as that would affect another case:
split_huge_pmd_locked()->folio_try_share_anon_rmap_pmd() can failed and
leave the folio mapped through PTEs; we would return "true" from
try_to_migrate_one() in that case as well.  While that is mostly harmless,
we could end up walking the rmap, wasting some cycles.

Link: https://lkml.kernel.org/r/20260205033113.30724-1-richard.weiyang@gmail.com
Fixes: 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and split_huge_pmd_locked()")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Gavin Guo <gavinguo@igalia.com>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Cc: Gavin Guo <gavinguo@igalia.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/mm/rmap.c~mm-huge_memory-fix-early-failure-try_to_migrate-when-split-huge-pmd-for-shared-thp
+++ a/mm/rmap.c
@@ -2443,11 +2443,17 @@ static bool try_to_migrate_one(struct fo
 			__maybe_unused pmd_t pmdval;
 
 			if (flags & TTU_SPLIT_HUGE_PMD) {
+				/*
+				 * split_huge_pmd_locked() might leave the
+				 * folio mapped through PTEs. Retry the walk
+				 * so we can detect this scenario and properly
+				 * abort the walk.
+				 */
 				split_huge_pmd_locked(vma, pvmw.address,
 						      pvmw.pmd, true);
-				ret = false;
-				page_vma_mapped_walk_done(&pvmw);
-				break;
+				flags &= ~TTU_SPLIT_HUGE_PMD;
+				page_vma_mapped_walk_restart(&pvmw);
+				continue;
 			}
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
 			pmdval = pmdp_get(pvmw.pmd);
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


