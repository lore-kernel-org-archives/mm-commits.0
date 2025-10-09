Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9143154BE2;
	Thu,  9 Oct 2025 04:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759982995; cv=none; b=sOwEpp1NkKp4uxr06hbpUz9u3FFCRzabarbACrAIDSrAplAjIeoomFdD5ouqTp3+3uWhqdvqIcdc6XhGh+fCe3nx6BLHO/1kuWBLEeRs19zzwGkDSDUfL8jVeroDodDgrkyUJ5XRD1XusC0tdiFWwQr7BZlX3jY3UaAWcKOyUNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759982995; c=relaxed/simple;
	bh=76GtxTQ9g8hb2HTgrV261GUqJcKp2bKqR5EmQDQA3fw=;
	h=Date:To:From:Subject:Message-Id; b=u/D5MHkQJP73924C/PJSYjIr09s0nOYLVH/JwNgdY6uunmAr3Tk/U3wGvF2puLU0wR3rUqV1BCjY4RMPUrv9z4uRcX6w0cGcKCqPca+gWFMpAewX+ukjnQw4Ds4RcMRBRYPL7Oq5hRS1IJJ9B6BU8RqCumvZZIUpj22JMRSursQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JP2SWXsP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JP2SWXsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66108C4CEE7;
	Thu,  9 Oct 2025 04:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759982995;
	bh=76GtxTQ9g8hb2HTgrV261GUqJcKp2bKqR5EmQDQA3fw=;
	h=Date:To:From:Subject:From;
	b=JP2SWXsP56WqouBVdjSGEXCsCRVrxc5cpqZF4Mos7Ttt1Y/9BtpkZ9tq19fGAzNBt
	 0BsudSkDZFdbxq5KCQ5v9dci2gv4n1CRlvdCtCpxetzo02pmhSm/1HuMhEZ6Sq87Ue
	 aUCYcuD5f7mZcb3L69sDAEfuR3csr2hQZrFxiblc=
Date: Wed, 08 Oct 2025 21:09:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,usamaarif642@gmail.com,stable@vger.kernel.org,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-add-pmd-folio-to-ds_queue-in-do_huge_zero_wp_pmd.patch added to mm-new branch
Message-Id: <20251009040955.66108C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: add pmd folio to ds_queue in do_huge_zero_wp_pmd()
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-add-pmd-folio-to-ds_queue-in-do_huge_zero_wp_pmd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-add-pmd-folio-to-ds_queue-in-do_huge_zero_wp_pmd.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/huge_memory: add pmd folio to ds_queue in do_huge_zero_wp_pmd()
Date: Wed, 8 Oct 2025 09:54:52 +0000

We add pmd folio into ds_queue on the first page fault in
__do_huge_pmd_anonymous_page(), so that we can split it in case of memory
pressure.  This should be the same for a pmd folio during wp page fault.

Commit 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault") miss to
add it to ds_queue, which means system may not reclaim enough memory in
case of memory pressure even the pmd folio is under used.

Move deferred_split_folio() into map_anon_folio_pmd() to make the pmd
folio installation consistent.

Link: https://lkml.kernel.org/r/20251008095453.18772-2-richard.weiyang@gmail.com
Fixes: 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-add-pmd-folio-to-ds_queue-in-do_huge_zero_wp_pmd
+++ a/mm/huge_memory.c
@@ -1317,6 +1317,7 @@ static void map_anon_folio_pmd(struct fo
 	count_vm_event(THP_FAULT_ALLOC);
 	count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
 	count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
+	deferred_split_folio(folio, false);
 }
 
 static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
@@ -1357,7 +1358,6 @@ static vm_fault_t __do_huge_pmd_anonymou
 		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
 		map_anon_folio_pmd(folio, vmf->pmd, vma, haddr);
 		mm_inc_nr_ptes(vma->vm_mm);
-		deferred_split_folio(folio, false);
 		spin_unlock(vmf->ptl);
 	}
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-compaction-check-the-range-to-pageblock_pfn_to_page-is-within-the-zone-first.patch
mm-compaction-fix-the-range-to-pageblock_pfn_to_page.patch
mm-huge_memory-add-pmd-folio-to-ds_queue-in-do_huge_zero_wp_pmd.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd.patch

