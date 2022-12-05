Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80D77C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  5 Dec 2022 02:13:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbiLECNR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 4 Dec 2022 21:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiLECNQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 4 Dec 2022 21:13:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D4B2643
        for <mm-commits@vger.kernel.org>; Sun,  4 Dec 2022 18:13:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A07D560EA1
        for <mm-commits@vger.kernel.org>; Mon,  5 Dec 2022 02:13:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE58C433D6;
        Mon,  5 Dec 2022 02:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670206394;
        bh=DmnLCvr4WWrXUzJ0ujcRmS6qJZQPLVWAzTnZGxYLzJ4=;
        h=Date:To:From:Subject:From;
        b=fQM7jGkcRAmbGquZbpt61cUFSKTrnIzEa5dhxP6AtVXJbd0wMalhs6mrompO56CsI
         JZoNPd5Far3zXnyaGrA8uLLEEKHCXBsAjvI+ABUClL5tSaM3gkCk0bXu+W8Ho6dinR
         zgI7Wh8+XPtrygNOCdHaUJBBQ8S8wRt9BMQgEw5M=
Date:   Sun, 04 Dec 2022 18:13:13 -0800
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, vbabka@suse.cz, torvalds@linux-foundation.org,
        songmuchun@bytedance.com, sidhartha.kumar@oracle.com,
        shy828301@gmail.com, peterx@redhat.com, naoya.horiguchi@linux.dev,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        kirill@shutemov.name, jthoughton@google.com, jhubbard@nvidia.com,
        hannes@cmpxchg.org, david@redhat.com, almasrymina@google.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmthprmap-fix-races-between-updates-of-subpages_mapcount.patch added to mm-unstable branch
Message-Id: <20221205021313.ECE58C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,thp,rmap: fix races between updates of subpages_mapcount
has been added to the -mm mm-unstable branch.  Its filename is
     mmthprmap-fix-races-between-updates-of-subpages_mapcount.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmthprmap-fix-races-between-updates-of-subpages_mapcount.patch

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
Subject: mm,thp,rmap: fix races between updates of subpages_mapcount
Date: Sun, 4 Dec 2022 17:57:07 -0800 (PST)

Commit 4b51634cd16a, introducing the COMPOUND_MAPPED bit, paid attention
to the impossibility of subpages_mapcount ever appearing negative; but did
not attend to those races in which it can momentarily appear larger than
thought possible.

These arise from how page_remove_rmap() first decrements page->_mapcount
or compound_mapcount, then, if that transition goes negative (logical 0),
decrements subpages_mapcount.  The initial decrement lets a racing
page_add_*_rmap() reincrement _mapcount or compound_mapcount immediately,
and then in rare cases its corresponding increment of subpages_mapcount
may be completed before page_remove_rmap()'s decrement.  There could even
(with increasing unlikelihood) be a series of increments intermixed with
the decrements.

In practice, checking subpages_mapcount with a temporary WARN on range,
has caught values of 0x1000000 (2*COMPOUND_MAPPED, when move_pages() was
using remove_migration_pmd()) and 0x800201 (do_huge_pmd_wp_page() using
__split_huge_pmd()): page_add_anon_rmap() racing page_remove_rmap(), as
predicted.

I certainly found it harder to reason about than when bit_spin_locked, but
the easy case gives a clue to how to handle the harder case.  The easy
case being the three !(nr & COMPOUND_MAPPED) checks, which should
obviously be replaced by (nr < COMPOUND_MAPPED) checks - to count a page
as compound mapped, even while the bit in that position is 0.

The harder case is when trying to decide how many subpages are newly
covered or uncovered, when compound map is first added or last removed:
not knowing all that racily happened between first and second atomic ops.

But the easy way to handle that, is again to count the page as compound
mapped all the while that its subpages_mapcount indicates so - ignoring
the _mapcount or compound_mapcount transition while it is on the way to
being reversed.

Link: https://lkml.kernel.org/r/4388158-3092-a960-ff2d-55f2b0fe4ef8@google.com
Fixes: 4b51634cd16a ("mm,thp,rmap: subpages_mapcount COMPOUND_MAPPED if PMD-mapped")
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
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

 mm/rmap.c |   42 +++++++++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 9 deletions(-)

--- a/mm/rmap.c~mmthprmap-fix-races-between-updates-of-subpages_mapcount
+++ a/mm/rmap.c
@@ -1232,7 +1232,7 @@ void page_add_anon_rmap(struct page *pag
 		if (first && PageCompound(page)) {
 			mapped = subpages_mapcount_ptr(compound_head(page));
 			nr = atomic_inc_return_relaxed(mapped);
-			nr = !(nr & COMPOUND_MAPPED);
+			nr = (nr < COMPOUND_MAPPED);
 		}
 	} else if (PageTransHuge(page)) {
 		/* That test is redundant: it's for safety or to optimize out */
@@ -1241,8 +1241,16 @@ void page_add_anon_rmap(struct page *pag
 		if (first) {
 			mapped = subpages_mapcount_ptr(page);
 			nr = atomic_add_return_relaxed(COMPOUND_MAPPED, mapped);
-			nr_pmdmapped = thp_nr_pages(page);
-			nr = nr_pmdmapped - (nr & SUBPAGES_MAPPED);
+			if (likely(nr < COMPOUND_MAPPED + COMPOUND_MAPPED)) {
+				nr_pmdmapped = thp_nr_pages(page);
+				nr = nr_pmdmapped - (nr & SUBPAGES_MAPPED);
+				/* Raced ahead of a remove and another add? */
+				if (unlikely(nr < 0))
+					nr = 0;
+			} else {
+				/* Raced ahead of a remove of COMPOUND_MAPPED */
+				nr = 0;
+			}
 		}
 	}
 
@@ -1330,7 +1338,7 @@ void page_add_file_rmap(struct page *pag
 		if (first && PageCompound(page)) {
 			mapped = subpages_mapcount_ptr(compound_head(page));
 			nr = atomic_inc_return_relaxed(mapped);
-			nr = !(nr & COMPOUND_MAPPED);
+			nr = (nr < COMPOUND_MAPPED);
 		}
 	} else if (PageTransHuge(page)) {
 		/* That test is redundant: it's for safety or to optimize out */
@@ -1339,8 +1347,16 @@ void page_add_file_rmap(struct page *pag
 		if (first) {
 			mapped = subpages_mapcount_ptr(page);
 			nr = atomic_add_return_relaxed(COMPOUND_MAPPED, mapped);
-			nr_pmdmapped = thp_nr_pages(page);
-			nr = nr_pmdmapped - (nr & SUBPAGES_MAPPED);
+			if (likely(nr < COMPOUND_MAPPED + COMPOUND_MAPPED)) {
+				nr_pmdmapped = thp_nr_pages(page);
+				nr = nr_pmdmapped - (nr & SUBPAGES_MAPPED);
+				/* Raced ahead of a remove and another add? */
+				if (unlikely(nr < 0))
+					nr = 0;
+			} else {
+				/* Raced ahead of a remove of COMPOUND_MAPPED */
+				nr = 0;
+			}
 		}
 	}
 
@@ -1387,7 +1403,7 @@ void page_remove_rmap(struct page *page,
 		if (last && PageCompound(page)) {
 			mapped = subpages_mapcount_ptr(compound_head(page));
 			nr = atomic_dec_return_relaxed(mapped);
-			nr = !(nr & COMPOUND_MAPPED);
+			nr = (nr < COMPOUND_MAPPED);
 		}
 	} else if (PageTransHuge(page)) {
 		/* That test is redundant: it's for safety or to optimize out */
@@ -1396,8 +1412,16 @@ void page_remove_rmap(struct page *page,
 		if (last) {
 			mapped = subpages_mapcount_ptr(page);
 			nr = atomic_sub_return_relaxed(COMPOUND_MAPPED, mapped);
-			nr_pmdmapped = thp_nr_pages(page);
-			nr = nr_pmdmapped - (nr & SUBPAGES_MAPPED);
+			if (likely(nr < COMPOUND_MAPPED)) {
+				nr_pmdmapped = thp_nr_pages(page);
+				nr = nr_pmdmapped - (nr & SUBPAGES_MAPPED);
+				/* Raced ahead of another remove and an add? */
+				if (unlikely(nr < 0))
+					nr = 0;
+			} else {
+				/* An add of COMPOUND_MAPPED raced ahead */
+				nr = 0;
+			}
 		}
 	}
 
_

Patches currently in -mm which might be from hughd@google.com are

tmpfs-fix-data-loss-from-failed-fallocate.patch
mm-memcg-fix-swapcached-stat-accounting.patch
mmthprmap-fix-races-between-updates-of-subpages_mapcount.patch

