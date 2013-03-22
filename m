From: akpm@linux-foundation.org
Subject: + mm-hotplug-only-free-wait_table-if-its-allocated-by-vmalloc.patch added to -mm tree
Date: Fri, 22 Mar 2013 12:37:16 -0700
Message-ID: <20130322193716.7857131C4C0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:48382 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab3CVThR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Mar 2013 15:37:17 -0400
Received: by mail-gh0-f202.google.com with SMTP id z10so66717ghb.5
        for <mm-commits@vger.kernel.org>; Fri, 22 Mar 2013 12:37:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wujianguo@huawei.com, jiang.liu@huawei.com, tangchen@cn.fujitsu.com


The patch titled
     Subject: mm/hotplug: only free wait_table if it's allocated by vmalloc
has been added to the -mm tree.  Its filename is
     mm-hotplug-only-free-wait_table-if-its-allocated-by-vmalloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jianguo Wu <wujianguo@huawei.com>
Subject: mm/hotplug: only free wait_table if it's allocated by vmalloc

zone->wait_table may be allocated from bootmem, it can not be freed.

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~mm-hotplug-only-free-wait_table-if-its-allocated-by-vmalloc mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-hotplug-only-free-wait_table-if-its-allocated-by-vmalloc
+++ a/mm/memory_hotplug.c
@@ -1779,7 +1779,11 @@ void try_offline_node(int nid)
 	for (i = 0; i < MAX_NR_ZONES; i++) {
 		struct zone *zone = pgdat->node_zones + i;
 
-		if (zone->wait_table)
+		/*
+		 * wait_table may be allocated from boot memory,
+		 * here only free if it's allocated by vmalloc.
+		 */
+		if (is_vmalloc_addr(zone->wait_table))
 			vfree(zone->wait_table);
 	}
 
_

Patches currently in -mm which might be from wujianguo@huawei.com are

linux-next.patch
mm-hotplug-only-free-wait_table-if-its-allocated-by-vmalloc.patch
arch-x86-mm-init_64c-fix-build-warning-when-config_memory_hotremove=n.patch
mm-migrate-fix-comment-typo-syncronous-synchronous.patch

