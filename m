From: akpm@linux-foundation.org
Subject: [merged]
 mm-slab-fix-unalignment-problem-on-malta-with-eva-due-to-slab-merge.patch
 removed from -mm tree
Date: Mon, 17 Nov 2014 12:50:47 -0800
Message-ID: <546a5fa7.4ACNBFKGSm1LE/8D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51009 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbaKQUus (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Nov 2014 15:50:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, Markos.Chandras@imgtec.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: fix unalignment problem on Malta with EVA due to slab merge
has been removed from the -mm tree.  Its filename was
     mm-slab-fix-unalignment-problem-on-malta-with-eva-due-to-slab-merge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: fix unalignment problem on Malta with EVA due to slab merge

Unlike the SLUB, sometimes, object isn't started at the beginning of the
slab in the SLAB.  This causes the unalignment problem after slab merging
is supported by commit 12220dea07f1 ("mm/slab: support slab merge"). 
Following is the report from Markos that fail to boot on Malta with EVA.

Calibrating delay loop... 19.86 BogoMIPS (lpj=99328)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 4096 (order: 0, 16384 bytes)
Mountpoint-cache hash table entries: 4096 (order: 0, 16384 bytes)
Kernel bug detected[#1]:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.17.0-05639-g12220dea07f1 #1631
task: 1f04f5d8 ti: 1f050000 task.ti: 1f050000
$ 0   : 00000000 806c0000 00000080 00000000
$ 4   : 1f048080 00000001 00000001 00000000
$ 8   : 1f04f5d8 00000001 fffffffc 00000000
$12   : 00000000 ffffffff fffef7b7 00000000
$16   : 1f048080 1f00ec00 1f048180 806ba998
$20   : 1f00ec00 80660000 1f03b780 806ad380
$24   : 00000000 80154d70
$28   : 1f050000 1f053d48 806ba8ec 80141184
Hi    : 00000000
Lo    : 0b532b80
epc   : 80141190 alloc_unbound_pwq+0x234/0x304
    Not tainted
ra    : 80141184 alloc_unbound_pwq+0x228/0x304
Status: 1000dc03        KERNEL EXL IE
Cause : 00800034
PrId  : 0001a82d (MIPS P5600)
Modules linked in:
Process swapper/0 (pid: 1, threadinfo=1f050000, task=1f04f5d8, tls=00000000)
Stack : 1f03b880 00000002 1f03b800 80140d90 1f048180 1f03b880 00000002
1f03b800
          1f03bb80 801417a4 1f0481e0 0000000e 1f048180 00000200 1f048180
1f048190
          00000002 1f048188 80660000 80660000 8065af94 80141dc0 0110d710
00000100
          8065af94 806ad380 8065b200 8013ea70 1f048280 1f053e0c 8065af98
1f0481e0
          00000000 00000004 80660000 80660000 80660000 80660000 80660000
80660000
          ...
Call Trace:
[<80141190>] alloc_unbound_pwq+0x234/0x304
[<801417a4>] apply_workqueue_attrs+0x11c/0x294
[<80141dc0>] __alloc_workqueue_key+0x23c/0x470
[<80683de4>] init_workqueues+0x320/0x400
[<8010058c>] do_one_initcall+0xe8/0x23c
[<8067cbec>] kernel_init_freeable+0x9c/0x224
[<80565fd8>] kernel_init+0x10/0x100
[<80104e38>] ret_from_kernel_thread+0x14/0x1c

Code: 10400032  00408021  320200ff <00020336> 00002821  02002021
0c0defb0  24060100  26020074
[ end trace cb88537fdc8fa200 ]
Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

[ end Kernel panic - not syncing: Attempted to kill init!
exitcode=0x0000000b

alloc_unbound_pwq() allocates slab object from pool_workqueue.  This
kmem_cache requires 256 bytes alignment, but, current merging code doesn't
honor that, and merge it with kmalloc-256.  kmalloc-256 requires only
cacheline size alignment so that above failure occurs.  However, in x86,
kmalloc-256 is luckily aligned in 256 bytes, so the problem didn't happen
on it.

To fix this problem, this patch introduces alignment mismatch check in
find_mergeable().  This will fix the problem.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reported-by: Markos Chandras <Markos.Chandras@imgtec.com>
Tested-by: Markos Chandras <Markos.Chandras@imgtec.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/slab_common.c~mm-slab-fix-unalignment-problem-on-malta-with-eva-due-to-slab-merge mm/slab_common.c
--- a/mm/slab_common.c~mm-slab-fix-unalignment-problem-on-malta-with-eva-due-to-slab-merge
+++ a/mm/slab_common.c
@@ -259,6 +259,10 @@ struct kmem_cache *find_mergeable(size_t
 		if (s->size - size >= sizeof(void *))
 			continue;
 
+		if (IS_ENABLED(CONFIG_SLAB) && align &&
+			(align > s->align || s->align % align))
+			continue;
+
 		return s;
 	}
 	return NULL;
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slab-slub-coding-style-whitespaces-and-tabs-mixture.patch
slab-print-slabinfo-header-in-seq-show.patch
mm-slab-reverse-iteration-on-find_mergeable.patch
mm-slub-fix-format-mismatches-in-slab_err-callers.patch
slab-improve-checking-for-invalid-gfp_flags.patch
slab-replace-smp_read_barrier_depends-with-lockless_dereference.patch
mm-introduce-single-zone-pcplists-drain.patch
mm-page_isolation-drain-single-zone-pcplists.patch
mm-cma-drain-single-zone-pcplists.patch
mm-memory_hotplug-failure-drain-single-zone-pcplists.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-defer-only-on-compact_complete.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-compaction-more-focused-lru-and-pcplists-draining.patch
memcg-use-generic-slab-iterators-for-showing-slabinfo.patch
mm-embed-the-memcg-pointer-directly-into-struct-page.patch
mm-embed-the-memcg-pointer-directly-into-struct-page-fix.patch
mm-page_cgroup-rename-file-to-mm-swap_cgroupc.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix-2.patch
lib-bitmap-added-alignment-offset-for-bitmap_find_next_zero_area.patch
mm-cma-align-to-physical-address-not-cma-region-position.patch
mm-debug-pagealloc-cleanup-page-guard-code.patch
zsmalloc-merge-size_class-to-reduce-fragmentation.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch
mm-cma-split-cma-reserved-in-dmesg-log.patch
fs-proc-include-cma-info-in-proc-meminfo.patch
page-owners-correct-page-order-when-to-free-page.patch

