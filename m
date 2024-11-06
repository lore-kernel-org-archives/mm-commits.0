Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A9E142E86
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854739; cv=none; b=aHScA/k1SvEWMZozjr+tK77/l9T7j6IvGPqt8o4UQos3s4Q0aDz10qoEOd1Ue0Vhk7MoUpUUhQJ4Lct0JPDuvR63Q7wIGVs7AwCXT3E0u4RRl5/Ov+7NvTm2n/U9O/+Hw/OxmlcTK5vRc23GntutdHD5c5SEgU1QVPnnm9W7vts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854739; c=relaxed/simple;
	bh=KfvGq2BcYBpPvnB2HAuZX0REENXsohmcPvExHwBRi9I=;
	h=Date:To:From:Subject:Message-Id; b=sMOTnxQUXjddT8s/ZhoiwJfJOOmrAOEKkQI+7R1p5J8Glx8mTrCI+ZJ835WQs1h+DuIFNKY8HsoVJmAtKa+ROmwNi/uh6kGltKyl9nULizJI88/v/F1FwSXLSsSPCW7UfRlfgdE/DyBtOvegZzV70Z6inAJYqLcJMznvUURoiSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y3KHLUK9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y3KHLUK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C752C4CECF;
	Wed,  6 Nov 2024 00:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854739;
	bh=KfvGq2BcYBpPvnB2HAuZX0REENXsohmcPvExHwBRi9I=;
	h=Date:To:From:Subject:From;
	b=Y3KHLUK9n40IoG9iXQIj5CD26pRb/zT+umk9rwVxi+PEL6sklg/KLz8Jd8MDCSQBV
	 V9E/WAI1KM1/V1gQ7E7KAF1l/wRQg7eqVBvG2C/COJir5pf3QC/E10iur5jCJA3RHZ
	 dM9lmiPlIJ9HAx5WZKC1xq42W7IWYRECEeWh9JaQ=
Date: Tue, 05 Nov 2024 16:58:58 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,david@redhat.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pgtable-remove-pte_offset_map_nolock.patch removed from -mm tree
Message-Id: <20241106005859.7C752C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: pgtable: remove pte_offset_map_nolock()
has been removed from the -mm tree.  Its filename was
     mm-pgtable-remove-pte_offset_map_nolock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


