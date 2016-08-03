From: akpm@linux-foundation.org
Subject: [merged] mm-fail-prefaulting-if-page-table-allocation-fails.patch removed from -mm tree
Date: Wed, 03 Aug 2016 11:10:40 -0700
Message-ID: <57a233a0.IsOa7nnuxkMmcAn6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34118 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756395AbcHCSVv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:21:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vegard.nossum@oracle.com, hillf.zj@alibaba-inc.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fail prefaulting if page table allocation fails
has been removed from the -mm tree.  Its filename was
     mm-fail-prefaulting-if-page-table-allocation-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: mm: fail prefaulting if page table allocation fails

I ran into this:

    BUG: sleeping function called from invalid context at mm/page_alloc.c:3784
    in_atomic(): 0, irqs_disabled(): 0, pid: 1434, name: trinity-c1
    2 locks held by trinity-c1/1434:
     #0:  (&mm->mmap_sem){......}, at: [<ffffffff810ce31e>] __do_page_fault+0x1ce/0x8f0
     #1:  (rcu_read_lock){......}, at: [<ffffffff81378f86>] filemap_map_pages+0xd6/0xdd0

    CPU: 0 PID: 1434 Comm: trinity-c1 Not tainted 4.7.0+ #58
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
     ffff8800b662f698 ffff8800b662f548 ffffffff81d6d001 ffffffff83a61100
     ffff8800b662f620 ffff8800b662f610 ffffffff81373fd1 0000000041b58ab3
     ffffffff8406ca21 ffffffff81373e4c 0000000041b58ab3 ffffffff00000008
    Call Trace:
     [<ffffffff81d6d001>] dump_stack+0x65/0x84
     [<ffffffff81373fd1>] panic+0x185/0x2dd
     [<ffffffff8118e38c>] ___might_sleep+0x51c/0x600
     [<ffffffff8118e500>] __might_sleep+0x90/0x1a0
     [<ffffffff81392761>] __alloc_pages_nodemask+0x5b1/0x2160
     [<ffffffff814665ac>] alloc_pages_current+0xcc/0x370
     [<ffffffff810d95b2>] pte_alloc_one+0x12/0x90
     [<ffffffff814053cd>] __pte_alloc+0x1d/0x200
     [<ffffffff8140be4e>] alloc_set_pte+0xe3e/0x14a0
     [<ffffffff813792db>] filemap_map_pages+0x42b/0xdd0
     [<ffffffff8140e0d5>] handle_mm_fault+0x17d5/0x28b0
     [<ffffffff810ce460>] __do_page_fault+0x310/0x8f0
     [<ffffffff810cec7d>] trace_do_page_fault+0x18d/0x310
     [<ffffffff810c2177>] do_async_page_fault+0x27/0xa0
     [<ffffffff8389e258>] async_page_fault+0x28/0x30

The important bits from the above is that filemap_map_pages() is calling
into the page allocator while holding rcu_read_lock (sleeping is not
allowed inside RCU read-side critical sections).

According to Kirill Shutemov, the prefaulting code in do_fault_around()
is supposed to take care of this, but missing error handling means that
the allocation failure can go unnoticed.

We don't need to return VM_FAULT_OOM (or any other error) here, since we
can just let the normal fault path try again.

Fixes: 7267ec008b5c ("mm: postpone page table allocation until we have page to map")
Link: http://lkml.kernel.org/r/1469708107-11868-1-git-send-email-vegard.nossum@oracle.com
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: "Hillf Danton" <hillf.zj@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/memory.c~mm-fail-prefaulting-if-page-table-allocation-fails mm/memory.c
--- a/mm/memory.c~mm-fail-prefaulting-if-page-table-allocation-fails
+++ a/mm/memory.c
@@ -3133,6 +3133,8 @@ static int do_fault_around(struct fault_
 
 	if (pmd_none(*fe->pmd)) {
 		fe->prealloc_pte = pte_alloc_one(fe->vma->vm_mm, fe->address);
+		if (!fe->prealloc_pte)
+			goto out;
 		smp_wmb(); /* See comment in __pte_alloc() */
 	}
 
_

Patches currently in -mm which might be from vegard.nossum@oracle.com are


