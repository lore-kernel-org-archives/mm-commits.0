Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BF20C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 10 Nov 2022 03:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbiKJD2s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Nov 2022 22:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbiKJD2r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2022 22:28:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BFCD13F06
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 19:28:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E4C56CE2130
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2022 03:28:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B68FC433D6;
        Thu, 10 Nov 2022 03:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668050923;
        bh=KklHEi2GfLJvONCEovfbTMl41X7EU/Moroods9Dvn/o=;
        h=Date:To:From:Subject:From;
        b=xyhf8VBcQqOogds7bgHlJf/Wg07LWtLthEiER/DnL8XYtvpCHQ2/RLNdpt2muFPkx
         dRH45gxzDfLc4uKDszsj6ZWdhJld6g8fK5JquyxT67mWqULzJb0DCmB49FBFRRLD7d
         9BIeLIHEF+gEFPzVA8PqgckY7lmlMm2yYYb2S4Fs=
Date:   Wed, 09 Nov 2022 19:28:42 -0800
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, vbabka@suse.cz, songmuchun@bytedance.com,
        sidhartha.kumar@oracle.com, shy828301@gmail.com, peterx@redhat.com,
        naoya.horiguchi@linux.dev, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jthoughton@google.com, jhubbard@nvidia.com, david@redhat.com,
        almasrymina@google.com, hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmthprmap-handle-the-normal-pagecompound-case-first.patch added to mm-unstable branch
Message-Id: <20221110032843.0B68FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,thp,rmap: handle the normal !PageCompound case first
has been added to the -mm mm-unstable branch.  Its filename is
     mmthprmap-handle-the-normal-pagecompound-case-first.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmthprmap-handle-the-normal-pagecompound-case-first.patch

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
From: Hugh Dickins <hughd@google.com>
Subject: mm,thp,rmap: handle the normal !PageCompound case first
Date: Wed, 9 Nov 2022 18:18:49 -0800 (PST)

Commit ("mm,thp,rmap: lock_compound_mapcounts() on THP mapcounts")
propagated the "if (compound) {lock} else if (PageCompound) {lock} else
{atomic}" pattern throughout; but Linus hated the way that gives primacy
to the uncommon case: switch to "if (!PageCompound) {atomic} else if
(compound) {lock} else {lock}" throughout.  Linus has a bigger idea for
how to improve it all, but here just make that rearrangement.

Link: https://lkml.kernel.org/r/fca2f694-2098-b0ef-d4e-f1d8b94d318c@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   54 ++++++++++++++++++++++++++--------------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

--- a/mm/rmap.c~mmthprmap-handle-the-normal-pagecompound-case-first
+++ a/mm/rmap.c
@@ -1311,7 +1311,11 @@ void page_add_anon_rmap(struct page *pag
 	else
 		VM_BUG_ON_PAGE(!PageLocked(page), page);
 
-	if (compound && PageTransHuge(page)) {
+	if (likely(!PageCompound(page))) {
+		first = atomic_inc_and_test(&page->_mapcount);
+		nr = first;
+
+	} else if (compound && PageTransHuge(page)) {
 		lock_compound_mapcounts(page, &mapcounts);
 		first = !mapcounts.compound_mapcount;
 		mapcounts.compound_mapcount++;
@@ -1321,8 +1325,7 @@ void page_add_anon_rmap(struct page *pag
 				nr = nr_subpages_unmapped(page, nr_pmdmapped);
 		}
 		unlock_compound_mapcounts(page, &mapcounts);
-
-	} else if (PageCompound(page)) {
+	} else {
 		struct page *head = compound_head(page);
 
 		lock_compound_mapcounts(head, &mapcounts);
@@ -1330,10 +1333,6 @@ void page_add_anon_rmap(struct page *pag
 		first = subpage_mapcount_inc(page);
 		nr = first && !mapcounts.compound_mapcount;
 		unlock_compound_mapcounts(head, &mapcounts);
-
-	} else {
-		first = atomic_inc_and_test(&page->_mapcount);
-		nr = first;
 	}
 
 	VM_BUG_ON_PAGE(!first && (flags & RMAP_EXCLUSIVE), page);
@@ -1373,20 +1372,23 @@ void page_add_anon_rmap(struct page *pag
 void page_add_new_anon_rmap(struct page *page,
 	struct vm_area_struct *vma, unsigned long address)
 {
-	const bool compound = PageCompound(page);
-	int nr = compound ? thp_nr_pages(page) : 1;
+	int nr;
 
 	VM_BUG_ON_VMA(address < vma->vm_start || address >= vma->vm_end, vma);
 	__SetPageSwapBacked(page);
-	if (compound) {
+
+	if (likely(!PageCompound(page))) {
+		/* increment count (starts at -1) */
+		atomic_set(&page->_mapcount, 0);
+		nr = 1;
+	} else {
 		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
 		/* increment count (starts at -1) */
 		atomic_set(compound_mapcount_ptr(page), 0);
+		nr = thp_nr_pages(page);
 		__mod_lruvec_page_state(page, NR_ANON_THPS, nr);
-	} else {
-		/* increment count (starts at -1) */
-		atomic_set(&page->_mapcount, 0);
 	}
+
 	__mod_lruvec_page_state(page, NR_ANON_MAPPED, nr);
 	__page_set_anon_rmap(page, vma, address, 1);
 }
@@ -1409,7 +1411,11 @@ void page_add_file_rmap(struct page *pag
 	VM_BUG_ON_PAGE(compound && !PageTransHuge(page), page);
 	lock_page_memcg(page);
 
-	if (compound && PageTransHuge(page)) {
+	if (likely(!PageCompound(page))) {
+		first = atomic_inc_and_test(&page->_mapcount);
+		nr = first;
+
+	} else if (compound && PageTransHuge(page)) {
 		lock_compound_mapcounts(page, &mapcounts);
 		first = !mapcounts.compound_mapcount;
 		mapcounts.compound_mapcount++;
@@ -1419,8 +1425,7 @@ void page_add_file_rmap(struct page *pag
 				nr = nr_subpages_unmapped(page, nr_pmdmapped);
 		}
 		unlock_compound_mapcounts(page, &mapcounts);
-
-	} else if (PageCompound(page)) {
+	} else {
 		struct page *head = compound_head(page);
 
 		lock_compound_mapcounts(head, &mapcounts);
@@ -1428,10 +1433,6 @@ void page_add_file_rmap(struct page *pag
 		first = subpage_mapcount_inc(page);
 		nr = first && !mapcounts.compound_mapcount;
 		unlock_compound_mapcounts(head, &mapcounts);
-
-	} else {
-		first = atomic_inc_and_test(&page->_mapcount);
-		nr = first;
 	}
 
 	if (nr_pmdmapped)
@@ -1471,7 +1472,11 @@ void page_remove_rmap(struct page *page,
 	lock_page_memcg(page);
 
 	/* page still mapped by someone else? */
-	if (compound && PageTransHuge(page)) {
+	if (likely(!PageCompound(page))) {
+		last = atomic_add_negative(-1, &page->_mapcount);
+		nr = last;
+
+	} else if (compound && PageTransHuge(page)) {
 		lock_compound_mapcounts(page, &mapcounts);
 		mapcounts.compound_mapcount--;
 		last = !mapcounts.compound_mapcount;
@@ -1481,8 +1486,7 @@ void page_remove_rmap(struct page *page,
 				nr = nr_subpages_unmapped(page, nr_pmdmapped);
 		}
 		unlock_compound_mapcounts(page, &mapcounts);
-
-	} else if (PageCompound(page)) {
+	} else {
 		struct page *head = compound_head(page);
 
 		lock_compound_mapcounts(head, &mapcounts);
@@ -1490,10 +1494,6 @@ void page_remove_rmap(struct page *page,
 		last = subpage_mapcount_dec(page);
 		nr = last && !mapcounts.compound_mapcount;
 		unlock_compound_mapcounts(head, &mapcounts);
-
-	} else {
-		last = atomic_add_negative(-1, &page->_mapcount);
-		nr = last;
 	}
 
 	if (nr_pmdmapped) {
_

Patches currently in -mm which might be from hughd@google.com are

mmhugetlb-use-folio-fields-in-second-tail-page.patch
mmhugetlb-use-folio-fields-in-second-tail-page-fix.patch
mmthprmap-simplify-compound-page-mapcount-handling.patch
mmthprmap-lock_compound_mapcounts-on-thp-mapcounts.patch
mmthprmap-handle-the-normal-pagecompound-case-first.patch

