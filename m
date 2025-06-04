Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089991F0E47
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 20:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749068978; cv=none; b=M3sGQ9onFvQ1KbLAwwZHyphO9nTYz43shSkZ+FLCgHFr94tskU2SPK3l/yRPwMT677U5WEosNAcSczCwh81v/Ampi5AF6p2vrDhPy2X4+YJyYvIFBuHoEA57jDc8VJ046Ke+PpvOHlwsnEO7W3PpG8c58MnBsIpZlkyxVI21eOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749068978; c=relaxed/simple;
	bh=zwP3ksIBrhYFmoT8LdFbOiJKMHt6QHGSAKs4g25deK4=;
	h=Date:To:From:Subject:Message-Id; b=sWTp2XnXXRrMY9I2L2kSmy9XnPPirdCXGhU35qUQ1aNGKyv7dwLiwBBrTmuB4rWNZAgPMS1HNGOTuRuaCpdBPlNTTuqv6Zu9IPb12FYSI5DbxqKla1SOmG0Le6NYOeg4sHZ/U6M80Jtp7TH2RGiXTHJ54jPhLfcLGF9qiDcSAD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kDWLlMQ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kDWLlMQ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6066DC4CEE4;
	Wed,  4 Jun 2025 20:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749068977;
	bh=zwP3ksIBrhYFmoT8LdFbOiJKMHt6QHGSAKs4g25deK4=;
	h=Date:To:From:Subject:From;
	b=kDWLlMQ80wGcjDrjJGkTgj3kXvPi7bIGiH82Mgtf0vPCPr96Tpxtgkt37Okzk6mxq
	 IYnTiyxuJEBptBIgNLUufp+ubuH2NfOIz1kDRXw8uwX9QImCpNcdHxa+5Z7QnDO5El
	 HI0+uczgPCIMzTZ2pXdM7BaBUp+YLNvf/87cTa6I=
Date: Wed, 04 Jun 2025 13:29:36 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jhubbard@nvidia.com,jgg@ziepe.ca,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-remove-vm_bug_ons.patch added to mm-new branch
Message-Id: <20250604202937.6066DC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: remove (VM_)BUG_ONs
has been added to the -mm mm-new branch.  Its filename is
     mm-gup-remove-vm_bug_ons.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-remove-vm_bug_ons.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/gup: remove (VM_)BUG_ONs
Date: Wed, 4 Jun 2025 16:05:44 +0200

Especially once we hit one of the assertions in
sanity_check_pinned_pages(), observing follow-up assertions failing in
other code can give good clues about what went wrong, so use
VM_WARN_ON_ONCE instead.

While at it, let's just convert all VM_BUG_ON to VM_WARN_ON_ONCE as well. 
Add one comment for the pfn_valid() check.

We have to introduce VM_WARN_ON_ONCE_VMA() to make that fly.

Drop the BUG_ON after mmap_read_lock_killable(), if that ever returns
something > 0 we're in bigger trouble.  Convert the other BUG_ON's into
VM_WARN_ON_ONCE as well, they are in a similar domain "should never
happen", but more reasonable to check for during early testing.

Link: https://lkml.kernel.org/r/20250604140544.688711-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmdebug.h |   12 +++++++++++
 mm/gup.c                |   41 +++++++++++++++++---------------------
 2 files changed, 31 insertions(+), 22 deletions(-)

--- a/include/linux/mmdebug.h~mm-gup-remove-vm_bug_ons
+++ a/include/linux/mmdebug.h
@@ -89,6 +89,17 @@ void vma_iter_dump_tree(const struct vma
 	}								\
 	unlikely(__ret_warn_once);					\
 })
+#define VM_WARN_ON_ONCE_VMA(cond, vma)		({			\
+	static bool __section(".data..once") __warned;			\
+	int __ret_warn_once = !!(cond);					\
+									\
+	if (unlikely(__ret_warn_once && !__warned)) {			\
+		dump_vma(vma);						\
+		__warned = true;					\
+		WARN_ON(1);						\
+	}								\
+	unlikely(__ret_warn_once);					\
+})
 #define VM_WARN_ON_VMG(cond, vmg)		({			\
 	int __ret_warn = !!(cond);					\
 									\
@@ -115,6 +126,7 @@ void vma_iter_dump_tree(const struct vma
 #define VM_WARN_ON_FOLIO(cond, folio)  BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ON_ONCE_FOLIO(cond, folio)  BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ON_ONCE_MM(cond, mm)  BUILD_BUG_ON_INVALID(cond)
+#define VM_WARN_ON_ONCE_VMA(cond, vma)  BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ON_VMG(cond, vmg)  BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ONCE(cond, format...) BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN(cond, format...) BUILD_BUG_ON_INVALID(cond)
--- a/mm/gup.c~mm-gup-remove-vm_bug_ons
+++ a/mm/gup.c
@@ -64,11 +64,11 @@ static inline void sanity_check_pinned_p
 		    !folio_test_anon(folio))
 			continue;
 		if (!folio_test_large(folio) || folio_test_hugetlb(folio))
-			VM_BUG_ON_PAGE(!PageAnonExclusive(&folio->page), page);
+			VM_WARN_ON_ONCE_PAGE(!PageAnonExclusive(&folio->page), page);
 		else
 			/* Either a PTE-mapped or a PMD-mapped THP. */
-			VM_BUG_ON_PAGE(!PageAnonExclusive(&folio->page) &&
-				       !PageAnonExclusive(page), page);
+			VM_WARN_ON_ONCE_PAGE(!PageAnonExclusive(&folio->page) &&
+					     !PageAnonExclusive(page), page);
 	}
 }
 
@@ -760,8 +760,8 @@ static struct page *follow_huge_pmd(stru
 	if (!pmd_write(pmdval) && gup_must_unshare(vma, flags, page))
 		return ERR_PTR(-EMLINK);
 
-	VM_BUG_ON_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
-			!PageAnonExclusive(page), page);
+	VM_WARN_ON_ONCE_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
+			     !PageAnonExclusive(page), page);
 
 	ret = try_grab_folio(page_folio(page), 1, flags);
 	if (ret)
@@ -899,8 +899,8 @@ static struct page *follow_page_pte(stru
 		goto out;
 	}
 
-	VM_BUG_ON_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
-		       !PageAnonExclusive(page), page);
+	VM_WARN_ON_ONCE_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
+			     !PageAnonExclusive(page), page);
 
 	/* try_grab_folio() does nothing unless FOLL_GET or FOLL_PIN is set. */
 	ret = try_grab_folio(folio, 1, flags);
@@ -1180,7 +1180,7 @@ static int faultin_page(struct vm_area_s
 	if (unshare) {
 		fault_flags |= FAULT_FLAG_UNSHARE;
 		/* FAULT_FLAG_WRITE and FAULT_FLAG_UNSHARE are incompatible */
-		VM_BUG_ON(fault_flags & FAULT_FLAG_WRITE);
+		VM_WARN_ON_ONCE(fault_flags & FAULT_FLAG_WRITE);
 	}
 
 	ret = handle_mm_fault(vma, address, fault_flags, NULL);
@@ -1760,10 +1760,7 @@ static __always_inline long __get_user_p
 		}
 
 		/* VM_FAULT_RETRY or VM_FAULT_COMPLETED cannot return errors */
-		if (!*locked) {
-			BUG_ON(ret < 0);
-			BUG_ON(ret >= nr_pages);
-		}
+		VM_WARN_ON_ONCE(!*locked && (ret < 0 || ret >= nr_pages));
 
 		if (ret > 0) {
 			nr_pages -= ret;
@@ -1808,7 +1805,6 @@ retry:
 
 		ret = mmap_read_lock_killable(mm);
 		if (ret) {
-			BUG_ON(ret > 0);
 			if (!pages_done)
 				pages_done = ret;
 			break;
@@ -1819,11 +1815,11 @@ retry:
 				       pages, locked);
 		if (!*locked) {
 			/* Continue to retry until we succeeded */
-			BUG_ON(ret != 0);
+			VM_WARN_ON_ONCE(ret != 0);
 			goto retry;
 		}
 		if (ret != 1) {
-			BUG_ON(ret > 1);
+			VM_WARN_ON_ONCE(ret > 1);
 			if (!pages_done)
 				pages_done = ret;
 			break;
@@ -1885,10 +1881,10 @@ long populate_vma_page_range(struct vm_a
 	int gup_flags;
 	long ret;
 
-	VM_BUG_ON(!PAGE_ALIGNED(start));
-	VM_BUG_ON(!PAGE_ALIGNED(end));
-	VM_BUG_ON_VMA(start < vma->vm_start, vma);
-	VM_BUG_ON_VMA(end   > vma->vm_end, vma);
+	VM_WARN_ON_ONCE(!PAGE_ALIGNED(start));
+	VM_WARN_ON_ONCE(!PAGE_ALIGNED(end));
+	VM_WARN_ON_ONCE_VMA(start < vma->vm_start, vma);
+	VM_WARN_ON_ONCE_VMA(end   > vma->vm_end, vma);
 	mmap_assert_locked(mm);
 
 	/*
@@ -1957,8 +1953,8 @@ long faultin_page_range(struct mm_struct
 	int gup_flags;
 	long ret;
 
-	VM_BUG_ON(!PAGE_ALIGNED(start));
-	VM_BUG_ON(!PAGE_ALIGNED(end));
+	VM_WARN_ON_ONCE(!PAGE_ALIGNED(start));
+	VM_WARN_ON_ONCE(!PAGE_ALIGNED(end));
 	mmap_assert_locked(mm);
 
 	/*
@@ -2908,7 +2904,8 @@ static int gup_fast_pte_range(pmd_t pmd,
 		} else if (pte_special(pte))
 			goto pte_unmap;
 
-		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
+		/* If it's not marked as special it must have a valid memmap. */
+		VM_WARN_ON_ONCE(!pfn_valid(pte_pfn(pte)));
 		page = pte_page(pte);
 
 		folio = try_grab_folio_fast(page, 1, flags);
_

Patches currently in -mm which might be from david@redhat.com are

mm-gup-remove-vm_bug_ons.patch

