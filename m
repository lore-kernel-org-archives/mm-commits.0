From: akpm@linux-foundation.org
Subject: [obsolete] mm-memblock-reduce-overhead-in-binary-search.patch removed from -mm tree
Date: Tue, 18 Dec 2012 15:11:50 -0800
Message-ID: <20121218231151.AB092200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f73.google.com ([74.125.83.73]:35979 "EHLO
	mail-ee0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab2LRXLy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 18:11:54 -0500
Received: by mail-ee0-f73.google.com with SMTP id c50so69448eek.0
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 15:11:53 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liwanp@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, minchan@kernel.org, shangw@linux.vnet.ibm.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock: reduce overhead in binary search
has been removed from the -mm tree.  Its filename was
     mm-memblock-reduce-overhead-in-binary-search.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/memblock: reduce overhead in binary search

When checking that the indicated address belongs to the memory region, the
memory regions are checked one by one through a binary search, which will
be time consuming.

If the indicated address isn't in the memory region, then we needn't do
the time-consuming search.  Add a check on the indicated address for that
purpose.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/memblock.c~mm-memblock-reduce-overhead-in-binary-search mm/memblock.c
--- a/mm/memblock.c~mm-memblock-reduce-overhead-in-binary-search
+++ a/mm/memblock.c
@@ -889,6 +889,11 @@ int __init memblock_is_reserved(phys_add
 
 int __init_memblock memblock_is_memory(phys_addr_t addr)
 {
+
+	if (unlikely(addr < memblock_start_of_DRAM() ||
+		addr >= memblock_end_of_DRAM()))
+		return 0;
+
 	return memblock_search(&memblock.memory, addr) != -1;
 }
 
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are


