From: akpm@linux-foundation.org
Subject: + mm-rmap-dont-try-to-add-an-unevictable-page-to-lru-list.patch
 added to -mm tree
Date: Mon, 31 Mar 2014 14:06:07 -0700
Message-ID: <5339d8bf.uguMIKn0srJeV76I%akpm__17668.7523410239$1396299986$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49440 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbaCaVGI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Mar 2014 17:06:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, sasha.levin@oracle.com, riel@redhat.com, mel@csn.ul.ie, bob.liu@oracle.com, lliubbo@gmail.com

Subject: + mm-rmap-dont-try-to-add-an-unevictable-page-to-lru-list.patch added to -mm tree
To: lliubbo@gmail.com,bob.liu@oracle.com,mel@csn.ul.ie,riel@redhat.com,sasha.levin@oracle.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 31 Mar 2014 14:06:07 -0700


The patch titled
     Subject: mm: rmap: don't try to add an unevictable page to lru list
has been added to the -mm tree.  Its filename is
     mm-rmap-dont-try-to-add-an-unevictable-page-to-lru-list.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-dont-try-to-add-an-unevictable-page-to-lru-list.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-dont-try-to-add-an-unevictable-page-to-lru-list.patch

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
Subject: mm: rmap: don't try to add an unevictable page to lru list

VM_BUG_ON_PAGE(PageActive(page) && PageUnevictable(page), page) in
lru_cache_add() was triggered during migrate_misplaced_transhuge_page.

[  477.301955] kernel BUG at mm/swap.c:609!
[  477.302564] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  477.303590] Dumping ftrace buffer:
[  477.305022]    (ftrace buffer empty)
[  477.305899] Modules linked in:
[  477.306397] CPU: 35 PID: 10092 Comm: trinity-c374 Tainted: G        W 3.14.0-rc5-next-20140307-sasha-00010-g1f812cb #142
[  477.307644] task: ffff8800a7f80000 ti: ffff8800a7f6a000 task.ti: ffff8800a7f6a000
[  477.309124] RIP: 0010:[<ffffffff8127f311>]  [<ffffffff8127f311>] lru_cache_add+0x21/0x60
[  477.310301] RSP: 0000:ffff8800a7f6bbc8  EFLAGS: 00010292
[  477.311110] RAX: 000000000000003f RBX: ffffea0013d68000 RCX: 0000000000000006
[  477.311110] RDX: 0000000000000006 RSI: ffff8800a7f80d60 RDI: 0000000000000282
[  477.311110] RBP: ffff8800a7f6bbc8 R08: 0000000000000001 R09: 0000000000000001
[  477.311110] R10: 0000000000000001 R11: 0000000000000001 R12: ffff8800ab9b0c00
[  477.311110] R13: 0000000002400000 R14: ffff8800ab9b0c00 R15: 0000000000000001
[  477.311110] FS:  00007ff2c047c700(0000) GS:ffff88042bc00000(0000) knlGS:0000000000000000
[  477.311110] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  477.311110] CR2: 0000000003788a68 CR3: 00000000a7f68000 CR4: 00000000000006a0
[  477.311110] DR0: 000000000069b000 DR1: 0000000000000000 DR2: 0000000000000000
[  477.311110] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[  477.311110] Stack:
[  477.311110]  ffff8800a7f6bbf8 ffffffff812adaec ffffea0013d68000 ffffea002bdb8000
[  477.311110]  ffffea0013d68000 ffff8800a7f7c090 ffff8800a7f6bca8 ffffffff812db8ec
[  477.311110]  0000000000000001 ffffffff812e1321 ffff8800a7f6bc48 ffffffff811ad632
[  477.311110] Call Trace:
[  477.311110]  [<ffffffff812adaec>] page_add_new_anon_rmap+0x1ec/0x210
[  477.311110]  [<ffffffff812db8ec>] migrate_misplaced_transhuge_page+0x55c/0x830
[  477.311110]  [<ffffffff812e1321>] ? do_huge_pmd_numa_page+0x311/0x460
[  477.311110]  [<ffffffff811ad632>] ? __lock_release+0x1e2/0x200
[  477.311110]  [<ffffffff812e133f>] do_huge_pmd_numa_page+0x32f/0x460
[  477.311110]  [<ffffffff81af6aca>] ? delay_tsc+0xfa/0x120
[  477.311110]  [<ffffffff812a31f4>] __handle_mm_fault+0x244/0x3a0
[  477.311110]  [<ffffffff812e37ed>] ? rcu_read_unlock+0x5d/0x60
[  477.311110]  [<ffffffff812a3463>] handle_mm_fault+0x113/0x1c0
[  477.311110]  [<ffffffff844abd42>] ? __do_page_fault+0x302/0x5d0
[  477.311110]  [<ffffffff844abfd1>] __do_page_fault+0x591/0x5d0
[  477.311110]  [<ffffffff8118ab46>] ? vtime_account_user+0x96/0xb0
[  477.311110]  [<ffffffff844ac492>] ? preempt_count_sub+0xe2/0x120
[  477.311110]  [<ffffffff81269567>] ? context_tracking_user_exit+0x187/0x1d0
[  477.311110]  [<ffffffff844ac0d5>] do_page_fault+0x45/0x70
[  477.311110]  [<ffffffff844ab386>] do_async_page_fault+0x36/0x100
[  477.311110]  [<ffffffff844a7f18>] async_page_fault+0x28/0x30
[  477.311110] Code: 65 f0 4c 8b 6d f8 c9 c3 66 90 55 48 89 e5 66 66 66 66 90
48 8b 07 a8 40 74 18 48 8b 07 a9 00 00 10 00 74 0e 31 f6 e8 2f 20 ff ff <0f>
0b eb fe 0f 1f 00 48 8b 07 a8 20 74 19 31 f6 e8 1a 20 ff ff
[  477.311110] RIP  [<ffffffff8127f311>] lru_cache_add+0x21/0x60
[  477.311110]  RSP <ffff8800a7f6bbc8>

The root cause is that checking mlocked_vma_newpage() in
page_add_new_anon_rmap() is not enough to decide whether a page is
unevictable.

migrate_misplaced_transhuge_page():
	=> migrate_page_copy()
		=> SetPageUnevictable(newpage)

	=> page_add_new_anon_rmap(newpage)
		=> mlocked_vma_newpage(vma, newpage) <--This check is not enough
			=> SetPageActive(newpage)
			=> lru_cache_add(newpage)
				=> VM_BUG_ON_PAGE()

From vmscan.c:
 * Reasons page might not be evictable:
 * (1) page's mapping marked unevictable
 * (2) page is part of an mlocked VMA

But page_add_new_anon_rmap() only checks reason (2), we may hit this
VM_BUG_ON_PAGE() if PageUnevictable(old_page) was originally set by reason (1).

Signed-off-by: Bob Liu <bob.liu@oracle.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/rmap.c~mm-rmap-dont-try-to-add-an-unevictable-page-to-lru-list mm/rmap.c
--- a/mm/rmap.c~mm-rmap-dont-try-to-add-an-unevictable-page-to-lru-list
+++ a/mm/rmap.c
@@ -1020,7 +1020,7 @@ void page_add_new_anon_rmap(struct page
 	__mod_zone_page_state(page_zone(page), NR_ANON_PAGES,
 			hpage_nr_pages(page));
 	__page_set_anon_rmap(page, vma, address, 1);
-	if (!mlocked_vma_newpage(vma, page)) {
+	if (!mlocked_vma_newpage(vma, page) && !PageUnevictable(page)) {
 		SetPageActive(page);
 		lru_cache_add(page);
 	} else
_

Patches currently in -mm which might be from lliubbo@gmail.com are

mm-introduce-do_shared_fault-and-drop-do_fault-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-rmap-dont-try-to-add-an-unevictable-page-to-lru-list.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

