Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795403042;
	b=1UjVrgjPRF0MhdsYHihsPqKmvCuxglgDwAl0axXqWGSim6TY+2DZphF6fPLhDJ93C8wF
	 vnT0u2BKDNArH6xXHzj8MiIfU+QSn8YNTP65aTR7VcTJOFJcyiFYo4eYOok1rfzIGJA9M
	 yggj8hoXWuZ1UDxGvMHG4+Dunr3hOsDxzp6OvOnnkYQBbf9Er262aVb7joBNKl2KSAjz4
	 3I0F0lYbJOFFVRlL7zuY7EjDPcGZg/OAJ2F8L1zyaB7cHyb/V9IcYf6jnKs3HmGQX9zm7
	 cx2USTQYUOdT+dcffcUfmbcqu5liHn+Njwc7MK9IVFslHih1p9ZZXWSuotC9gk0yZzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795403042;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=WRTeM2NDS6Ii1PGiOalIsThhE6bxBzU7MASclo4NcUA=;
	b=OtPV/1XRJuXAiGxxw+vVLQcnV9JtdLO8LerBgHs3RT8EM6QvToLnguW/TW12r4AzXcsi
	 +ylt+lU/H0lNtOsR3oI9U1tGDqVo0svXUY51/I4YXCXC7TJlXDdNtxLGaG3kLQmecy+O6
	 qQGkcr6sm6qjL+IGFKAHVgNhfj22tP9AGZFSzBuQdGcHc58YkgTi8KUQjrnQKgt546PEt
	 jj9DC8iMfLM7EPDtvrZ3wACLwk4hv+YZKg4Td1eMFf44aSgqCyroi04H+6DmdZKUlTx+t
	 fSpwzGR/HXRqHGUzs2nmJ4Z7LXfrLuRBwlD5I7wrQRVNziBiua3Z8gtbkkB5t4D3IFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ONOSkISy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D281A606A31A
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 03:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ONOSkISy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3821F000D0;
	Mon, 23 Nov 2026 03:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795403042;
	bh=WRTeM2NDS6Ii1PGiOalIsThhE6bxBzU7MASclo4NcUA=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=ONOSkISy1ngFeSwFBCxGoHCgeXUpJpzX9Bu+arbqDi2VyDrA1Y0tXBq3mmRhwow1D
	 mLV69MFowx5KnxsH/TmjiLi1NZl2auvzaoWCPKpMPZixwx70UPB/AKSuhkeabyln0d
	 KOOh6k+9p666n2jjfWHeGMfjKiKThsmmPT6T5nrQ=
Date: Sun, 22 Nov 2026 19:04:01 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	rppt@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,
	ljs@kernel.org,lizhe.67@bytedance.com,liam@infradead.org,
	lance.yang@linux.dev,jthoughton@google.com,david@kernel.org,
	balbirs@nvidia.com,apopple@nvidia.com,songmuchun@bytedance.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261120100856.16929-2-songmuchun@bytedance.com>
References: <20261120100856.16929-2-songmuchun@bytedance.com>
Subject: + mm-mm_init-verify-zones-for-template-initialized-pages.patch added to mm-new branch
Message-Id: <20261123030402.3A3821F000D0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mm_init: verify zones for template-initialized pages
has been added to the -mm mm-new branch.  Its filename is
     mm-mm_init-verify-zones-for-template-initialized-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_init-verify-zones-for-template-initialized-pages.patch

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
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/mm_init: verify zones for template-initialized pages
Date: Fri, 20 Nov 2026 18:08:46 +0800

Patch series "mm: Unify memmap initialization for compound pages", v3.

This series is split out from the earlier, larger series "mm: Generalize
HVO for HugeTLB and device DAX" [1].  That series generalized vmemmap
optimization across HugeTLB and device DAX.  One remaining piece is the
separate compound struct page initialization used by boot-time gigantic
HugeTLB pages and compound ZONE_DEVICE ranges.

In v3, Li Zhe's template-copy work is integrated directly into the generic
compound-page initialization changes instead of being stacked as two
prerequisite patches.  The shared memmap_init_compound_page() helper now
covers both compound ZONE_DEVICE ranges and boot-time gigantic HugeTLB
folios.  ZONE_DEVICE retains memcpy_nontemporal(), while normal memory
uses memcpy().

The first four patches make the generic memmap initialization code
suitable for sharing.  They add zone-consistency verification, factor the
PFN-independent page state, simplify ZONE_DEVICE template setup, and
introduce the common compound-page initialization helper.

The next four patches remove the boot-time HugeTLB HVO special handling,
initialize all bootmem hugepage struct pages in one place, switch HugeTLB
to the common helper, and make the now-local page initializer static.

The final three patches centralize early CMA pageblock setup and move
MIGRATE_MOVABLE pageblock initialization into the shared memmap helpers.

After this series, boot-time HugeTLB and compound ZONE_DEVICE ranges,
including device DAX, use the same helpers for compound-page and pageblock
initialization.


This patch (of 11):

Template-based ZONE_DEVICE initialization bypasses
__init_single_page(), which means copied struct pages do not run the
vmemmap zone consistency check.

Verify each destination after copying the template so the fast path gets
the same validation as regular page initialization.

Link: https://lore.kernel.org/20261120100856.16929-1-songmuchun@bytedance.com
Link: https://patch.msgid.link/20261120100856.16929-2-songmuchun@bytedance.com
Link: https://lore.kernel.org/20260513130542.35604-1-songmuchun@bytedance.com/ [1]
Link: https://lore.kernel.org/20261112112816.55095-1-lizhe.67@bytedance.com/ [2]
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Qi Zheng <qi.zheng@linux.dev>

 mm/mm_init.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/mm_init.c~mm-mm_init-verify-zones-for-template-initialized-pages
+++ a/mm/mm_init.c
@@ -1082,6 +1082,7 @@ static void zone_device_page_init_from_t
 		set_page_address(template, __va(pfn << PAGE_SHIFT));
 #endif
 	memcpy_nontemporal(page, template, sizeof(*page));
+	vmemmap_optimization_verify_zone(page);
 }
 
 /*
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

powerpc-mm-make-vmemmap_populate_compound_pages-static.patch
powerpc-mm-drop-powerpc-vmemmap_can_optimize.patch
mm-sparse-vmemmap-drop-vmemmap_can_optimize.patch
mm-sparse-vmemmap-drop-pgmap-from-vmemmap-population-apis.patch
mm-hugetlb_vmemmap-fix-hwpoison-state-races-during-optimization.patch
mm-hugetlb_vmemmap-fix-pmd-split-tlb-flush-race.patch
mm-hugetlb_vmemmap-fix-deadlock-during-pmd-split.patch
mm-list_lru-fix-potential-infinite-loop-on-xa-node-allocation-failure.patch
mm-mm_init-verify-zones-for-template-initialized-pages.patch
mm-mm_init-factor-out-common-struct-page-initialization.patch
mm-mm_init-simplify-zone-device-page-initialization.patch
mm-mm_init-factor-out-compound-page-initialization.patch
mm-hugetlb-drop-boot-time-hvo-handling-for-gigantic-folios.patch
mm-hugetlb-initialize-all-struct-pages-for-bootmem-hugepages.patch
mm-hugetlb-use-common-compound-page-initialization-helper.patch
mm-mm_init-make-__init_single_page-static.patch
mm-cma-centralize-cma-pageblock-initialization.patch
mm-cma-localize-init_cma_pageblock-to-cmac.patch
mm-mm_init-move-pageblock-migratetype-init-to-memmap-helpers.patch

