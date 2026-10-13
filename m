Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200EB30F52B;
	Tue, 13 Oct 2026 03:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791861440; cv=none; b=RmykxC4r33gFZJAo449Zgo/W+saAM8U+W7V51ID9IBOvo2mfOEmdo8XBzUZGt4+SnhIrQsbPPcNsKFUfkR4eQUECpevtzoPo8kfPxeUiDGE9/Hj1lMpbz5l52iQumhdYQ8esTBepwxZaUA3R2kvinkU9Z+18M/YwrbhNlkQevfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791861440; c=relaxed/simple;
	bh=n0EYfALjysSL6EnpbgycVs6maZaXGm5Zpt2V+4ST85I=;
	h=Date:To:From:Subject:Message-Id; b=Sl5iY1iOPF3au5iaporr47auv6IuJWEadaoRObiTajbPeF7hpTHP1HxwUi/pkpBE0jLgg6T9vf7s8XBhYo+XTiNykO3Z8LpeIm1gWj0V7E1NLfEXxinUrc+1bXtnGHYgZ1grR8jZbUuQ2nWsq6a6DvIWrYbQ85JLxL2jvXozp9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uVqSce9v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uVqSce9v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D42A1F000FF;
	Tue, 13 Oct 2026 03:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791861438;
	bh=eHCVjNJgbanG0StU0eXmW71Wbwp74ANQIRuO3XXYunM=;
	h=Date:To:From:Subject;
	b=uVqSce9v314h/ZULhXOUj4lsjPoGZjPCnhn5i1cDryWN3Bj4XX7sWTEcEfEmDvStS
	 nUZhQ0kV5ZvkQxz1ej3+7A0PcdKKl5gddJy+7Wu9hqMCW7DqJ98VRW1Va2Iq2sG4UK
	 uG62DgU95OcxPEugNZPm6TxNgcJ4i1SQdsex27v8=
Date: Mon, 12 Oct 2026 20:17:18 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,riel@surriel.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kylebot@openai.com,jannh@google.com,harry@kernel.org,david@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-rmap-dont-discard-lazyfree-thps-at-pmd-level.patch removed from -mm tree
Message-Id: <20261013031718.7D42A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: don't discard lazyfree THPs at PMD level
has been removed from the -mm tree.  Its filename was
     mm-rmap-dont-discard-lazyfree-thps-at-pmd-level.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/rmap: don't discard lazyfree THPs at PMD level
Date: Fri, 09 Oct 2026 22:08:18 -0400

__discard_anon_folio_pmd_locked() clears a lazyfree THP PMD before it
knows whether the folio can be discarded, and restores it if the folio was
redirtied or has extra references.  A concurrent munmap() or
MREMAP_DONTUNMAP skips the temporary none PMD and unlinks the VMA from its
anon_vma, so the folio stays mapped after the anon_vma is freed and a
later rmap walk uses the freed anon_vma.

Using an invalidated PMD instead of a cleared one requires additional arch
code fixes.  Instead, disable the PMD level discard of lazyfree THPs, as
before commit 735ecdfaf4e8 ("mm/vmscan: avoid split lazyfree THP during
shrink_folio_list()").

Link: https://lore.kernel.org/20261009-lazyfree-stable-fix-v1-1-70997958ef8d@nvidia.com
Fixes: 735ecdfaf4e8 ("mm/vmscan: avoid split lazyfree THP during shrink_folio_list()")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Kyle Zeng <kylebot@openai.com>
Closes: https://lore.kernel.org/r/20261009165214.40212-2-kylebot@openai.com
Reviewed-by: Kyle Zeng <kylebot@openai.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Assisted-by: LLM
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: <stable@vger.kernel.org>
---

 mm/rmap.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/mm/rmap.c~mm-rmap-dont-discard-lazyfree-thps-at-pmd-level
+++ a/mm/rmap.c
@@ -2275,17 +2275,6 @@ static bool try_to_unmap_one(struct foli
 		}
 
 		if (!pvmw.pte) {
-			if (folio_test_lazyfree(folio)) {
-				if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, folio))
-					goto walk_done;
-				/*
-				 * unmap_huge_pmd_locked has either already marked
-				 * the folio as swap-backed or decided to retain it
-				 * due to GUP or speculative references.
-				 */
-				goto walk_abort;
-			}
-
 			if (flags & TTU_SPLIT_HUGE_PMD) {
 				/*
 				 * We temporarily have to drop the PTL and
_

Patches currently in -mm which might be from ziy@nvidia.com are


