Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793942357;
	b=qHFnXBcIMASWYBdXSj+782JKQ9JPDBFiI6Q1AcEYhdQMQ3FCboCQZhgFKzREvfJNiI7d
	 iurGwqusFkyOuOQyMqh324rSucP0Z4812pl7q8EmQNuaxNDCfk1qgM/Ef53Dornvlnnrz
	 4Hs0FCtM8Og6fKuI09w9Q5+6chC3+wrJ3TiTwURMlvvKJpivq4Ps7e6VBW+dar5VpAcMI
	 eM5FFySwWOV62h2F+aGNrrHHGUyTAzu+EQ5Wx8osT5qXj/2L+FPIsh466GA/SIq+fbzyQ
	 B3MlggwomJtzof+QWIvm/kIob/XeTpZh9MSnLZrr2/PbJ4jRxRyiwgeEMfR9JzB+84Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793942357;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=dw61ebh3pKK75fIixUuPM9l6xPOYIU88nwflRMiLbnk=;
	b=OoFl6RTS5jxd958vaCagG4RSgGiqxvOphoJFsX+5W/Sw1GTgOtgCIHgG6hQ4e+Jev8l6
	 qo6LQMVcPM+B0UnNp+QUYAtsKPvDoEY7nkTCtOBHgQu+6iuGkh2EsrRwPRfW/9jLUevvV
	 CJxXWxI+vGls/JOsyiULVwZRCUh/Ec2fju0THVOw3Lz9AaeQlsAJWrwE/wYxz+nFhNRUR
	 KI7xqKrfdvmiqERNI1yp76YE5zJOWQpWQBHlspx06JVNVUcisHSbubDyePqDzCWdUBdpq
	 9rVkYY+hvMW51yMjrSYadKGcuL+lF7ZMx396ENGEUyH5o6IryicQIDszrOQdoAoahRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CxbZfYJj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646FB606A32C;
	Fri,  6 Nov 2026 05:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CxbZfYJj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC571F0089F;
	Fri,  6 Nov 2026 05:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793942357;
	bh=dw61ebh3pKK75fIixUuPM9l6xPOYIU88nwflRMiLbnk=;
	h=Date:To:From:Subject;
	b=CxbZfYJjcgck4m7/XLnH56PygQkjE/+r3N8lxtuhwlsc/wXAa3llXasMnwXWQM5ZZ
	 DW+DmJltQgnoEShHiYt7TzdzNT5wMGzyx86iLSiJSkLAZwWlplD29u87kjBI22fX1h
	 83H3Wr4DUBGWZDbCxOqWPapQWjI2TRvjveixhiw8=
Date: Thu, 05 Nov 2026 21:19:16 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,usama.arif@linux.dev,
	stable@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,
	ritesh.list@gmail.com,peterx@redhat.com,nico.pache@linux.dev,
	maddy@linux.ibm.com,loic.molinari@collabora.com,ljs@kernel.org,
	liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,jgg@ziepe.ca,
	dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,
	baohua@kernel.org,azpijr@gmail.com,alex@shazbot.org,khorenko@virtuozzo.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-read-a-special-pmd-under-the-lock-in-copy_huge_pmd.patch added to mm-new branch
Message-Id: <20261106051916.EBC571F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/huge_memory: read a special PMD under the lock in copy_huge_pmd()
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-read-a-special-pmd-under-the-lock-in-copy_huge_pmd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-read-a-special-pmd-under-the-lock-in-copy_huge_pmd.patch

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
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: mm/huge_memory: read a special PMD under the lock in copy_huge_pmd()
Date: Wed, 04 Nov 2026 21:40:57 +0100

copy_huge_pmd() reads a special PMD without the page table lock and
copies that value to the child. The mmap write lock held by fork does
not stop unmap_mapping_range(): it zaps under i_mmap_rwsem and the PMD
lock.

The zap visits the parent VMA before the child's, as dup_mmap() links
the child right after the parent in i_mmap. If it clears the parent PMD
after fork has read it, and passes the child before fork copies it, the
child keeps a mapping the driver has revoked, for example:

- vfio-pci: the child reaches the BAR after the device memory was
  disabled or the device was reset, instead of getting SIGBUS;
- panthor: the child maps the pages of an evicted buffer object after
  the driver has released them.

The same branch deposits no page table under the copy. ppc64 in hash
mode keeps the hash slot array of every huge PMD in that table, so the
child dereferences a NULL table on the first hash fault, in
__hash_page_thp(), and on the zap, in hash__pmdp_huge_get_and_clear().

Take the locks first and let vm_normal_page_pmd() tell a PFN mapping
from a folio under them, as copy_present_ptes() does with
vm_normal_page(). The zap clears the parent PMD under the same lock, so
either fork finds it none and skips it, or the copy is in place before
the zap reaches the child.

The copy of a PFN mapping then goes through the same tail as a folio:

- it gets a page table where the architecture needs one;
- in a shared mapping it is marked clean in the child, as a PTE is;
- in a CoW mapping, which only VM_MIXEDMAP allows, both sides are write
  protected instead of a warning being printed.

Link: https://lore.kernel.org/20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-3-c56d0d26f970@virtuozzo.com
Fixes: bc02afbd4d73 ("mm/fork: accept huge pfnmap entries")
Fixes: d1503aa9ab80 ("powerpc/64s: Add support for huge pfnmaps")
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v1-1-d225c60bc316@virtuozzo.com?part=1
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Alex Williamson <alex@shazbot.org>
Cc: Loïc Molinari <loic.molinari@collabora.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: <stable@vger.kernel.org>
---

 mm/huge_memory.c |   24 +++---------------------
 1 file changed, 3 insertions(+), 21 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-read-a-special-pmd-under-the-lock-in-copy_huge_pmd
+++ a/mm/huge_memory.c
@@ -1961,25 +1961,6 @@ int copy_huge_pmd(struct mm_struct *dst_
 	int ret = -ENOMEM;
 	bool writable;
 
-	pmd = pmdp_get_lockless(src_pmd);
-	if (unlikely(pmd_present(pmd) && pmd_special(pmd) &&
-		     !is_huge_zero_pmd(pmd))) {
-		dst_ptl = pmd_lock(dst_mm, dst_pmd);
-		src_ptl = pmd_lockptr(src_mm, src_pmd);
-		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
-		/*
-		 * No need to recheck the pmd, it can't change with write
-		 * mmap lock held here.
-		 *
-		 * Meanwhile, making sure it's not a CoW VMA with writable
-		 * mapping, otherwise it means either the anon page wrongly
-		 * applied special bit, or we made the PRIVATE mapping be
-		 * able to wrongly write to the backend MMIO.
-		 */
-		VM_WARN_ON_ONCE(vma_is_cow_mapping(src_vma) && pmd_write(pmd));
-		goto set_pmd;
-	}
-
 	if (vma_is_anonymous(dst_vma) || arch_needs_pgtable_deposit()) {
 		pgtable = pte_alloc_one(dst_mm);
 		if (unlikely(!pgtable))
@@ -2021,7 +2002,9 @@ int copy_huge_pmd(struct mm_struct *dst_
 		goto copy_pmd;
 	}
 
-	src_page = pmd_page(pmd);
+	src_page = vm_normal_page_pmd(src_vma, addr, pmd);
+	if (!src_page)
+		goto copy_pmd;
 	VM_BUG_ON_PAGE(!PageHead(src_page), src_page);
 	src_folio = page_folio(src_page);
 
@@ -2061,7 +2044,6 @@ copy_pmd:
 	}
 	if (src_vma->vm_flags & VM_SHARED)
 		pmd = pmd_mkclean(pmd);
-set_pmd:
 	pmd = pmd_mkold(pmd);
 	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
 
_

Patches currently in -mm which might be from khorenko@virtuozzo.com are

mm-rmap-duplicate-a-pmd-mapping-as-one-in-folio_dup_file_rmap_pmd.patch
mm-huge_memory-copy-file-thps-at-fork-like-copy_present_ptes-does.patch
mm-huge_memory-read-a-special-pmd-under-the-lock-in-copy_huge_pmd.patch
selftests-mm-test-fork-of-pmd-mapped-shmem-thps.patch

