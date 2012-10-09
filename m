From: akpm@linux-foundation.org
Subject: [merged] mm-memblock-use-existing-interface-to-set-nid.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:12:00 -0700
Message-ID: <20121009181200.BB9BD100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:59167 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777Ab2JISMC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:12:02 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so518873qae.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:12:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liwanp@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, minchan@kernel.org, shangw@linux.vnet.ibm.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock: use existing interface to set nid
has been removed from the -mm tree.  Its filename was
     mm-memblock-use-existing-interface-to-set-nid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/memblock: use existing interface to set nid

Use the existing interface function to set the NUMA node ID (NID) for the
regions, either memory or reserved region.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memblock.c~mm-memblock-use-existing-interface-to-set-nid mm/memblock.c
--- a/mm/memblock.c~mm-memblock-use-existing-interface-to-set-nid
+++ a/mm/memblock.c
@@ -756,7 +756,7 @@ int __init_memblock memblock_set_node(ph
 		return ret;
 
 	for (i = start_rgn; i < end_rgn; i++)
-		type->regions[i].nid = nid;
+		memblock_set_region_node(&type->regions[i], nid);
 
 	memblock_merge_regions(type);
 	return 0;
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

origin.patch
mm-memblock-reduce-overhead-in-binary-search.patch

