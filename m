From: akpm@linux-foundation.org
Subject: [patch 02/11] mm: move mm_percpu_wq initialization earlier
Date: Fri, 31 Mar 2017 15:11:47 -0700
Message-ID: <58ded423.afZ6JNp4Hel6Q3ly%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41562 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933149AbdCaWLs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 31 Mar 2017 18:11:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, mgorman@suse.de, penguin-kernel@I-love.SAKURA.ne.jp, pku.leo@gmail.com, vbabka@suse.cz, xiaolong.ye@intel.com

From: Michal Hocko <mhocko@suse.com>
Subject: mm: move mm_percpu_wq initialization earlier

Yang Li has reported that drain_all_pages triggers a WARN_ON which means
that this function is called earlier than the mm_percpu_wq is initialized
on arm64 with CMA configured:

[    0.276449] WARNING: CPU: 2 PID: 1 at mm/page_alloc.c:2423 drain_all_pages+0x244/0x25c
[    0.276537] Modules linked in:
[    0.276594] CPU: 2 PID: 1 Comm: swapper/0 Not tainted 4.11.0-rc1-next-20170310-00027-g64dfbc5 #127
[    0.276693] Hardware name: Freescale Layerscape 2088A RDB Board (DT)
[    0.276764] task: ffffffc07c4a6d00 task.stack: ffffffc07c4a8000
[    0.276831] PC is at drain_all_pages+0x244/0x25c
[    0.276886] LR is at start_isolate_page_range+0x14c/0x1f0
[...]
[    0.279000] [<ffffff80081636bc>] drain_all_pages+0x244/0x25c
[    0.279065] [<ffffff80081c675c>] start_isolate_page_range+0x14c/0x1f0
[    0.279137] [<ffffff8008166a48>] alloc_contig_range+0xec/0x354
[    0.279203] [<ffffff80081c6c5c>] cma_alloc+0x100/0x1fc
[    0.279263] [<ffffff8008481714>] dma_alloc_from_contiguous+0x3c/0x44
[    0.279336] [<ffffff8008b25720>] atomic_pool_init+0x7c/0x208
[    0.279399] [<ffffff8008b258f0>] arm64_dma_init+0x44/0x4c
[    0.279461] [<ffffff8008083144>] do_one_initcall+0x38/0x128
[    0.279525] [<ffffff8008b20d30>] kernel_init_freeable+0x1a0/0x240
[    0.279596] [<ffffff8008807778>] kernel_init+0x10/0xfc
[    0.279654] [<ffffff8008082b70>] ret_from_fork+0x10/0x20

Fix this by moving the whole setup_vmstat which is an initcall right now
to init_mm_internals which will be called right after the WQ subsystem is
initialized.

Link: http://lkml.kernel.org/r/20170315164021.28532-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Yang Li <pku.leo@gmail.com>
Tested-by: Yang Li <pku.leo@gmail.com>
Tested-by: Xiaolong Ye <xiaolong.ye@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 ++
 init/main.c        |    2 ++
 mm/vmstat.c        |    4 +---
 3 files changed, 5 insertions(+), 3 deletions(-)

diff -puN include/linux/mm.h~mm-move-mm_percpu_wq-initialization-earlier include/linux/mm.h
--- a/include/linux/mm.h~mm-move-mm_percpu_wq-initialization-earlier
+++ a/include/linux/mm.h
@@ -32,6 +32,8 @@ struct user_struct;
 struct writeback_control;
 struct bdi_writeback;
 
+void init_mm_internals(void);
+
 #ifndef CONFIG_NEED_MULTIPLE_NODES	/* Don't use mapnrs, do it properly */
 extern unsigned long max_mapnr;
 
diff -puN init/main.c~mm-move-mm_percpu_wq-initialization-earlier init/main.c
--- a/init/main.c~mm-move-mm_percpu_wq-initialization-earlier
+++ a/init/main.c
@@ -1022,6 +1022,8 @@ static noinline void __init kernel_init_
 
 	workqueue_init();
 
+	init_mm_internals();
+
 	do_pre_smp_initcalls();
 	lockup_detector_init();
 
diff -puN mm/vmstat.c~mm-move-mm_percpu_wq-initialization-earlier mm/vmstat.c
--- a/mm/vmstat.c~mm-move-mm_percpu_wq-initialization-earlier
+++ a/mm/vmstat.c
@@ -1764,7 +1764,7 @@ static int vmstat_cpu_dead(unsigned int
 
 #endif
 
-static int __init setup_vmstat(void)
+void __init init_mm_internals(void)
 {
 #ifdef CONFIG_SMP
 	int ret;
@@ -1792,9 +1792,7 @@ static int __init setup_vmstat(void)
 	proc_create("vmstat", S_IRUGO, NULL, &proc_vmstat_file_operations);
 	proc_create("zoneinfo", S_IRUGO, NULL, &proc_zoneinfo_file_operations);
 #endif
-	return 0;
 }
-module_init(setup_vmstat)
 
 #if defined(CONFIG_DEBUG_FS) && defined(CONFIG_COMPACTION)
 
_
