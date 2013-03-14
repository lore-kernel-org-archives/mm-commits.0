From: akpm@linux-foundation.org
Subject: [merged] mm-remove_memory-fix-end_pfn-setting.patch removed from -mm tree
Date: Thu, 14 Mar 2013 11:52:07 -0700
Message-ID: <20130314185207.8FA095A41B0@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:37670 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab3CNSwK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Mar 2013 14:52:10 -0400
Received: by mail-gg0-f201.google.com with SMTP id l2so258644ggn.2
        for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2013 11:52:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hp.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, tangchen@cn.fujitsu.com, wency@cn.fujitsu.com, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove_memory(): fix end_pfn setting
has been removed from the -mm tree.  Its filename was
     mm-remove_memory-fix-end_pfn-setting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Toshi Kani <toshi.kani@hp.com>
Subject: mm: remove_memory(): fix end_pfn setting

remove_memory() calls walk_memory_range() with [start_pfn, end_pfn), where
end_pfn is exclusive in this range.  Therefore, end_pfn needs to be set to
the next page of the end address.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Wu Jianguo <wujianguo@huawei.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~mm-remove_memory-fix-end_pfn-setting mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-remove_memory-fix-end_pfn-setting
+++ a/mm/memory_hotplug.c
@@ -1801,7 +1801,7 @@ int __ref remove_memory(int nid, u64 sta
 	int retry = 1;
 
 	start_pfn = PFN_DOWN(start);
-	end_pfn = start_pfn + PFN_DOWN(size);
+	end_pfn = PFN_UP(start + size - 1);
 
 	/*
 	 * When CONFIG_MEMCG is on, one memory block may be used by other
_

Patches currently in -mm which might be from toshi.kani@hp.com are

origin.patch
linux-next.patch
mm-walk_memory_range-fix-typo-in-comment.patch

