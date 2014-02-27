From: akpm@linux-foundation.org
Subject: + mm-introduce-do_shared_fault-and-drop-do_fault-fix.patch added
 to -mm tree
Date: Thu, 27 Feb 2014 14:43:28 -0800
Message-ID: <530fbf90.zJpOQ52UUZX9dKoe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40178 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbaB0Wn3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Feb 2014 17:43:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mgorman@suse.de, matthew.r.wilcox@intel.com, kirill.shutemov@linux.intel.com, dave.hansen@linux.intel.com, bob.liu@oracle.com, ak@linux.intel.com, lliubbo@gmail.com

Subject: + mm-introduce-do_shared_fault-and-drop-do_fault-fix.patch added to -mm tree
To: lliubbo@gmail.com,ak@linux.intel.com,bob.liu@oracle.com,dave.hansen@linux.intel.com,kirill.shutemov@linux.intel.com,matthew.r.wilcox@intel.com,mgorman@suse.de,n-horiguchi@ah.jp.nec.com,riel@redhat.com,sasha.levin@oracle.com
From: akpm@linux-foundation.org
Date: Thu, 27 Feb 2014 14:43:28 -0800


The patch titled
     Subject: mm: do_shared_fault: fix potential NULL pointer dereference
has been added to the -mm tree.  Its filename is
     mm-introduce-do_shared_fault-and-drop-do_fault-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-do_shared_fault-and-drop-do_fault-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-do_shared_fault-and-drop-do_fault-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bob Liu <lliubbo@gmail.com>
Subject: mm: do_shared_fault: fix potential NULL pointer dereference

[  232.869443] BUG: unable to handle kernel NULL pointer dereference at
0000000000000020
[  232.870230] IP: [<mm/page-writeback.c:1612>]
balance_dirty_pages_ratelimited+0x1e/0x150
[  232.870230] PGD 586e1d067 PUD 586e1e067 PMD 0
[  232.870230] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  232.870230] Dumping ftrace buffer:
[  232.870230]    (ftrace buffer empty)
[  232.870230] Modules linked in:
[  232.870230] CPU: 36 PID: 9707 Comm: trinity-c36 Tainted: G        W
3.14.0-rc4-next-20140225-sasha-00010-ga117461 #42
[  232.870230] task: ffff880586dfb000 ti: ffff880586e34000 task.ti:
ffff880586e34000
[  232.870230] RIP: 0010:[<mm/page-writeback.c:1612>]
[<mm/page-writeback.c:1612>]
balance_dirty_pages_ratelimited+0x1e/0x150
[  232.870230] RSP: 0000:ffff880586e35c58  EFLAGS: 00010282
[  232.870230] RAX: 0000000000000000 RBX: ffff880582831361 RCX:
0000000000000007
[  232.870230] RDX: 0000000000000007 RSI: ffff880586dfbcc0 RDI:
ffff880582831361
[  232.870230] RBP: ffff880586e35c78 R08: 0000000000000000 R09:
0000000000000000
[  232.870230] R10: 0000000000000001 R11: 0000000000000001 R12:
00007f58007ee000
[  232.870230] R13: ffff880c8d6d4f70 R14: 0000000000000200 R15:
ffff880c8dcce710
[  232.870230] FS:  00007f58018bb700(0000) GS:ffff880c8e800000(0000)
knlGS:0000000000000000
[  232.870230] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  232.870230] CR2: 0000000000000020 CR3: 0000000586e1c000 CR4:
00000000000006e0
[  232.870230] Stack:
[  232.870230]  ffff880586e35c78 ffff880586e33400 00007f58007ee000
ffff880c8d6d4f70
[  232.870230]  ffff880586e35cd8 ffffffff8127d241 0000000000000001
0000000000000001
[  232.870230]  0000000000000000 ffffea0032337080 0000000080000000
ffff880586e33400
[  232.870230] Call Trace:
[  232.870230]  [<mm/memory.c:3467>] do_shared_fault+0x1a1/0x1f0
[  232.870230]  [<mm/memory.c:3487>] handle_pte_fault+0xc8/0x230
[  232.870230]  [<arch/x86/include/asm/preempt.h:98>] ? delay_tsc+0xea/0x110
[  232.870230]  [<mm/memory.c:3770>] __handle_mm_fault+0x36e/0x3a0
[  232.870230]  [<include/linux/rcupdate.h:829>] ? rcu_read_unlock+0x5d/0x60
[  232.870230]  [<include/linux/memcontrol.h:148>] handle_mm_fault+0x10b/0x1b0
[  232.870230]  [<arch/x86/mm/fault.c:1147>] ? __do_page_fault+0x2e2/0x590
[  232.870230]  [<arch/x86/mm/fault.c:1214>] __do_page_fault+0x551/0x590
[  232.870230]  [<kernel/sched/cputime.c:681>] ? vtime_account_user+0x91/0xa0
[  232.870230]  [<arch/x86/include/asm/atomic.h:26>] ?
context_tracking_user_exit+0xa8/0x1c0
[  232.870230]  [<arch/x86/include/asm/preempt.h:98>] ?
_raw_spin_unlock+0x30/0x50
[  232.870230]  [<kernel/sched/cputime.c:681>] ? vtime_account_user+0x91/0xa0
[  232.870230]  [<arch/x86/include/asm/atomic.h:26>] ?
context_tracking_user_exit+0xa8/0x1c0
[  232.870230]  [<arch/x86/include/asm/atomic.h:26>] do_page_fault+0x3d/0x70
[  232.870230]  [<arch/x86/kernel/kvm.c:263>] do_async_page_fault+0x35/0x100
[  232.870230]  [<arch/x86/kernel/entry_64.S:1496>] async_page_fault+0x28/0x30
[  232.870230] Code: 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 48 83
ec 20 48 89 5d e8 4c
89 65 f0 4c 89 6d f8 48 89 fb 48 8b 87 50 01 00 00 <f6> 40 20 01 0f 85 18 01
00 00 65 48 8b 14 25 40
da 00 00 44 8b
[  232.870230] RIP  [<mm/page-writeback.c:1612>]
balance_dirty_pages_ratelimited+0x1e/0x150
[  232.870230]  RSP <ffff880586e35c58>
[  232.870230] CR2: 0000000000000020

See: https://lkml.org/lkml/2014/2/25/463

This bug was first introduced by commit: 'mm: introduce do_shared_fault()
and drop do_fault()'(3a379a672c7adf40) The root cause is
'fault_page->mapping' might be set to NULL just after the if condition and
pass down to 'balance_dirty_pages_ratelimited()'.  This patch fix this
issue by use a local variable just as before.

Signed-off-by: Bob Liu <bob.liu@oracle.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~mm-introduce-do_shared_fault-and-drop-do_fault-fix mm/memory.c
--- a/mm/memory.c~mm-introduce-do_shared_fault-and-drop-do_fault-fix
+++ a/mm/memory.c
@@ -3415,6 +3415,7 @@ static int do_shared_fault(struct mm_str
 		pgoff_t pgoff, unsigned int flags, pte_t orig_pte)
 {
 	struct page *fault_page;
+	struct address_space *mapping;
 	spinlock_t *ptl;
 	pte_t entry, *pte;
 	int dirtied = 0;
@@ -3475,13 +3476,14 @@ set_pte:
 
 	if (set_page_dirty(fault_page))
 		dirtied = 1;
+	mapping = fault_page->mapping;
 	unlock_page(fault_page);
-	if ((dirtied || vma->vm_ops->page_mkwrite) && fault_page->mapping) {
+	if ((dirtied || vma->vm_ops->page_mkwrite) && mapping) {
 		/*
 		 * Some device drivers do not set page.mapping but still
 		 * dirty their pages
 		 */
-		balance_dirty_pages_ratelimited(fault_page->mapping);
+		balance_dirty_pages_ratelimited(mapping);
 	}
 
 	/* file_update_time outside page_lock */
_

Patches currently in -mm which might be from lliubbo@gmail.com are

mm-introduce-do_shared_fault-and-drop-do_fault-fix.patch
linux-next.patch

