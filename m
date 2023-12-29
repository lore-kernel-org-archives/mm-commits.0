Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413B013AC4
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YuM9baHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F321C433C7;
	Fri, 29 Dec 2023 20:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880103;
	bh=0Mpo6VmENYxjc9KZ9mGrLURqWqKZbneCowMToCvZT/o=;
	h=Date:To:From:Subject:From;
	b=YuM9baHPiLOsccK3P/W8IdHgOIrom5WQj3bS+V0PvKTmmGW4NLha8X2eON7vXmCSw
	 /tMdBmX+1Tf1k7c5XAYQGccvbd3psB1rBX4ARNLfnJrK2ah6WX2r6llqfigBWwbUb7
	 gRoGXpLkLFoIYGu8IAze3N2ZSRQ3worB17Sbbjlo=
Date: Fri, 29 Dec 2023 12:01:42 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swapfile-page_add_anon_rmap-folio_add_anon_rmap_pte.patch removed from -mm tree
Message-Id: <20231229200143.0F321C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swapfile: page_add_anon_rmap() -> folio_add_anon_rmap_pte()
has been removed from the -mm tree.  Its filename was
     mm-swapfile-page_add_anon_rmap-folio_add_anon_rmap_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/swapfile: page_add_anon_rmap() -> folio_add_anon_rmap_pte()
Date: Wed, 20 Dec 2023 23:44:43 +0100

Let's convert unuse_pte().

Link: https://lkml.kernel.org/r/20231220224504.646757-20-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swapfile-page_add_anon_rmap-folio_add_anon_rmap_pte
+++ a/mm/swapfile.c
@@ -1806,7 +1806,7 @@ static int unuse_pte(struct vm_area_stru
 		if (pte_swp_exclusive(old_pte))
 			rmap_flags |= RMAP_EXCLUSIVE;
 
-		page_add_anon_rmap(page, vma, addr, rmap_flags);
+		folio_add_anon_rmap_pte(folio, page, vma, addr, rmap_flags);
 	} else { /* ksm created a completely new copy */
 		folio_add_new_anon_rmap(folio, vma, addr);
 		folio_add_lru_vma(folio, vma);
_

Patches currently in -mm which might be from david@redhat.com are


