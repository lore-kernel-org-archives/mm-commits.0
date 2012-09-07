From: akpm@linux-foundation.org
Subject: + mm-memblock-reduce-overhead-in-binary-search.patch added to -mm tree
Date: Fri, 07 Sep 2012 16:50:57 -0700
Message-ID: <20120907235058.A33F75C0219@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:48382 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab2IGXvC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Sep 2012 19:51:02 -0400
Received: by eekd4 with SMTP id d4so5197eek.1
        for <mm-commits@vger.kernel.org>; Fri, 07 Sep 2012 16:51:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liwanp@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, minchan@kernel.org, shangw@linux.vnet.ibm.com, yinghai@kernel.org


The patch titled
     Subject: mm/memblock: reduce overhead in binary search
has been added to the -mm tree.  Its filename is
     mm-memblock-reduce-overhead-in-binary-search.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -888,6 +888,11 @@ int __init memblock_is_reserved(phys_add
 
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

mm-mmu_notifier-init-notifier-if-necessary.patch
mm-vmscan-fix-error-number-for-failed-kthread.patch
mm-memblock-reduce-overhead-in-binary-search.patch
mm-memblock-rename-get_allocated_memblock_reserved_regions_info.patch
mm-memblock-use-existing-interface-to-set-nid.patch
mm-memblock-cleanup-early_node_map-related-comments.patch

