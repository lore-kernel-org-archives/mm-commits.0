From: akpm@linux-foundation.org
Subject: [failures]
 mm-vmalloc-replace-opencoded-4-level-page-walkers.patch removed from -mm
 tree
Date: Mon, 08 Jan 2018 17:19:53 -0800
Message-ID: <5a5418b9.8cLva6+p1k9FmyaO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60746 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933434AbeAIBT5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jan 2018 20:19:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@chris-wilson.co.uk, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, jmarchan@redhat.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@kernel.org, rientjes@google.com, vdavydov.dev@gmail.com, wangxq10@lzu.edu.cn, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: replace opencoded 4-level page walkers
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-replace-opencoded-4-level-page-walkers.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: mm/vmalloc.c: replace opencoded 4-level page walkers

Rather than open-code the intricacies of walking the 4-level page tables,
use the generic page table walker apply_to_page_range() instead.

The important change is that it now cleans up after an unsuccessful
insertion and propagates the correct error.  The current failure may lead
to a WARN if we encounter ENOMEM in one vmap_pte_range() and later retry
with the same page range:

WARNING: CPU: 0 PID: 605 at mm/vmalloc.c:136 vmap_page_range_noflush+0x2c1/0x340
i.e. WARN_ON(!pte_none(*pte))

v2: Don't convert the vunmap code over to apply_to_page_range() as it may
try to allocate during atomic sections, such as exiting a task:

[    9.837563]  [<ffffffff810519b0>] pte_alloc_one_kernel+0x10/0x20
[    9.837568]  [<ffffffff811a7486>] __pte_alloc_kernel+0x16/0xa0
[    9.837572]  [<ffffffff811aaa76>] apply_to_page_range+0x3f6/0x460
[    9.837576]  [<ffffffff811b8888>] free_unmap_vmap_area_noflush+0x28/0x40
[    9.837579]  [<ffffffff811b9dcd>] remove_vm_area+0x4d/0x60
[    9.837582]  [<ffffffff811b9e09>] __vunmap+0x29/0x130
[    9.837585]  [<ffffffff811b9f7d>] vfree+0x3d/0x90
[    9.837589]  [<ffffffff8107ace6>] put_task_stack+0x76/0x130

and it also upsets sparc64:

[    2.530785] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff,max_idle_ns: 19112604462750000 ns
[    2.532359] kernel BUG at mm/memory.c:1881!
[    2.532798]               \|/ ____ \|/
[    2.532798]               "@'/ .. \`@"
[    2.532798]               /_| \__/ |_\
[    2.532798]                  \__U_/
[    2.533250] swapper(1): Kernel bad sw trap 5 [#1]
[    2.533705] CPU: 0 PID: 1 Comm: swapper Not tainted 4.9.0-rc2+ #1
[    2.534129] task: fffff8001f0af620 task.stack: fffff8001f0b0000
[    2.534505] TSTATE: 0000004480001605 TPC: 00000000005124d8 TNPC: 00000000005124dc Y: 00000035    Not tainted
[    2.535112] TPC: <apply_to_page_range+0x2f8/0x3a0>
[    2.535469] g0: 00000000009b1548 g1: 0000000000a4a990 g2: 0000000000a4a990 g3: 0000000000b37694
[    2.535857] g4: fffff8001f0af620 g5: 0000000000000000 g6: fffff8001f0b0000 g7: 0000000000000000
[    2.536236] o0: 000000000000001f o1: 00000000009ac2c0 o2: 0000000000000759 o3: 0000000000122000
[    2.536695] o4: 0000000000000000 o5: 00000000009ac2c0 sp: fffff8001f0b2d61 ret_pc: 00000000005124d0
[    2.537086] RPC: <apply_to_page_range+0x2f0/0x3a0>
[    2.537454] l0: 0000000000000000 l1: 0000000000002000 l2: fffff8001f10b000 l3: 0000000100002000
[    2.537843] l4: 0000000000aef910 l5: 0000000000a5e7e8 l6: 0000000100001fff l7: ffffffffff800000
[    2.538229] i0: 0000000000a5e7e8 i1: 0000000100000000 i2: 0000000100002000 i3: 000000000051e5e0
[    2.538613] i4: fffff8001f0b3708 i5: fffff8001f10c000 i6: fffff8001f0b2e51 i7: 000000000051e8e0
[    2.539007] I7: <vmap_page_range_noflush+0x40/0x80>
[    2.539387] Call Trace:
[    2.539765]  [000000000051e8e0] vmap_page_range_noflush+0x40/0x80
[    2.540139]  [000000000051e970] map_vm_area+0x50/0x80
[    2.540492]  [000000000051f84c] __vmalloc_node_range+0x14c/0x260
[    2.540848]  [000000000051f98c] __vmalloc_node+0x2c/0x40
[    2.541198]  [00000000004d39cc] bpf_prog_alloc+0x2c/0xa0
[    2.541554]  [00000000008129bc] bpf_prog_create+0x3c/0xa0
[    2.541916]  [0000000000adb21c] ptp_classifier_init+0x20/0x4c
[    2.542271]  [0000000000ad9808] sock_init+0x90/0xa0
[    2.542622]  [0000000000426cb0] do_one_initcall+0x30/0x160
[    2.542978]  [0000000000aaeaec] kernel_init_freeable+0x10c/0x1b0
[    2.543332]  [00000000008e3324] kernel_init+0x4/0x100
[    2.543681]  [0000000000405f04] ret_from_fork+0x1c/0x2c

which was a BUG_ON(pmd_huge(*pmd)) and seems to be a general problem
pointed out by the generic pagewalkers that is handled by vunmap.  Perhaps
we need a clear_page_range()?

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=98269
References: msg-id:20161028171825.GA15116@roeck-us.net
Link: http://lkml.kernel.org/r/20171219111025.28283-1-chris@chris-wilson.co.uk
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: David Rientjes <rientjes@google.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Wang Xiaoqiang <wangxq10@lzu.edu.cn>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |  110 ++++++++++++-------------------------------------
 1 file changed, 27 insertions(+), 83 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-replace-opencoded-4-level-page-walkers mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-replace-opencoded-4-level-page-walkers
+++ a/mm/vmalloc.c
@@ -131,80 +131,27 @@ static void vunmap_page_range(unsigned l
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
-
-		if (WARN_ON(!pte_none(*pte)))
-			return -EBUSY;
-		if (WARN_ON(!page))
-			return -ENOMEM;
-		set_pte_at(&init_mm, addr, pte, mk_pte(page, prot));
-		(*nr)++;
-	} while (pte++, addr += PAGE_SIZE, addr != end);
-	return 0;
-}
+struct vmap_page {
+	pgprot_t prot;
+	struct page **pages;
+	unsigned long count;
+};
 
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
 
-static int vmap_pud_range(p4d_t *p4d, unsigned long addr,
-		unsigned long end, pgprot_t prot, struct page **pages, int *nr)
-{
-	pud_t *pud;
-	unsigned long next;
+	if (WARN_ON(!pte_none(*pte)))
+		return -EBUSY;
 
-	pud = pud_alloc(&init_mm, p4d, addr);
-	if (!pud)
+	page = v->pages[v->count];
+	if (WARN_ON(!page))
 		return -ENOMEM;
-	do {
-		next = pud_addr_end(addr, end);
-		if (vmap_pmd_range(pud, addr, next, prot, pages, nr))
-			return -ENOMEM;
-	} while (pud++, addr = next, addr != end);
-	return 0;
-}
-
-static int vmap_p4d_range(pgd_t *pgd, unsigned long addr,
-		unsigned long end, pgprot_t prot, struct page **pages, int *nr)
-{
-	p4d_t *p4d;
-	unsigned long next;
 
-	p4d = p4d_alloc(&init_mm, pgd, addr);
-	if (!p4d)
-		return -ENOMEM;
-	do {
-		next = p4d_addr_end(addr, end);
-		if (vmap_pud_range(p4d, addr, next, prot, pages, nr))
-			return -ENOMEM;
-	} while (p4d++, addr = next, addr != end);
+	set_pte_at(&init_mm, addr, pte, mk_pte(page, v->prot));
+	v->count++;
 	return 0;
 }
 
@@ -217,22 +164,19 @@ static int vmap_p4d_range(pgd_t *pgd, un
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
-		err = vmap_p4d_range(pgd, addr, next, prot, pages, &nr);
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


