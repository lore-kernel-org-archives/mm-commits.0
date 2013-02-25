From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-integrated-__remove_section-of-config_sparsemem_vmemmap.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:50:15 -0800
Message-ID: <20130225205015.DFB495A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:61507 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759560Ab3BYUuR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:50:17 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so347058vcd.3
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:50:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, mingo@elte.hu, tglx@linutronix.de, wency@cn.fujitsu.com, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: integrated __remove_section() of CONFIG_SPARSEMEM_VMEMMAP.
has been removed from the -mm tree.  Its filename was
     memory-hotplug-integrated-__remove_section-of-config_sparsemem_vmemmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: memory-hotplug: integrated __remove_section() of CONFIG_SPARSEMEM_VMEMMAP.

Currently __remove_section for SPARSEMEM_VMEMMAP does nothing.  But even
if we use SPARSEMEM_VMEMMAP, we can unregister the memory_section.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Wu Jianguo <wujianguo@huawei.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   11 -----------
 1 file changed, 11 deletions(-)

diff -puN mm/memory_hotplug.c~memory-hotplug-integrated-__remove_section-of-config_sparsemem_vmemmap mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-integrated-__remove_section-of-config_sparsemem_vmemmap
+++ a/mm/memory_hotplug.c
@@ -432,16 +432,6 @@ static int __meminit __add_section(int n
 	return register_new_memory(nid, __pfn_to_section(phys_start_pfn));
 }
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
-static int __remove_section(struct zone *zone, struct mem_section *ms)
-{
-	/*
-	 * XXX: Freeing memmap with vmemmap is not implement yet.
-	 *      This should be removed later.
-	 */
-	return -EBUSY;
-}
-#else
 static int __remove_section(struct zone *zone, struct mem_section *ms)
 {
 	int ret = -EINVAL;
@@ -456,7 +446,6 @@ static int __remove_section(struct zone 
 	sparse_remove_one_section(zone, ms);
 	return 0;
 }
-#endif
 
 /*
  * Reasonably generic function for adding memory.  It is
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

origin.patch
linux-next.patch

