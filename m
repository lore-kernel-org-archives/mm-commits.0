Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA2422129F
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343176; cv=none; b=az92fLrJF7bbLPxTkEyRV+NSLFto0FtgCdPaQNEa+Fk96L5wJWcJ/Cx9f4EGb7J9MNJgSndEM4etMcQhQQlxS1CDM+uXDUW2rw+XhrY/Ed2ba1kRNQyl5LlvZIze6ogdmq0RpFNxHL6Jsa72Pr3aPhY6+wx3tpmskhPjAgquBqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343176; c=relaxed/simple;
	bh=bvhWS1XL27oEPYvSw7Iy25tZmqKr7U1wAJpJyKUPZLk=;
	h=Date:To:From:Subject:Message-Id; b=Q2CCvOfb8SjJ32PBfWY9pF5C+JqQYw5fEgLvA7UeDFTIwHUVEJjoUEj3AuAdYYum0Z7khZcMyGR+tvKo13oEblZkvuYUkxjeg9qJlWmw15s8A23uhGigSxSzSgjw1Eh124GGt5xpKtU+AdKz/+5L4LPQqlhCGW8zxTtX8X9xI9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oRYsnkfA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oRYsnkfA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF9D5C113D0;
	Mon, 17 Nov 2025 01:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343176;
	bh=bvhWS1XL27oEPYvSw7Iy25tZmqKr7U1wAJpJyKUPZLk=;
	h=Date:To:From:Subject:From;
	b=oRYsnkfAq08K0a35S17QHbqtz5mbebAnZS4rLaGg57VM0hgpPLtS19vB/4H6pu5rE
	 r8BHh4LBl1iWCJR+AeRsz6CnYFPJ0Iq20v74fSsPHCxkFr2d5M4LTKUFEpdKsD7Yl6
	 shogPHbBovQnqsdToKbmWeoROK+Kre8cZV7x2ldQ=
Date: Sun, 16 Nov 2025 17:32:55 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vishal.l.verma@intel.com,viro@zeniv.linux.org.uk,vgoyal@redhat.com,vbabka@suse.cz,urezki@gmail.com,tsbogend@alpha.franken.de,tony.luck@intel.com,svens@linux.ibm.com,surenb@google.com,sumanthk@linux.ibm.com,rppt@kernel.org,robin.murphy@arm.com,reinette.chatre@intel.com,pfalcato@suse.de,osalvador@suse.de,nico@fluxnic.net,muchun.song@linux.dev,mhocko@suse.com,liam.howlett@oracle.com,kevin.tian@intel.com,jgg@nvidia.com,jannh@google.com,james.morse@arm.com,jack@suse.cz,hughd@google.com,hca@linux.ibm.com,guoren@kernel.org,gregkh@linuxfoundation.org,gor@linux.ibm.com,dyoung@redhat.com,dvyukov@google.com,david@redhat.com,davem@davemloft.net,dave.martin@arm.com,dave.jiang@intel.com,dan.j.williams@intel.com,corbet@lwn.net,brauner@kernel.org,borntraeger@linux.ibm.com,bhe@redhat.com,baolin.wang@linux.alibaba.com,arnd@arndb.de,andreyknvl@gmail.com,andreas@gaisler.com,almaz.alexandrovich@paragon-software.com,agordeev@linux.ibm.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-remove-unused-function-make-internal-functions-static.patch removed from -mm tree
Message-Id: <20251117013255.DF9D5C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: remove unused function, make internal functions static
has been removed from the -mm tree.  Its filename was
     mm-vma-remove-unused-function-make-internal-functions-static.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/vma: remove unused function, make internal functions static
Date: Mon, 20 Oct 2025 13:11:20 +0100

unlink_file_vma() is not used by anything, so remove it.

vma_link() and vma_link_file() are only used within mm/vma.c, so make them
static.

Link: https://lkml.kernel.org/r/f2ab9ea051225a02e6d1d45a7608f4e149220117.1760959442.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Chatre, Reinette <reinette.chatre@intel.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dave Martin <dave.martin@arm.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Morse <james.morse@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Robin Murohy <robin.murphy@arm.com>
Cc: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   21 ++-------------------
 mm/vma.h |    6 ------
 2 files changed, 2 insertions(+), 25 deletions(-)

--- a/mm/vma.c~mm-vma-remove-unused-function-make-internal-functions-static
+++ a/mm/vma.c
@@ -1754,24 +1754,7 @@ void unlink_file_vma_batch_final(struct
 		unlink_file_vma_batch_process(vb);
 }
 
-/*
- * Unlink a file-based vm structure from its interval tree, to hide
- * vma from rmap and vmtruncate before freeing its page tables.
- */
-void unlink_file_vma(struct vm_area_struct *vma)
-{
-	struct file *file = vma->vm_file;
-
-	if (file) {
-		struct address_space *mapping = file->f_mapping;
-
-		i_mmap_lock_write(mapping);
-		__remove_shared_vm_struct(vma, mapping);
-		i_mmap_unlock_write(mapping);
-	}
-}
-
-void vma_link_file(struct vm_area_struct *vma)
+static void vma_link_file(struct vm_area_struct *vma)
 {
 	struct file *file = vma->vm_file;
 	struct address_space *mapping;
@@ -1784,7 +1767,7 @@ void vma_link_file(struct vm_area_struct
 	}
 }
 
-int vma_link(struct mm_struct *mm, struct vm_area_struct *vma)
+static int vma_link(struct mm_struct *mm, struct vm_area_struct *vma)
 {
 	VMA_ITERATOR(vmi, mm, 0);
 
--- a/mm/vma.h~mm-vma-remove-unused-function-make-internal-functions-static
+++ a/mm/vma.h
@@ -312,12 +312,6 @@ void unlink_file_vma_batch_final(struct
 void unlink_file_vma_batch_add(struct unlink_vma_file_batch *vb,
 			       struct vm_area_struct *vma);
 
-void unlink_file_vma(struct vm_area_struct *vma);
-
-void vma_link_file(struct vm_area_struct *vma);
-
-int vma_link(struct mm_struct *mm, struct vm_area_struct *vma);
-
 struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	unsigned long addr, unsigned long len, pgoff_t pgoff,
 	bool *need_rmap_locks);
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-introduce-vm_maybe_guard-and-make-visible-in-proc-pid-smaps.patch
mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such.patch
mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such-fix.patch
mm-implement-sticky-vma-flags.patch
mm-introduce-copy-on-fork-vmas-and-make-vm_maybe_guard-one.patch
mm-set-the-vm_maybe_guard-flag-on-guard-region-install.patch
mm-set-the-vm_maybe_guard-flag-on-guard-region-install-fix.patch
tools-testing-vma-add-vma-sticky-userland-tests.patch
tools-testing-selftests-mm-add-madv_collapse-test-case.patch
tools-testing-selftests-mm-add-smaps-visibility-guard-region-test.patch
mm-correctly-handle-uffd-pte-markers.patch
mm-introduce-leaf-entry-type-and-use-to-simplify-leaf-entry-logic.patch
mm-avoid-unnecessary-uses-of-is_swap_pte.patch
mm-eliminate-is_swap_pte-when-softleaf_from_pte-suffices.patch
mm-use-leaf-entries-in-debug-pgtable-remove-is_swap_pte.patch
fs-proc-task_mmu-refactor-pagemap_pmd_range.patch
mm-avoid-unnecessary-use-of-is_swap_pmd.patch
mm-huge_memory-refactor-copy_huge_pmd-non-present-logic.patch
mm-huge_memory-refactor-change_huge_pmd-non-present-logic.patch
mm-replace-pmd_to_swp_entry-with-softleaf_from_pmd.patch
mm-introduce-pmd_is_huge-and-use-where-appropriate.patch
mm-remove-remaining-is_swap_pmd-users-and-is_swap_pmd.patch
mm-remove-non_swap_entry-and-use-softleaf-helpers-instead.patch
mm-remove-is_hugetlb_entry_.patch
mm-eliminate-further-swapops-predicates.patch
mm-replace-remaining-pte_to_swp_entry-with-softleaf_from_pte.patch
mm-rename-walk_page_range_mm.patch
mm-madvise-allow-guard-page-install-remove-under-vma-lock.patch
mm-propagate-vm_softdirty-on-merge.patch
testing-selftests-mm-add-soft-dirty-merge-self-test.patch
mm-declare-vma-flags-by-bit.patch
mm-declare-vma-flags-by-bit-fix.patch
mm-declare-vma-flags-by-bit-fix-2.patch
mm-simplify-and-rename-mm-flags-function-for-clarity.patch
tools-testing-vma-eliminate-dependency-on-vma-__vm_flags.patch
mm-introduce-vma-flags-bitmap-type.patch

