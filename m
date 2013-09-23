From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-vmalloc-revert-mm-vmallocc-emit-the-failure-message-before-return.patch
 removed from -mm tree
Date: Mon, 23 Sep 2013 16:18:46 -0700
Message-ID: <5240cc56.mrxfzpo5nTDwucNl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56767 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab3IWXSr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Sep 2013 19:18:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, rientjes@google.com, kosaki.motohiro@jp.fujitsu.com, iamjoonsoo.kim@lge.com, liwanp@linux.vnet.ibm.com

Subject: [to-be-updated] mm-vmalloc-revert-mm-vmallocc-emit-the-failure-message-before-return.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,iamjoonsoo.kim@lge.com,kosaki.motohiro@jp.fujitsu.com,rientjes@google.com,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 23 Sep 2013 16:18:46 -0700


The patch titled
     Subject: mm/vmalloc: revert "mm/vmalloc.c: emit the failure message before return"
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-revert-mm-vmallocc-emit-the-failure-message-before-return.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/vmalloc: revert "mm/vmalloc.c: emit the failure message before return"

Don't warn twice in __vmalloc_area_node and __vmalloc_node_range if
__vmalloc_area_node allocation failure.  This patch reverts 46c001a2
("mm/vmalloc.c: emit the failure message before return").

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmalloc.c~mm-vmalloc-revert-mm-vmallocc-emit-the-failure-message-before-return mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-revert-mm-vmallocc-emit-the-failure-message-before-return
+++ a/mm/vmalloc.c
@@ -1635,7 +1635,7 @@ void *__vmalloc_node_range(unsigned long
 
 	addr = __vmalloc_area_node(area, gfp_mask, prot, node, caller);
 	if (!addr)
-		goto fail;
+		return NULL;
 
 	/*
 	 * In this function, newly allocated vm_struct has VM_UNINITIALIZED
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

revert-mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages.patch
mm-compactionc-periodically-schedule-when-freeing-pages.patch
ksm-remove-redundant-__gfp_zero-from-kcalloc.patch
mm-vmalloc-revert-mm-vmallocc-emit-the-failure-message-before-return-fix.patch
mm-vmalloc-revert-mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info.patch
mm-vmalloc-fix-show-vmap_area-information-race-with-vmap_area-tear-down.patch
mm-huge_memoryc-fix-stale-comments-of-transparent_hugepage_flags.patch
mm-memory-failurec-move-set_migratetype_isolate-outside-get_any_page.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

