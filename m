Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794270391;
	b=H9k7/TShK+tcCtvlaTonKoPnXCqhdslNZIjFu6xARryfcITuWVKC90iyK9rRggnZzpZ3
	 j9rFvpxwai9uHSwSomOlPvxeAxMYADqaezBubrvW04WY9vJiBqYr9HnkH8/yfS4AmjvE2
	 hl4ZDGUAZXEbUCS8ategzE1dtAj/mAECMNWsdo8Z7QvwBzz7gIq9Ki7O98IqQZtNzJA3m
	 Aw8w74aSe+X2uxay9msTZEsn9vStRUBnOF7OepywauzMZgM+F7oMM8U2do2KJEJWkruh6
	 Dfxul+Xc78ZvyA08+iZCWyloUFbBPyT8iUXgFgRCeNSTrIc9CRq3aYTrEgYnYVeJi2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794270391;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=qabSgjJUBX2Oz+uaRG2lMApO+AcZr478dEqj1/UW1bs=;
	b=lkALOVvB8U22JzcJR3idAWMBgXCnYPgJuZV4A8U6UUrdh+9Dobbn7TVS27ryngTTWMyD
	 DmD95la7RlOSWNvsJ/S4FtFZDPtmQLpX0lM0hr7IO/v099hp+8MuUAGDYvDzC1zkin2b4
	 aa2/iitnibEOWCPv1J4aprHOChe/zgtNQp0o3AJ20Dy5f+154lYuSt0biNi6oc8ZA3klG
	 0WNkJw3YzKKVSo/EfTIwCqa+TlfSX/zbquFUJdGcCPy0+GY38Ba/It+RHK38DSkh/84wF
	 PhRv4nTcSGks6TbFM+EnZBW29kaIzpYE9RtfU/YI2OIaxi+klXqn3yXx50wP2F8Xn0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=NvCMMsZb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADDA606A31C;
	Tue, 10 Nov 2026 00:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=NvCMMsZb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808701F008A1;
	Tue, 10 Nov 2026 00:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794270390;
	bh=qabSgjJUBX2Oz+uaRG2lMApO+AcZr478dEqj1/UW1bs=;
	h=Date:To:From:Subject;
	b=NvCMMsZbzl+EBG755hIjTSf6wZY+yVzkKTvhdFjpruPeHr8Dc5UUllvYLlPWmMZdL
	 XxhQ9xfOgdUchp+wzsSvdLGha6vx/cmI5meWyS2ODtoBExk3jBrDXta29FUHKUFGDQ
	 bMZWWmoeOXjbdtp9WzNO77ZR//Evc1V9tgUz1+ZY=
Date: Mon, 09 Nov 2026 16:26:30 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,usama.arif@linux.dev,
	stable@vger.kernel.org,ryan.roberts@arm.com,qi.zheng@linux.dev,
	nico.pache@linux.dev,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,
	hughd@google.com,dev.jain@arm.com,baolin.wang@linux.alibaba.com,
	baohua@kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-free-unused-page-table-when-setting-a-huge-pmd-fails.patch added to mm-new branch
Message-Id: <20261110002630.808701F008A1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: free unused page table allocated by do_set_pmd()
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-free-unused-page-table-when-setting-a-huge-pmd-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-free-unused-page-table-when-setting-a-huge-pmd-fails.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm: free unused page table allocated by do_set_pmd()
Date: Wed, 4 Nov 2026 20:56:37 +0100

do_set_pmd() can allocate vmf->prealloc_pte on architectures that need a
deposited page table, such as PowerPC with the hash MMU.  If the PMD is no
longer empty when it takes the PMD lock, it returns VM_FAULT_FALLBACK
without consuming that table.

Since collapse_pte_mapped_thp() uses mmap_read_lock(), a concurrent
userfaultfd operation can install a PTE table before taking the folio
lock.  If that races with set_huge_pmd(), the unused preallocated table is
lost when its local vm_fault goes out of scope.

Track whether do_set_pmd() allocated the table and free it after dropping
the PMD lock if it was not consumed.  Preserve any preallocated table
supplied by the caller for PTE fallback.  Successful PMD installation
consumes the table and clears the pointer.

Returning without a preallocated table matches the existing behavior on
architectures that do not need a deposited table.  All callers already
handle that case.

Link: https://lore.kernel.org/c13cdd25-7d7b-4059-a22d-af0a48fabaac@kernel.org
Fixes: 1043173eb5eb ("mm/khugepaged: collapse_pte_mapped_thp() with mmap_read_lock()")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
---

 mm/memory.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/memory.c~mm-khugepaged-free-unused-page-table-when-setting-a-huge-pmd-fails
+++ a/mm/memory.c
@@ -5694,6 +5694,7 @@ vm_fault_t do_set_pmd(struct vm_fault *v
 	struct vm_area_struct *vma = vmf->vma;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
+	bool pgtable_allocated = false;
 	pmd_t entry;
 	vm_fault_t ret = VM_FAULT_FALLBACK;
 
@@ -5732,6 +5733,7 @@ vm_fault_t do_set_pmd(struct vm_fault *v
 		vmf->prealloc_pte = pte_alloc_one(vma->vm_mm);
 		if (!vmf->prealloc_pte)
 			return VM_FAULT_OOM;
+		pgtable_allocated = true;
 	}
 
 	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
@@ -5762,6 +5764,10 @@ vm_fault_t do_set_pmd(struct vm_fault *v
 	count_vm_event(THP_FILE_MAPPED);
 out:
 	spin_unlock(vmf->ptl);
+	if (pgtable_allocated && vmf->prealloc_pte) {
+		pte_free(vma->vm_mm, vmf->prealloc_pte);
+		vmf->prealloc_pte = NULL;
+	}
 	return ret;
 }
 #else
_

Patches currently in -mm which might be from david@kernel.org are

mm-memory-failure-fix-folio-refcount-leak-and-min_order_for_split-locking.patch
mm-mprotect-dont-skip-uffd-marker-install-when-racing-with-pte-table-reclaim.patch
mm-khugepaged-free-unused-page-table-when-setting-a-huge-pmd-fails.patch

