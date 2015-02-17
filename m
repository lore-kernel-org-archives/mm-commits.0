From: akpm@linux-foundation.org
Subject: + mm-nommu-fix-memory-leak.patch added to -mm tree
Date: Tue, 17 Feb 2015 14:12:19 -0800
Message-ID: <54e3bcc3.vs3wOxjr9fQUVm2q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36834 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbbBQWMV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Feb 2015 17:12:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, iamjoonsoo.kim@lge.com, mcoquelin.stm32@gmail.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/nommu: fix memory leak
has been added to the -mm tree.  Its filename is
     mm-nommu-fix-memory-leak.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-nommu-fix-memory-leak.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-nommu-fix-memory-leak.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm/nommu: fix memory leak

Maxime reported the following memory leak regression due to commit
dbc8358c7237 ("mm/nommu: use alloc_pages_exact() rather than its own
implementation").

On v3.19, I am facing a memory leak.  Each time I run a command one page
is lost.  Here an example with busybox's free command:

/ # free
             total       used       free     shared    buffers     cached
Mem:          7928       1972       5956          0          0        492
-/+ buffers/cache:       1480       6448
/ # free
             total       used       free     shared    buffers     cached
Mem:          7928       1976       5952          0          0        492
-/+ buffers/cache:       1484       6444
/ # free
             total       used       free     shared    buffers     cached
Mem:          7928       1980       5948          0          0        492
-/+ buffers/cache:       1488       6440
/ # free
             total       used       free     shared    buffers     cached
Mem:          7928       1984       5944          0          0        492
-/+ buffers/cache:       1492       6436
/ # free
             total       used       free     shared    buffers     cached
Mem:          7928       1988       5940          0          0        492
-/+ buffers/cache:       1496       6432

At some point, the system fails to sastisfy 256KB allocations:

[   38.720000] free: page allocation failure: order:6, mode:0xd0
[   38.730000] CPU: 0 PID: 67 Comm: free Not tainted
3.19.0-05389-gacf2cf1-dirty #64
[   38.740000] Hardware name: STM32 (Device Tree Support)
[   38.740000] [<08022e25>] (unwind_backtrace) from [<080221e7>]
(show_stack+0xb/0xc)
[   38.750000] [<080221e7>] (show_stack) from [<0804fd3b>]
(warn_alloc_failed+0x97/0xbc)
[   38.760000] [<0804fd3b>] (warn_alloc_failed) from [<08051171>]
(__alloc_pages_nodemask+0x295/0x35c)
[   38.770000] [<08051171>] (__alloc_pages_nodemask) from [<08051243>]
(__get_free_pages+0xb/0x24)
[   38.780000] [<08051243>] (__get_free_pages) from [<0805127f>]
(alloc_pages_exact+0x19/0x24)
[   38.790000] [<0805127f>] (alloc_pages_exact) from [<0805bdbf>]
(do_mmap_pgoff+0x423/0x658)
[   38.800000] [<0805bdbf>] (do_mmap_pgoff) from [<08056e73>]
(vm_mmap_pgoff+0x3f/0x4e)
[   38.810000] [<08056e73>] (vm_mmap_pgoff) from [<08080949>]
(load_flat_file+0x20d/0x4f8)
[   38.820000] [<08080949>] (load_flat_file) from [<08080dfb>]
(load_flat_binary+0x3f/0x26c)
[   38.830000] [<08080dfb>] (load_flat_binary) from [<08063741>]
(search_binary_handler+0x51/0xe4)
[   38.840000] [<08063741>] (search_binary_handler) from [<08063a45>]
(do_execveat_common+0x271/0x35c)
[   38.850000] [<08063a45>] (do_execveat_common) from [<08063b49>]
(do_execve+0x19/0x1c)
[   38.860000] [<08063b49>] (do_execve) from [<08020a01>]
(ret_fast_syscall+0x1/0x4a)
[   38.870000] Mem-info:
[   38.870000] Normal per-cpu:
[   38.870000] CPU    0: hi:    0, btch:   1 usd:   0
[   38.880000] active_anon:0 inactive_anon:0 isolated_anon:0
[   38.880000]  active_file:0 inactive_file:0 isolated_file:0
[   38.880000]  unevictable:123 dirty:0 writeback:0 unstable:0
[   38.880000]  free:1515 slab_reclaimable:17 slab_unreclaimable:139
[   38.880000]  mapped:0 shmem:0 pagetables:0 bounce:0
[   38.880000]  free_cma:0
[   38.910000] Normal free:6060kB min:352kB low:440kB high:528kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:492kB isolated(anon):0ks
[   38.950000] lowmem_reserve[]: 0 0
[   38.950000] Normal: 23*4kB (U) 22*8kB (U) 24*16kB (U) 23*32kB (U)
23*64kB (U) 23*128kB (U) 1*256kB (U) 0*512kB 0*1024kB 0*2048kB
0*4096kB = 6060kB
[   38.970000] 123 total pagecache pages
[   38.970000] 2048 pages of RAM
[   38.980000] 1538 free pages
[   38.980000] 66 reserved pages
[   38.990000] 109 slab pages
[   38.990000] -46 pages shared
[   38.990000] 0 pages swap cached
[   38.990000] nommu: Allocation of length 221184 from process 67 (free) failed
[   39.000000] Normal per-cpu:
[   39.010000] CPU    0: hi:    0, btch:   1 usd:   0
[   39.010000] active_anon:0 inactive_anon:0 isolated_anon:0
[   39.010000]  active_file:0 inactive_file:0 isolated_file:0
[   39.010000]  unevictable:123 dirty:0 writeback:0 unstable:0
[   39.010000]  free:1515 slab_reclaimable:17 slab_unreclaimable:139
[   39.010000]  mapped:0 shmem:0 pagetables:0 bounce:0
[   39.010000]  free_cma:0
[   39.050000] Normal free:6060kB min:352kB low:440kB high:528kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:492kB isolated(anon):0ks
[   39.090000] lowmem_reserve[]: 0 0
[   39.090000] Normal: 23*4kB (U) 22*8kB (U) 24*16kB (U) 23*32kB (U)
23*64kB (U) 23*128kB (U) 1*256kB (U) 0*512kB 0*1024kB 0*2048kB
0*4096kB = 6060kB
[   39.100000] 123 total pagecache pages
[   39.110000] Unable to allocate RAM for process text/data, errno 12
SEGV

This problem happens because we allocate ordered page through
__get_free_pages() in do_mmap_private() in some cases and we try to free
individual pages rather than ordered page in free_page_series().  In this
case, freeing pages whose refcount is not 0 won't be freed to the page
allocator so memory leak happens.

To fix the problem, this patch changes __get_free_pages() to
alloc_pages_exact() since alloc_pages_exact() returns
physically-contiguous pages but each pages are refcounted.

Fixes: dbc8358c7237 ("mm/nommu: use alloc_pages_exact() rather than its own implementation").
Reported-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Tested-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <stable@vger.kernel.org>	[3.19]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/nommu.c~mm-nommu-fix-memory-leak mm/nommu.c
--- a/mm/nommu.c~mm-nommu-fix-memory-leak
+++ a/mm/nommu.c
@@ -1213,11 +1213,9 @@ static int do_mmap_private(struct vm_are
 	if (sysctl_nr_trim_pages && total - point >= sysctl_nr_trim_pages) {
 		total = point;
 		kdebug("try to alloc exact %lu pages", total);
-		base = alloc_pages_exact(len, GFP_KERNEL);
-	} else {
-		base = (void *)__get_free_pages(GFP_KERNEL, order);
 	}
 
+	base = alloc_pages_exact(total << PAGE_SHIFT, GFP_KERNEL);
 	if (!base)
 		goto enomem;
 
_

Patches currently in -mm which might be from js1304@gmail.com are

mm-memcontrol-fix-null-pointer-dereference-when-use_hierarchy-is-0.patch
mm-nommu-fix-memory-leak.patch
zram-use-proper-type-to-update-max_used_pages.patch

