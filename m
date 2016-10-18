From: akpm@linux-foundation.org
Subject: + mm-vmalloc-replace-opencoded-4-level-page-walkers.patch added
 to -mm tree
Date: Tue, 18 Oct 2016 14:58:58 -0700
Message-ID: <58069b22.e+qGTrFKFULppQuA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57522 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754039AbcJRV7A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2016 17:59:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@chris-wilson.co.uk, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, jmarchan@redhat.com, mgorman@techsingularity.net, rientjes@google.com, vdavydov.dev@gmail.com, wangxq10@lzu.edu.cn, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: replace opencoded 4-level page walkers
has been added to the -mm tree.  Its filename is
     mm-vmalloc-replace-opencoded-4-level-page-walkers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-replace-opencoded-4-level-page-walkers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-replace-opencoded-4-level-page-walkers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: mm/vmalloc: replace opencoded 4-level page walkers

Rather than open-code the intricacies of walking the 4-level page tables,
use the generic page table walker apply_to_page_range() instead.

The important change is that it now cleans up after an unsuccessful
insertion and propagates the correct error.  The current failure may lead
to a WARN if we encounter ENOMEM in one vmap_pte_range() and later retry
with the same page range.

WARNING: CPU: 0 PID: 605 at mm/vmalloc.c:136 vmap_page_range_noflush+0x2c1/0x340
i.e. WARN_ON(!pte_none(*pte))

v2: Don't convert the vunmap code over to apply_to_page_range() as it
may try to allocate during atomic sections, such as exiting a task:

[    9.837563]  [<ffffffff810519b0>] pte_alloc_one_kernel+0x10/0x20
[    9.837568]  [<ffffffff811a7486>] __pte_alloc_kernel+0x16/0xa0
[    9.837572]  [<ffffffff811aaa76>] apply_to_page_range+0x3f6/0x460
[    9.837576]  [<ffffffff811b8888>] free_unmap_vmap_area_noflush+0x28/0x40
[    9.837579]  [<ffffffff811b9dcd>] remove_vm_area+0x4d/0x60
[    9.837582]  [<ffffffff811b9e09>] __vunmap+0x29/0x130
[    9.837585]  [<ffffffff811b9f7d>] vfree+0x3d/0x90
[    9.837589]  [<ffffffff8107ace6>] put_task_stack+0x76/0x130

References: https://bugs.freedesktop.org/show_bug.cgi?id=98269
Link: http://lkml.kernel.org/r/20161018161117.31198-1-chris@chris-wilson.co.uk
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: David Rientjes <rientjes@google.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Wang Xiaoqiang <wangxq10@lzu.edu.cn>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   95 ++++++++++++++-----------------------------------
 1 file changed, 28 insertions(+), 67 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-replace-opencoded-4-level-page-walkers mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-replace-opencoded-4-level-page-walkers
+++ a/mm/vmalloc.c
@@ -117,63 +117,27 @@ static void vunmap_page_range(unsigned l
 	} while (pgd++, addr = next, addr != end);
 }
 
-static int vmap_pte_range(pmd_t *pmd, unsigned long addr,
-		unsigned long end, pgprot_t prot, struct page **pages, int *nr)
-{
-	pte_t *pte;
-
-	/*
-	 * nr is a running index into the array which helps higher level
-	 * callers keep track of where we're up to.
-	 */
-
-	pte = pte_alloc_kernel(pmd, addr);
-	if (!pte)
-		return -ENOMEM;
-	do {
-		struct page *page = pages[*nr];
+struct vmap_page {
+	pgprot_t prot;
+	struct page **pages;
+	unsigned long count;
+};
 
-		if (WARN_ON(!pte_none(*pte)))
-			return -EBUSY;
-		if (WARN_ON(!page))
-			return -ENOMEM;
-		set_pte_at(&init_mm, addr, pte, mk_pte(page, prot));
-		(*nr)++;
-	} while (pte++, addr += PAGE_SIZE, addr != end);
-	return 0;
-}
-
-static int vmap_pmd_range(pud_t *pud, unsigned long addr,
-		unsigned long end, pgprot_t prot, struct page **pages, int *nr)
+static int vmap_page(pte_t *pte, pgtable_t token,
+		     unsigned long addr, void *data)
 {
-	pmd_t *pmd;
-	unsigned long next;
-
-	pmd = pmd_alloc(&init_mm, pud, addr);
-	if (!pmd)
-		return -ENOMEM;
-	do {
-		next = pmd_addr_end(addr, end);
-		if (vmap_pte_range(pmd, addr, next, prot, pages, nr))
-			return -ENOMEM;
-	} while (pmd++, addr = next, addr != end);
-	return 0;
-}
+	struct vmap_page *v = data;
+	struct page *page;
 
-static int vmap_pud_range(pgd_t *pgd, unsigned long addr,
-		unsigned long end, pgprot_t prot, struct page **pages, int *nr)
-{
-	pud_t *pud;
-	unsigned long next;
+	if (WARN_ON(!pte_none(*pte)))
+		return -EBUSY;
 
-	pud = pud_alloc(&init_mm, pgd, addr);
-	if (!pud)
+	page = v->pages[v->count];
+	if (WARN_ON(!page))
 		return -ENOMEM;
-	do {
-		next = pud_addr_end(addr, end);
-		if (vmap_pmd_range(pud, addr, next, prot, pages, nr))
-			return -ENOMEM;
-	} while (pud++, addr = next, addr != end);
+
+	set_pte_at(&init_mm, addr, pte, mk_pte(page, v->prot));
+	v->count++;
 	return 0;
 }
 
@@ -186,22 +150,19 @@ static int vmap_pud_range(pgd_t *pgd, un
 static int vmap_page_range_noflush(unsigned long start, unsigned long end,
 				   pgprot_t prot, struct page **pages)
 {
-	pgd_t *pgd;
-	unsigned long next;
-	unsigned long addr = start;
-	int err = 0;
-	int nr = 0;
-
-	BUG_ON(addr >= end);
-	pgd = pgd_offset_k(addr);
-	do {
-		next = pgd_addr_end(addr, end);
-		err = vmap_pud_range(pgd, addr, next, prot, pages, &nr);
-		if (err)
-			return err;
-	} while (pgd++, addr = next, addr != end);
+	struct vmap_page v = { prot, pages };
+	int err;
+
+	if ((end - start) >> PAGE_SHIFT > INT_MAX)
+		return -EINVAL;
+
+	err = apply_to_page_range(&init_mm, start, end - start, vmap_page, &v);
+	if (unlikely(err)) {
+		vunmap_page_range(start, start + (v.count << PAGE_SHIFT));
+		return err;
+	}
 
-	return nr;
+	return v.count;
 }
 
 static int vmap_page_range(unsigned long start, unsigned long end,
_

Patches currently in -mm which might be from chris@chris-wilson.co.uk are

mm-vmalloc-replace-opencoded-4-level-page-walkers.patch

