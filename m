From: akpm@linux-foundation.org
Subject: + memremap-add-scheduling-point-to-devm_memremap_pages.patch
 added to -mm tree
Date: Wed, 27 Sep 2017 15:32:39 -0700
Message-ID: <59cc2707.2BFKpoZkFGhWWSZa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53852 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751355AbdI0Wck (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Sep 2017 18:32:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, dan.j.williams@gmail.com, jthumshirn@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: memremap: add scheduling point to devm_memremap_pages
has been added to the -mm tree.  Its filename is
     memremap-add-scheduling-point-to-devm_memremap_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memremap-add-scheduling-point-to-devm_memremap_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memremap-add-scheduling-point-to-devm_memremap_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: memremap: add scheduling point to devm_memremap_pages

devm_memremap_pages is initializing struct pages in for_each_device_pfn
and that can take quite some time.  We have even seen a soft lockup
triggering on a non preemptive kernel

[  125.583233] NMI watchdog: BUG: soft lockup - CPU#61 stuck for 22s! [kworker/u641:11:1808]
[...]
[  125.583467] RIP: 0010:[<ffffffff8118b6b7>]  [<ffffffff8118b6b7>] devm_memremap_pages+0x327/0x430
[...]
[  125.583488] Call Trace:
[  125.583496]  [<ffffffffa016550d>] pmem_attach_disk+0x2fd/0x3f0 [nd_pmem]
[  125.583528]  [<ffffffffa14ae984>] nvdimm_bus_probe+0x64/0x110 [libnvdimm]
[  125.583536]  [<ffffffff8146b257>] driver_probe_device+0x1f7/0x420
[  125.583540]  [<ffffffff81469212>] bus_for_each_drv+0x52/0x80
[  125.583543]  [<ffffffff8146af40>] __device_attach+0xb0/0x130
[  125.583546]  [<ffffffff8146a367>] bus_probe_device+0x87/0xa0
[  125.583548]  [<ffffffff814682fc>] device_add+0x3fc/0x5f0
[  125.583553]  [<ffffffffa14adffe>] nd_async_device_register+0xe/0x40 [libnvdimm]
[  125.583556]  [<ffffffff8109e413>] async_run_entry_fn+0x43/0x150
[  125.583561]  [<ffffffff81095b8e>] process_one_work+0x14e/0x410
[  125.583563]  [<ffffffff810963f6>] worker_thread+0x116/0x490
[  125.583565]  [<ffffffff8109b8c7>] kthread+0xc7/0xe0
[  125.583569]  [<ffffffff8160a57f>] ret_from_fork+0x3f/0x70

fix this by adding cond_resched every 1024 pages.

Link: http://lkml.kernel.org/r/20170918121410.24466-4-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Johannes Thumshirn <jthumshirn@suse.de>
Tested-by: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Dan Williams <dan.j.williams@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/memremap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/memremap.c~memremap-add-scheduling-point-to-devm_memremap_pages kernel/memremap.c
--- a/kernel/memremap.c~memremap-add-scheduling-point-to-devm_memremap_pages
+++ a/kernel/memremap.c
@@ -350,7 +350,7 @@ void *devm_memremap_pages(struct device
 	pgprot_t pgprot = PAGE_KERNEL;
 	struct dev_pagemap *pgmap;
 	struct page_map *page_map;
-	int error, nid, is_ram;
+	int error, nid, is_ram, i = 0;
 
 	align_start = res->start & ~(SECTION_SIZE - 1);
 	align_size = ALIGN(res->start + resource_size(res), SECTION_SIZE)
@@ -448,6 +448,8 @@ void *devm_memremap_pages(struct device
 		list_del(&page->lru);
 		page->pgmap = pgmap;
 		percpu_ref_get(ref);
+		if (!(++i % 1024))
+			cond_resched();
 	}
 	devres_add(dev, page_map);
 	return __va(res->start);
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-oom_reaper-skip-mm-structs-with-mmu-notifiers.patch
mm-memcg-remove-hotplug-locking-from-try_charge.patch
mm-memory_hotplug-add-scheduling-point-to-__add_pages.patch
mm-page_alloc-add-scheduling-point-to-memmap_init_zone.patch
memremap-add-scheduling-point-to-devm_memremap_pages.patch
mm-memory_hotplug-do-not-back-off-draining-pcp-free-pages-from-kworker-context.patch

