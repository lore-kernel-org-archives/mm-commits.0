Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1502713AEB
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EsUQZnRK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5349C433CA;
	Fri, 29 Dec 2023 20:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880094;
	bh=G7B5OY56i/hzCXnNe0HT91VskJSTQMinS280pIS/Ik8=;
	h=Date:To:From:Subject:From;
	b=EsUQZnRK59bvDcKLLM7z9/f78bCAJyHF+eT/a0ZsDixbeHLjTOv4EWhuGir/IXBz0
	 ahTZ3Qm1JkpQV9+3Z4sVmpeLujKMo0NL7E7F6X5862UfE8jZoWiUPTh+xYTnFA6EFV
	 pbHvNuBDVpBuOnNJU65aTvojBSW80sOO3NW08BxQ=
Date: Fri, 29 Dec 2023 12:01:34 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-userfaultfd-page_add_file_rmap-folio_add_file_rmap_pte.patch removed from -mm tree
Message-Id: <20231229200134.D5349C433CA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/userfaultfd: page_add_file_rmap() -> folio_add_file_rmap_pte()
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-page_add_file_rmap-folio_add_file_rmap_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/userfaultfd: page_add_file_rmap() -> folio_add_file_rmap_pte()
Date: Wed, 20 Dec 2023 23:44:35 +0100

Let's convert mfill_atomic_install_pte().

Link: https://lkml.kernel.org/r/20231220224504.646757-12-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/userfaultfd.c~mm-userfaultfd-page_add_file_rmap-folio_add_file_rmap_pte
+++ a/mm/userfaultfd.c
@@ -114,7 +114,7 @@ int mfill_atomic_install_pte(pmd_t *dst_
 		/* Usually, cache pages are already added to LRU */
 		if (newly_allocated)
 			folio_add_lru(folio);
-		page_add_file_rmap(page, dst_vma, false);
+		folio_add_file_rmap_pte(folio, page, dst_vma);
 	} else {
 		folio_add_new_anon_rmap(folio, dst_vma, dst_addr);
 		folio_add_lru_vma(folio, dst_vma);
_

Patches currently in -mm which might be from david@redhat.com are


