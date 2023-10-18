Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B879DC46CA1
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:36:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbjJRVg3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235221AbjJRVgF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:05 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710CD136
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F4CC4166B;
        Wed, 18 Oct 2023 21:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664916;
        bh=moGw93o7d6e4sUXv2EJkC3mzwLwh6eAolilWSxOWMKc=;
        h=Date:To:From:Subject:From;
        b=T442XK171jwgyS1dqykvOaaKlCDmp0+y/FT9c4hdblGkd/PUF1IpkYVK/Ki39XQD9
         vPKhhfZ2Wj8hTd6TW3UVVXr3/a310a3FYzS5HfCGVIrfKJq8qISCzHt/+IJQAqhUpa
         exqb1Hh4IB0EFg+BC9lv1Efukgq1m0KnsVcmRXSI=
Date:   Wed, 18 Oct 2023 14:35:15 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, surenb@google.com, muchun.song@linux.dev,
        mike.kravetz@oracle.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-move-setpageanonexclusive-out-of-page_move_anon_rmap.patch removed from -mm tree
Message-Id: <20231018213516.36F4CC4166B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/rmap: move SetPageAnonExclusive() out of page_move_anon_rmap()
has been removed from the -mm tree.  Its filename was
     mm-rmap-move-setpageanonexclusive-out-of-page_move_anon_rmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: move SetPageAnonExclusive() out of page_move_anon_rmap()
Date: Mon, 2 Oct 2023 16:29:47 +0200

Patch series "mm/rmap: convert page_move_anon_rmap() to
folio_move_anon_rmap()".

Convert page_move_anon_rmap() to folio_move_anon_rmap(), letting the
callers handle PageAnonExclusive.  I'm including cleanup patch #3 because
it fits into the picture and can be done cleaner by the conversion.


This patch (of 3):

Let's move it into the caller: there is a difference between whether an
anon folio can only be mapped by one process (e.g., into one VMA), and
whether it is truly exclusive (e.g., no references -- including GUP --
from other processes).

Further, for large folios the page might not actually be pointing at the
head page of the folio, so it better be handled in the caller.  This is a
preparation for converting page_move_anon_rmap() to consume a folio.

Link: https://lkml.kernel.org/r/20231002142949.235104-1-david@redhat.com
Link: https://lkml.kernel.org/r/20231002142949.235104-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    1 +
 mm/hugetlb.c     |    4 +++-
 mm/memory.c      |    1 +
 mm/rmap.c        |    1 -
 4 files changed, 5 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-rmap-move-setpageanonexclusive-out-of-page_move_anon_rmap
+++ a/mm/huge_memory.c
@@ -1377,6 +1377,7 @@ vm_fault_t do_huge_pmd_wp_page(struct vm
 		pmd_t entry;
 
 		page_move_anon_rmap(page, vma);
+		SetPageAnonExclusive(page);
 		folio_unlock(folio);
 reuse:
 		if (unlikely(unshare)) {
--- a/mm/hugetlb.c~mm-rmap-move-setpageanonexclusive-out-of-page_move_anon_rmap
+++ a/mm/hugetlb.c
@@ -5652,8 +5652,10 @@ retry_avoidcopy:
 	 * owner and can reuse this page.
 	 */
 	if (folio_mapcount(old_folio) == 1 && folio_test_anon(old_folio)) {
-		if (!PageAnonExclusive(&old_folio->page))
+		if (!PageAnonExclusive(&old_folio->page)) {
 			page_move_anon_rmap(&old_folio->page, vma);
+			SetPageAnonExclusive(&old_folio->page);
+		}
 		if (likely(!unshare))
 			set_huge_ptep_writable(vma, haddr, ptep);
 
--- a/mm/memory.c~mm-rmap-move-setpageanonexclusive-out-of-page_move_anon_rmap
+++ a/mm/memory.c
@@ -3481,6 +3481,7 @@ static vm_fault_t do_wp_page(struct vm_f
 		 * sunglasses. Hit it.
 		 */
 		page_move_anon_rmap(vmf->page, vma);
+		SetPageAnonExclusive(vmf->page);
 		folio_unlock(folio);
 reuse:
 		if (unlikely(unshare)) {
--- a/mm/rmap.c~mm-rmap-move-setpageanonexclusive-out-of-page_move_anon_rmap
+++ a/mm/rmap.c
@@ -1152,7 +1152,6 @@ void page_move_anon_rmap(struct page *pa
 	 * folio_test_anon()) will not see one without the other.
 	 */
 	WRITE_ONCE(folio->mapping, anon_vma);
-	SetPageAnonExclusive(page);
 }
 
 /**
_

Patches currently in -mm which might be from david@redhat.com are


