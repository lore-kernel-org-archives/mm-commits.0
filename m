Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793659990;
	b=kuuzkE0bcp0u6jF2e/Iq0NbR8xZB3bL4cra7CCWQA4nCS31/xyGtjJpMRo85T47x8tB/
	 5NFzJJivWTCKM0Tv4hpXDgWbhVzxYO40F3HgfN4J6tT6X2NNUMBhNxFXXBRQakwBpzc9p
	 GxYapJPvHNWzQTjZGJ1/BUdBTe3IgtGDvDpXccJyCECfDxaF0MoJVHxxvYcwzOcs501g2
	 tJGAUlC/tbroD5gcnjVuSrs1Q9OLnI7j0jyIthZXP3ShyKezaYgWrm90p98eLot8YpUtl
	 JsXZFkC3/TN5K5WfFP4URYiDOfk3Kx23oRday9wH/J1eshvwmXLIrD7QuG15EPOsfTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793659990;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=lfW0qif8GNnixdr0f6WK+S0pp+B3/NLN+h6GfsTP2Ys=;
	b=dgG3dNFoymunbeT/+VgrRH2O4+cIobyPE0JMTEWF2zBVq5M8Zd2MXMfGVhGu/Sw6nV6E
	 VakiJ7IdSiIfxhu5S3NUVr7UL+lPEnDyTmC0XkXZxU/q+SN0Ima/2q1LFWI0ABTkMi8fU
	 GSOXJFrKaRPqhKzD3o7wrLps2fUJRC29W/byxjOrbeu5kAXvSKoE0kPU6aM/aHfLwVMvP
	 uR2t4TI1QURs4aagVsm3Y64AoYLlV809tCkxBPxuAF9PHSUycbQCmTAcCDNtI0A+95m8V
	 rEBk+5VzoI1QoPp4qbaAQLxIj6fmIE5GJmabGloN69qHABRNrGPwkHoBVrVDy5Lh9ZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=nvZ3uxda;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCBE9606A32C
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 22:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=nvZ3uxda
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755401F00A16;
	Mon,  2 Nov 2026 22:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793659989;
	bh=lfW0qif8GNnixdr0f6WK+S0pp+B3/NLN+h6GfsTP2Ys=;
	h=Date:To:From:Subject;
	b=nvZ3uxda8uqhxKeAoRVuJKpwcgWngD4pCHUhn7tdfsfTx8zX7QH5RsBcKYsQBlw+A
	 1e+nSk0C6cMErKIGGhA9wXRFdg6EDspoDFkbUfU8v9XInH06ivh9Yy9A37zsPf75e2
	 +yOF5sEBK2wHONte3ZVU1mC0WhWtMS356T6T7ITs=
Date: Mon, 02 Nov 2026 14:53:09 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shakeel.butt@linux.dev,
	rppt@kernel.org,roman.gushchin@linux.dev,qi.zheng@linux.dev,
	osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,
	mt4022@columbia.edu,mike.kravetz@oracle.com,mhocko@kernel.org,
	linmiaohe@huawei.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,
	fvdl@google.com,david@kernel.org,chris@chrisdown.name,
	baolin.wang@linux.alibaba.com,chengkaitao@kylinos.cn,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-preserve-persistent-flags-when-returning-folios-to-the-pool.patch added to mm-new branch
Message-Id: <20261102225309.755401F00A16@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/hugetlb: preserve persistent flags when returning folios to the pool
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-preserve-persistent-flags-when-returning-folios-to-the-pool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-preserve-persistent-flags-when-returning-folios-to-the-pool.patch

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
From: Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: mm/hugetlb: preserve persistent flags when returning folios to the pool
Date: Mon, 02 Nov 2026 10:49:09 +0800

add_hugetlb_folio() returns a folio to the HugeTLB pool when vmemmap
restoration fails. It clears folio->private and restores only
HPG_vmemmap_optimized, losing other flags that must survive the rollback.

Clearing HPG_cma causes a later free to bypass the CMA release path,
leaving the CMA allocation bitmap set. Clearing HPG_raw_hwp_unreliable
loses the indication that the locations of poisoned subpages are unknown,
undermining the checks that prevent freeing or unpoisoning such folios.

Preserve the existing flags instead of resetting folio->private. Callers
already clear HPG_restore_reserve, HPG_migratable and HPG_freed before
returning a folio to the pool. Clear HPG_temporary in free_huge_folio()
before attempting to free a temporary folio, so a failed vmemmap restore
does not leave that flag set on a folio returned as surplus.

Add a VM_WARN_ON_ONCE_FOLIO() check for flags other than
HPG_vmemmap_optimized, HPG_raw_hwp_unreliable and HPG_cma to detect
incomplete transient flag cleanup.

Link: https://lore.kernel.org/20261102024910.31486-3-kaitao.cheng@linux.dev
Fixes: 161df60e9e89 ("mm, hwpoison, hugetlb: support saving mechanism of raw error pages")
Fixes: d2d786714080 ("mm/hugetlb: enable bootmem allocation from CMA areas")
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://sashiko.dev/#/bug/linux-5363eb09-9c3c-4f8b-9f3c-a998a8c4b258
Suggested-by: David Hildenbrand <david@kernel.org>
Suggested-by: Muchun Song <muchun.song@linux.dev>
Suggested-by: Zi Yan <ziy@nvidia.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Mani Tofigh <mt4022@columbia.edu>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
---

 mm/hugetlb.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-preserve-persistent-flags-when-returning-folios-to-the-pool
+++ a/mm/hugetlb.c
@@ -1443,6 +1443,12 @@ void add_hugetlb_folio(struct hstate *h,
 
 	lockdep_assert_held(&hugetlb_lock);
 
+	/* Callers must clear transient flags before returning to the pool. */
+	VM_WARN_ON_ONCE_FOLIO((unsigned long)folio->private &
+			     ~(BIT(HPG_vmemmap_optimized) |
+			       BIT(HPG_raw_hwp_unreliable) |
+			       BIT(HPG_cma)), folio);
+
 	INIT_LIST_HEAD(&folio->lru);
 	h->nr_huge_pages++;
 	h->nr_huge_pages_node[nid]++;
@@ -1453,9 +1459,6 @@ void add_hugetlb_folio(struct hstate *h,
 	}
 
 	__folio_set_hugetlb(folio);
-	/* Clear all folio->private flags except hugetlb_vmemmap_optimized. */
-	folio->private = NULL;
-	folio_set_hugetlb_vmemmap_optimized(folio);
 
 	arch_clear_hugetlb_flags(folio);
 	enqueue_hugetlb_folio(h, folio);
@@ -1743,6 +1746,7 @@ void free_huge_folio(struct folio *folio
 		h->resv_huge_pages++;
 
 	if (folio_test_hugetlb_temporary(folio)) {
+		folio_clear_hugetlb_temporary(folio);
 		remove_hugetlb_folio(h, folio, false);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 		update_and_free_hugetlb_folio(h, folio, true);
_

Patches currently in -mm which might be from chengkaitao@kylinos.cn are

mm-hugetlb_cma-fix-incorrect-hugetlb_cma_size-assignment-on-malformed-input.patch
mm-hugetlb-preserve-persistent-flags-when-returning-folios-to-the-pool.patch
mm-hugetlb-fix-nr_hugetlb-accounting-for-surplus-folios.patch

