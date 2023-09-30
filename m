Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9D7FE7734B
	for <mm-commits@archiver.kernel.org>; Sat, 30 Sep 2023 00:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233977AbjI3AVr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Sep 2023 20:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233951AbjI3AVb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2023 20:21:31 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE791B3;
        Fri, 29 Sep 2023 17:21:27 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85CB7C433CB;
        Sat, 30 Sep 2023 00:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696033287;
        bh=7kJxkxzZ+MNb5VV50+vbdSPAqToa8wI4aKDpTTCauNM=;
        h=Date:To:From:Subject:From;
        b=ZQjzLW5EBTQP2xnfseHkStRFVGFx3OI3P+cQRul/AkW2f8Nhu6u+ULZWwABmkyoIf
         KiAgRvryz+X99nK4BKqORtStyYN2i5N2RatgI3kgMSapovnYg/C3CAv2g6M4pEG8ur
         gOFuK0olvFGysmu9V7MBybLNVCie3afhFnEsw9H4=
Date:   Fri, 29 Sep 2023 17:21:26 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, stable@vger.kernel.org, rientjes@google.com,
        osalvador@suse.de, mhocko@suse.com, kirill@shutemov.name,
        hughd@google.com, aquini@redhat.com, yang@os.amperecomputing.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mempolicy-keep-vma-walk-if-both-mpol_mf_strict-and-mpol_mf_move-are-specified.patch removed from -mm tree
Message-Id: <20230930002127.85CB7C433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: mempolicy: keep VMA walk if both MPOL_MF_STRICT and MPOL_MF_MOVE are specified
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-keep-vma-walk-if-both-mpol_mf_strict-and-mpol_mf_move-are-specified.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Shi <yang@os.amperecomputing.com>
Subject: mm: mempolicy: keep VMA walk if both MPOL_MF_STRICT and MPOL_MF_MOVE are specified
Date: Wed, 20 Sep 2023 15:32:42 -0700

When calling mbind() with MPOL_MF_{MOVE|MOVEALL} | MPOL_MF_STRICT, kernel
should attempt to migrate all existing pages, and return -EIO if there is
misplaced or unmovable page.  Then commit 6f4576e3687b ("mempolicy: apply
page table walker on queue_pages_range()") messed up the return value and
didn't break VMA scan early ianymore when MPOL_MF_STRICT alone.  The
return value problem was fixed by commit a7f40cfe3b7a ("mm: mempolicy:
make mbind() return -EIO when MPOL_MF_STRICT is specified"), but it broke
the VMA walk early if unmovable page is met, it may cause some pages are
not migrated as expected.

The code should conceptually do:

 if (MPOL_MF_MOVE|MOVEALL)
     scan all vmas
     try to migrate the existing pages
     return success
 else if (MPOL_MF_MOVE* | MPOL_MF_STRICT)
     scan all vmas
     try to migrate the existing pages
     return -EIO if unmovable or migration failed
 else /* MPOL_MF_STRICT alone */
     break early if meets unmovable and don't call mbind_range() at all
 else /* none of those flags */
     check the ranges in test_walk, EFAULT without mbind_range() if discontig.

Fixed the behavior.

Link: https://lkml.kernel.org/r/20230920223242.3425775-1-yang@os.amperecomputing.com
Fixes: a7f40cfe3b7a ("mm: mempolicy: make mbind() return -EIO when MPOL_MF_STRICT is specified")
Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>	[4.9+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-keep-vma-walk-if-both-mpol_mf_strict-and-mpol_mf_move-are-specified
+++ a/mm/mempolicy.c
@@ -426,6 +426,7 @@ struct queue_pages {
 	unsigned long start;
 	unsigned long end;
 	struct vm_area_struct *first;
+	bool has_unmovable;
 };
 
 /*
@@ -446,9 +447,8 @@ static inline bool queue_folio_required(
 /*
  * queue_folios_pmd() has three possible return values:
  * 0 - folios are placed on the right node or queued successfully, or
- *     special page is met, i.e. huge zero page.
- * 1 - there is unmovable folio, and MPOL_MF_MOVE* & MPOL_MF_STRICT were
- *     specified.
+ *     special page is met, i.e. zero page, or unmovable page is found
+ *     but continue walking (indicated by queue_pages.has_unmovable).
  * -EIO - is migration entry or only MPOL_MF_STRICT was specified and an
  *        existing folio was already on a node that does not follow the
  *        policy.
@@ -479,7 +479,7 @@ static int queue_folios_pmd(pmd_t *pmd,
 	if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) {
 		if (!vma_migratable(walk->vma) ||
 		    migrate_folio_add(folio, qp->pagelist, flags)) {
-			ret = 1;
+			qp->has_unmovable = true;
 			goto unlock;
 		}
 	} else
@@ -495,9 +495,8 @@ unlock:
  *
  * queue_folios_pte_range() has three possible return values:
  * 0 - folios are placed on the right node or queued successfully, or
- *     special page is met, i.e. zero page.
- * 1 - there is unmovable folio, and MPOL_MF_MOVE* & MPOL_MF_STRICT were
- *     specified.
+ *     special page is met, i.e. zero page, or unmovable page is found
+ *     but continue walking (indicated by queue_pages.has_unmovable).
  * -EIO - only MPOL_MF_STRICT was specified and an existing folio was already
  *        on a node that does not follow the policy.
  */
@@ -508,7 +507,6 @@ static int queue_folios_pte_range(pmd_t
 	struct folio *folio;
 	struct queue_pages *qp = walk->private;
 	unsigned long flags = qp->flags;
-	bool has_unmovable = false;
 	pte_t *pte, *mapped_pte;
 	pte_t ptent;
 	spinlock_t *ptl;
@@ -538,11 +536,12 @@ static int queue_folios_pte_range(pmd_t
 		if (!queue_folio_required(folio, qp))
 			continue;
 		if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) {
-			/* MPOL_MF_STRICT must be specified if we get here */
-			if (!vma_migratable(vma)) {
-				has_unmovable = true;
-				break;
-			}
+			/*
+			 * MPOL_MF_STRICT must be specified if we get here.
+			 * Continue walking vmas due to MPOL_MF_MOVE* flags.
+			 */
+			if (!vma_migratable(vma))
+				qp->has_unmovable = true;
 
 			/*
 			 * Do not abort immediately since there may be
@@ -550,16 +549,13 @@ static int queue_folios_pte_range(pmd_t
 			 * need migrate other LRU pages.
 			 */
 			if (migrate_folio_add(folio, qp->pagelist, flags))
-				has_unmovable = true;
+				qp->has_unmovable = true;
 		} else
 			break;
 	}
 	pte_unmap_unlock(mapped_pte, ptl);
 	cond_resched();
 
-	if (has_unmovable)
-		return 1;
-
 	return addr != end ? -EIO : 0;
 }
 
@@ -599,7 +595,7 @@ static int queue_folios_hugetlb(pte_t *p
 		 * Detecting misplaced folio but allow migrating folios which
 		 * have been queued.
 		 */
-		ret = 1;
+		qp->has_unmovable = true;
 		goto unlock;
 	}
 
@@ -620,7 +616,7 @@ static int queue_folios_hugetlb(pte_t *p
 			 * Failed to isolate folio but allow migrating pages
 			 * which have been queued.
 			 */
-			ret = 1;
+			qp->has_unmovable = true;
 	}
 unlock:
 	spin_unlock(ptl);
@@ -756,12 +752,15 @@ queue_pages_range(struct mm_struct *mm,
 		.start = start,
 		.end = end,
 		.first = NULL,
+		.has_unmovable = false,
 	};
 	const struct mm_walk_ops *ops = lock_vma ?
 			&queue_pages_lock_vma_walk_ops : &queue_pages_walk_ops;
 
 	err = walk_page_range(mm, start, end, ops, &qp);
 
+	if (qp.has_unmovable)
+		err = 1;
 	if (!qp.first)
 		/* whole range in hole */
 		err = -EFAULT;
@@ -1358,7 +1357,7 @@ static long do_mbind(unsigned long start
 				putback_movable_pages(&pagelist);
 		}
 
-		if ((ret > 0) || (nr_failed && (flags & MPOL_MF_STRICT)))
+		if (((ret > 0) || nr_failed) && (flags & MPOL_MF_STRICT))
 			err = -EIO;
 	} else {
 up_out:
_

Patches currently in -mm which might be from yang@os.amperecomputing.com are


