Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1868830B53E
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334302; cv=none; b=HsqvFBG0VueyO5WzpJLEdPswkaad/fxgIGkT+Ab3vTqYHaH1YZp4UKAsqluY8/ZZOAyD1a2Gwam7OuNmii+YfuKW/+NqeyerTxdq5y75ont1ILKIlkLbx4SnR05nlwDZec6yy4ReZsJ8PpgXJNbHOwoH5sT1arPMmx56C2Ro1LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334302; c=relaxed/simple;
	bh=v82KVw+e+0aML00U7VEE5I66Jo67g03LsA1Mc55AaYs=;
	h=Date:To:From:Subject:Message-Id; b=BXhdL4n9mToENjW3Iy9Utd4y42CJmu7WaBb2k8oGdsNwuyT8svHr3U25AmosWN3iDtqLd4FOMi0AT2yTNmTNC2SeLfturKCozrc1oHItsfeujfJfGDZ19jtqyGsa1vlIUvrmiJ4fyAmGAoSRQf3h+JCKBDoOa5rQXPoZvnydmDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mwALibBM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mwALibBM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1BE21F0089B;
	Wed,  7 Oct 2026 00:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334301;
	bh=LlI4rN+shn3KsLIZ8WCrxMdPU7ijDHk6L9C30ggML9k=;
	h=Date:To:From:Subject;
	b=mwALibBMk176qK9483A/meESfUTkN3XCAUFYbN0DFHGp07bX720lzGifPZtnGye3d
	 oGtOs3yA3Xi33LN7Ce2pSdgq/sewpWMOKO5xjyhYTUpdxDnh7s/wjqcxdy5FAiNqjS
	 gBNruBtvD1fNTlF+cBCGy1mJuirD9DbJtTuZSutQ=
Date: Tue, 06 Oct 2026 17:51:40 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,riel@surriel.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kunwu.chan@gmail.com,jannh@google.com,harry@kernel.org,david@kernel.org,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-remove-stale-hugetlb-check-in-try_to_unmap_one.patch removed from -mm tree
Message-Id: <20261007005140.E1BE21F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: remove stale hugetlb check in try_to_unmap_one
has been removed from the -mm tree.  Its filename was
     mm-rmap-remove-stale-hugetlb-check-in-try_to_unmap_one.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm/rmap: remove stale hugetlb check in try_to_unmap_one
Date: Mon, 31 Aug 2026 08:28:47 +0000

Post commit d4ec5572825a ("mm/rmap: add
try_to_unmap_poisoned_hugetlb_one") try_to_unmap_one() cannot be called
with a hugetlb folio.  Therefore remove the folio_test_hugetlb() check.

Link: https://lore.kernel.org/20260831082849.3573957-1-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/rmap.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/rmap.c~mm-rmap-remove-stale-hugetlb-check-in-try_to_unmap_one
+++ a/mm/rmap.c
@@ -2301,11 +2301,8 @@ static bool try_to_unmap_one(struct foli
 		VM_BUG_ON_FOLIO(!pvmw.pte, folio);
 
 		address = pvmw.address;
-		if (folio_test_hugetlb(folio)) {
-			pteval = huge_ptep_get(mm, address, pvmw.pte);
-		} else {
-			pteval = ptep_get(pvmw.pte);
-		}
+		pteval = ptep_get(pvmw.pte);
+
 		if (likely(pte_present(pteval))) {
 			pfn = pte_pfn(pteval);
 		} else {
_

Patches currently in -mm which might be from dev.jain@arm.com are


