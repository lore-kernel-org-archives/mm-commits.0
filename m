From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory_hotplug-add-scheduling-point-to-__add_pages.patch removed from
 -mm tree
Date: Wed, 04 Oct 2017 12:41:46 -0700
Message-ID: <20171004194146.H-C1UNRL0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33692 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbdJDTlr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 15:41:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@gmail.com, jthumshirn@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memory_hotplug: add scheduling point to __add_pages
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-add-scheduling-point-to-__add_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, memory_hotplug: add scheduling point to __add_pages

Patch series "mm, memory_hotplug: fix few soft lockups in memory hotadd".

Johannes has noticed few soft lockups when adding a large nvdimm device. 
All of them were caused by a long loop without any explicit cond_resched
which is a problem for !PREEMPT kernels.  The fix is quite
straightforward.  Just make sure that cond_resched gets called from time
to time.


This patch (of 3):

__add_pages gets a pfn range to add and there is no upper bound for a
single call.  This is usually a memory block aligned size for the regular
memory hotplug - smaller sizes are usual for memory balloning drivers, or
the whole NUMA node for physical memory online.  There is no explicit
scheduling point in that code path though.

This can lead to long latencies while __add_pages is executed and we have
even seen a soft lockup report during nvdimm initialization with !PREEMPT
kernel

[   33.588806] NMI watchdog: BUG: soft lockup - CPU#11 stuck for 23s! [kworker/u641:3:832]
[...]
[   33.588875] Workqueue: events_unbound async_run_entry_fn
[   33.588876] task: ffff881809270f40 ti: ffff881809274000 task.ti: ffff881809274000
[   33.588878] RIP: 0010:[<ffffffff81608c01>]  [<ffffffff81608c01>] _raw_spin_unlock_irqrestore+0x11/0x20
[   33.588883] RSP: 0018:ffff881809277b10  EFLAGS: 00000286
[...]
[   33.588900] Call Trace:
[   33.588906]  [<ffffffff81603a45>] sparse_add_one_section+0x13d/0x18e
[   33.588909]  [<ffffffff815fde8a>] __add_pages+0x10a/0x1d0
[   33.588916]  [<ffffffff810634ca>] arch_add_memory+0x4a/0xc0
[   33.588920]  [<ffffffff8118b22d>] devm_memremap_pages+0x29d/0x430
[   33.588931]  [<ffffffffa042e50d>] pmem_attach_disk+0x2fd/0x3f0 [nd_pmem]
[   33.589001]  [<ffffffffa14ad984>] nvdimm_bus_probe+0x64/0x110 [libnvdimm]
[   33.589008]  [<ffffffff8146a337>] driver_probe_device+0x1f7/0x420
[   33.589012]  [<ffffffff814682f2>] bus_for_each_drv+0x52/0x80
[   33.589014]  [<ffffffff8146a020>] __device_attach+0xb0/0x130
[   33.589017]  [<ffffffff81469447>] bus_probe_device+0x87/0xa0
[   33.589020]  [<ffffffff8146741c>] device_add+0x3fc/0x5f0
[   33.589029]  [<ffffffffa14acffe>] nd_async_device_register+0xe/0x40 [libnvdimm]
[   33.589047]  [<ffffffff8109e1c3>] async_run_entry_fn+0x43/0x150
[   33.589073]  [<ffffffff8109594e>] process_one_work+0x14e/0x410
[   33.589086]  [<ffffffff810961a6>] worker_thread+0x116/0x490
[   33.589089]  [<ffffffff8109b677>] kthread+0xc7/0xe0
[   33.589119]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[   33.590756] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70

Fix this by adding cond_resched once per each memory section in the
given pfn range. Each section is constant amount of work which itself is
not too expensive but many of them will just add up.

Link: http://lkml.kernel.org/r/20170918121410.24466-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Johannes Thumshirn <jthumshirn@suse.de>
Tested-by: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Dan Williams <dan.j.williams@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/memory_hotplug.c~mm-memory_hotplug-add-scheduling-point-to-__add_pages mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-add-scheduling-point-to-__add_pages
+++ a/mm/memory_hotplug.c
@@ -328,6 +328,7 @@ int __ref __add_pages(int nid, unsigned
 		if (err && (err != -EEXIST))
 			break;
 		err = 0;
+		cond_resched();
 	}
 	vmemmap_populate_print_last();
 out:
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-memory_hotplug-do-not-back-off-draining-pcp-free-pages-from-kworker-context.patch
mm-memory_hotplug-do-not-fail-offlining-too-early.patch
mm-memory_hotplug-remove-timeout-from-__offline_memory.patch
mm-hugetlb-drop-hugepages_treat_as_movable-sysctl.patch

