Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D918C41513
	for <mm-commits@archiver.kernel.org>; Fri,  4 Aug 2023 20:04:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbjHDUEe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Aug 2023 16:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbjHDUEU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2023 16:04:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F1FE6E;
        Fri,  4 Aug 2023 13:04:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B57AE62120;
        Fri,  4 Aug 2023 20:04:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D83C433C7;
        Fri,  4 Aug 2023 20:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691179458;
        bh=yKgc0fR6WQTIbrXdOSJA5V0U6o+15x4Ywwd1SrqGlHw=;
        h=Date:To:From:Subject:From;
        b=1oMVaRXuAbKdG0qjnp69S7G8GkSjPv7Mnh6WNYljldNeu54MDz1mq3QbT04Q4TzXm
         4/ZAp0gYggDLH7aElN8G3CUMaOwH99TToC8Q1Gg1gIu4OGBefDBb2sT6coxqAlRJZY
         Rgvscp7vXxvvJin5h2fb5L2FumpchjIiotBf8voI=
Date:   Fri, 04 Aug 2023 13:04:17 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songmuchun@bytedance.com, naoya.horiguchi@nec.com, mhocko@suse.com,
        linmiaohe@huawei.com, jthoughton@google.com, jiaqiyan@google.com,
        axelrasmussen@google.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] hugetlb-do-not-clear-hugetlb-dtor-until-allocating-vmemmap.patch removed from -mm tree
Message-Id: <20230804200418.16D83C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: do not clear hugetlb dtor until allocating vmemmap
has been removed from the -mm tree.  Its filename was
     hugetlb-do-not-clear-hugetlb-dtor-until-allocating-vmemmap.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: do not clear hugetlb dtor until allocating vmemmap
Date: Tue, 11 Jul 2023 15:09:41 -0700

Patch series "Fix hugetlb free path race with memory errors".

In the discussion of Jiaqi Yan's series "Improve hugetlbfs read on
HWPOISON hugepages" the race window was discovered. 
https://lore.kernel.org/linux-mm/20230616233447.GB7371@monkey/

Freeing a hugetlb page back to low level memory allocators is performed
in two steps.
1) Under hugetlb lock, remove page from hugetlb lists and clear destructor
2) Outside lock, allocate vmemmap if necessary and call low level free
Between these two steps, the hugetlb page will appear as a normal
compound page.  However, vmemmap for tail pages could be missing.
If a memory error occurs at this time, we could try to update page
flags non-existant page structs.

A much more detailed description is in the first patch.

The first patch addresses the race window.  However, it adds a
hugetlb_lock lock/unlock cycle to every vmemmap optimized hugetlb page
free operation.  This could lead to slowdowns if one is freeing a large
number of hugetlb pages.

The second path optimizes the update_and_free_pages_bulk routine to only
take the lock once in bulk operations.

The second patch is technically not a bug fix, but includes a Fixes tag
and Cc stable to avoid a performance regression.  It can be combined with
the first, but was done separately make reviewing easier.


This patch (of 2):

Freeing a hugetlb page and releasing base pages back to the underlying
allocator such as buddy or cma is performed in two steps:
- remove_hugetlb_folio() is called to remove the folio from hugetlb
  lists, get a ref on the page and remove hugetlb destructor.  This
  all must be done under the hugetlb lock.  After this call, the page
  can be treated as a normal compound page or a collection of base
  size pages.
- update_and_free_hugetlb_folio() is called to allocate vmemmap if
  needed and the free routine of the underlying allocator is called
  on the resulting page.  We can not hold the hugetlb lock here.

One issue with this scheme is that a memory error could occur between
these two steps.  In this case, the memory error handling code treats
the old hugetlb page as a normal compound page or collection of base
pages.  It will then try to SetPageHWPoison(page) on the page with an
error.  If the page with error is a tail page without vmemmap, a write
error will occur when trying to set the flag.

Address this issue by modifying remove_hugetlb_folio() and
update_and_free_hugetlb_folio() such that the hugetlb destructor is not
cleared until after allocating vmemmap.  Since clearing the destructor
requires holding the hugetlb lock, the clearing is done in
remove_hugetlb_folio() if the vmemmap is present.  This saves a
lock/unlock cycle.  Otherwise, destructor is cleared in
update_and_free_hugetlb_folio() after allocating vmemmap.

Note that this will leave hugetlb pages in a state where they are marked
free (by hugetlb specific page flag) and have a ref count.  This is not
a normal state.  The only code that would notice is the memory error
code, and it is set up to retry in such a case.

A subsequent patch will create a routine to do bulk processing of
vmemmap allocation.  This will eliminate a lock/unlock cycle for each
hugetlb page in the case where we are freeing a large number of pages.

Link: https://lkml.kernel.org/r/20230711220942.43706-1-mike.kravetz@oracle.com
Link: https://lkml.kernel.org/r/20230711220942.43706-2-mike.kravetz@oracle.com
Fixes: ad2fa3717b74 ("mm: hugetlb: alloc the vmemmap pages associated with each HugeTLB page")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Tested-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   75 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 51 insertions(+), 24 deletions(-)

--- a/mm/hugetlb.c~hugetlb-do-not-clear-hugetlb-dtor-until-allocating-vmemmap
+++ a/mm/hugetlb.c
@@ -1579,9 +1579,37 @@ static inline void destroy_compound_giga
 						unsigned int order) { }
 #endif
 
+static inline void __clear_hugetlb_destructor(struct hstate *h,
+						struct folio *folio)
+{
+	lockdep_assert_held(&hugetlb_lock);
+
+	/*
+	 * Very subtle
+	 *
+	 * For non-gigantic pages set the destructor to the normal compound
+	 * page dtor.  This is needed in case someone takes an additional
+	 * temporary ref to the page, and freeing is delayed until they drop
+	 * their reference.
+	 *
+	 * For gigantic pages set the destructor to the null dtor.  This
+	 * destructor will never be called.  Before freeing the gigantic
+	 * page destroy_compound_gigantic_folio will turn the folio into a
+	 * simple group of pages.  After this the destructor does not
+	 * apply.
+	 *
+	 */
+	if (hstate_is_gigantic(h))
+		folio_set_compound_dtor(folio, NULL_COMPOUND_DTOR);
+	else
+		folio_set_compound_dtor(folio, COMPOUND_PAGE_DTOR);
+}
+
 /*
- * Remove hugetlb folio from lists, and update dtor so that the folio appears
- * as just a compound page.
+ * Remove hugetlb folio from lists.
+ * If vmemmap exists for the folio, update dtor so that the folio appears
+ * as just a compound page.  Otherwise, wait until after allocating vmemmap
+ * to update dtor.
  *
  * A reference is held on the folio, except in the case of demote.
  *
@@ -1612,31 +1640,19 @@ static void __remove_hugetlb_folio(struc
 	}
 
 	/*
-	 * Very subtle
-	 *
-	 * For non-gigantic pages set the destructor to the normal compound
-	 * page dtor.  This is needed in case someone takes an additional
-	 * temporary ref to the page, and freeing is delayed until they drop
-	 * their reference.
-	 *
-	 * For gigantic pages set the destructor to the null dtor.  This
-	 * destructor will never be called.  Before freeing the gigantic
-	 * page destroy_compound_gigantic_folio will turn the folio into a
-	 * simple group of pages.  After this the destructor does not
-	 * apply.
-	 *
-	 * This handles the case where more than one ref is held when and
-	 * after update_and_free_hugetlb_folio is called.
-	 *
-	 * In the case of demote we do not ref count the page as it will soon
-	 * be turned into a page of smaller size.
+	 * We can only clear the hugetlb destructor after allocating vmemmap
+	 * pages.  Otherwise, someone (memory error handling) may try to write
+	 * to tail struct pages.
+	 */
+	if (!folio_test_hugetlb_vmemmap_optimized(folio))
+		__clear_hugetlb_destructor(h, folio);
+
+	 /*
+	  * In the case of demote we do not ref count the page as it will soon
+	  * be turned into a page of smaller size.
 	 */
 	if (!demote)
 		folio_ref_unfreeze(folio, 1);
-	if (hstate_is_gigantic(h))
-		folio_set_compound_dtor(folio, NULL_COMPOUND_DTOR);
-	else
-		folio_set_compound_dtor(folio, COMPOUND_PAGE_DTOR);
 
 	h->nr_huge_pages--;
 	h->nr_huge_pages_node[nid]--;
@@ -1705,6 +1721,7 @@ static void __update_and_free_hugetlb_fo
 {
 	int i;
 	struct page *subpage;
+	bool clear_dtor = folio_test_hugetlb_vmemmap_optimized(folio);
 
 	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
 		return;
@@ -1735,6 +1752,16 @@ static void __update_and_free_hugetlb_fo
 	if (unlikely(folio_test_hwpoison(folio)))
 		folio_clear_hugetlb_hwpoison(folio);
 
+	/*
+	 * If vmemmap pages were allocated above, then we need to clear the
+	 * hugetlb destructor under the hugetlb lock.
+	 */
+	if (clear_dtor) {
+		spin_lock_irq(&hugetlb_lock);
+		__clear_hugetlb_destructor(h, folio);
+		spin_unlock_irq(&hugetlb_lock);
+	}
+
 	for (i = 0; i < pages_per_huge_page(h); i++) {
 		subpage = folio_page(folio, i);
 		subpage->flags &= ~(1 << PG_locked | 1 << PG_error |
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


