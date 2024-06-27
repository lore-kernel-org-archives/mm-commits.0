Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C904519939D
	for <mm-commits@vger.kernel.org>; Thu, 27 Jun 2024 22:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719528471; cv=none; b=CDVxkfGrl3aCPcuS70gFpdvTupXL4QlWuSwLyq/T7MAJ/kHQuxU4ht2qrnvwdvshyFPTxfKlo/oz/eYgVasaDadABmRYxKp8fI6pZkpoYT5coXnjRHTFAEEfVB7hCCKBUVJY/7H1Wt63cWKpqnr/a9Tmh+mnvGaGrMBnutVVUqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719528471; c=relaxed/simple;
	bh=2G7gKCuBKWWf2eWUerjEVv4Xiot2LpM4NGGc4XOgySs=;
	h=Date:To:From:Subject:Message-Id; b=r9c7mxEpDmnHQHsrle6vmK9SC/QSKtrPJfq8RqN76AQ7uMjBRObRdJ0JFjKGYXapqgVdxFMkBFa8h+NGfktlZX4aq/ws2FfGY4bqGx9MfYDUmjcsgnjFtt5w3zQ1Zw72ZmjsEhjDcPJiseFC+XS5OlLe5QdxBpcSQu71rKlESbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P5jnVTXW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P5jnVTXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32BA6C2BBFC;
	Thu, 27 Jun 2024 22:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719528471;
	bh=2G7gKCuBKWWf2eWUerjEVv4Xiot2LpM4NGGc4XOgySs=;
	h=Date:To:From:Subject:From;
	b=P5jnVTXWPeOeRC3JSYQy12Rfqzj3rO9YQMTkjLH01fhSxHgaN1rA0Keee+sWxwOof
	 kLdhWjPhtnvOz5ZMx8D9kxQSatBPoqycrHuvt9Lll4e0mLt6MfBdc1eqwTRTUVLWWf
	 /YHEq2fco3xmoFyu9qge7LQ6GTyEi1ztKhOCTnMo=
Date: Thu, 27 Jun 2024 15:47:50 -0700
To: mm-commits@vger.kernel.org,yang@os.amperecomputing.com,willy@infradead.org,peterx@redhat.com,muchun.song@linux.dev,fvdl@google.com,david@redhat.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-fix-race-with-speculative-pfn-walkers.patch added to mm-hotfixes-unstable branch
Message-Id: <20240627224751.32BA6C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb_vmemmap: fix race with speculative PFN walkers
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-fix-race-with-speculative-pfn-walkers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-fix-race-with-speculative-pfn-walkers.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Yu Zhao <yuzhao@google.com>
Subject: mm/hugetlb_vmemmap: fix race with speculative PFN walkers
Date: Thu, 27 Jun 2024 16:27:05 -0600

While investigating HVO for THPs [1], it turns out that speculative PFN
walkers like compaction can race with vmemmap modifications, e.g.,

  CPU 1 (vmemmap modifier)         CPU 2 (speculative PFN walker)
  -------------------------------  ------------------------------
  Allocates an LRU folio page1
                                   Sees page1
  Frees page1

  Allocates a hugeTLB folio page2
  (page1 being a tail of page2)

  Updates vmemmap mapping page1
                                   get_page_unless_zero(page1)

Even though page1->_refcount is zero after HVO, get_page_unless_zero() can
still try to modify this read-only field, resulting in a crash.

An independent report [2] confirmed this race.

There are two discussed approaches to fix this race:
1. Make RO vmemmap RW so that get_page_unless_zero() can fail without
   triggering a PF.
2. Use RCU to make sure get_page_unless_zero() either sees zero
   page->_refcount through the old vmemmap or non-zero page->_refcount
   through the new one.

The second approach is preferred here because:
1. It can prevent illegal modifications to struct page[] that has been
   HVO'ed;
2. It can be generalized, in a way similar to ZERO_PAGE(), to fix
   similar races in other places, e.g., arch_remove_memory() on x86
   [3], which frees vmemmap mapping offlined struct page[].

While adding synchronize_rcu(), the goal is to be surgical, rather than
optimized.  Specifically, calls to synchronize_rcu() on the error handling
paths can be coalesced, but it is not done for the sake of Simplicity:
noticeably, this fix removes ~50% more lines than it adds.

According to the hugetlb_optimize_vmemmap section in
Documentation/admin-guide/sysctl/vm.rst, enabling HVO makes allocating or
freeing hugeTLB pages "~2x slower than before".  Having synchronize_rcu()
on top makes those operations even worse, and this also affects the user
interface /proc/sys/vm/nr_overcommit_hugepages.

[1] https://lore.kernel.org/20240229183436.4110845-4-yuzhao@google.com/
[2] https://lore.kernel.org/917FFC7F-0615-44DD-90EE-9F85F8EA9974@linux.dev/
[3] https://lore.kernel.org/be130a96-a27e-4240-ad78-776802f57cad@redhat.com/

Link: https://lkml.kernel.org/r/20240627222705.2974207-1-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_ref.h |    8 ++++-
 mm/hugetlb.c             |   53 ++++---------------------------------
 mm/hugetlb_vmemmap.c     |   16 +++++++++++
 3 files changed, 30 insertions(+), 47 deletions(-)

--- a/include/linux/page_ref.h~mm-hugetlb_vmemmap-fix-race-with-speculative-pfn-walkers
+++ a/include/linux/page_ref.h
@@ -230,7 +230,13 @@ static inline int folio_ref_dec_return(s
 
 static inline bool page_ref_add_unless(struct page *page, int nr, int u)
 {
-	bool ret = atomic_add_unless(&page->_refcount, nr, u);
+	bool ret = false;
+
+	rcu_read_lock();
+	/* avoid writing to the vmemmap area being remapped */
+	if (!page_is_fake_head(page) && page_ref_count(page) != u)
+		ret = atomic_add_unless(&page->_refcount, nr, u);
+	rcu_read_unlock();
 
 	if (page_ref_tracepoint_active(page_ref_mod_unless))
 		__page_ref_mod_unless(page, nr, ret);
--- a/mm/hugetlb.c~mm-hugetlb_vmemmap-fix-race-with-speculative-pfn-walkers
+++ a/mm/hugetlb.c
@@ -1625,13 +1625,10 @@ static inline void destroy_compound_giga
  * folio appears as just a compound page.  Otherwise, wait until after
  * allocating vmemmap to clear the flag.
  *
- * A reference is held on the folio, except in the case of demote.
- *
  * Must be called with hugetlb lock held.
  */
-static void __remove_hugetlb_folio(struct hstate *h, struct folio *folio,
-							bool adjust_surplus,
-							bool demote)
+static void remove_hugetlb_folio(struct hstate *h, struct folio *folio,
+							bool adjust_surplus)
 {
 	int nid = folio_nid(folio);
 
@@ -1645,6 +1642,7 @@ static void __remove_hugetlb_folio(struc
 	list_del(&folio->lru);
 
 	if (folio_test_hugetlb_freed(folio)) {
+		folio_clear_hugetlb_freed(folio);
 		h->free_huge_pages--;
 		h->free_huge_pages_node[nid]--;
 	}
@@ -1661,33 +1659,13 @@ static void __remove_hugetlb_folio(struc
 	if (!folio_test_hugetlb_vmemmap_optimized(folio))
 		__folio_clear_hugetlb(folio);
 
-	 /*
-	  * In the case of demote we do not ref count the page as it will soon
-	  * be turned into a page of smaller size.
-	 */
-	if (!demote)
-		folio_ref_unfreeze(folio, 1);
-
 	h->nr_huge_pages--;
 	h->nr_huge_pages_node[nid]--;
 }
 
-static void remove_hugetlb_folio(struct hstate *h, struct folio *folio,
-							bool adjust_surplus)
-{
-	__remove_hugetlb_folio(h, folio, adjust_surplus, false);
-}
-
-static void remove_hugetlb_folio_for_demote(struct hstate *h, struct folio *folio,
-							bool adjust_surplus)
-{
-	__remove_hugetlb_folio(h, folio, adjust_surplus, true);
-}
-
 static void add_hugetlb_folio(struct hstate *h, struct folio *folio,
 			     bool adjust_surplus)
 {
-	int zeroed;
 	int nid = folio_nid(folio);
 
 	VM_BUG_ON_FOLIO(!folio_test_hugetlb_vmemmap_optimized(folio), folio);
@@ -1711,21 +1689,6 @@ static void add_hugetlb_folio(struct hst
 	 */
 	folio_set_hugetlb_vmemmap_optimized(folio);
 
-	/*
-	 * This folio is about to be managed by the hugetlb allocator and
-	 * should have no users.  Drop our reference, and check for others
-	 * just in case.
-	 */
-	zeroed = folio_put_testzero(folio);
-	if (unlikely(!zeroed))
-		/*
-		 * It is VERY unlikely soneone else has taken a ref
-		 * on the folio.  In this case, we simply return as
-		 * free_huge_folio() will be called when this other ref
-		 * is dropped.
-		 */
-		return;
-
 	arch_clear_hugetlb_flags(folio);
 	enqueue_hugetlb_folio(h, folio);
 }
@@ -1779,6 +1742,8 @@ static void __update_and_free_hugetlb_fo
 		spin_unlock_irq(&hugetlb_lock);
 	}
 
+	folio_ref_unfreeze(folio, 1);
+
 	/*
 	 * Non-gigantic pages demoted from CMA allocated gigantic pages
 	 * need to be given back to CMA in free_gigantic_folio.
@@ -3079,11 +3044,8 @@ retry:
 
 free_new:
 	spin_unlock_irq(&hugetlb_lock);
-	if (new_folio) {
-		/* Folio has a zero ref count, but needs a ref to be freed */
-		folio_ref_unfreeze(new_folio, 1);
+	if (new_folio)
 		update_and_free_hugetlb_folio(h, new_folio, false);
-	}
 
 	return ret;
 }
@@ -3938,7 +3900,7 @@ static int demote_free_hugetlb_folio(str
 
 	target_hstate = size_to_hstate(PAGE_SIZE << h->demote_order);
 
-	remove_hugetlb_folio_for_demote(h, folio, false);
+	remove_hugetlb_folio(h, folio, false);
 	spin_unlock_irq(&hugetlb_lock);
 
 	/*
@@ -3952,7 +3914,6 @@ static int demote_free_hugetlb_folio(str
 		if (rc) {
 			/* Allocation of vmemmmap failed, we can not demote folio */
 			spin_lock_irq(&hugetlb_lock);
-			folio_ref_unfreeze(folio, 1);
 			add_hugetlb_folio(h, folio, false);
 			return rc;
 		}
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-fix-race-with-speculative-pfn-walkers
+++ a/mm/hugetlb_vmemmap.c
@@ -446,6 +446,8 @@ static int __hugetlb_vmemmap_restore_fol
 	unsigned long vmemmap_reuse;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
+
 	if (!folio_test_hugetlb_vmemmap_optimized(folio))
 		return 0;
 
@@ -481,6 +483,9 @@ static int __hugetlb_vmemmap_restore_fol
  */
 int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio)
 {
+	/* avoid writes from page_ref_add_unless() while unfolding vmemmap */
+	synchronize_rcu();
+
 	return __hugetlb_vmemmap_restore_folio(h, folio, 0);
 }
 
@@ -505,6 +510,9 @@ long hugetlb_vmemmap_restore_folios(cons
 	long restored = 0;
 	long ret = 0;
 
+	/* avoid writes from page_ref_add_unless() while unfolding vmemmap */
+	synchronize_rcu();
+
 	list_for_each_entry_safe(folio, t_folio, folio_list, lru) {
 		if (folio_test_hugetlb_vmemmap_optimized(folio)) {
 			ret = __hugetlb_vmemmap_restore_folio(h, folio,
@@ -550,6 +558,8 @@ static int __hugetlb_vmemmap_optimize_fo
 	unsigned long vmemmap_reuse;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
+
 	if (!vmemmap_should_optimize_folio(h, folio))
 		return ret;
 
@@ -601,6 +611,9 @@ void hugetlb_vmemmap_optimize_folio(cons
 {
 	LIST_HEAD(vmemmap_pages);
 
+	/* avoid writes from page_ref_add_unless() while folding vmemmap */
+	synchronize_rcu();
+
 	__hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, 0);
 	free_vmemmap_page_list(&vmemmap_pages);
 }
@@ -644,6 +657,9 @@ void hugetlb_vmemmap_optimize_folios(str
 
 	flush_tlb_all();
 
+	/* avoid writes from page_ref_add_unless() while folding vmemmap */
+	synchronize_rcu();
+
 	list_for_each_entry(folio, folio_list, lru) {
 		int ret;
 
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-hugetlb_vmemmap-fix-race-with-speculative-pfn-walkers.patch

