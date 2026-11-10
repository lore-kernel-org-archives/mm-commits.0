Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794270250;
	b=KWcYLDOZ7QA7seuZq3LS6mHRjBd1aosm5eQK3wS2uBErhLhnoziZYS3X+tMJFHDA6Tse
	 o5+cEFzSlo/soEqSzd866cBecLeI4//aAaGRW/VXF4TLdOIe0+j29FcGQwHsOnlY1Tlht
	 O61co/0P60jMScrtF7OlZgGk/AU6o1SSUajh04OQPBfM+hMSPdDhgFEzuLWZOqAD7mt0e
	 iFHp1LcBGl4yw5loIm2HT86vnvoWc0ux3O+5SBwrZhVIshYcpoVoFwtO7G5NiqolxEEQI
	 UqX1NOFgsyoLMf39q0eAYzh8YrBM3KV+PFjKJiJ98T9nVFHhuxDNN7tUSSAAVuoj2GQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794270250;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=BB5yTfkQZuLx+hrNXsXydPDZeBoHyMRfwRL4VXc87SE=;
	b=BEMEFc4uq2W7rFCqQ9qvMWZ58gXdQ45Zj5MKX4VH02X76fKHZgNZg8NIhJg+WY6IrW3v
	 Wu6q3D/uBoDo2Bf16QDzYVKj65uOnza0IJl9DTrUCBBMO84umjPjL8/H7bfT4QHKYYGoB
	 G8SjO4Z+/BXg5M+IyYB3EdVt0u8+UhyG6XjUswTqtb5M1y5o9o687iB7NgLdHfcSbXLiD
	 3HNh9ci5dGHIApyT4bbboeGW6JlmJm7TPRTxF+E3xAjW9LwEEwCrJSgyg1dO/fB1KELmD
	 pZGYMvFYkLUwYWpbdN6lbeLO35p0U2OcGEZkPCKz20UaSMc4exvbUlgnSsaFXeGAzPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="HWT+j/Wf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2D8606A326
	for <mm-commits@vger.kernel.org>; Tue, 10 Nov 2026 00:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HWT+j/Wf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3601F008A1;
	Tue, 10 Nov 2026 00:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794270250;
	bh=BB5yTfkQZuLx+hrNXsXydPDZeBoHyMRfwRL4VXc87SE=;
	h=Date:To:From:Subject;
	b=HWT+j/WfUPOkBfW7bQFIvnbmnqrggZDBpcmVbhEEF5aC47IOaHsNjyJpdM2Ta/Hyg
	 QGw92Li8YbreNCokUEkWTaiWb5pAMAESr/KqbkQbsdRNR8V914+m/kIM+P0jcGHhoz
	 JgAbkxdKgopZaTHplnsfe7ET/SMp3TbvcKhu2FnE=
Date: Mon, 09 Nov 2026 16:24:09 -0800
To: mm-commits@vger.kernel.org,chengkaitao@kylinos.cn,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-preserve-persistent-flags-when-returning-folios-to-the-pool.patch added to mm-unstable branch
Message-Id: <20261110002409.DF3601F008A1@smtp.kernel.org>
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
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-preserve-persistent-flags-when-returning-folios-to-the-pool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-preserve-persistent-flags-when-returning-folios-to-the-pool.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Date: Fri, 06 Nov 2026 18:05:19 +0800

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

Link: https://lore.kernel.org/20261106100521.30099-3-kaitao.cheng@linux.dev
Fixes: 161df60e9e89 ("mm, hwpoison, hugetlb: support saving mechanism of raw error pages")
Fixes: d2d786714080 ("mm/hugetlb: enable bootmem allocation from CMA areas")
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://sashiko.dev/#/bug/linux-5363eb09-9c3c-4f8b-9f3c-a998a8c4b258
Suggested-by: David Hildenbrand <david@kernel.org>
Suggested-by: Muchun Song <muchun.song@linux.dev>
Suggested-by: Zi Yan <ziy@nvidia.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
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
Cc: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
---

 mm/hugetlb.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-preserve-persistent-flags-when-returning-folios-to-the-pool
+++ a/mm/hugetlb.c
@@ -1443,6 +1443,12 @@ void add_hugetlb_folio(struct hstate *h,
 
 	lockdep_assert_held(&hugetlb_lock);
 
+	/* Callers must clear transient flags before returning to the pool. */
+	VM_WARN_ON_ONCE_FOLIO((unsigned long)folio->private &
+			      ~(BIT(HPG_vmemmap_optimized) |
+				BIT(HPG_raw_hwp_unreliable) |
+				BIT(HPG_cma)), folio);
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
mm-hugetlb-fix-nr_hugetlb-accounting-for-unused-surplus-folios.patch
mm-hugetlb-account-nr_hugetlb-at-folio-state-transitions.patch

