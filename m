From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-refactor-insert_page-to-prepare-for-batched-lock-insert.patch added to
 -mm tree
Date: Wed, 12 Feb 2020 18:56:55 -0800
Message-ID: <20200213025655.Ai-ktMoGK%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729333AbgBMC46 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Feb 2020 21:56:58 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjunroy@google.com, davem@davemloft.net, edumazet@google.com, mm-commits@vger.kernel.org, soheil@google.com


The patch titled
     Subject: mm/memory.c: refactor insert_page to prepare for batched-lock insert
has been added to the -mm tree.  Its filename is
     mm-refactor-insert_page-to-prepare-for-batched-lock-insert.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-refactor-insert_page-to-prepare-for-batched-lock-insert.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-refactor-insert_page-to-prepare-for-batched-lock-insert.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arjun Roy <arjunroy@google.com>
Subject: mm/memory.c: refactor insert_page to prepare for batched-lock insert

Add helper methods for vm_insert_page()/insert_page() to prepare for
vm_insert_pages(), which batch-inserts pages to reduce spinlock operations
when inserting multiple consecutive pages into the user page table.

The intention of this patch-set is to reduce atomic ops for tcp zerocopy
receives, which normally hits the same spinlock multiple times
consecutively.

Link: http://lkml.kernel.org/r/20200128025958.43490-1-arjunroy.kdev@gmail.com
Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

--- a/mm/memory.c~mm-refactor-insert_page-to-prepare-for-batched-lock-insert
+++ a/mm/memory.c
@@ -1430,6 +1430,27 @@ pte_t *__get_locked_pte(struct mm_struct
 	return pte_alloc_map_lock(mm, pmd, addr, ptl);
 }
 
+static int validate_page_before_insert(struct page *page)
+{
+	if (PageAnon(page) || PageSlab(page) || page_has_type(page))
+		return -EINVAL;
+	flush_dcache_page(page);
+	return 0;
+}
+
+static int insert_page_into_pte_locked(struct mm_struct *mm, pte_t *pte,
+			unsigned long addr, struct page *page, pgprot_t prot)
+{
+	if (!pte_none(*pte))
+		return -EBUSY;
+	/* Ok, finally just insert the thing.. */
+	get_page(page);
+	inc_mm_counter_fast(mm, mm_counter_file(page));
+	page_add_file_rmap(page, false);
+	set_pte_at(mm, addr, pte, mk_pte(page, prot));
+	return 0;
+}
+
 /*
  * This is the old fallback for page remapping.
  *
@@ -1445,26 +1466,14 @@ static int insert_page(struct vm_area_st
 	pte_t *pte;
 	spinlock_t *ptl;
 
-	retval = -EINVAL;
-	if (PageAnon(page) || PageSlab(page) || page_has_type(page))
+	retval = validate_page_before_insert(page);
+	if (retval)
 		goto out;
 	retval = -ENOMEM;
-	flush_dcache_page(page);
 	pte = get_locked_pte(mm, addr, &ptl);
 	if (!pte)
 		goto out;
-	retval = -EBUSY;
-	if (!pte_none(*pte))
-		goto out_unlock;
-
-	/* Ok, finally just insert the thing.. */
-	get_page(page);
-	inc_mm_counter_fast(mm, mm_counter_file(page));
-	page_add_file_rmap(page, false);
-	set_pte_at(mm, addr, pte, mk_pte(page, prot));
