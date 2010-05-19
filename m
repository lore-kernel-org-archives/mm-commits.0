From: akpm@linux-foundation.org
Subject: + mem-hotplug-avoid-multiple-zones-sharing-same-boot-strapping-boot_pageset.patch added to -mm tree
Date: Wed, 19 May 2010 14:51:01 -0700
Message-ID: <201005192151.o4JLp1Za008144@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751731Ab0ESVva (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 17:51:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haicheng.li@linux.intel.com, andi.kleen@intel.com, cl@linux-foundation.org, fengguang.wu@intel.com, mel@csn.ul.ie, tj@kernel.org


The patch titled
     mem-hotplug: avoid multiple zones sharing same boot strapping boot_pageset
has been added to the -mm tree.  Its filename is
     mem-hotplug-avoid-multiple-zones-sharing-same-boot-strapping-boot_pageset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mem-hotplug: avoid multiple zones sharing same boot strapping boot_pageset
From: Haicheng Li <haicheng.li@linux.intel.com>

For each new populated zone of hotadded node, need to update its pagesets
with dynamically allocated per_cpu_pageset struct for all possible CPUs:

    1) Detach zone->pageset from the shared boot_pageset
       at end of __build_all_zonelists().

    2) Use mutex to protect zone->pageset when it's still
       shared in onlined_pages()

Otherwises, multiple zones of different nodes would share same boot strapping
boot_pageset for same CPU, which will finally cause below kernel panic:

[   47.326005] ------------[ cut here ]------------
[   47.328431] kernel BUG at mm/page_alloc.c:1239!
[   47.333208] invalid opcode: 0000 [#1] SMP
[   47.333208] last sysfs file: /sys/devices/system/cpu/probe
[   47.333208] CPU 0
[   47.333208] Modules linked in: snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_seq snd_timer
snd_seq_device snd soundcore snd_page_alloc drm
[   47.333208] Pid: 2379, comm: cp Not tainted 2.6.32 #4 Bochs
[   47.333208] RIP: 0010:[<ffffffff8112ff13>]  [<ffffffff8112ff13>] get_page_from_freelist+0x883/0x900
[   47.333208] RSP: 0018:ffff88000d1e78a8  EFLAGS: 00010202
[   47.333208] RAX: 0000000000000001 RBX: 0000000000000001 RCX: 0000000000000004
[   47.333208] RDX: 000000000001037d RSI: ffffea0000696ac8 RDI: ffff88000d9e8e80
[   47.333208] RBP: ffff88000d1e79c8 R08: 0000000000030000 R09: 0000000000000001
[   47.333208] R10: 0000000000000000 R11: 0000000000000001 R12: ffffffff82610700
[   47.333208] R13: ffffea0000696ac8 R14: ffff88000d9e8e80 R15: 00000000000000fd
[   47.333208] FS:  00007f9fb1279790(0000) GS:ffff880003400000(0000) knlGS:0000000000000000
[   47.333208] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   47.333208] CR2: 00007f9fb128940a CR3: 000000000d98a000 CR4: 00000000000006f0
[   47.333208] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   47.333208] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   47.333208] Process cp (pid: 2379, threadinfo ffff88000d1e6000, task ffff88000d3e0000)
[   47.333208] Stack:
[   47.333208]  0000000000000000 ffffea0000697068 ffffea0000697010 ffff88000d3e1288
[   47.333208] <0> 0000000100000001 ffffffff82610700 0000000000000009 00000040ffffffff
[   47.333208] <0> ffff88000d3e1288 ffff880000009d08 ffff88000d9e8f10 000000038105fe6f
[   47.333208] Call Trace:
[   47.333208]  [<ffffffff811300c1>] __alloc_pages_nodemask+0x131/0x7b0
[   47.333208]  [<ffffffff8113257d>] ? __do_page_cache_readahead+0xad/0x260
[   47.333208]  [<ffffffff8105f171>] ? kvm_clock_read+0x21/0x30
[   47.333208]  [<ffffffff81043189>] ? sched_clock+0x9/0x10
[   47.333208]  [<ffffffff810b3135>] ? sched_clock_local+0x25/0x90
[   47.333208]  [<ffffffff810b3258>] ? sched_clock_cpu+0xb8/0x110
[   47.333208]  [<ffffffff81162e67>] alloc_pages_current+0x87/0xd0
[   47.333208]  [<ffffffff81128407>] __page_cache_alloc+0x67/0x70
[   47.333208]  [<ffffffff811325f0>] __do_page_cache_readahead+0x120/0x260
[   47.333208]  [<ffffffff8113257d>] ? __do_page_cache_readahead+0xad/0x260
[   47.333208]  [<ffffffff81127f04>] ? find_get_page+0xb4/0x120
[   47.333208]  [<ffffffff81132751>] ra_submit+0x21/0x30
[   47.333208]  [<ffffffff811329c6>] ondemand_readahead+0x166/0x2c0
[   47.333208]  [<ffffffff810bf59d>] ? lock_release_holdtime+0x3d/0x170
[   47.333208]  [<ffffffff81132ba0>] page_cache_async_readahead+0x80/0xa0
[   47.333208]  [<ffffffff81127e50>] ? find_get_page+0x0/0x120
[   47.333208]  [<ffffffff8112a0e4>] generic_file_aio_read+0x364/0x670
[   47.333208]  [<ffffffff81266cfa>] nfs_file_read+0xca/0x130
[   47.333208]  [<ffffffff813bd12b>] ? __up_read+0x8b/0xb0
[   47.333208]  [<ffffffff8117b20a>] do_sync_read+0xfa/0x140
[   47.333208]  [<ffffffff8103cad0>] ? restore_args+0x0/0x30
[   47.333208]  [<ffffffff810acc60>] ? autoremove_wake_function+0x0/0x40
[   47.333208]  [<ffffffff816bcece>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   47.333208]  [<ffffffff8117bf75>] vfs_read+0xb5/0x1a0
[   47.333208]  [<ffffffff8117c151>] sys_read+0x51/0x80
[   47.333208]  [<ffffffff8103c032>] system_call_fastpath+0x16/0x1b
[   47.333208] Code: 49 89 c5 8b 95 18 ff ff ff 4c 89 f7 e8 27 1d 01 00 48 8b bd 30 ff ff ff e8 1b
d5 58 00 4d 85 ed 0f 85 25 fa ff ff e9 31 fe ff ff <0f> 0b eb fe 83 7d ac 01 7e ab 83 3d b8 05 4e 01
00 75 a2 be c8
[   47.333208] RIP  [<ffffffff8112ff13>] get_page_from_freelist+0x883/0x900
[   47.333208]  RSP <ffff88000d1e78a8>
[   47.468914] ---[ end trace 4bda28328b9990db ]

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Andi Kleen <andi.kleen@intel.com>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 init/main.c            |    2 +-
 mm/memory_hotplug.c    |   18 +++++++++++++-----
 mm/page_alloc.c        |   17 +++++++++++++----
 4 files changed, 28 insertions(+), 11 deletions(-)

diff -puN include/linux/mmzone.h~mem-hotplug-avoid-multiple-zones-sharing-same-boot-strapping-boot_pageset include/linux/mmzone.h
--- a/include/linux/mmzone.h~mem-hotplug-avoid-multiple-zones-sharing-same-boot-strapping-boot_pageset
+++ a/include/linux/mmzone.h
@@ -652,7 +652,7 @@ typedef struct pglist_data {
 
 void get_zone_counts(unsigned long *active, unsigned long *inactive,
 			unsigned long *free);
-void build_all_zonelists(void);
+void build_all_zonelists(void *data);
 void wakeup_kswapd(struct zone *zone, int order);
 int zone_watermark_ok(struct zone *z, int order, unsigned long mark,
 		int classzone_idx, int alloc_flags);
diff -puN init/main.c~mem-hotplug-avoid-multiple-zones-sharing-same-boot-strapping-boot_pageset init/main.c
--- a/init/main.c~mem-hotplug-avoid-multiple-zones-sharing-same-boot-strapping-boot_pageset
+++ a/init/main.c
@@ -567,7 +567,7 @@ asmlinkage void __init start_kernel(void
 	setup_per_cpu_areas();
 	smp_prepare_boot_cpu();	/* arch-specific boot-cpu hooks */
 
-	build_all_zonelists();
+	build_all_zonelists(NULL);
 	page_alloc_init();
 
 	printk(KERN_NOTICE "Kernel command line: %s\n", boot_command_line);
diff -puN mm/memory_hotplug.c~mem-hotplug-avoid-multiple-zones-sharing-same-boot-strapping-boot_pageset mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mem-hotplug-avoid-multiple-zones-sharing-same-boot-strapping-boot_pageset
+++ a/mm/memory_hotplug.c
@@ -389,6 +389,11 @@ int online_pages(unsigned long pfn, unsi
 	int nid;
 	int ret;
 	struct memory_notify arg;
+	/*
+	 * mutex to protect zone->pageset when it's still shared
+	 * in onlined_pages()
+	 */
+	static DEFINE_MUTEX(zone_pageset_mutex);
 
 	arg.start_pfn = pfn;
 	arg.nr_pages = nr_pages;
@@ -415,12 +420,14 @@ int online_pages(unsigned long pfn, unsi
 	 * This means the page allocator ignores this zone.
 	 * So, zonelist must be updated after online.
 	 */
+	mutex_lock(&zone_pageset_mutex);
 	if (!populated_zone(zone))
 		need_zonelists_rebuild = 1;
 
 	ret = walk_system_ram_range(pfn, nr_pages, &onlined_pages,
 		online_pages_range);
 	if (ret) {
+		mutex_unlock(&zone_pageset_mutex);
 		printk(KERN_DEBUG "online_pages %lx at %lx failed\n",
 			nr_pages, pfn);
 		memory_notify(MEM_CANCEL_ONLINE, &arg);
@@ -429,8 +436,12 @@ int online_pages(unsigned long pfn, unsi
 
 	zone->present_pages += onlined_pages;
 	zone->zone_pgdat->node_present_pages += onlined_pages;
+	if (need_zonelists_rebuild)
+		build_all_zonelists(zone);
+	else
+		zone_pcp_update(zone);
 
-	zone_pcp_update(zone);
+	mutex_unlock(&zone_pageset_mutex);
 	setup_per_zone_wmarks();
 	calculate_zone_inactive_ratio(zone);
 	if (onlined_pages) {
@@ -438,10 +449,7 @@ int online_pages(unsigned long pfn, unsi
 		node_set_state(zone_to_nid(zone), N_HIGH_MEMORY);
 	}
 
-	if (need_zonelists_rebuild)
-		build_all_zonelists();
-	else
-		vm_total_pages = nr_free_pagecache_pages();
+	vm_total_pages = nr_free_pagecache_pages();
 
 	writeback_set_ratelimit();
 
diff -puN mm/page_alloc.c~mem-hotplug-avoid-multiple-zones-sharing-same-boot-strapping-boot_pageset mm/page_alloc.c
--- a/mm/page_alloc.c~mem-hotplug-avoid-multiple-zones-sharing-same-boot-strapping-boot_pageset
+++ a/mm/page_alloc.c
@@ -2572,7 +2572,7 @@ int numa_zonelist_order_handler(ctl_tabl
 				NUMA_ZONELIST_ORDER_LEN);
 			user_zonelist_order = oldval;
 		} else if (oldval != user_zonelist_order)
-			build_all_zonelists();
+			build_all_zonelists(NULL);
 	}
 out:
 	mutex_unlock(&zl_order_mutex);
@@ -2922,9 +2922,10 @@ static void build_zonelist_cache(pg_data
  */
 static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch);
 static DEFINE_PER_CPU(struct per_cpu_pageset, boot_pageset);
+static void setup_zone_pageset(struct zone *zone);
 
 /* return values int ....just for stop_machine() */
-static int __build_all_zonelists(void *dummy)
+static __init_refok int __build_all_zonelists(void *data)
 {
 	int nid;
 	int cpu;
@@ -2939,6 +2940,14 @@ static int __build_all_zonelists(void *d
 		build_zonelist_cache(pgdat);
 	}
 
+#ifdef CONFIG_MEMORY_HOTPLUG
+	/* Setup real pagesets for the new zone */
+	if (data) {
+		struct zone *zone = data;
+		setup_zone_pageset(zone);
+	}
+#endif
+
 	/*
 	 * Initialize the boot_pagesets that are going to be used
 	 * for bootstrapping processors. The real pagesets for
@@ -2958,7 +2967,7 @@ static int __build_all_zonelists(void *d
 	return 0;
 }
 
-void build_all_zonelists(void)
+void build_all_zonelists(void *data)
 {
 	set_zonelist_order();
 
@@ -2969,7 +2978,7 @@ void build_all_zonelists(void)
 	} else {
 		/* we have to stop all cpus to guarantee there is no user
 		   of zonelist */
-		stop_machine(__build_all_zonelists, NULL, NULL);
+		stop_machine(__build_all_zonelists, data, NULL);
 		/* cpuset refresh routine should be here */
 	}
 	vm_total_pages = nr_free_pagecache_pages();
_

Patches currently in -mm which might be from haicheng.li@linux.intel.com are

mem-hotplug-separate-setup_per_cpu_pageset-into-separate-functions.patch
mem-hotplug-avoid-multiple-zones-sharing-same-boot-strapping-boot_pageset.patch
mem-hotplug-fix-potential-race-while-building-zonelist-for-new-populated-zone.patch

