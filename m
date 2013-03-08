From: akpm@linux-foundation.org
Subject: + mm-remove_memory-fix-end_pfn-setting.patch added to -mm tree
Date: Fri, 08 Mar 2013 13:31:49 -0800
Message-ID: <20130308213149.E1A1D5A41F7@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:36939 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756372Ab3CHVbv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Mar 2013 16:31:51 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so204061ggn.4
        for <mm-commits@vger.kernel.org>; Fri, 08 Mar 2013 13:31:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: toshi.kani@hp.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, tangchen@cn.fujitsu.com, wency@cn.fujitsu.com, wujianguo@huawei.com


The patch titled
     Subject: mm: remove_memory(): fix end_pfn setting
has been added to the -mm tree.  Its filename is
     mm-remove_memory-fix-end_pfn-setting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-walk_memory_range-fix-typo-in-comment.patch
mm-remove_memory-fix-end_pfn-setting.patch

