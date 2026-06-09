Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40762DB794;
	Tue,  9 Jun 2026 01:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780968159; cv=none; b=LY60PEPKSeWiE7fjGmCutzOsfB5Ca6BPXMNoWlAxq27Z9eivotNc3s9WeDHIbm0JySNtD9WfRAnYuLt/7SqqTYY6koCFf3bfcakUKNw7GsgWPoz1FinoOqp6N4kHiGd71J5arc34MVNTklBuBnHhnf7L13pAwpe3MDFuyKArPhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780968159; c=relaxed/simple;
	bh=0/pU0T32yhrn+Prq2euJjruRynrpstLKIUHqv+nStBc=;
	h=Date:To:From:Subject:Message-Id; b=RhR2ANL4V77ZDgtlOSm5KKIi+jtORpuhWlQXov5ipgZVOv7nmlvPfbXf7Rr332U9JXjN71D6ad2+SPPC49idCdQPuhIUPeW+3ZlMnkWiwz8JE0pdjlUh9pC7bVlOd0CIwWaLrCbubNo8Hh1vuk94bVl1qQnxRwgM61Ez4P72jR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1nRYTwZp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1nRYTwZp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683A11F00893;
	Tue,  9 Jun 2026 01:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780968157;
	bh=TLCtaTwikNW12yThybfLtmd5l/qdYq/yi/dOdDes9V8=;
	h=Date:To:From:Subject;
	b=1nRYTwZpuwLcW1pljzuwprP5X3H2arQyJkaWf3ESAbAW1UXjzc5+WD1Gh3q0TTPpB
	 1+xhbPYEwhC0vMDWuX2Rkr2A6XVO81IgnAShWUd1r+Fp5t+yRqmVxgbIGgaavBWD7c
	 sWY7+owRlN+Iz+5lR4+XPUMc5wdldTtGOW39bgzw=
Date: Mon, 08 Jun 2026 18:22:37 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,sashiko-bot@kernel.org,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,ljs@kernel.org,david@kernel.org,balbirs@nvidia.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-proc-task_mmu-fix-hugetlb-self-deadlock-in-pagemap_scan_pte_hole.patch removed from -mm tree
Message-Id: <20260609012237.683A11F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/task_mmu: fix hugetlb self-deadlock in pagemap_scan_pte_hole()
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-fix-hugetlb-self-deadlock-in-pagemap_scan_pte_hole.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: fs/proc/task_mmu: fix hugetlb self-deadlock in pagemap_scan_pte_hole()
Date: Fri, 29 May 2026 18:23:27 +0100

A PAGEMAP_SCAN ioctl requesting PM_SCAN_WP_MATCHING on a hugetlb VMA hangs
the calling thread, unkillably, as soon as the scan reaches an unpopulated
part of the range:

  do_pagemap_scan()
    walk_page_range()
      walk_hugetlb_range()
        hugetlb_vma_lock_read()           # take the vma lock for read ...
        pagemap_scan_pte_hole()           # ... ->pte_hole() for a hole
          uffd_wp_range()
            change_protection()
              hugetlb_change_protection()
                hugetlb_vma_lock_write()  # ... and block taking it for write

walk_hugetlb_range() holds the hugetlb vma lock for read across the whole
walk.  A present entry goes to ->hugetlb_entry(); an unpopulated one goes
to ->pte_hole(), i.e.  pagemap_scan_pte_hole().  To write-protect the hole
that handler calls uffd_wp_range(), which on a hugetlb VMA reaches
hugetlb_change_protection() and takes the same vma lock for write.  The
thread then blocks in down_write() waiting for the read lock it is itself
holding.

The populated path avoids this: pagemap_scan_hugetlb_entry()
write-protects the entry inline under the page-table lock and never enters
hugetlb_change_protection().

Do the same for holes.  Fault in the page table and install the uffd-wp
marker directly with make_uffd_wp_huge_pte() under the page-table lock,
rather than routing through uffd_wp_range().  That is the same sequence
hugetlb_change_protection() runs for an unpopulated entry, minus the vma
write lock -- which is safe to skip because PMD sharing is disabled on
uffd-wp VMAs (hugetlb_unshare_all_pmds() runs at registration), leaving
nothing for that lock to serialise against.

Link: https://lore.kernel.org/20260529172331.356655-4-kas@kernel.org
Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Assisted-by: Claude:claude-opus-4-8
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   59 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 58 insertions(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-fix-hugetlb-self-deadlock-in-pagemap_scan_pte_hole
+++ a/fs/proc/task_mmu.c
@@ -2977,8 +2977,62 @@ out_unlock:
 
 	return ret;
 }
+
+/*
+ * Write-protect the unpopulated hugetlb entries covering [addr, end) by
+ * installing uffd-wp markers inline, exactly as pagemap_scan_hugetlb_entry()
+ * does for populated entries.
+ *
+ * walk_hugetlb_range() currently calls ->pte_hole() once per huge page, so the
+ * loop normally runs a single iteration; it is written to cover the full range
+ * in case the walker ever coalesces adjacent holes.
+ *
+ * The obvious route -- uffd_wp_range() -> hugetlb_change_protection() --
+ * cannot be used here: it takes hugetlb_vma_lock_write(), but the page-table
+ * walker (walk_hugetlb_range()) already holds hugetlb_vma_lock_read() on the
+ * same VMA, so the scanning thread would deadlock against itself. PMD sharing
+ * is disabled on uffd-wp VMAs (hugetlb_unshare_all_pmds() at registration), so
+ * the vma lock guards nothing that matters for these entries anyway.
+ */
+static int pagemap_scan_hugetlb_hole_wp(struct vm_area_struct *vma,
+					unsigned long addr, unsigned long end)
+{
+	struct hstate *h = hstate_vma(vma);
+	unsigned long psize = huge_page_size(h);
+	struct mm_struct *mm = vma->vm_mm;
+	spinlock_t *ptl;
+	pte_t *ptep;
+	pte_t pte;
+
+	for (addr = ALIGN_DOWN(addr, psize); addr < end; addr += psize) {
+		ptep = huge_pte_alloc(mm, vma, addr, psize);
+		if (!ptep)
+			return -ENOMEM;
+
+		i_mmap_lock_write(vma->vm_file->f_mapping);
+		ptl = huge_pte_lock(h, mm, ptep);
+		pte = huge_ptep_get(mm, addr, ptep);
+		make_uffd_wp_huge_pte(vma, addr, ptep, pte);
+		/*
+		 * A none entry has no cached translation, so installing the
+		 * marker needs no TLB flush. Flush only if a fault populated
+		 * the entry between huge_pte_alloc() and the page table lock.
+		 */
+		if (!huge_pte_none(pte))
+			flush_hugetlb_tlb_range(vma, addr, addr + psize);
+		spin_unlock(ptl);
+		i_mmap_unlock_write(vma->vm_file->f_mapping);
+	}
+
+	return 0;
+}
 #else
 #define pagemap_scan_hugetlb_entry NULL
+static int pagemap_scan_hugetlb_hole_wp(struct vm_area_struct *vma,
+					unsigned long addr, unsigned long end)
+{
+	return 0;
+}
 #endif
 
 static int pagemap_scan_pte_hole(unsigned long addr, unsigned long end,
@@ -2998,7 +3052,10 @@ static int pagemap_scan_pte_hole(unsigne
 	if (~p->arg.flags & PM_SCAN_WP_MATCHING)
 		return ret;
 
-	err = uffd_wp_range(vma, addr, end - addr, true);
+	if (is_vm_hugetlb_page(vma))
+		err = pagemap_scan_hugetlb_hole_wp(vma, addr, end);
+	else
+		err = uffd_wp_range(vma, addr, end - addr, true);
 	if (err < 0)
 		ret = err;
 
_

Patches currently in -mm which might be from kas@kernel.org are


