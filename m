Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E495184537
	for <mm-commits@vger.kernel.org>; Thu, 26 Sep 2024 20:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727382768; cv=none; b=nL+wxwzT2lTFvx4MTyAySlrne18bQAvYhUsS7fHeXTElDtZDqTQ6woOjzGU86rmT4rnediBU/j4qnXrHW9IFPw9m3TbWgzcJx6DSsOMdsItC9ERNzAcT4qIXrG3ZvhRYnv8FCjpisrmrYEZHQpQaALBXjgNpTFpAVtAaLxKKFBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727382768; c=relaxed/simple;
	bh=4Uo2FzmY+hZIzQrk2fViQKiw67nwSHk4FA7ppifj1mc=;
	h=Date:To:From:Subject:Message-Id; b=eGKzB6sbo4KxXWbrr3K+7T/m+uk4pSjgogv22VoCP/+ZrmncJ0eW/RVkVOxPfuqI7dg2n6JF77JqugBSiE9budIpo4ttP7OhysGO+q6gmNJQIlNIl4TpubfqAF0+J2xq4JUzA0VSzSA3M1yz7HzIEL7snYszGgwzr8BF3Eunj1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tsYjdkl8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tsYjdkl8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB689C4CEC5;
	Thu, 26 Sep 2024 20:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727382768;
	bh=4Uo2FzmY+hZIzQrk2fViQKiw67nwSHk4FA7ppifj1mc=;
	h=Date:To:From:Subject:From;
	b=tsYjdkl8nTik0PoPhLnXmP4ieZpxLsbyz/oEzBWL4lG81mgdUXu3MisF6ZN3l1T8p
	 n9ex6MZwLu7AbqeL4S+8mbmmiC2mUozSM/+fDrO2uHMSjFKMN/heKH8aSUwIsn9t3K
	 83k+UJTSW8ZbWHfr68c7qiYVhSvjFkz4cv/bEZQU=
Date: Thu, 26 Sep 2024 13:32:47 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,david@redhat.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pgtable-remove-pte_offset_map_nolock.patch added to mm-unstable branch
Message-Id: <20240926203247.EB689C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: pgtable: remove pte_offset_map_nolock()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pgtable-remove-pte_offset_map_nolock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pgtable-remove-pte_offset_map_nolock.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: pgtable: remove pte_offset_map_nolock()
Date: Thu, 26 Sep 2024 14:46:26 +0800

Now no users are using the pte_offset_map_nolock(), remove it.

Link: https://lkml.kernel.org/r/d04f9bbbcde048fb6ffa6f2bdbc6f9b22d5286f9.1727332572.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/split_page_table_lock.rst |    3 --
 include/linux/mm.h                         |    2 -
 mm/pgtable-generic.c                       |   21 -------------------
 3 files changed, 26 deletions(-)

--- a/Documentation/mm/split_page_table_lock.rst~mm-pgtable-remove-pte_offset_map_nolock
+++ a/Documentation/mm/split_page_table_lock.rst
@@ -16,9 +16,6 @@ There are helpers to lock/unlock a table
  - pte_offset_map_lock()
 	maps PTE and takes PTE table lock, returns pointer to PTE with
 	pointer to its PTE table lock, or returns NULL if no PTE table;
- - pte_offset_map_nolock()
-	maps PTE, returns pointer to PTE with pointer to its PTE table
-	lock (not taken), or returns NULL if no PTE table;
  - pte_offset_map_ro_nolock()
 	maps PTE, returns pointer to PTE with pointer to its PTE table
 	lock (not taken), or returns NULL if no PTE table;
--- a/include/linux/mm.h~mm-pgtable-remove-pte_offset_map_nolock
+++ a/include/linux/mm.h
@@ -3015,8 +3015,6 @@ static inline pte_t *pte_offset_map_lock
 	return pte;
 }
 
-pte_t *pte_offset_map_nolock(struct mm_struct *mm, pmd_t *pmd,
-			unsigned long addr, spinlock_t **ptlp);
 pte_t *pte_offset_map_ro_nolock(struct mm_struct *mm, pmd_t *pmd,
 				unsigned long addr, spinlock_t **ptlp);
 pte_t *pte_offset_map_rw_nolock(struct mm_struct *mm, pmd_t *pmd,
--- a/mm/pgtable-generic.c~mm-pgtable-remove-pte_offset_map_nolock
+++ a/mm/pgtable-generic.c
@@ -305,18 +305,6 @@ nomap:
 	return NULL;
 }
 
-pte_t *pte_offset_map_nolock(struct mm_struct *mm, pmd_t *pmd,
-			     unsigned long addr, spinlock_t **ptlp)
-{
-	pmd_t pmdval;
-	pte_t *pte;
-
-	pte = __pte_offset_map(pmd, addr, &pmdval);
-	if (likely(pte))
-		*ptlp = pte_lockptr(mm, &pmdval);
-	return pte;
-}
-
 pte_t *pte_offset_map_ro_nolock(struct mm_struct *mm, pmd_t *pmd,
 				unsigned long addr, spinlock_t **ptlp)
 {
@@ -372,15 +360,6 @@ pte_t *pte_offset_map_rw_nolock(struct m
  * and disconnected table.  Until pte_unmap(pte) unmaps and rcu_read_unlock()s
  * afterwards.
  *
- * pte_offset_map_nolock(mm, pmd, addr, ptlp), above, is like pte_offset_map();
- * but when successful, it also outputs a pointer to the spinlock in ptlp - as
- * pte_offset_map_lock() does, but in this case without locking it.  This helps
- * the caller to avoid a later pte_lockptr(mm, *pmd), which might by that time
- * act on a changed *pmd: pte_offset_map_nolock() provides the correct spinlock
- * pointer for the page table that it returns.  In principle, the caller should
- * recheck *pmd once the lock is taken; in practice, no callsite needs that -
- * either the mmap_lock for write, or pte_same() check on contents, is enough.
- *
  * pte_offset_map_ro_nolock(mm, pmd, addr, ptlp), above, is like pte_offset_map();
  * but when successful, it also outputs a pointer to the spinlock in ptlp - as
  * pte_offset_map_lock() does, but in this case without locking it.  This helps
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-pgtable-introduce-pte_offset_map_rorw_nolock.patch
powerpc-assert_pte_locked-use-pte_offset_map_ro_nolock.patch
mm-filemap-filemap_fault_recheck_pte_none-use-pte_offset_map_ro_nolock.patch
mm-khugepaged-__collapse_huge_page_swapin-use-pte_offset_map_ro_nolock.patch
arm-adjust_pte-use-pte_offset_map_rw_nolock.patch
mm-handle_pte_fault-use-pte_offset_map_rw_nolock.patch
mm-khugepaged-collapse_pte_mapped_thp-use-pte_offset_map_rw_nolock.patch
mm-copy_pte_range-use-pte_offset_map_rw_nolock.patch
mm-mremap-move_ptes-use-pte_offset_map_rw_nolock.patch
mm-page_vma_mapped_walk-map_pte-use-pte_offset_map_rw_nolock.patch
mm-userfaultfd-move_pages_pte-use-pte_offset_map_rw_nolock.patch
mm-multi-gen-lru-walk_pte_range-use-pte_offset_map_rw_nolock.patch
mm-pgtable-remove-pte_offset_map_nolock.patch

