From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-call-kernel_map_pages-in-unset_migrateype_isolate.patch added to -mm tree
Date: Wed, 18 Mar 2015 16:26:05 -0700
Message-ID: <550a098d.gDWlNGMwomPf6f1P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39866 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586AbbCRX0G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Mar 2015 19:26:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lauraa@codeaurora.org, gioh.kim@lge.com, iamjoonsoo.kim@lge.com, isimatu.yasuaki@jp.fujitsu.com, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, n-horiguchi@ah.jp.nec.com, qiuxishi@huawei.com, riel@redhat.com, stable@vger.kernel.org, vbabka@suse.cz, vdavydov@parallels.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: call kernel_map_pages in unset_migrateype_isolate
has been added to the -mm tree.  Its filename is
     mm-page_alloc-call-kernel_map_pages-in-unset_migrateype_isolate.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-call-kernel_map_pages-in-unset_migrateype_isolate.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-call-kernel_map_pages-in-unset_migrateype_isolate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-page_alloc-call-kernel_map_pages-in-unset_migrateype_isolate.patch
mm-cma-debugfs-interface.patch
mm-cma-allocation-trigger.patch
mm-cma-release-trigger.patch
mm-cma-allocation-trigger-fix.patch
cma-debug-document-new-debugfs-interface.patch
mm-dont-offset-memmap-for-flatmem.patch
seccomp-allow-compat-sigreturn-overrides.patch
arm-use-asm-generic-for-seccomph.patch

