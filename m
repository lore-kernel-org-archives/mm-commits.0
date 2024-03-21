Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABBF134420
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 21:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711055019; cv=none; b=R5sICyTXq5kgsj4MyW3mmoMbaXMByPT6XiY0G6RL9iIHdHElvI6gXYtUUZzQTUYEObHMiLJLfQd7jyOvabP/phMSrpYUJan8VioJwE7PNFwkVXWGv6pxj9EhHp49/reJXuHNMBp9cZQ7SZNvI++gVR43YnXkz4pcAmid98UFY14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711055019; c=relaxed/simple;
	bh=Kgy5M254SA4TGHxG979sZrDjAhWXytm9qn9jbcMBsLE=;
	h=Date:To:From:Subject:Message-Id; b=l36Z5+WYzFE/LiffM7u15AIX9ErdvL0XFG7mEt44Xlx1aH40vDNWQmY7jehOOBGjjCpTO2WxTqa/U8hqDCqjopXSdYBFbkSi/6n2lNE+Sk2Pjf3EuB8kuXyiI+p2ucg5UJuvdEdqvTIAvYQx4XR55vyY2KN4dTcfhbFUBDqCxOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nJE0WjHL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nJE0WjHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9563BC433F1;
	Thu, 21 Mar 2024 21:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711055019;
	bh=Kgy5M254SA4TGHxG979sZrDjAhWXytm9qn9jbcMBsLE=;
	h=Date:To:From:Subject:From;
	b=nJE0WjHL+5SdAq2fMKdNQOMp410f8nR528jc/1R9byBq2Lf2dRW92w7RvKePbQ2bm
	 iGt74J4mwb5RI8HiZAQ/gsqBhRNBClpjWH50SISUeOOu3AgpgXbqlBXjUN2mL0RUWt
	 5i2HFHJWnCCjmiu3fk/zTGZ7092MQ6FmblIAkT5M=
Date: Thu, 21 Mar 2024 14:03:39 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,muchun.song@linux.dev,linmiaohe@huawei.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-remove-mention-of-destructors.patch added to mm-unstable branch
Message-Id: <20240321210339.9563BC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb: remove mention of destructors
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-remove-mention-of-destructors.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-remove-mention-of-destructors.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: hugetlb: remove mention of destructors
Date: Thu, 21 Mar 2024 14:24:47 +0000

We no longer have destructors or dtors, merely a page flag (technically a
page type flag, but that's an implementation detail).  Remove
__clear_hugetlb_destructor, fix up comments and the occasional variable
name.

Link: https://lkml.kernel.org/r/20240321142448.1645400-10-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   42 +++++++++++++++++-------------------------
 1 file changed, 17 insertions(+), 25 deletions(-)

--- a/mm/hugetlb.c~hugetlb-remove-mention-of-destructors
+++ a/mm/hugetlb.c
@@ -1619,19 +1619,11 @@ static inline void destroy_compound_giga
 						unsigned int order) { }
 #endif
 
-static inline void __clear_hugetlb_destructor(struct hstate *h,
-						struct folio *folio)
-{
-	lockdep_assert_held(&hugetlb_lock);
-
-	__folio_clear_hugetlb(folio);
-}
-
 /*
  * Remove hugetlb folio from lists.
- * If vmemmap exists for the folio, update dtor so that the folio appears
- * as just a compound page.  Otherwise, wait until after allocating vmemmap
- * to update dtor.
+ * If vmemmap exists for the folio, clear the hugetlb flag so that the
+ * folio appears as just a compound page.  Otherwise, wait until after
+ * allocating vmemmap to clear the flag.
  *
  * A reference is held on the folio, except in the case of demote.
  *
@@ -1662,12 +1654,12 @@ static void __remove_hugetlb_folio(struc
 	}
 
 	/*
-	 * We can only clear the hugetlb destructor after allocating vmemmap
+	 * We can only clear the hugetlb flag after allocating vmemmap
 	 * pages.  Otherwise, someone (memory error handling) may try to write
 	 * to tail struct pages.
 	 */
 	if (!folio_test_hugetlb_vmemmap_optimized(folio))
-		__clear_hugetlb_destructor(h, folio);
+		__folio_clear_hugetlb(folio);
 
 	 /*
 	  * In the case of demote we do not ref count the page as it will soon
@@ -1741,7 +1733,7 @@ static void add_hugetlb_folio(struct hst
 static void __update_and_free_hugetlb_folio(struct hstate *h,
 						struct folio *folio)
 {
-	bool clear_dtor = folio_test_hugetlb_vmemmap_optimized(folio);
+	bool clear_flag = folio_test_hugetlb_vmemmap_optimized(folio);
 
 	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
 		return;
@@ -1754,11 +1746,11 @@ static void __update_and_free_hugetlb_fo
 		return;
 
 	/*
-	 * If folio is not vmemmap optimized (!clear_dtor), then the folio
+	 * If folio is not vmemmap optimized (!clear_flag), then the folio
 	 * is no longer identified as a hugetlb page.  hugetlb_vmemmap_restore_folio
 	 * can only be passed hugetlb pages and will BUG otherwise.
 	 */
-	if (clear_dtor && hugetlb_vmemmap_restore_folio(h, folio)) {
+	if (clear_flag && hugetlb_vmemmap_restore_folio(h, folio)) {
 		spin_lock_irq(&hugetlb_lock);
 		/*
 		 * If we cannot allocate vmemmap pages, just refuse to free the
@@ -1779,11 +1771,11 @@ static void __update_and_free_hugetlb_fo
 
 	/*
 	 * If vmemmap pages were allocated above, then we need to clear the
-	 * hugetlb destructor under the hugetlb lock.
+	 * hugetlb flag under the hugetlb lock.
 	 */
-	if (clear_dtor) {
+	if (clear_flag) {
 		spin_lock_irq(&hugetlb_lock);
-		__clear_hugetlb_destructor(h, folio);
+		__folio_clear_hugetlb(folio);
 		spin_unlock_irq(&hugetlb_lock);
 	}
 
@@ -1885,7 +1877,7 @@ static void bulk_vmemmap_restore_error(s
 		list_for_each_entry_safe(folio, t_folio, non_hvo_folios, lru) {
 			list_del(&folio->lru);
 			spin_lock_irq(&hugetlb_lock);
-			__clear_hugetlb_destructor(h, folio);
+			__folio_clear_hugetlb(folio);
 			spin_unlock_irq(&hugetlb_lock);
 			update_and_free_hugetlb_folio(h, folio, false);
 			cond_resched();
@@ -1910,7 +1902,7 @@ static void bulk_vmemmap_restore_error(s
 			} else {
 				list_del(&folio->lru);
 				spin_lock_irq(&hugetlb_lock);
-				__clear_hugetlb_destructor(h, folio);
+				__folio_clear_hugetlb(folio);
 				spin_unlock_irq(&hugetlb_lock);
 				update_and_free_hugetlb_folio(h, folio, false);
 				cond_resched();
@@ -1943,14 +1935,14 @@ retry:
 	 * should only be pages on the non_hvo_folios list.
 	 * Do note that the non_hvo_folios list could be empty.
 	 * Without HVO enabled, ret will be 0 and there is no need to call
-	 * __clear_hugetlb_destructor as this was done previously.
+	 * __folio_clear_hugetlb as this was done previously.
 	 */
 	VM_WARN_ON(!list_empty(folio_list));
 	VM_WARN_ON(ret < 0);
 	if (!list_empty(&non_hvo_folios) && ret) {
 		spin_lock_irq(&hugetlb_lock);
 		list_for_each_entry(folio, &non_hvo_folios, lru)
-			__clear_hugetlb_destructor(h, folio);
+			__folio_clear_hugetlb(folio);
 		spin_unlock_irq(&hugetlb_lock);
 	}
 
@@ -1975,7 +1967,7 @@ void free_huge_folio(struct folio *folio
 {
 	/*
 	 * Can't pass hstate in here because it is called from the
-	 * compound page destructor.
+	 * generic mm code.
 	 */
 	struct hstate *h = folio_hstate(folio);
 	int nid = folio_nid(folio);
@@ -2125,7 +2117,7 @@ static bool __prep_compound_gigantic_fol
 			set_compound_head(p, &folio->page);
 	}
 	__folio_set_head(folio);
-	/* we rely on prep_new_hugetlb_folio to set the destructor */
+	/* we rely on prep_new_hugetlb_folio to set the hugetlb flag */
 	folio_set_order(folio, order);
 	atomic_set(&folio->_entire_mapcount, -1);
 	atomic_set(&folio->_nr_pages_mapped, 0);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-increase-folio-batch-size.patch
mm-always-initialise-folio-_deferred_list.patch
mm-create-folio_flag_false-and-folio_type_ops-macros.patch
mm-remove-folio_prep_large_rmappable.patch
mm-support-page_mapcount-on-page_has_type-pages.patch
mm-turn-folio_test_hugetlb-into-a-pagetype.patch
mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch
mm-free-up-pg_slab.patch
mm-improve-dumping-of-mapcount-and-page_type.patch
hugetlb-remove-mention-of-destructors.patch

