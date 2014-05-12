From: akpm@linux-foundation.org
Subject: +
 mm-use-a-light-weight-__mod_zone_page_state-in-mlocked_vma_newpage.patch
 added to -mm tree
Date: Mon, 12 May 2014 13:50:09 -0700
Message-ID: <53713401.J5Y+ekB4cD0/XaYs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38476 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611AbaELUuK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 May 2014 16:50:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hughd@google.com, akpm@linux-foundation.org, nasa4836@gmail.com

Subject: + mm-use-a-light-weight-__mod_zone_page_state-in-mlocked_vma_newpage.patch added to -mm tree
To: nasa4836@gmail.com,akpm@linux-foundation.org,hughd@google.com
From: akpm@linux-foundation.org
Date: Mon, 12 May 2014 13:50:09 -0700


The patch titled
     Subject: mm: fold mlocked_vma_newpage() into its only call site
has been added to the -mm tree.  Its filename is
     mm-use-a-light-weight-__mod_zone_page_state-in-mlocked_vma_newpage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-a-light-weight-__mod_zone_page_state-in-mlocked_vma_newpage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-a-light-weight-__mod_zone_page_state-in-mlocked_vma_newpage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jianyu Zhan <nasa4836@gmail.com>
Subject: mm: fold mlocked_vma_newpage() into its only call site

In previous commit(mm: use the light version __mod_zone_page_state in
mlocked_vma_newpage()) a irq-unsafe __mod_zone_page_state is used.  And as
suggested by Andrew, to reduce the risks that new call sites incorrectly
using mlocked_vma_newpage() without knowing they are adding racing, this
patch folds mlocked_vma_newpage() into its only call site,
page_add_new_anon_rmap, to make it open-cocded for people to know what is
going on.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   29 -----------------------------
 mm/rmap.c     |   20 +++++++++++++++++---
 2 files changed, 17 insertions(+), 32 deletions(-)

diff -puN mm/internal.h~mm-use-a-light-weight-__mod_zone_page_state-in-mlocked_vma_newpage mm/internal.h
--- a/mm/internal.h~mm-use-a-light-weight-__mod_zone_page_state-in-mlocked_vma_newpage
+++ a/mm/internal.h
@@ -189,31 +189,6 @@ static inline void munlock_vma_pages_all
 }
 
 /*
- * Called only in fault path, to determine if a new page is being
- * mapped into a LOCKED vma.  If it is, mark page as mlocked.
- */
-static inline int mlocked_vma_newpage(struct vm_area_struct *vma,
-				    struct page *page)
-{
-	VM_BUG_ON_PAGE(PageLRU(page), page);
-
-	if (likely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) != VM_LOCKED))
-		return 0;
-
-	if (!TestSetPageMlocked(page)) {
-		/*
-		 * We use the irq-unsafe __mod_zone_page_stat because
-		 * this counter is not modified from interrupt context, and the
-		 * pte lock is held(spinlock), which implies preemption disabled.
-		 */
-		__mod_zone_page_state(page_zone(page), NR_MLOCK,
-				    hpage_nr_pages(page));
-		count_vm_event(UNEVICTABLE_PGMLOCKED);
-	}
-	return 1;
-}
-
-/*
  * must be called with vma's mmap_sem held for read or write, and page locked.
  */
 extern void mlock_vma_page(struct page *page);
@@ -255,10 +230,6 @@ extern unsigned long vma_address(struct
 				 struct vm_area_struct *vma);
 #endif
 #else /* !CONFIG_MMU */
-static inline int mlocked_vma_newpage(struct vm_area_struct *v, struct page *p)
-{
-	return 0;
-}
 static inline void clear_page_mlock(struct page *page) { }
 static inline void mlock_vma_page(struct page *page) { }
 static inline void mlock_migrate_page(struct page *new, struct page *old) { }
diff -puN mm/rmap.c~mm-use-a-light-weight-__mod_zone_page_state-in-mlocked_vma_newpage mm/rmap.c
--- a/mm/rmap.c~mm-use-a-light-weight-__mod_zone_page_state-in-mlocked_vma_newpage
+++ a/mm/rmap.c
@@ -1025,11 +1025,25 @@ void page_add_new_anon_rmap(struct page
 	__mod_zone_page_state(page_zone(page), NR_ANON_PAGES,
 			hpage_nr_pages(page));
 	__page_set_anon_rmap(page, vma, address, 1);
-	if (!mlocked_vma_newpage(vma, page)) {
+
+	VM_BUG_ON_PAGE(PageLRU(page), page);
+	if (likely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) != VM_LOCKED)) {
 		SetPageActive(page);
 		lru_cache_add(page);
-	} else
-		add_page_to_unevictable_list(page);
+		return;
+	}
+
+	if (!TestSetPageMlocked(page)) {
+		/*
+		 * We use the irq-unsafe __mod_zone_page_stat because
+		 * this counter is not modified from interrupt context, and the
+		 * pte lock is held(spinlock), which implies preemption disabled.
+		 */
+		__mod_zone_page_state(page_zone(page), NR_MLOCK,
+				    hpage_nr_pages(page));
+		count_vm_event(UNEVICTABLE_PGMLOCKED);
+	}
+	add_page_to_unevictable_list(page);
 }
 
 /**
_

Patches currently in -mm which might be from nasa4836@gmail.com are

mm-swapc-clean-up-lru_cache_add-functions.patch
mm-swapc-introduce-put_refcounted_compound_page-helpers-for-spliting-put_compound_page.patch
mm-swapc-split-put_compound_page-function.patch
mm-introdule-compound_head_by_tail.patch
mm-memcontrol-clean-up-memcg-zoneinfo-lookup.patch
mm-memcontrol-remove-unnecessary-memcg-argument-from-soft-limit-functions.patch
mm-use-the-light-version-__mod_zone_page_state-in-mlocked_vma_newpage.patch
mm-use-a-light-weight-__mod_zone_page_state-in-mlocked_vma_newpage.patch
linux-next.patch

