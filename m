From: akpm@linux-foundation.org
Subject: [merged]
 mm-fix-devm_memremap_pages-crash-use-mem_hotplug_begin-done.patch removed
 from -mm tree
Date: Wed, 11 Jan 2017 14:27:57 -0800
Message-ID: <5876b16d.ZIpRwigCHmmAr76F%akpm__17802.0194558941$1484173770$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51492 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933153AbdAKW2e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2017 17:28:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, hch@lst.de, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix devm_memremap_pages crash, use mem_hotplug_{begin, done}
has been removed from the -mm tree.  Its filename was
     mm-fix-devm_memremap_pages-crash-use-mem_hotplug_begin-done.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: fix devm_memremap_pages crash, use mem_hotplug_{begin, done}

Both arch_add_memory() and arch_remove_memory() expect a single threaded
context.

For example, arch/x86/mm/init_64.c::kernel_physical_mapping_init() does
not hold any locks over this check and branch:

    if (pgd_val(*pgd)) {
    	pud = (pud_t *)pgd_page_vaddr(*pgd);
    	paddr_last = phys_pud_init(pud, __pa(vaddr),
    				   __pa(vaddr_end),
    				   page_size_mask);
    	continue;
    }

    pud = alloc_low_page();
    paddr_last = phys_pud_init(pud, __pa(vaddr), __pa(vaddr_end),
    			   page_size_mask);

The result is that two threads calling devm_memremap_pages()
simultaneously can end up colliding on pgd initialization. This leads to
crash signatures like the following where the loser of the race
initializes the wrong pgd entry:

    BUG: unable to handle kernel paging request at ffff888ebfff0000
    IP: [<ffffffff8149e1e6>] memcpy_erms+0x6/0x10
    PGD 2f8e8fc067 PUD 0 /* <---- Invalid PUD */
    Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
    CPU: 54 PID: 3818 Comm: systemd-udevd Not tainted 4.6.7+ #13
    task: ffff882fac290040 ti: ffff882f887a4000 task.ti: ffff882f887a4000
    RIP: 0010:[<ffffffff8149e1e6>]  [<ffffffff8149e1e6>] memcpy_erms+0x6/0x10
    [..]
    Call Trace:
     [<ffffffffc0119045>] ? pmem_do_bvec+0x205/0x370 [nd_pmem]
     [<ffffffff8145b82a>] ? blk_queue_enter+0x3a/0x280
     [<ffffffffc0119418>] pmem_rw_page+0x38/0x80 [nd_pmem]
     [<ffffffff812b1c94>] bdev_read_page+0x84/0xb0

Hold the standard memory hotplug mutex over calls to
arch_{add,remove}_memory().

Fixes: 41e94a851304 ("add devm_memremap_pages")
Link: http://lkml.kernel.org/r/148357647831.9498.12606007370121652979.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/memremap.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/memremap.c~mm-fix-devm_memremap_pages-crash-use-mem_hotplug_begin-done kernel/memremap.c
--- a/kernel/memremap.c~mm-fix-devm_memremap_pages-crash-use-mem_hotplug_begin-done
+++ a/kernel/memremap.c
@@ -246,7 +246,9 @@ static void devm_memremap_pages_release(
 	/* pages are dead and unused, undo the arch mapping */
 	align_start = res->start & ~(SECTION_SIZE - 1);
 	align_size = ALIGN(resource_size(res), SECTION_SIZE);
+	mem_hotplug_begin();
 	arch_remove_memory(align_start, align_size);
+	mem_hotplug_done();
 	untrack_pfn(NULL, PHYS_PFN(align_start), align_size);
 	pgmap_radix_release(res);
 	dev_WARN_ONCE(dev, pgmap->altmap && pgmap->altmap->alloc,
@@ -358,7 +360,9 @@ void *devm_memremap_pages(struct device
 	if (error)
 		goto err_pfn_remap;
 
+	mem_hotplug_begin();
 	error = arch_add_memory(nid, align_start, align_size, true);
+	mem_hotplug_done();
 	if (error)
 		goto err_add_memory;
 
_

Patches currently in -mm which might be from dan.j.williams@intel.com are


