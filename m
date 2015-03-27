From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-call-kernel_map_pages-in-unset_migrateype_isolate.patch
 removed from -mm tree
Date: Fri, 27 Mar 2015 11:16:55 -0700
Message-ID: <55159e97.zS+eOW0HhV4EmnGc%akpm__40251.7329356217$1427480261$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47714 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbbC0SQ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Mar 2015 14:16:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lauraa@codeaurora.org, gioh.kim@lge.com, iamjoonsoo.kim@lge.com, isimatu.yasuaki@jp.fujitsu.com, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, n-horiguchi@ah.jp.nec.com, qiuxishi@huawei.com, riel@redhat.com, stable@vger.kernel.org, vbabka@suse.cz, vdavydov@parallels.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: call kernel_map_pages in unset_migrateype_isolate
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-call-kernel_map_pages-in-unset_migrateype_isolate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Laura Abbott <lauraa@codeaurora.org>
Subject: mm/page_alloc.c: call kernel_map_pages in unset_migrateype_isolate

Commit 3c605096d315 ("mm/page_alloc: restrict max order of merging on
isolated pageblock") changed the logic of unset_migratetype_isolate to
check the buddy allocator and explicitly call __free_pages to merge.  The
page that is being freed in this path never had prep_new_page called so
set_page_refcounted is called explicitly but there is no call to
kernel_map_pages.  With the default kernel_map_pages this is mostly
harmless but if kernel_map_pages does any manipulation of the page tables
(unmapping or setting pages to read only) this may trigger a fault:

    alloc_contig_range test_pages_isolated(ceb00, ced00) failed
    Unable to handle kernel paging request at virtual address ffffffc0cec00000
    pgd = ffffffc045fc4000
    [ffffffc0cec00000] *pgd=0000000000000000
    Internal error: Oops: 9600004f [#1] PREEMPT SMP
    Modules linked in: exfatfs
    CPU: 1 PID: 23237 Comm: TimedEventQueue Not tainted 3.10.49-gc72ad36-dirty #1
    task: ffffffc03de52100 ti: ffffffc015388000 task.ti: ffffffc015388000
    PC is at memset+0xc8/0x1c0
    LR is at kernel_map_pages+0x1ec/0x244

Fix this by calling kernel_map_pages to ensure the page is set in the
page table properly

Fixes: 3c605096d315 ("mm/page_alloc: restrict max order of merging on isolated pageblock")
Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Gioh Kim <gioh.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/page_isolation.c~mm-page_alloc-call-kernel_map_pages-in-unset_migrateype_isolate mm/page_isolation.c
--- a/mm/page_isolation.c~mm-page_alloc-call-kernel_map_pages-in-unset_migrateype_isolate
+++ a/mm/page_isolation.c
@@ -103,6 +103,7 @@ void unset_migratetype_isolate(struct pa
 
 			if (!is_migrate_isolate_page(buddy)) {
 				__isolate_free_page(page, order);
+				kernel_map_pages(page, (1 << order), 1);
 				set_page_refcounted(page);
 				isolated_page = page;
 			}
_

Patches currently in -mm which might be from lauraa@codeaurora.org are

origin.patch
mm-cma-debugfs-interface.patch
mm-cma-allocation-trigger.patch
mm-cma-release-trigger.patch
mm-cma-allocation-trigger-fix.patch
cma-debug-document-new-debugfs-interface.patch
seccomp-allow-compat-sigreturn-overrides.patch
arm-use-asm-generic-for-seccomph.patch
linux-next.patch

