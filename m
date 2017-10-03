From: akpm@linux-foundation.org
Subject: [patch 40/51] mm, page_alloc: add scheduling point to
 memmap_init_zone
Date: Tue, 03 Oct 2017 16:16:19 -0700
Message-ID: <59d41a43.o6GgJRBIvdTpXoEJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58822 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXQV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 19:16:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, dan.j.williams@gmail.com, jthumshirn@suse.de

From: Michal Hocko <mhocko@suse.com>
Subject: mm, page_alloc: add scheduling point to memmap_init_zone

memmap_init_zone gets a pfn range to initialize and it can be really large
resulting in a soft lockup on non-preemptible kernels

[   65.585596] NMI watchdog: BUG: soft lockup - CPU#31 stuck for 23s! [kworker/u642:5:1720]
[...]
[   65.585818] task: ffff88ecd7e902c0 ti: ffff88eca4e50000 task.ti: ffff88eca4e50000
[   65.585819] RIP: 0010:[<ffffffff815ff545>]  [<ffffffff815ff545>] move_pfn_range_to_zone+0x185/0x1d0
[...]
[   65.585843] Call Trace:
[   65.585853]  [<ffffffff8118b657>] devm_memremap_pages+0x2c7/0x430
[   65.585862]  [<ffffffffa02d650d>] pmem_attach_disk+0x2fd/0x3f0 [nd_pmem]
[   65.585893]  [<ffffffffa14bb984>] nvdimm_bus_probe+0x64/0x110 [libnvdimm]
[   65.585904]  [<ffffffff8146b257>] driver_probe_device+0x1f7/0x420
[   65.585910]  [<ffffffff81469212>] bus_for_each_drv+0x52/0x80
[   65.585913]  [<ffffffff8146af40>] __device_attach+0xb0/0x130
[   65.585916]  [<ffffffff8146a367>] bus_probe_device+0x87/0xa0
[   65.585919]  [<ffffffff814682fc>] device_add+0x3fc/0x5f0
[   65.585924]  [<ffffffffa14baffe>] nd_async_device_register+0xe/0x40 [libnvdimm]
[   65.585927]  [<ffffffff8109e413>] async_run_entry_fn+0x43/0x150
[   65.585933]  [<ffffffff81095b8e>] process_one_work+0x14e/0x410
[   65.585937]  [<ffffffff810963f6>] worker_thread+0x116/0x490
[   65.585939]  [<ffffffff8109b8c7>] kthread+0xc7/0xe0
[   65.585943]  [<ffffffff8160a57f>] ret_from_fork+0x3f/0x70

Fix this by adding a scheduling point once per page block.

Link: http://lkml.kernel.org/r/20170918121410.24466-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Johannes Thumshirn <jthumshirn@suse.de>
Tested-by: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Dan Williams <dan.j.williams@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/page_alloc.c~mm-page_alloc-add-scheduling-point-to-memmap_init_zone mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-add-scheduling-point-to-memmap_init_zone
+++ a/mm/page_alloc.c
@@ -5367,6 +5367,7 @@ not_early:
 
 			__init_single_page(page, pfn, zone, nid);
 			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
+			cond_resched();
 		} else {
 			__init_single_pfn(pfn, zone, nid);
 		}
_
