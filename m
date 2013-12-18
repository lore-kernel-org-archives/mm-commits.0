From: akpm@linux-foundation.org
Subject: + mm-remove-bug_on-from-mlock_vma_page.patch added to -mm tree
Date: Wed, 18 Dec 2013 14:31:02 -0800
Message-ID: <52b22226.aOVglLB3OjyKbakp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab3LRWbD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Dec 2013 17:31:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, vbabka@suse.cz, stable@vger.kernel.org, sasha.levin@oracle.com, rientjes@google.com, riel@redhat.com, minchan@kernel.org, mgorman@suse.de, liwanp@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, bob.liu@oracle.com, lliubbo@gmail.com

Subject: + mm-remove-bug_on-from-mlock_vma_page.patch added to -mm tree
To: lliubbo@gmail.com,bob.liu@oracle.com,hannes@cmpxchg.org,hughd@google.com,kosaki.motohiro@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,minchan@kernel.org,riel@redhat.com,rientjes@google.com,sasha.levin@oracle.com,stable@vger.kernel.org,vbabka@suse.cz,walken@google.com
From: akpm@linux-foundation.org
Date: Wed, 18 Dec 2013 14:31:02 -0800


The patch titled
     Subject: mm: remove BUG_ON() from mlock_vma_page()
has been added to the -mm tree.  Its filename is
     mm-remove-bug_on-from-mlock_vma_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-bug_on-from-mlock_vma_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-bug_on-from-mlock_vma_page.patch

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
Subject: mm: remove BUG_ON() from mlock_vma_page()

objrmap doesn't work for nonlinear VMAs because the assumption that
offset-into-file correlates with offset-into-virtual-addresses does not
hold.  Hence what try_to_unmap_cluster does is a mini "virtual scan" of
each nonlinear VMA which maps the file to which the target page belongs. 
If vma locked, mlock the pages in the cluster, rather than unmapping them.
However, not all pages are guarantee page locked instead of the check
page, resulting in the below BUG_ON().

It's safe to mlock_vma_page() without PageLocked, so fix this issue by
removing that BUG_ON().

[  253.869145] kernel BUG at mm/mlock.c:82!
[  253.869549] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  253.870098] Dumping ftrace buffer:
[  253.870098]    (ftrace buffer empty)
[  253.870098] Modules linked in:
[  253.870098] CPU: 10 PID: 9162 Comm: trinity-child75 Tainted: G        W 3.13.0-rc4-next-20131216-sasha-00011-g5f105ec-dirty #4137
[  253.873310] task: ffff8800c98cb000 ti: ffff8804d34e8000 task.ti: ffff8804d34e8000
[  253.873310] RIP: 0010:[<ffffffff81281f28>]  [<ffffffff81281f28>] mlock_vma_page+0x18/0xc0
[  253.873310] RSP: 0000:ffff8804d34e99e8  EFLAGS: 00010246
[  253.873310] RAX: 006fffff8038002c RBX: ffffea00474944c0 RCX: ffff880807636000
[  253.873310] RDX: ffffea0000000000 RSI: 00007f17a9bca000 RDI: ffffea00474944c0
[  253.873310] RBP: ffff8804d34e99f8 R08: ffff880807020000 R09: 0000000000000000
[  253.873310] R10: 0000000000000001 R11: 0000000000002000 R12: 00007f17a9bca000
[  253.873310] R13: ffffea00474944c0 R14: 00007f17a9be0000 R15: ffff880807020000
[  253.873310] FS:  00007f17aa31a700(0000) GS:ffff8801c9c00000(0000) knlGS:0000000000000000
[  253.873310] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  253.873310] CR2: 00007f17a94fa000 CR3: 00000004d3b02000 CR4: 00000000000006e0
[  253.873310] DR0: 00007f17a74ca000 DR1: 0000000000000000 DR2: 0000000000000000
[  253.873310] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[  253.873310] Stack:
[  253.873310]  0000000b3de28067 ffff880b3de28e50 ffff8804d34e9aa8 ffffffff8128bc31
[  253.873310]  0000000000000301 ffffea0011850220 ffff8809a4039000 ffffea0011850238
[  253.873310]  ffff8804d34e9aa8 ffff880807636060 0000000000000001 ffff880807636348
[  253.873310] Call Trace:
[  253.873310]  [<ffffffff8128bc31>] try_to_unmap_cluster+0x1c1/0x340
[  253.873310]  [<ffffffff8128c60a>] try_to_unmap_file+0x20a/0x2e0
[  253.873310]  [<ffffffff8128c7b3>] try_to_unmap+0x73/0x90
[  253.873310]  [<ffffffff812b526d>] __unmap_and_move+0x18d/0x250
[  253.873310]  [<ffffffff812b53e9>] unmap_and_move+0xb9/0x180
[  253.873310]  [<ffffffff812b559b>] migrate_pages+0xeb/0x2f0
[  253.873310]  [<ffffffff812a0660>] ? queue_pages_pte_range+0x1a0/0x1a0
[  253.873310]  [<ffffffff812a193c>] migrate_to_node+0x9c/0xc0
[  253.873310]  [<ffffffff812a30b8>] do_migrate_pages+0x1b8/0x240
[  253.873310]  [<ffffffff812a3456>] SYSC_migrate_pages+0x316/0x380
[  253.873310]  [<ffffffff812a31ec>] ? SYSC_migrate_pages+0xac/0x380
[  253.873310]  [<ffffffff811763c6>] ? vtime_account_user+0x96/0xb0
[  253.873310]  [<ffffffff812a34ce>] SyS_migrate_pages+0xe/0x10
[  253.873310]  [<ffffffff843c4990>] tracesys+0xdd/0xe2
[  253.873310] Code: 0f 1f 00 65 48 ff 04 25 10 25 1d 00 48 83 c4 08
5b c9 c3 55 48 89 e5 53 48 83 ec 08 66 66 66 66 90 48 8b 07 48 89 fb
a8 01 75 10 <0f> 0b 66 0f 1f 44 00 00 eb fe 66 0f 1f 44 00 00 f0 0f ba
2f 15
[  253.873310] RIP  [<ffffffff81281f28>] mlock_vma_page+0x18/0xc0
[  253.873310]  RSP <ffff8804d34e99e8>
[  253.904194] ---[ end trace be59c4a7f8edab3f ]---

Signed-off-by: Bob Liu <bob.liu@oracle.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/mlock.c~mm-remove-bug_on-from-mlock_vma_page mm/mlock.c
--- a/mm/mlock.c~mm-remove-bug_on-from-mlock_vma_page
+++ a/mm/mlock.c
@@ -79,8 +79,6 @@ void clear_page_mlock(struct page *page)
  */
 void mlock_vma_page(struct page *page)
 {
-	BUG_ON(!PageLocked(page));
