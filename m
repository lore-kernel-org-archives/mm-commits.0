Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406B42F7AD4;
	Mon, 24 Nov 2025 23:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025799; cv=none; b=Uaa6cm2O+4lQQ/rq+E0grWTwiFe6SCQJueezXxNYzA6WYUnzb52sohff8k9h6aGJe5i2R9Je3ymfHG8D31y3LWdSzG0uOW6+xa8jz7+RPzZJK+Ks7IniW8q2EW/SW7Y2Gq11hLDKTnjYhuqQUzy144bGhZoiDaD6ibqkARPXznU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025799; c=relaxed/simple;
	bh=Q1OSOL5z3BLP0C9pzIqeq1yBSqHerbhkTaYnhH19Rxk=;
	h=Date:To:From:Subject:Message-Id; b=fGCBJAnfnZ9uUFy7bWd8NGPd1wfs8IZN7ZINklByRLqJisAT1IA5pSLaOkxxzw6itrJcXieOEqVd0L/asY7CDFqo76TWYXg00wv/xZr0LXHFhig6+TuWrXqN7WnI+FHXuvyQiaZ7HBn/cHwH9Abm0HfosNmj3LK0Zmie/xzTyEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qrEUjJDm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qrEUjJDm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12727C4CEF1;
	Mon, 24 Nov 2025 23:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025799;
	bh=Q1OSOL5z3BLP0C9pzIqeq1yBSqHerbhkTaYnhH19Rxk=;
	h=Date:To:From:Subject:From;
	b=qrEUjJDmzMx3SBVFwDqTyaw0zUO760HlYqy/caW3j+6Gkn7mdr7tVX2gllbq/2hJy
	 A+N8OGaepuCCJFAGNWNRVH3zL+1+u9hzxiyTn5tbHjONRTKyNU6q7QLjMpL55MPvf2
	 N5Fiy/0GoAfmuxBybBsmMcrM86V/MbohZi3x2H7M=
Date: Mon, 24 Nov 2025 15:09:58 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,usamaarif642@gmail.com,stable@vger.kernel.org,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-add-pmd-folio-to-ds_queue-in-do_huge_zero_wp_pmd.patch removed from -mm tree
Message-Id: <20251124230959.12727C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: add pmd folio to ds_queue in do_huge_zero_wp_pmd()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-add-pmd-folio-to-ds_queue-in-do_huge_zero_wp_pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-add-pmd-folio-to-ds_queue-in-do_huge_zero_wp_pmd
+++ a/mm/huge_memory.c
@@ -1233,6 +1233,7 @@ static void map_anon_folio_pmd(struct fo
 	count_vm_event(THP_FAULT_ALLOC);
 	count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
 	count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
+	deferred_split_folio(folio, false);
 }
 
 static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
@@ -1273,7 +1274,6 @@ static vm_fault_t __do_huge_pmd_anonymou
 		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
 		map_anon_folio_pmd(folio, vmf->pmd, vma, haddr);
 		mm_inc_nr_ptes(vma->vm_mm);
-		deferred_split_folio(folio, false);
 		spin_unlock(vmf->ptl);
 	}
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


