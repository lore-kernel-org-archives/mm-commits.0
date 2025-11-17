Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C911222129F
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343138; cv=none; b=ds4LPAtAMP3bkN76RQjT1OBdUIB8ayn/oQJqLNeB6lP6osnKJWEYsCKZcSptIddGwNKCH8bVyddaYXuOhjY+xMqVaQelvOnsj8ZMIyPYkUtZt4FWYDcQ3JF4Y+TU0PfbNiwgoHUZY3+HhHjwYnNRYj2kQk2ToVqrm6w3a2upweI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343138; c=relaxed/simple;
	bh=3nRhvMoFuj0geiu2vUs1MZn+jqrCyy9v7E75KSufNxs=;
	h=Date:To:From:Subject:Message-Id; b=SZXRlRSVnFopsaWk3dgHmO6TEEO6HNxzVV94M6VzYlSvQChLE7531LasfF8SPeN0NJZuJrSNdculy1s+jWitY474tSrLtK8taAE8q2SLHliImJBMK4pwZL/1FmjXsWeE7tCLbjXZ5q68Fta4I37LS17Bp15tYwjZ/Wqq3Qrh80o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qxoFRXnj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qxoFRXnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6EDC4CEF1;
	Mon, 17 Nov 2025 01:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343138;
	bh=3nRhvMoFuj0geiu2vUs1MZn+jqrCyy9v7E75KSufNxs=;
	h=Date:To:From:Subject:From;
	b=qxoFRXnjzDUyCg8W4sWVZrlnpYZqGn/vf6kqWOQuSmGWCaTPecK65lSu0KzBs/hPM
	 vwhAfZTCQaMliQM3Vx1d273QzUyybmIQeqyS69Zi2XpyVSNnWtynt8lguP9GPJu7lu
	 8otr9GAWyncmCcJiaWuVuNd6GqGcRyVxO4cCaoSI=
Date: Sun, 16 Nov 2025 17:32:18 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,sidhartha.kumar@oracle.com,ryan.roberts@arm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-use-folio_can_map_prot_numa-for-pmd-folio.patch removed from -mm tree
Message-Id: <20251117013218.9B6EDC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: huge_memory: use folio_can_map_prot_numa() for pmd folio
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-use-folio_can_map_prot_numa-for-pmd-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: huge_memory: use folio_can_map_prot_numa() for pmd folio
Date: Thu, 23 Oct 2025 19:37:37 +0800

The folio_can_map_prot_numa() checks whether the folio can map prot numa,
which skips unsuitable folio, i.e.  zone device, shared folios (KSM, CoW),
non-movable dma pinned, dirty file folio and folios that already have the
expected node affinity.  Although the ksm only applies to small folios, an
extra test was added for large folios, but the other policies should be
applied to pmd folio, which helps to avoid unnecessary pmd change and
folio migration attempts.

Link: https://lkml.kernel.org/r/20251023113737.3572790-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-use-folio_can_map_prot_numa-for-pmd-folio
+++ a/mm/huge_memory.c
@@ -2396,8 +2396,7 @@ int change_huge_pmd(struct mmu_gather *t
 #endif
 
 	if (prot_numa) {
-		struct folio *folio;
-		bool toptier;
+
 		/*
 		 * Avoid trapping faults against the zero page. The read-only
 		 * data is likely to be read-cached on the local CPU and
@@ -2409,19 +2408,9 @@ int change_huge_pmd(struct mmu_gather *t
 		if (pmd_protnone(*pmd))
 			goto unlock;
 
-		folio = pmd_folio(*pmd);
-		toptier = node_is_toptier(folio_nid(folio));
-		/*
-		 * Skip scanning top tier node if normal numa
-		 * balancing is disabled
-		 */
-		if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
-		    toptier)
+		if (!folio_can_map_prot_numa(pmd_folio(*pmd), vma,
+					     vma_is_single_threaded_private(vma)))
 			goto unlock;
-
-		if (folio_use_access_time(folio))
-			folio_xchg_access_time(folio,
-					       jiffies_to_msecs(jiffies));
 	}
 	/*
 	 * In case prot_numa, we are under mmap_read_lock(mm). It's critical
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-kill-mm_wr_locked-from-unmap_vmas-and-unmap_single_vma.patch

