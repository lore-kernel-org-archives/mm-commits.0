From: akpm@linux-foundation.org
Subject: - memory-hotplug-missing-zone-lock-in-test_pages_isolated.patch removed from -mm tree
Date: Fri, 03 Oct 2008 14:28:51 -0700
Message-ID: <200810032128.m93LSp8d016644@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51552 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752516AbYJCV3s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Oct 2008 17:29:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerald.schaefer@de.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memory hotplug: missing zone->lock in test_pages_isolated()
has been removed from the -mm tree.  Its filename was
     memory-hotplug-missing-zone-lock-in-test_pages_isolated.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory hotplug: missing zone->lock in test_pages_isolated()
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

__test_page_isolated_in_pageblock() in mm/page_isolation.c has a comment
saying that the caller must hold zone->lock. But the only caller of that
function, test_pages_isolated(), does not hold zone->lock and the lock is
also not acquired anywhere before. This patch adds the missing zone->lock
to test_pages_isolated().

We reproducibly run into BUG_ON(!PageBuddy(page)) in __offline_isolated_pages()
during memory hotplug stress test, see trace below. This patch fixes that
problem, it would be good if we could have it in 2.6.27.

kernel BUG at /home/autobuild/BUILD/linux-2.6.26-20080909/mm/page_alloc.c:4561!
illegal operation: 0001 [#1] PREEMPT SMP
Modules linked in: dm_multipath sunrpc bonding qeth_l3 dm_mod qeth ccwgroup vmur
CPU: 1 Not tainted 2.6.26-29.x.20080909-s390default #1
Process memory_loop_all (pid: 10025, task: 2f444028, ksp: 2b10dd28)
Krnl PSW : 040c0000 801727ea (__offline_isolated_pages+0x18e/0x1c4)
 R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:0 CC:0 PM:0
Krnl GPRS: 00000000 7e27fc00 00000000 7e27fc00
 00000000 00000400 00014000 7e27fc01
 00606f00 7e27fc00 00013fe0 2b10dd28
 00000005 80172662 801727b2 2b10dd28
Krnl Code: 801727de: 5810900c l %r1,12(%r9)
 801727e2: a7f4ffb3 brc 15,80172748
 801727e6: a7f40001 brc 15,801727e8
 >801727ea: a7f4ffbc brc 15,80172762
 801727ee: a7f40001 brc 15,801727f0
 801727f2: a7f4ffaf brc 15,80172750
 801727f6: 0707 bcr 0,%r7
 801727f8: 0017 unknown
Call Trace:
([<0000000000172772>] __offline_isolated_pages+0x116/0x1c4)
 [<00000000001953a2>] offline_isolated_pages_cb+0x22/0x34
 [<000000000013164c>] walk_memory_resource+0xcc/0x11c
 [<000000000019520e>] offline_pages+0x36a/0x498
 [<00000000001004d6>] remove_memory+0x36/0x44
 [<000000000028fb06>] memory_block_change_state+0x112/0x150
 [<000000000028ffb8>] store_mem_state+0x90/0xe4
 [<0000000000289c00>] sysdev_store+0x34/0x40
 [<00000000001ee048>] sysfs_write_file+0xd0/0x178
 [<000000000019b1a8>] vfs_write+0x74/0x118
 [<000000000019b9ae>] sys_write+0x46/0x7c
 [<000000000011160e>] sysc_do_restart+0x12/0x16
 [<0000000077f3e8ca>] 0x77f3e8ca

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN mm/page_isolation.c~memory-hotplug-missing-zone-lock-in-test_pages_isolated mm/page_isolation.c
--- a/mm/page_isolation.c~memory-hotplug-missing-zone-lock-in-test_pages_isolated
+++ a/mm/page_isolation.c
@@ -114,8 +114,10 @@ __test_page_isolated_in_pageblock(unsign
 
 int test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn)
 {
-	unsigned long pfn;
+	unsigned long pfn, flags;
 	struct page *page;
+	struct zone *zone;
+	int ret;
 
 	pfn = start_pfn;
 	/*
@@ -131,7 +133,9 @@ int test_pages_isolated(unsigned long st
 	if (pfn < end_pfn)
 		return -EBUSY;
 	/* Check all pages are free or Marked as ISOLATED */
-	if (__test_page_isolated_in_pageblock(start_pfn, end_pfn))
-		return 0;
-	return -EBUSY;
+	zone = page_zone(pfn_to_page(pfn));
+	spin_lock_irqsave(&zone->lock, flags);
+	ret = __test_page_isolated_in_pageblock(start_pfn, end_pfn);
+	spin_unlock_irqrestore(&zone->lock, flags);
+	return ret ? 0 : -EBUSY;
 }
_

Patches currently in -mm which might be from gerald.schaefer@de.ibm.com are

origin.patch

