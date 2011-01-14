From: akpm@linux-foundation.org
Subject: [merged] thp-split_huge_page-anon_vma-ordering-dependency.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:47:22 -0800
Message-ID: <201101142250.p0EMoCWV005383@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33021 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753868Ab1ANWuT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:50:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     thp: split_huge_page anon_vma ordering dependency
has been removed from the -mm tree.  Its filename was
     thp-split_huge_page-anon_vma-ordering-dependency.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: split_huge_page anon_vma ordering dependency
From: Andrea Arcangeli <aarcange@redhat.com>

This documents how split_huge_page is safe vs new vma inserctions into the
anon_vma that may have already released the anon_vma->lock but not
established pmds yet when split_huge_page starts.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   16 ++++++++++++++++
 mm/rmap.c        |    4 ++++
 2 files changed, 20 insertions(+)

diff -puN mm/huge_memory.c~thp-split_huge_page-anon_vma-ordering-dependency mm/huge_memory.c
--- a/mm/huge_memory.c~thp-split_huge_page-anon_vma-ordering-dependency
+++ a/mm/huge_memory.c
@@ -841,6 +841,19 @@ static void __split_huge_page(struct pag
 			continue;
 		mapcount += __split_huge_page_splitting(page, vma, addr);
 	}
+	/*
+	 * It is critical that new vmas are added to the tail of the
+	 * anon_vma list. This guarantes that if copy_huge_pmd() runs
+	 * and establishes a child pmd before
+	 * __split_huge_page_splitting() freezes the parent pmd (so if
+	 * we fail to prevent copy_huge_pmd() from running until the
+	 * whole __split_huge_page() is complete), we will still see
+	 * the newly established pmd of the child later during the
+	 * walk, to be able to set it as pmd_trans_splitting too.
+	 */
+	if (mapcount != page_mapcount(page))
+		printk(KERN_ERR "mapcount %d page_mapcount %d\n",
+		       mapcount, page_mapcount(page));
 	BUG_ON(mapcount != page_mapcount(page));
 
 	__split_huge_page_refcount(page);
@@ -854,6 +867,9 @@ static void __split_huge_page(struct pag
 			continue;
 		mapcount2 += __split_huge_page_map(page, vma, addr);
 	}
+	if (mapcount != mapcount2)
+		printk(KERN_ERR "mapcount %d mapcount2 %d page_mapcount %d\n",
+		       mapcount, mapcount2, page_mapcount(page));
 	BUG_ON(mapcount != mapcount2);
 }
 
diff -puN mm/rmap.c~thp-split_huge_page-anon_vma-ordering-dependency mm/rmap.c
--- a/mm/rmap.c~thp-split_huge_page-anon_vma-ordering-dependency
+++ a/mm/rmap.c
@@ -177,6 +177,10 @@ static void anon_vma_chain_link(struct v
 	list_add(&avc->same_vma, &vma->anon_vma_chain);
 
 	anon_vma_lock(anon_vma);
+	/*
+	 * It's critical to add new vmas to the tail of the anon_vma,
+	 * see comment in huge_memory.c:__split_huge_page().
+	 */
 	list_add_tail(&avc->same_anon_vma, &anon_vma->head);
 	anon_vma_unlock(anon_vma);
 }
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

