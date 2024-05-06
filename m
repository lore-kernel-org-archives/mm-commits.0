Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1DC25757
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957086; cv=none; b=GLNsAeHkFV0jHFYcms0y+ZDpO7NVom4uNGqSOqUd3cJtAkk+Ju/lAv1fEKKmef7WZWc+k6m0ePP18OKdWNHw+q3KbISqBDmzEwP2rNhkyOUyiNiNEiosty4qTOe4MB9/kYHkWdhggBXd5IhsJ+s8BBEpJ0EypdY4iVx+v17KLvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957086; c=relaxed/simple;
	bh=hJLbZ/mpnTxJOtW2Q2vocgk+2Jm3hd3lfDWZfPf3wiI=;
	h=Date:To:From:Subject:Message-Id; b=aeWGH5AYrBlGr03Iif4Kto7S21t4oCsYGOrps+HaQyd+Ump5bo8wgviRPLK4+Ya07UZwFGOSOoEpZBROhhGK818HsEsINNzNTf+7eKePYZjKvorvZ7mwr5aFdCYVmwMwq4mhKd+tJqmRWrFBALnVCg8uxLasggDxRiTXSyHgUio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S2IdxZAY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S2IdxZAY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1328FC116B1;
	Mon,  6 May 2024 00:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957086;
	bh=hJLbZ/mpnTxJOtW2Q2vocgk+2Jm3hd3lfDWZfPf3wiI=;
	h=Date:To:From:Subject:From;
	b=S2IdxZAYHs1B/WbjbBjBFH2+Bb2jvYKbMxgeL5cqOrbbup7Kl8apJzrabYV0KQdFi
	 ZN3Z1D+b3Twzlk1Vo41uXkb4k1zhRaGhKWipKUEuowBP63EYT2Yt9nMDz3k34GXl6B
	 gqFzu8x0MDJ1OjNuUDKAY4fy6ZB86yTOzcyGjnBs=
Date: Sun, 05 May 2024 17:58:05 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,linmiaohe@huawei.com,jane.chu@oracle.com,dan.j.williams@intel.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-return-the-address-from-page_mapped_in_vma.patch removed from -mm tree
Message-Id: <20240506005806.1328FC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: return the address from page_mapped_in_vma()
has been removed from the -mm tree.  Its filename was
     mm-return-the-address-from-page_mapped_in_vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: return the address from page_mapped_in_vma()
Date: Fri, 12 Apr 2024 20:35:00 +0100

The only user of this function calls page_address_in_vma() immediately
after page_mapped_in_vma() calculates it and uses it to return true/false.
Return the address instead, allowing memory-failure to skip the call to
page_address_in_vma().

Link: https://lkml.kernel.org/r/20240412193510.2356957-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    2 +-
 mm/memory-failure.c  |   22 +++++++++++++---------
 mm/page_vma_mapped.c |   16 +++++++++-------
 3 files changed, 23 insertions(+), 17 deletions(-)

--- a/include/linux/rmap.h~mm-return-the-address-from-page_mapped_in_vma
+++ a/include/linux/rmap.h
@@ -730,7 +730,7 @@ int pfn_mkclean_range(unsigned long pfn,
 
 void remove_migration_ptes(struct folio *src, struct folio *dst, bool locked);
 
-int page_mapped_in_vma(struct page *page, struct vm_area_struct *vma);
+unsigned long page_mapped_in_vma(struct page *page, struct vm_area_struct *vma);
 
 /*
  * rmap_walk_control: To control rmap traversing for specific needs
--- a/mm/memory-failure.c~mm-return-the-address-from-page_mapped_in_vma
+++ a/mm/memory-failure.c
@@ -473,10 +473,11 @@ static void __add_to_kill(struct task_st
 }
 
 static void add_to_kill_anon_file(struct task_struct *tsk, struct page *p,
-				  struct vm_area_struct *vma,
-				  struct list_head *to_kill)
+		struct vm_area_struct *vma, struct list_head *to_kill,
+		unsigned long addr)
 {
-	unsigned long addr = page_address_in_vma(p, vma);
+	if (addr == -EFAULT)
+		return;
 	__add_to_kill(tsk, p, vma, to_kill, addr);
 }
 
@@ -601,7 +602,6 @@ struct task_struct *task_early_kill(stru
 static void collect_procs_anon(struct folio *folio, struct page *page,
 		struct list_head *to_kill, int force_early)
 {
-	struct vm_area_struct *vma;
 	struct task_struct *tsk;
 	struct anon_vma *av;
 	pgoff_t pgoff;
@@ -613,8 +613,10 @@ static void collect_procs_anon(struct fo
 	pgoff = page_to_pgoff(page);
 	rcu_read_lock();
 	for_each_process(tsk) {
+		struct vm_area_struct *vma;
 		struct anon_vma_chain *vmac;
 		struct task_struct *t = task_early_kill(tsk, force_early);
+		unsigned long addr;
 
 		if (!t)
 			continue;
@@ -623,9 +625,8 @@ static void collect_procs_anon(struct fo
 			vma = vmac->vma;
 			if (vma->vm_mm != t->mm)
 				continue;
-			if (!page_mapped_in_vma(page, vma))
-				continue;
-			add_to_kill_anon_file(t, page, vma, to_kill);
+			addr = page_mapped_in_vma(page, vma);
+			add_to_kill_anon_file(t, page, vma, to_kill, addr);
 		}
 	}
 	rcu_read_unlock();
@@ -648,6 +649,7 @@ static void collect_procs_file(struct fo
 	pgoff = page_to_pgoff(page);
 	for_each_process(tsk) {
 		struct task_struct *t = task_early_kill(tsk, force_early);
+		unsigned long addr;
 
 		if (!t)
 			continue;
@@ -660,8 +662,10 @@ static void collect_procs_file(struct fo
 			 * Assume applications who requested early kill want
 			 * to be informed of all such data corruptions.
 			 */
-			if (vma->vm_mm == t->mm)
-				add_to_kill_anon_file(t, page, vma, to_kill);
+			if (vma->vm_mm != t->mm)
+				continue;
+			addr = page_address_in_vma(page, vma);
+			add_to_kill_anon_file(t, page, vma, to_kill, addr);
 		}
 	}
 	rcu_read_unlock();
--- a/mm/page_vma_mapped.c~mm-return-the-address-from-page_mapped_in_vma
+++ a/mm/page_vma_mapped.c
@@ -319,11 +319,12 @@ next_pte:
  * @page: the page to test
  * @vma: the VMA to test
  *
- * Returns 1 if the page is mapped into the page tables of the VMA, 0
- * if the page is not mapped into the page tables of this VMA.  Only
- * valid for normal file or anonymous VMAs.
+ * Return: The address the page is mapped at if the page is in the range
+ * covered by the VMA and present in the page table.  If the page is
+ * outside the VMA or not present, returns -EFAULT.
+ * Only valid for normal file or anonymous VMAs.
  */
-int page_mapped_in_vma(struct page *page, struct vm_area_struct *vma)
+unsigned long page_mapped_in_vma(struct page *page, struct vm_area_struct *vma)
 {
 	struct folio *folio = page_folio(page);
 	pgoff_t pgoff = folio->index + folio_page_idx(folio, page);
@@ -336,9 +337,10 @@ int page_mapped_in_vma(struct page *page
 
 	pvmw.address = vma_address(vma, pgoff, 1);
 	if (pvmw.address == -EFAULT)
-		return 0;
+		goto out;
 	if (!page_vma_mapped_walk(&pvmw))
-		return 0;
+		return -EFAULT;
 	page_vma_mapped_walk_done(&pvmw);
-	return 1;
+out:
+	return pvmw.address;
 }
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

