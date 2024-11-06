Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67172155747
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854725; cv=none; b=LFaLzadM2+Q9RnJTVxyzsYirkisnyzufRJWX6tJLDkG4Zdc6mfNu/19wM812Vydxea/PrdKOPd1+K8G9k5kqaEqR1ByNEgy1nNETi6roSQoIcWsoZBeSHL3jJHGWfYwB4WG1B+dyPVE0WMzje9tnxo8VzT5urdvYzUabeUZC9RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854725; c=relaxed/simple;
	bh=MxMz/LCFrBZMlwY+qZG2X5bowm5ZcbETCH3RlWjukv4=;
	h=Date:To:From:Subject:Message-Id; b=qwmhoRezOrhvbqSkbCoCaP8F+39pI4LuxdZHlZaWh1hHNcWtCCq5DLC9TB7iKAVjMFBt/qgKg28oLXmmX3K8TvAVtuS5gChClpJ0u7/6WM7oK3nxvHx76XpFEUz//UTw+wpgR6X3KhL/+8i15msEYs3iuijizEHJusux6vkAcFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dFML7lj/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dFML7lj/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5F8C4CED1;
	Wed,  6 Nov 2024 00:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854725;
	bh=MxMz/LCFrBZMlwY+qZG2X5bowm5ZcbETCH3RlWjukv4=;
	h=Date:To:From:Subject:From;
	b=dFML7lj/pLOx0J0NPUFwvSeqk/d4iEkheyF0dLeSixbHr7qowBv9Ac2NqRsiYzrO3
	 p+00wG5UGC0SHuB/AVEaDA7zQENNJgcZaTc/aj0rmXiHJ5/0/0XUoHkwRbrFz0hMTx
	 3m0Lw5rgP3LDZjbaZ8rKTr4ktssOxtP2JNIQS23g=
Date: Tue, 05 Nov 2024 16:58:44 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,david@redhat.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pgtable-introduce-pte_offset_map_rorw_nolock.patch removed from -mm tree
Message-Id: <20241106005845.3C5F8C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: pgtable: introduce pte_offset_map_{ro|rw}_nolock()
has been removed from the -mm tree.  Its filename was
     mm-pgtable-introduce-pte_offset_map_rorw_nolock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: pgtable: introduce pte_offset_map_{ro|rw}_nolock()
Date: Thu, 26 Sep 2024 14:46:14 +0800

Patch series "introduce pte_offset_map_{ro|rw}_nolock()", v5.

As proposed by David Hildenbrand [1], this series introduces the following
two new helper functions to replace pte_offset_map_nolock().

1. pte_offset_map_ro_nolock()
2. pte_offset_map_rw_nolock()

As the name suggests, pte_offset_map_ro_nolock() is used for read-only
case.  In this case, only read-only operations will be performed on PTE
page after the PTL is held.  The RCU lock in pte_offset_map_nolock() will
ensure that the PTE page will not be freed, and there is no need to worry
about whether the pmd entry is modified.  Therefore
pte_offset_map_ro_nolock() is just a renamed version of
pte_offset_map_nolock().

pte_offset_map_rw_nolock() is used for may-write case.  In this case, the
pte or pmd entry may be modified after the PTL is held, so we need to
ensure that the pmd entry has not been modified concurrently.  So in
addition to the name change, it also outputs the pmdval when successful. 
The users should make sure the page table is stable like checking
pte_same() or checking pmd_same() by using the output pmdval before
performing the write operations.

This series will convert all pte_offset_map_nolock() into the above two
helper functions one by one, and finally completely delete it.

This also a preparation for reclaiming the empty user PTE page table
pages.


This patch (of 13):

Currently, the usage of pte_offset_map_nolock() can be divided into the
following two cases:

1) After acquiring PTL, only read-only operations are performed on the PTE
   page. In this case, the RCU lock in pte_offset_map_nolock() will ensure
   that the PTE page will not be freed, and there is no need to worry
   about whether the pmd entry is modified.

2) After acquiring PTL, the pte or pmd entries may be modified. At this
   time, we need to ensure that the pmd entry has not been modified
   concurrently.

To more clearing distinguish between these two cases, this commit
introduces two new helper functions to replace pte_offset_map_nolock(). 
For 1), just rename it to pte_offset_map_ro_nolock().  For 2), in addition
to changing the name to pte_offset_map_rw_nolock(), it also outputs the
pmdval when successful.  It is applicable for may-write cases where any
modification operations to the page table may happen after the
corresponding spinlock is held afterwards.  But the users should make sure
the page table is stable like checking pte_same() or checking pmd_same()
by using the output pmdval before performing the write operations.

Note: "RO" / "RW" expresses the intended semantics, not that the *kmap*
will be read-only/read-write protected.

Subsequent commits will convert pte_offset_map_nolock() into the above
two functions one by one, and finally completely delete it.

Link: https://lkml.kernel.org/r/cover.1727332572.git.zhengqi.arch@bytedance.com
Link: https://lkml.kernel.org/r/5aeecfa131600a454b1f3a038a1a54282ca3b856.1727332572.git.zhengqi.arch@bytedance.com
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

 Documentation/mm/split_page_table_lock.rst |    7 ++
 include/linux/mm.h                         |    5 +
 mm/pgtable-generic.c                       |   48 +++++++++++++++++++
 3 files changed, 60 insertions(+)

--- a/Documentation/mm/split_page_table_lock.rst~mm-pgtable-introduce-pte_offset_map_rorw_nolock
+++ a/Documentation/mm/split_page_table_lock.rst
@@ -19,6 +19,13 @@ There are helpers to lock/unlock a table
  - pte_offset_map_nolock()
 	maps PTE, returns pointer to PTE with pointer to its PTE table
 	lock (not taken), or returns NULL if no PTE table;
+ - pte_offset_map_ro_nolock()
+	maps PTE, returns pointer to PTE with pointer to its PTE table
+	lock (not taken), or returns NULL if no PTE table;
+ - pte_offset_map_rw_nolock()
+	maps PTE, returns pointer to PTE with pointer to its PTE table
+	lock (not taken) and the value of its pmd entry, or returns NULL
+	if no PTE table;
  - pte_offset_map()
 	maps PTE, returns pointer to PTE, or returns NULL if no PTE table;
  - pte_unmap()
--- a/include/linux/mm.h~mm-pgtable-introduce-pte_offset_map_rorw_nolock
+++ a/include/linux/mm.h
@@ -3017,6 +3017,11 @@ static inline pte_t *pte_offset_map_lock
 
 pte_t *pte_offset_map_nolock(struct mm_struct *mm, pmd_t *pmd,
 			unsigned long addr, spinlock_t **ptlp);
+pte_t *pte_offset_map_ro_nolock(struct mm_struct *mm, pmd_t *pmd,
+				unsigned long addr, spinlock_t **ptlp);
+pte_t *pte_offset_map_rw_nolock(struct mm_struct *mm, pmd_t *pmd,
+				unsigned long addr, pmd_t *pmdvalp,
+				spinlock_t **ptlp);
 
 #define pte_unmap_unlock(pte, ptl)	do {		\
 	spin_unlock(ptl);				\
--- a/mm/pgtable-generic.c~mm-pgtable-introduce-pte_offset_map_rorw_nolock
+++ a/mm/pgtable-generic.c
@@ -317,6 +317,31 @@ pte_t *pte_offset_map_nolock(struct mm_s
 	return pte;
 }
 
+pte_t *pte_offset_map_ro_nolock(struct mm_struct *mm, pmd_t *pmd,
+				unsigned long addr, spinlock_t **ptlp)
+{
+	pmd_t pmdval;
+	pte_t *pte;
+
+	pte = __pte_offset_map(pmd, addr, &pmdval);
+	if (likely(pte))
+		*ptlp = pte_lockptr(mm, &pmdval);
+	return pte;
+}
+
+pte_t *pte_offset_map_rw_nolock(struct mm_struct *mm, pmd_t *pmd,
+				unsigned long addr, pmd_t *pmdvalp,
+				spinlock_t **ptlp)
+{
+	pte_t *pte;
+
+	VM_WARN_ON_ONCE(!pmdvalp);
+	pte = __pte_offset_map(pmd, addr, pmdvalp);
+	if (likely(pte))
+		*ptlp = pte_lockptr(mm, pmdvalp);
+	return pte;
+}
+
 /*
  * pte_offset_map_lock(mm, pmd, addr, ptlp), and its internal implementation
  * __pte_offset_map_lock() below, is usually called with the pmd pointer for
@@ -356,6 +381,29 @@ pte_t *pte_offset_map_nolock(struct mm_s
  * recheck *pmd once the lock is taken; in practice, no callsite needs that -
  * either the mmap_lock for write, or pte_same() check on contents, is enough.
  *
+ * pte_offset_map_ro_nolock(mm, pmd, addr, ptlp), above, is like pte_offset_map();
+ * but when successful, it also outputs a pointer to the spinlock in ptlp - as
+ * pte_offset_map_lock() does, but in this case without locking it.  This helps
+ * the caller to avoid a later pte_lockptr(mm, *pmd), which might by that time
+ * act on a changed *pmd: pte_offset_map_ro_nolock() provides the correct spinlock
+ * pointer for the page table that it returns. Even after grabbing the spinlock,
+ * we might be looking either at a page table that is still mapped or one that
+ * was unmapped and is about to get freed. But for R/O access this is sufficient.
+ * So it is only applicable for read-only cases where any modification operations
+ * to the page table are not allowed even if the corresponding spinlock is held
+ * afterwards.
+ *
+ * pte_offset_map_rw_nolock(mm, pmd, addr, pmdvalp, ptlp), above, is like
+ * pte_offset_map_ro_nolock(); but when successful, it also outputs the pdmval.
+ * It is applicable for may-write cases where any modification operations to the
+ * page table may happen after the corresponding spinlock is held afterwards.
+ * But the users should make sure the page table is stable like checking pte_same()
+ * or checking pmd_same() by using the output pmdval before performing the write
+ * operations.
+ *
+ * Note: "RO" / "RW" expresses the intended semantics, not that the *kmap* will
+ * be read-only/read-write protected.
+ *
  * Note that free_pgtables(), used after unmapping detached vmas, or when
  * exiting the whole mm, does not take page table lock before freeing a page
  * table, and may not use RCU at all: "outsiders" like khugepaged should avoid
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


