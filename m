Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D769D36E476
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776499010; cv=none; b=OxSxcHx8e6c3m9uwoZUeOZVzTJ/1Op6lyHGr6uRdLBxWf+Zx22hsWYpzHylLefijo8zHlHeCllQBz4V8WDFh1x1qkYluY3iRzSpMeaNmzauWBQNJtVlFjxwi3QCHUw9e4F/E4Z7hT4/FypTOs8K9keP8asZmXq1obS+yR2O5Vas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776499010; c=relaxed/simple;
	bh=rDP/lAgjf/amnj/0yltYi6g0kPM6QCy4svImrIeVFa8=;
	h=Date:To:From:Subject:Message-Id; b=cdWAX/fzQLh6mIq1YQmzOV/bY1SPPnl76MuVrWVmXxEResi7nJbeSe7OFRjYFocZJdadifmB2XAab3K5n+tChRJS3DtmmMN14sOJ4pkTD+bvxE4xXllfUj0rJa5Ihw4eGdvMwwuUg8w/xmBsHmIBrCKGfrlx5CgerTbF8Kkvlv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OEhVcHiC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OEhVcHiC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032E7C19424;
	Sat, 18 Apr 2026 07:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776499010;
	bh=rDP/lAgjf/amnj/0yltYi6g0kPM6QCy4svImrIeVFa8=;
	h=Date:To:From:Subject:From;
	b=OEhVcHiClDGbhsWdEJSpY7YhhZ5Ogy/q7nkOxMUqaWv+MkAYWyuIMD5Pw4g7e1CV2
	 lD+cyYADE6TD4ul5VqJs+wFCdRLgTbpvgP/iJSQsoeXUVqMFW+8SRwjnhhovC5gZLk
	 6OR02ITVY8kRd4H6EDUHPHqyJ0l1kRygtilfEv50=
Date: Sat, 18 Apr 2026 00:56:45 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,seanjc@google.com,peterx@redhat.com,pbonzini@redhat.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,kalyazin@amazon.com,jthoughton@google.com,hughd@google.com,harry.yoo@oracle.com,harry@kernel.org,devnexen@gmail.com,david@kernel.org,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,avagin@google.com,aarcange@redhat.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] userfaultfd-introduce-mfill_establish_pmd-helper.patch removed from -mm tree
Message-Id: <20260418075650.032E7C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd: introduce mfill_establish_pmd() helper
has been removed from the -mm tree.  Its filename was
     userfaultfd-introduce-mfill_establish_pmd-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: userfaultfd: introduce mfill_establish_pmd() helper
Date: Thu, 2 Apr 2026 07:11:44 +0300

There is a lengthy code chunk in mfill_atomic() that establishes the PMD
for UFFDIO operations.  This code may be called twice: first time when the
copy is performed with VMA/mm locks held and the other time after the copy
is retried with locks dropped.

Move the code that establishes a PMD into a helper function so it can be
reused later during refactoring of mfill_atomic_pte_copy().

Link: https://lore.kernel.org/20260402041156.1377214-4-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrei Vagin <avagin@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nikita Kalyazin <kalyazin@amazon.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Carlier <devnexen@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |  102 ++++++++++++++++++++++-----------------------
 1 file changed, 52 insertions(+), 50 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-introduce-mfill_establish_pmd-helper
+++ a/mm/userfaultfd.c
@@ -157,6 +157,56 @@ static void uffd_mfill_unlock(struct vm_
 }
 #endif
 
+static pmd_t *mm_alloc_pmd(struct mm_struct *mm, unsigned long address)
+{
+	pgd_t *pgd;
+	p4d_t *p4d;
+	pud_t *pud;
+
+	pgd = pgd_offset(mm, address);
+	p4d = p4d_alloc(mm, pgd, address);
+	if (!p4d)
+		return NULL;
+	pud = pud_alloc(mm, p4d, address);
+	if (!pud)
+		return NULL;
+	/*
+	 * Note that we didn't run this because the pmd was
+	 * missing, the *pmd may be already established and in
+	 * turn it may also be a trans_huge_pmd.
+	 */
+	return pmd_alloc(mm, pud, address);
+}
+
+static int mfill_establish_pmd(struct mfill_state *state)
+{
+	struct mm_struct *dst_mm = state->ctx->mm;
+	pmd_t *dst_pmd, dst_pmdval;
+
+	dst_pmd = mm_alloc_pmd(dst_mm, state->dst_addr);
+	if (unlikely(!dst_pmd))
+		return -ENOMEM;
+
+	dst_pmdval = pmdp_get_lockless(dst_pmd);
+	if (unlikely(pmd_none(dst_pmdval)) &&
+	    unlikely(__pte_alloc(dst_mm, dst_pmd)))
+		return -ENOMEM;
+
+	dst_pmdval = pmdp_get_lockless(dst_pmd);
+	/*
+	 * If the dst_pmd is THP don't override it and just be strict.
+	 * (This includes the case where the PMD used to be THP and
+	 * changed back to none after __pte_alloc().)
+	 */
+	if (unlikely(!pmd_present(dst_pmdval) || pmd_leaf(dst_pmdval)))
+		return -EEXIST;
+	if (unlikely(pmd_bad(dst_pmdval)))
+		return -EFAULT;
+
+	state->pmd = dst_pmd;
+	return 0;
+}
+
 /* Check if dst_addr is outside of file's size. Must be called with ptl held. */
 static bool mfill_file_over_size(struct vm_area_struct *dst_vma,
 				 unsigned long dst_addr)
@@ -489,27 +539,6 @@ out:
 	return ret;
 }
 
-static pmd_t *mm_alloc_pmd(struct mm_struct *mm, unsigned long address)
-{
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-
-	pgd = pgd_offset(mm, address);
-	p4d = p4d_alloc(mm, pgd, address);
-	if (!p4d)
-		return NULL;
-	pud = pud_alloc(mm, p4d, address);
-	if (!pud)
-		return NULL;
-	/*
-	 * Note that we didn't run this because the pmd was
-	 * missing, the *pmd may be already established and in
-	 * turn it may also be a trans_huge_pmd.
-	 */
-	return pmd_alloc(mm, pud, address);
-}
-
 #ifdef CONFIG_HUGETLB_PAGE
 /*
  * mfill_atomic processing for HUGETLB vmas.  Note that this routine is
@@ -742,7 +771,6 @@ static __always_inline ssize_t mfill_ato
 	struct vm_area_struct *dst_vma;
 	long copied = 0;
 	ssize_t err;
-	pmd_t *dst_pmd;
 
 	/*
 	 * Sanitize the command parameters:
@@ -808,41 +836,15 @@ retry:
 	while (state.src_addr < src_start + len) {
 		VM_WARN_ON_ONCE(state.dst_addr >= dst_start + len);
 
-		pmd_t dst_pmdval;
-
-		dst_pmd = mm_alloc_pmd(dst_mm, state.dst_addr);
-		if (unlikely(!dst_pmd)) {
-			err = -ENOMEM;
+		err = mfill_establish_pmd(&state);
+		if (err)
 			break;
-		}
 
-		dst_pmdval = pmdp_get_lockless(dst_pmd);
-		if (unlikely(pmd_none(dst_pmdval)) &&
-		    unlikely(__pte_alloc(dst_mm, dst_pmd))) {
-			err = -ENOMEM;
-			break;
-		}
-		dst_pmdval = pmdp_get_lockless(dst_pmd);
-		/*
-		 * If the dst_pmd is THP don't override it and just be strict.
-		 * (This includes the case where the PMD used to be THP and
-		 * changed back to none after __pte_alloc().)
-		 */
-		if (unlikely(!pmd_present(dst_pmdval) ||
-				pmd_trans_huge(dst_pmdval))) {
-			err = -EEXIST;
-			break;
-		}
-		if (unlikely(pmd_bad(dst_pmdval))) {
-			err = -EFAULT;
-			break;
-		}
 		/*
 		 * For shmem mappings, khugepaged is allowed to remove page
 		 * tables under us; pte_offset_map_lock() will deal with that.
 		 */
 
-		state.pmd = dst_pmd;
 		err = mfill_atomic_pte(&state);
 		cond_resched();
 
_

Patches currently in -mm which might be from rppt@kernel.org are


