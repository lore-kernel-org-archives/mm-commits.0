From: akpm@linux-foundation.org
Subject: [folded-merged]
 memory-hotplug-clear-pgdat-which-is-allocated-by-bootmem-in-try_offline_node-v2.patch removed from -mm tree
Date: Wed, 29 Oct 2014 14:47:18 -0700
Message-ID: <54516066.oL1x3e8jvQSwG+au%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52902 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312AbaJ2VrS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Oct 2014 17:47:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: isimatu.yasuaki@jp.fujitsu.com, dave.hansen@intel.com, rientjes@google.com, tangchen@cn.fujitsu.com, toshi.kani@hp.com, wangnan0@huawei.com, zhenzhang.zhang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug-clear-pgdat-which-is-allocated-by-bootmem-in-try_offline_node-v2
has been removed from the -mm tree.  Its filename was
     memory-hotplug-clear-pgdat-which-is-allocated-by-bootmem-in-try_offline_node-v2.patch

This patch was dropped because it was folded into memory-hotplug-clear-pgdat-which-is-allocated-by-bootmem-in-try_offline_node.patch

------------------------------------------------------
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: memory-hotplug-clear-pgdat-which-is-allocated-by-bootmem-in-try_offline_node-v2

v2: remove check of pgdat_page

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Zhang Zhen <zhenzhang.zhang@huawei.com>
Cc: Wang Nan <wangnan0@huawei.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN mm/memory_hotplug.c~memory-hotplug-clear-pgdat-which-is-allocated-by-bootmem-in-try_offline_node-v2 mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-clear-pgdat-which-is-allocated-by-bootmem-in-try_offline_node-v2
+++ a/mm/memory_hotplug.c
@@ -1912,7 +1912,6 @@ void try_offline_node(int nid)
 	unsigned long start_pfn = pgdat->node_start_pfn;
 	unsigned long end_pfn = start_pfn + pgdat->node_spanned_pages;
 	unsigned long pfn;
-	struct page *pgdat_page = virt_to_page(pgdat);
 	int i;
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
@@ -1941,10 +1940,6 @@ void try_offline_node(int nid)
 	node_set_offline(nid);
 	unregister_one_node(nid);
 
-	if (!PageSlab(pgdat_page) && !PageCompound(pgdat_page))
-		/* node data is allocated from boot memory */
-		goto out;
