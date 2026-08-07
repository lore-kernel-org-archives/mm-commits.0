Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574F73B8127
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068138; cv=none; b=qR00oLF/Nk1629sGZIlPaVShz5mpBddtS6AO4iJ5rnVRjwHwSPZOcVYL9AhYsp/8ktxZPNhpQEx/zaiDbnoDqAePZJH1tIu2St8Q44mSKPEd8YBYzc2dRPdBIgG7Yb4mfHEo5WPbeNTT3jssdHOP8XqlB2mbdmEUcvwoYHcqvwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068138; c=relaxed/simple;
	bh=j+Yo8nFpS7pHh1kQJNwBXRxopgCs0fFOKDmdFrqJxDA=;
	h=Date:To:From:Subject:Message-Id; b=mDgCPjdxWa93Zm9Yjq+gcQEc/FVpuwfqW59QEy4AB0G1xCGtk0kcAn5tZ/sI4p25Byja/Ya6WFiuIhX3RiHk8hIFYhMeb3Hhp4eSkTPOzrUH4/73fW8iLDuY/fXhRz2KmCNKqBBJhi/XMjt69w/nxhdPwAjd13t9nPRrkJO6cgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EcLEKjCn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EcLEKjCn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3279A1F000E9;
	Fri,  7 Aug 2026 02:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068137;
	bh=L5njEC7snHwsz6PsevOyuynTZmRaaeTJV+/JJLb3DuA=;
	h=Date:To:From:Subject;
	b=EcLEKjCnmXoomp86OUgI7M/dHcTrMbA/sOZMJvtlbsrVOR2pxA+nv19sEQtDpF+2j
	 BcYZ4MVpaQNb04UNBU/m0FnA/eSxDAAu6MVHw1YLzsbRC8vB/ym0dBpRMH9T5vWZUz
	 LLIdvrzELSufC7x+/GzL1sy9UAIhaVxfp4fRqoT4=
Date: Thu, 06 Aug 2026 19:02:16 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,jannh@google.com,harry@kernel.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-batch-unmap-file-folios-belonging-to-uffd-wp-vmas.patch removed from -mm tree
Message-Id: <20260807020217.3279A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: batch unmap file folios belonging to uffd-wp VMAs
has been removed from the -mm tree.  Its filename was
     mm-rmap-batch-unmap-file-folios-belonging-to-uffd-wp-vmas.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm/rmap: batch unmap file folios belonging to uffd-wp VMAs
Date: Mon, 20 Jul 2026 06:55:07 +0000

Commit a67fe41e214f ("mm: rmap: support batched unmapping for file large
folios") extended batched unmapping for file folios.  That also required
making pte_install_uffd_wp_if_needed() support batching, but that was left
out for the time being.  Correctness was maintained by stopping batching
if the VMA the folio belongs to is marked uffd-wp.

Now that cond_install_uffd_wp_ptes() supports batching, call it with the
full batch length and allow folio_unmap_pte_batch() to batch file folios
belonging to uffd-wp VMAs.

For file folios, if the uffd-wp bit is set, unmapping converts present
PTEs into uffd-wp markers.  We must ensure that the same PTE range is not
reprocessed by the try_to_unmap_one() loop.

The page_vma_mapped_walk API ensures this: check_pte() only returns true
if any PFN in [pvmw->pfn, pvmw->pfn + nr_pages) is mapped by the PTE. 
There is no PFN underlying a uffd-wp marker PTE, so check_pte() returns
false and the walk skips ahead until it reaches a present entry again.

Link: https://lore.kernel.org/20260720065508.2695106-4-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/rmap.c~mm-rmap-batch-unmap-file-folios-belonging-to-uffd-wp-vmas
+++ a/mm/rmap.c
@@ -1965,9 +1965,6 @@ static inline unsigned int folio_unmap_p
 	if (pte_unused(pte))
 		return 1;
 
-	if (userfaultfd_protected(vma))
-		return 1;
-
 	/*
 	 * If unmap fails, we need to restore the ptes. To avoid accidentally
 	 * upgrading write permissions for ptes that were not originally
@@ -2345,7 +2342,8 @@ static bool try_to_unmap_one(struct foli
 		 * we may want to replace a none pte with a marker pte if
 		 * it's file-backed, so we don't lose the tracking info.
 		 */
-		cond_install_uffd_wp_ptes(vma, address, pvmw.pte, pteval, 1);
+		cond_install_uffd_wp_ptes(vma, address, pvmw.pte, pteval,
+					  nr_pages);
 
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
_

Patches currently in -mm which might be from dev.jain@arm.com are


