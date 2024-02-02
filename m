Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878B91426A
	for <mm-commits@vger.kernel.org>; Fri,  2 Feb 2024 12:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706875984; cv=none; b=BooPwoBmYasYi05sUuP2o7EpUSJG7z9ogzs+rMTF6a8t3VKIDrARd3vG7eQxMVuGlIgk1fE9+NwYj1t4/wX735LqJvWbkuylf5kIPRt9oJHu9fWzjRnHIlVx5IoCAN0JuV6LH+OUiK7+jx0+32WwG5Nhp/ek2riw2exBpi8Q1Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706875984; c=relaxed/simple;
	bh=MNwvXx63ffJRIFaAlaq6UFBThhQpocFVYgMJgy8lS9c=;
	h=Date:To:From:Subject:Message-Id; b=OTW29C936Al2Fg8HXPehdbl03WrfLDYPBTajvbXXjns+9fwHGf6VtuhskdTxvbTjeSNvM2F/FWKBVhblZgP/igODn3MSJQyIeb/3qdJglLzyOpWxyC+Qu7Tawyh5Af8H/7YorThf0kwCEyfje0oV77bolEcUN6AzxoaZLzy1Twg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h78BxIzc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h78BxIzc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8B0CC43394;
	Fri,  2 Feb 2024 12:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706875984;
	bh=MNwvXx63ffJRIFaAlaq6UFBThhQpocFVYgMJgy8lS9c=;
	h=Date:To:From:Subject:From;
	b=h78BxIzcRTH4hrdDzBOBs8+77EuFuhwKZJ8dpLQd9VTVmwFoT4iF0eykPdwP+NzKA
	 xkzNQsvqvTj28vxCoDcMWInjMVdQQF2S5/CwIGkoa0bXu5mNGXfXruHldP9isPmcAm
	 3frWCP6wx/rc3PbHdSRdagApt3gVJrHecftye6+Q=
Date: Fri, 02 Feb 2024 04:13:01 -0800
To: mm-commits@vger.kernel.org,zhangpeng362@huawei.com,willy@infradead.org,viro@zeniv.linux.org.uk,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,ngeoffray@google.com,mhocko@suse.com,lokeshgidra@google.com,lkp@intel.com,Liam.Howlett@oracle.com,kaleshsingh@google.com,jannh@google.com,hughd@google.com,david@redhat.com,dan.carpenter@linaro.org,brauner@kernel.org,bgeffon@google.com,axelrasmussen@google.com,aarcange@redhat.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-handle-zeropage-moves-by-uffdio_move.patch added to mm-unstable branch
Message-Id: <20240202121303.B8B0CC43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: handle zeropage moves by UFFDIO_MOVE
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-handle-zeropage-moves-by-uffdio_move.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-handle-zeropage-moves-by-uffdio_move.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: userfaultfd: handle zeropage moves by UFFDIO_MOVE
Date: Wed, 31 Jan 2024 09:56:18 -0800

Current implementation of UFFDIO_MOVE fails to move zeropages and returns
EBUSY when it encounters one.  We can handle them by mapping a zeropage at
the destination and clearing the mapping at the source.  This is done both
for ordinary and for huge zeropages.

Link: https://lkml.kernel.org/r/20240131175618.2417291-1-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202401300107.U8iMAkTl-lkp@intel.com/
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Nicolas Geoffray <ngeoffray@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: ZhangPeng <zhangpeng362@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |  111 +++++++++++++++++++++++++--------------------
 mm/userfaultfd.c |   44 +++++++++++++++--
 2 files changed, 101 insertions(+), 54 deletions(-)

--- a/mm/huge_memory.c~userfaultfd-handle-zeropage-moves-by-uffdio_move
+++ a/mm/huge_memory.c
@@ -2200,13 +2200,18 @@ int move_pages_huge_pmd(struct mm_struct
 	}
 
 	src_page = pmd_page(src_pmdval);
-	if (unlikely(!PageAnonExclusive(src_page))) {
-		spin_unlock(src_ptl);
-		return -EBUSY;
-	}
 
-	src_folio = page_folio(src_page);
-	folio_get(src_folio);
+	if (!is_huge_zero_pmd(src_pmdval)) {
+		if (unlikely(!PageAnonExclusive(src_page))) {
+			spin_unlock(src_ptl);
+			return -EBUSY;
+		}
+
+		src_folio = page_folio(src_page);
+		folio_get(src_folio);
+	} else
+		src_folio = NULL;
+
 	spin_unlock(src_ptl);
 
 	flush_cache_range(src_vma, src_addr, src_addr + HPAGE_PMD_SIZE);
@@ -2214,19 +2219,22 @@ int move_pages_huge_pmd(struct mm_struct
 				src_addr + HPAGE_PMD_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
 
-	folio_lock(src_folio);
+	if (src_folio) {
+		folio_lock(src_folio);
 
-	/*
-	 * split_huge_page walks the anon_vma chain without the page
-	 * lock. Serialize against it with the anon_vma lock, the page
-	 * lock is not enough.
-	 */
-	src_anon_vma = folio_get_anon_vma(src_folio);
-	if (!src_anon_vma) {
-		err = -EAGAIN;
-		goto unlock_folio;
-	}
-	anon_vma_lock_write(src_anon_vma);
+		/*
+		 * split_huge_page walks the anon_vma chain without the page
+		 * lock. Serialize against it with the anon_vma lock, the page
+		 * lock is not enough.
+		 */
+		src_anon_vma = folio_get_anon_vma(src_folio);
+		if (!src_anon_vma) {
+			err = -EAGAIN;
+			goto unlock_folio;
+		}
+		anon_vma_lock_write(src_anon_vma);
+	} else
+		src_anon_vma = NULL;
 
 	dst_ptl = pmd_lockptr(mm, dst_pmd);
 	double_pt_lock(src_ptl, dst_ptl);
@@ -2235,45 +2243,54 @@ int move_pages_huge_pmd(struct mm_struct
 		err = -EAGAIN;
 		goto unlock_ptls;
 	}
-	if (folio_maybe_dma_pinned(src_folio) ||
-	    !PageAnonExclusive(&src_folio->page)) {
-		err = -EBUSY;
-		goto unlock_ptls;
-	}
-
-	if (WARN_ON_ONCE(!folio_test_head(src_folio)) ||
-	    WARN_ON_ONCE(!folio_test_anon(src_folio))) {
-		err = -EBUSY;
-		goto unlock_ptls;
-	}
-
-	folio_move_anon_rmap(src_folio, dst_vma);
-	WRITE_ONCE(src_folio->index, linear_page_index(dst_vma, dst_addr));
-
-	src_pmdval = pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
-	/* Folio got pinned from under us. Put it back and fail the move. */
-	if (folio_maybe_dma_pinned(src_folio)) {
-		set_pmd_at(mm, src_addr, src_pmd, src_pmdval);
-		err = -EBUSY;
-		goto unlock_ptls;
+	if (src_folio) {
+		if (folio_maybe_dma_pinned(src_folio) ||
+		    !PageAnonExclusive(&src_folio->page)) {
+			err = -EBUSY;
+			goto unlock_ptls;
+		}
+
+		if (WARN_ON_ONCE(!folio_test_head(src_folio)) ||
+		    WARN_ON_ONCE(!folio_test_anon(src_folio))) {
+			err = -EBUSY;
+			goto unlock_ptls;
+		}
+
+		folio_move_anon_rmap(src_folio, dst_vma);
+		WRITE_ONCE(src_folio->index, linear_page_index(dst_vma, dst_addr));
+
+		src_pmdval = pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
+		/* Folio got pinned from under us. Put it back and fail the move. */
+		if (folio_maybe_dma_pinned(src_folio)) {
+			set_pmd_at(mm, src_addr, src_pmd, src_pmdval);
+			err = -EBUSY;
+			goto unlock_ptls;
+		}
+
+		_dst_pmd = mk_huge_pmd(&src_folio->page, dst_vma->vm_page_prot);
+		/* Follow mremap() behavior and treat the entry dirty after the move */
+		_dst_pmd = pmd_mkwrite(pmd_mkdirty(_dst_pmd), dst_vma);
+	} else {
+		src_pmdval = pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
+		_dst_pmd = mk_huge_pmd(src_page, dst_vma->vm_page_prot);
 	}
-
-	_dst_pmd = mk_huge_pmd(&src_folio->page, dst_vma->vm_page_prot);
-	/* Follow mremap() behavior and treat the entry dirty after the move */
-	_dst_pmd = pmd_mkwrite(pmd_mkdirty(_dst_pmd), dst_vma);
 	set_pmd_at(mm, dst_addr, dst_pmd, _dst_pmd);
 
 	src_pgtable = pgtable_trans_huge_withdraw(mm, src_pmd);
 	pgtable_trans_huge_deposit(mm, dst_pmd, src_pgtable);
 unlock_ptls:
 	double_pt_unlock(src_ptl, dst_ptl);
-	anon_vma_unlock_write(src_anon_vma);
-	put_anon_vma(src_anon_vma);
+	if (src_anon_vma) {
+		anon_vma_unlock_write(src_anon_vma);
+		put_anon_vma(src_anon_vma);
+	}
 unlock_folio:
 	/* unblock rmap walks */
-	folio_unlock(src_folio);
+	if (src_folio)
+		folio_unlock(src_folio);
 	mmu_notifier_invalidate_range_end(&range);
-	folio_put(src_folio);
+	if (src_folio)
+		folio_put(src_folio);
 	return err;
 }
 #endif /* CONFIG_USERFAULTFD */
--- a/mm/userfaultfd.c~userfaultfd-handle-zeropage-moves-by-uffdio_move
+++ a/mm/userfaultfd.c
@@ -959,6 +959,33 @@ static int move_swap_pte(struct mm_struc
 	return 0;
 }
 
+static int move_zeropage_pte(struct mm_struct *mm,
+			     struct vm_area_struct *dst_vma,
+			     struct vm_area_struct *src_vma,
+			     unsigned long dst_addr, unsigned long src_addr,
+			     pte_t *dst_pte, pte_t *src_pte,
+			     pte_t orig_dst_pte, pte_t orig_src_pte,
+			     spinlock_t *dst_ptl, spinlock_t *src_ptl)
+{
+	pte_t zero_pte;
+
+	double_pt_lock(dst_ptl, src_ptl);
+	if (!pte_same(ptep_get(src_pte), orig_src_pte) ||
+	    !pte_same(ptep_get(dst_pte), orig_dst_pte)) {
+		double_pt_unlock(dst_ptl, src_ptl);
+		return -EAGAIN;
+	}
+
+	zero_pte = pte_mkspecial(pfn_pte(my_zero_pfn(dst_addr),
+					 dst_vma->vm_page_prot));
+	ptep_clear_flush(src_vma, src_addr, src_pte);
+	set_pte_at(mm, dst_addr, dst_pte, zero_pte);
+	double_pt_unlock(dst_ptl, src_ptl);
+
+	return 0;
+}
+
+
 /*
  * The mmap_lock for reading is held by the caller. Just move the page
  * from src_pmd to dst_pmd if possible, and return true if succeeded
@@ -1041,6 +1068,14 @@ retry:
 	}
 
 	if (pte_present(orig_src_pte)) {
+		if (is_zero_pfn(pte_pfn(orig_src_pte))) {
+			err = move_zeropage_pte(mm, dst_vma, src_vma,
+					       dst_addr, src_addr, dst_pte, src_pte,
+					       orig_dst_pte, orig_src_pte,
+					       dst_ptl, src_ptl);
+			goto out;
+		}
+
 		/*
 		 * Pin and lock both source folio and anon_vma. Since we are in
 		 * RCU read section, we can't block, so on contention have to
@@ -1404,19 +1439,14 @@ ssize_t move_pages(struct userfaultfd_ct
 				err = -ENOENT;
 				break;
 			}
-			/* Avoid moving zeropages for now */
-			if (is_huge_zero_pmd(*src_pmd)) {
-				spin_unlock(ptl);
-				err = -EBUSY;
-				break;
-			}
 
 			/* Check if we can move the pmd without splitting it. */
 			if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
 			    !pmd_none(dst_pmdval)) {
 				struct folio *folio = pfn_folio(pmd_pfn(*src_pmd));
 
-				if (!folio || !PageAnonExclusive(&folio->page)) {
+				if (!folio || (!is_huge_zero_page(&folio->page) &&
+					       !PageAnonExclusive(&folio->page))) {
 					spin_unlock(ptl);
 					err = -EBUSY;
 					break;
_

Patches currently in -mm which might be from surenb@google.com are

arch-arm-mm-fix-major-fault-accounting-when-retrying-under-per-vma-lock.patch
userfaultfd-handle-zeropage-moves-by-uffdio_move.patch

