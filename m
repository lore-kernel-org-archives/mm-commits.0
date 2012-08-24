From: akpm@linux-foundation.org
Subject: [merged] mm-memblock-reduce-overhead-in-binary-search.patch removed from -mm tree
Date: Fri, 24 Aug 2012 15:08:54 -0700
Message-ID: <20120824220854.787FF100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:45545 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758962Ab2HXWIz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Aug 2012 18:08:55 -0400
Received: by yhl10 with SMTP id 10so339094yhl.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Aug 2012 15:08:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liwanp@linux.vnet.ibm.com, benh@kernel.crashing.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, minchan@kernel.org, shangw@linux.vnet.ibm.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock: reduce overhead in binary search
has been removed from the -mm tree.  Its filename was
     mm-memblock-reduce-overhead-in-binary-search.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/memblock: reduce overhead in binary search

When checking the indicated address belongs to the memory or reserved
region, the memory or reserved regions are checked one by one through
binary search, which would be a little time consuming.  If the indicated
address isn't in memory region, then we needn't do the time-sonsuming
search.  The patch adds more check on the indicated address for that
purpose.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/memblock.c~mm-memblock-reduce-overhead-in-binary-search mm/memblock.c
--- a/mm/memblock.c~mm-memblock-reduce-overhead-in-binary-search
+++ a/mm/memblock.c
@@ -871,6 +871,10 @@ static int __init_memblock memblock_sear
 {
 	unsigned int left = 0, right = type->cnt;
 
+	if (unlikely(addr < memblock_start_of_DRAM() ||
+		addr >= memblock_end_of_DRAM()))
+			return 0;
+
 	do {
 		unsigned int mid = (right + left) / 2;
 
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

mm-mmu_notifier-init-notifier-if-necessary.patch
mm-memblock-truncate-memblock-if-necessary.patch
mm-memblock-rename-get_allocated_memblock_reserved_regions_info.patch
mm-memblock-use-existing-interface-to-set-nid.patch
mm-memblock-cleanup-early_node_map-related-comments.patch
mm-vmscan-fix-error-number-for-failed-kthread.patch

