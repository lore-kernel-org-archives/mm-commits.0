Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16ED512B93;
	Fri, 29 Dec 2023 19:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d3ZFvyjK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4EF3C433C8;
	Fri, 29 Dec 2023 19:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703876849;
	bh=wB9g3K5uRJDJKPewUbc3L9soV5ziv4h2s0ZAqdBR+ek=;
	h=Date:To:From:Subject:From;
	b=d3ZFvyjKpYN0iXsFYFZAio2x8DgAOELIz/QoF3N7Y9vx5Ez26SRJDMuucF6wBeHFD
	 TbDlZWfB5xFBigqxUCPiiYBppTM37GB9ZPPlLbuKWHQpBlF9A2MXd7/16HkzTzM1ou
	 PPltI4QgoLod7OOJebpOFua34WI7tIv0CviJGmeM=
Date: Fri, 29 Dec 2023 11:07:29 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mglru-skip-special-vmas-in-lru_gen_look_around.patch removed from -mm tree
Message-Id: <20231229190729.C4EF3C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: skip special VMAs in lru_gen_look_around()
has been removed from the -mm tree.  Its filename was
     mm-mglru-skip-special-vmas-in-lru_gen_look_around.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm/mglru: skip special VMAs in lru_gen_look_around()
Date: Fri, 22 Dec 2023 21:56:47 -0700

Special VMAs like VM_PFNMAP can contain anon pages from COW.  There isn't
much profit in doing lookaround on them.  Besides, they can trigger the
pte_special() warning in get_pte_pfn().

Skip them in lru_gen_look_around().

Link: https://lkml.kernel.org/r/20231223045647.1566043-1-yuzhao@google.com
Fixes: 018ee47f1489 ("mm: multi-gen LRU: exploit locality in rmap")
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reported-by: syzbot+03fd9b3f71641f0ebf2d@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/000000000000f9ff00060d14c256@google.com/
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/mm/vmscan.c~mm-mglru-skip-special-vmas-in-lru_gen_look_around
+++ a/mm/vmscan.c
@@ -3955,6 +3955,7 @@ void lru_gen_look_around(struct page_vma
 	int young = 0;
 	pte_t *pte = pvmw->pte;
 	unsigned long addr = pvmw->address;
+	struct vm_area_struct *vma = pvmw->vma;
 	struct folio *folio = pfn_folio(pvmw->pfn);
 	bool can_swap = !folio_is_file_lru(folio);
 	struct mem_cgroup *memcg = folio_memcg(folio);
@@ -3969,11 +3970,15 @@ void lru_gen_look_around(struct page_vma
 	if (spin_is_contended(pvmw->ptl))
 		return;
 
+	/* exclude special VMAs containing anon pages from COW */
+	if (vma->vm_flags & VM_SPECIAL)
+		return;
+
 	/* avoid taking the LRU lock under the PTL when possible */
 	walk = current->reclaim_state ? current->reclaim_state->mm_walk : NULL;
 
-	start = max(addr & PMD_MASK, pvmw->vma->vm_start);
-	end = min(addr | ~PMD_MASK, pvmw->vma->vm_end - 1) + 1;
+	start = max(addr & PMD_MASK, vma->vm_start);
+	end = min(addr | ~PMD_MASK, vma->vm_end - 1) + 1;
 
 	if (end - start > MIN_LRU_BATCH * PAGE_SIZE) {
 		if (addr - start < MIN_LRU_BATCH * PAGE_SIZE / 2)
@@ -3998,7 +4003,7 @@ void lru_gen_look_around(struct page_vma
 		unsigned long pfn;
 		pte_t ptent = ptep_get(pte + i);
 
-		pfn = get_pte_pfn(ptent, pvmw->vma, addr);
+		pfn = get_pte_pfn(ptent, vma, addr);
 		if (pfn == -1)
 			continue;
 
@@ -4009,7 +4014,7 @@ void lru_gen_look_around(struct page_vma
 		if (!folio)
 			continue;
 
-		if (!ptep_test_and_clear_young(pvmw->vma, addr, pte + i))
+		if (!ptep_test_and_clear_young(vma, addr, pte + i))
 			VM_WARN_ON_ONCE(true);
 
 		young++;
_

Patches currently in -mm which might be from yuzhao@google.com are


