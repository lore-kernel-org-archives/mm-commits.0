From: akpm@linux-foundation.org
Subject: + memcg-fix-swapcache-charge-from-kernel-thread-context.patch
 added to -mm tree
Date: Mon, 19 May 2014 13:22:39 -0700
Message-ID: <537a680f.dyhknEAZxPBflp+f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48627 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932478AbaESUWk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 May 2014 16:22:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hughd@google.com, hannes@cmpxchg.org, coolo@suse.com, branimir.maksimovic@gmail.com, mhocko@suse.cz

Subject: + memcg-fix-swapcache-charge-from-kernel-thread-context.patch added to -mm tree
To: mhocko@suse.cz,branimir.maksimovic@gmail.com,coolo@suse.com,hannes@cmpxchg.org,hughd@google.com
From: akpm@linux-foundation.org
Date: Mon, 19 May 2014 13:22:39 -0700


The patch titled
     Subject: memcg: fix swapcache charge from kernel thread context
has been added to the -mm tree.  Its filename is
     memcg-fix-swapcache-charge-from-kernel-thread-context.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-fix-swapcache-charge-from-kernel-thread-context.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-fix-swapcache-charge-from-kernel-thread-context.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: fix swapcache charge from kernel thread context

284f39afeaa4 (mm: memcg: push !mm handling out to page cache charge
function) explicitly checks for page cache charges without any mm context
(from kernel thread context[1]).

This seemed to be the only possible case where memory could be charged
without mm context so 03583f1a631c (memcg: remove unnecessary !mm check
from try_get_mem_cgroup_from_mm()) removed the mm check from
get_mem_cgroup_from_mm.  This however caused another NULL ptr dereference
during early boot when loopback kernel thread splices to tmpfs as reported
by Stephan Kulow:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000360
IP: [<ffffffff81196aab>] get_mem_cgroup_from_mm.isra.42+0x2b/0x60
PGD 5082067 PUD 83c3067 PMD 0
Oops: 0000 [#1] SMP
Modules linked in: btrfs dm_multipath dm_mod scsi_dh multipath raid10 raid456 async_raid6_recov async_memcpy async_pq raid6_pq async_xor xor async_tx raid1 raid0 md_mod parport_pc parport nls_utf8 isofs usb_storage iscsi_ibft iscsi_boot_sysfs arc4 ecb fan thermal nfs lockd fscache nls_iso8859_1 nls_cp437 sg st hid_generic usbhid af_packet sunrpc sr_mod cdrom ata_generic uhci_hcd virtio_net virtio_blk ehci_hcd usbcore ata_piix floppy processor button usb_common virtio_pci virtio_ring virtio edd squashfs loop
 ppa]
CPU: 0 PID: 97 Comm: loop1 Not tainted 3.15.0-rc5-5-default #1
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
task: ffff880039b7a390 ti: ffff880038efe000 task.ti: ffff880038efe000
RIP: 0010:[<ffffffff81196aab>]  [<ffffffff81196aab>] get_mem_cgroup_from_mm.isra.42+0x2b/0x60
RSP: 0018:ffff880038effa40  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffea00001e5140 RCX: 0000000000000020
RDX: ffff88003c365020 RSI: ffffea00001e5140 RDI: 0000000000000360
RBP: ffff880038effa78 R08: 0000000000000ab3 R09: ffff880039572248
R10: 0000000000002ace R11: 0000000000000000 R12: 0000000000000010
R13: 0000000000000000 R14: ffff880038c72448 R15: 00000000fffffffe
FS:  00007fb0042ed880(0000) GS:ffff88003c000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000360 CR3: 0000000005e2b000 CR4: 00000000000006f0
Stack:
 ffffffff8119bae0 0000000000000000 0000000000000000 ffffea00001e5140
 0000000000000001 00000000ffffffef ffffffff8119c04b 0000000000000000
 ffff880038c722f8 0000000000000ab3 ffffffff8115129b 00000000000001d7
Call Trace:
 [<ffffffff8119bae0>] __mem_cgroup_try_charge_swapin+0x40/0xe0
 [<ffffffff8119c04b>] mem_cgroup_charge_file+0x8b/0xd0
 [<ffffffff8115129b>] shmem_getpage_gfp+0x66b/0x7b0
 [<ffffffff811518cf>] shmem_file_splice_read+0x18f/0x430
 [<ffffffff811ceff2>] splice_direct_to_actor+0xa2/0x1c0
 [<ffffffffa00019ea>] do_lo_receive+0x5a/0x60 [loop]
 [<ffffffffa0002158>] loop_thread+0x298/0x720 [loop]
 [<ffffffff810778d6>] kthread+0xc6/0xe0
 [<ffffffff815c0dbc>] ret_from_fork+0x7c/0xb0
Code: 66 66 66 66 90 eb 24 66 0f 1f 84 00 00 00 00 00 f6 40 48 01 75 3a 48 8b 50 18 f6 c2 03 75 32 65 ff 02 ba 01 00 00 00 84 d2 75 25 <48> 8b 07 48 85 c0 74 10 48 8b 80 70 08 00 00 48 8b 40 60 48 85
RIP  [<ffffffff81196aab>] get_mem_cgroup_from_mm.isra.42+0x2b/0x60
 RSP <ffff880038effa40>
CR2: 0000000000000360

Also Branimir Maksimovic reported the following oops which is tiggered
for the swapcache charge path from the accounting code for kernel threads:

[  388.522494] CPU: 1 PID: 160 Comm: kworker/u8:5 Tainted: P           OE 3.15.0-rc5-core2-custom #159
[  388.522496] Hardware name: System manufacturer System Product Name/MAXIMUSV GENE, BIOS 1903 08/19/2013
[  388.522498] task: ffff880404e349b0 ti: ffff88040486a000 task.ti: ffff88040486a000
[  388.522500] RIP: 0010:[<ffffffff81185b0b>] [<ffffffff81185b0b>] get_mem_cgroup_from_mm.isra.42+0x2b/0x60
[  388.522504] RSP: 0000:ffff88040486bab8  EFLAGS: 00010246
[  388.522506] RAX: 0000000000000000 RBX: ffffea000a416340 RCX: 0000000000000a40
[  388.522508] RDX: ffff88041efe8a40 RSI: ffffea000a416340 RDI: 0000000000000340
[  388.522509] RBP: ffff88040486bab8 R08: 000000000001cb56 R09: 0000000000072d5a
[  388.522511] R10: 0000000000000000 R11: 0000000000000005 R12: ffff88040486bb00
[  388.522512] R13: 00000000000000d0 R14: 0000000000000000 R15: ffff8803f3fe82f8
[  388.522515] FS:  0000000000000000(0000) GS:ffff88041ec80000(0000) knlGS:0000000000000000
[  388.522517] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  388.522518] CR2: 0000000000000340 CR3: 00000003ee44d000 CR4: 00000000001407e0
[  388.522520] Stack:
[  388.522521]  ffff88040486baf0 ffffffff8118abf5 ffffffff8112ce1a 0000000000000000
[  388.522524]  ffffea000a416340 0000000000000003 00000000ffffffef ffff88040486bb18
[  388.522527]  ffffffff8118b1cc ffff88040486baf8 000000000001cb56 0000000000000000
[  388.522530] Call Trace:
[  388.522536]  [<ffffffff8118abf5>] __mem_cgroup_try_charge_swapin+0x45/0xf0
[  388.522539]  [<ffffffff8112ce1a>] ? __lock_page+0x6a/0x70
[  388.522543]  [<ffffffff8118b1cc>] mem_cgroup_charge_file+0x9c/0xe0
[  388.522548]  [<ffffffff8114599c>] shmem_getpage_gfp+0x62c/0x770
[  388.522552]  [<ffffffff81145b18>] shmem_write_begin+0x38/0x40
[  388.522555]  [<ffffffff8112d1c5>] generic_perform_write+0xc5/0x1c0
[  388.522559]  [<ffffffff811ad53a>] ? file_update_time+0x8a/0xd0
[  388.522563]  [<ffffffff8112f211>] __generic_file_aio_write+0x1d1/0x3f0
[  388.522567]  [<ffffffff81084fc1>] ? enqueue_entity+0x291/0xb90
[  388.522570]  [<ffffffff8112f47f>] generic_file_aio_write+0x4f/0xc0
[  388.522574]  [<ffffffff81192eaa>] do_sync_write+0x5a/0x90
[  388.522578]  [<ffffffff810c53c1>] do_acct_process+0x4b1/0x550
[  388.522582]  [<ffffffff810c5acd>] acct_process+0x6d/0xa0
[  388.522587]  [<ffffffff810667d0>] ? manage_workers.isra.25+0x2a0/0x2a0
[  388.522590]  [<ffffffff8104d937>] do_exit+0x827/0xa70
[  388.522594]  [<ffffffff8106699e>] ? worker_thread+0x1ce/0x3a0
[  388.522597]  [<ffffffff810667d0>] ? manage_workers.isra.25+0x2a0/0x2a0
[  388.522600]  [<ffffffff8106cad3>] kthread+0xc3/0xf0
[  388.522604]  [<ffffffff8106ca10>] ? kthread_create_on_node+0x180/0x180
[  388.522608]  [<ffffffff816bfe6c>] ret_from_fork+0x7c/0xb0
[  388.522611]  [<ffffffff8106ca10>] ? kthread_create_on_node+0x180/0x180

This patch fixes the issue by reintroducing mm check into
get_mem_cgroup_from_mm.  We could do the same trick in
__mem_cgroup_try_charge_swapin as we do for the regular page cache path
but it is not worth troubles.  The check is not that expensive and it is
better to have get_mem_cgroup_from_mm more robust.

[1] - http://marc.info/?l=linux-mm&m=139463617808941&w=2

Fixes: 03583f1a631c ("memcg: remove unnecessary !mm check from try_get_mem_cgroup_from_mm()")
Reported-and-tested-by: Stephan Kulow <coolo@suse.com>
Reported-by: Branimir Maksimovic <branimir.maksimovic@gmail.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-swapcache-charge-from-kernel-thread-context mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-swapcache-charge-from-kernel-thread-context
+++ a/mm/memcontrol.c
@@ -1077,9 +1077,18 @@ static struct mem_cgroup *get_mem_cgroup
 
 	rcu_read_lock();
 	do {
-		memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
-		if (unlikely(!memcg))
+		/*
+		 * Page cache insertions can happen withou an
+		 * actual mm context, e.g. during disk probing
+		 * on boot, loopback IO, acct() writes etc.
+		 */
+		if (unlikely(!mm))
 			memcg = root_mem_cgroup;
+		else {
+			memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
+			if (unlikely(!memcg))
+				memcg = root_mem_cgroup;
+		}
 	} while (!css_tryget(&memcg->css));
 	rcu_read_unlock();
 	return memcg;
@@ -3958,17 +3967,9 @@ int mem_cgroup_charge_file(struct page *
 		return 0;
 	}
 
-	/*
-	 * Page cache insertions can happen without an actual mm
-	 * context, e.g. during disk probing on boot.
-	 */
-	if (unlikely(!mm))
-		memcg = root_mem_cgroup;
-	else {
-		memcg = mem_cgroup_try_charge_mm(mm, gfp_mask, 1, true);
-		if (!memcg)
-			return -ENOMEM;
-	}
+	memcg = mem_cgroup_try_charge_mm(mm, gfp_mask, 1, true);
+	if (!memcg)
+		return -ENOMEM;
 	__mem_cgroup_commit_charge(memcg, page, 1, type, false);
 	return 0;
 }
_

Patches currently in -mm which might be from mhocko@suse.cz are

memcg-fix-swapcache-charge-from-kernel-thread-context.patch
slb-charge-slabs-to-kmemcg-explicitly.patch
mm-get-rid-of-__gfp_kmemcg.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch
mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control.patch
mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control-fix.patch
mm-disable-zone_reclaim_mode-by-default.patch
mm-page_alloc-do-not-cache-reclaim-distances.patch
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
documentation-memcg-warn-about-incomplete-kmemcg-state.patch
memcg-kill-config_mm_owner.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
memcg-slab-do-not-schedule-cache-destruction-when-last-page-goes-away.patch
memcg-slab-merge-memcg_bindrelease_pages-to-memcg_uncharge_slab.patch
memcg-slab-simplify-synchronization-scheme.patch
memcg-mm_update_next_owner-should-skip-kthreads.patch
memcg-optimize-the-search-everything-else-loop-in-mm_update_next_owner.patch
memcg-kill-start_kernel-mm_init_ownerinit_mm.patch
memcg-fold-mem_cgroup_stolen.patch
memcg-fold-mem_cgroup_stolen-fix.patch
memcg-correct-comments-for-__mem_cgroup_begin_update_page_stat.patch
memcg-get-rid-of-memcg_create_cache_name.patch
memcg-memcg_kmem_create_cache-make-memcg_name_buf.patch
swap-change-swap_info-singly-linked-list-to-list_head.patch
plist-add-helper-functions.patch
plist-add-plist_requeue.patch
swap-change-swap_list_head-to-plist-add-swap_avail_head.patch
memcg-cleanup-kmem-cache-creation-destruction-functions-naming.patch
jump_label-expose-the-reference-count.patch
mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets.patch
mm-page_alloc-only-check-the-zone-id-check-if-pages-are-buddies.patch
mm-page_alloc-only-check-the-alloc-flags-and-gfp_mask-for-dirty-once.patch
mm-page_alloc-take-the-alloc_no_watermark-check-out-of-the-fast-path.patch
mm-page_alloc-use-word-based-accesses-for-get-set-pageblock-bitmaps.patch
mm-page_alloc-reduce-number-of-times-page_to_pfn-is-called.patch
mm-page_alloc-lookup-pageblock-migratetype-with-irqs-enabled-during-free.patch
mm-page_alloc-use-unsigned-int-for-order-in-more-places.patch
mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool.patch
mm-shmem-avoid-atomic-operation-during-shmem_getpage_gfp.patch
mm-do-not-use-atomic-operations-when-releasing-pages.patch
mm-do-not-use-unnecessary-atomic-operations-when-adding-pages-to-the-lru.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible.patch
mm-page_alloc-calculate-classzone_idx-once-from-the-zonelist-ref.patch
mm-hugetlb-move-the-error-handle-logic-out-of-normal-code-path.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull-fix.patch
linux-next.patch
memcg-mm-introduce-lowlimit-reclaim.patch
memcg-mm-introduce-lowlimit-reclaim-fix.patch
memcg-allow-setting-low_limit.patch
memcg-doc-clarify-global-vs-limit-reclaims.patch
memcg-doc-clarify-global-vs-limit-reclaims-fix.patch
memcg-document-memorylow_limit_in_bytes.patch
vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-oom_control.patch
mm-memcontrol-clean-up-memcg-zoneinfo-lookup.patch
mm-memcontrol-remove-unnecessary-memcg-argument-from-soft-limit-functions.patch
memcg-deprecate-memoryforce_empty-knob.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch

