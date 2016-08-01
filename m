From: akpm@linux-foundation.org
Subject: + mm-kasan-fix-corruptions-and-false-positive-reports.patch added to -mm tree
Date: Mon, 01 Aug 2016 13:16:08 -0700
Message-ID: <579fae08.nYZipdeCjj/dqdcc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41287 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025AbcHAUlt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2016 16:41:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, alexander.levin@verizon.com, davej@codemonkey.org.uk, dvyukov@google.com, glider@google.com, vegard.nossum@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kasan: fix corruptions and false positive reports
has been added to the -mm tree.  Its filename is
     mm-kasan-fix-corruptions-and-false-positive-reports.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kasan-fix-corruptions-and-false-positive-reports.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kasan-fix-corruptions-and-false-positive-reports.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: mm/kasan: fix corruptions and false positive reports

Once an object is put into quarantine, we no longer own it, i.e.  object
could leave the quarantine and be reallocated.  So having set_track() call
after the quarantine_put() may corrupt slab objects.

 BUG kmalloc-4096 (Not tainted): Poison overwritten
 -----------------------------------------------------------------------------
 Disabling lock debugging due to kernel taint
 INFO: 0xffff8804540de850-0xffff8804540de857. First byte 0xb5 instead of 0x6b
...
 INFO: Freed in qlist_free_all+0x42/0x100 age=75 cpu=3 pid=24492
  __slab_free+0x1d6/0x2e0
  ___cache_free+0xb6/0xd0
  qlist_free_all+0x83/0x100
  quarantine_reduce+0x177/0x1b0
  kasan_kmalloc+0xf3/0x100
  kasan_slab_alloc+0x12/0x20
  kmem_cache_alloc+0x109/0x3e0
  mmap_region+0x53e/0xe40
  do_mmap+0x70f/0xa50
  vm_mmap_pgoff+0x147/0x1b0
  SyS_mmap_pgoff+0x2c7/0x5b0
  SyS_mmap+0x1b/0x30
  do_syscall_64+0x1a0/0x4e0
  return_from_SYSCALL_64+0x0/0x7a
 INFO: Slab 0xffffea0011503600 objects=7 used=7 fp=0x          (null) flags=0x8000000000004080
 INFO: Object 0xffff8804540de848 @offset=26696 fp=0xffff8804540dc588
 Redzone ffff8804540de840: bb bb bb bb bb bb bb bb                          ........
 Object ffff8804540de848: 6b 6b 6b 6b 6b 6b 6b 6b b5 52 00 00 f2 01 60 cc  kkkkkkkk.R....`.

Similarly, poisoning after the quarantine_put() leads to false positive
use-after-free reports:

 BUG: KASAN: use-after-free in anon_vma_interval_tree_insert+0x304/0x430 at addr ffff880405c540a0
 Read of size 8 by task trinity-c0/3036
 CPU: 0 PID: 3036 Comm: trinity-c0 Not tainted 4.7.0-think+ #9
  ffff880405c54200 00000000c5c4423e ffff88044a5ef9f0 ffffffffaea48532
  ffff88044a5efa88 ffff880461497a00 ffff88044a5efa78 ffffffffae57cfe2
  ffff88046501c958 ffff880436aa5440 0000000000000282 0000000000000007
 Call Trace:
  [<ffffffffaea48532>] dump_stack+0x68/0x96
  [<ffffffffae57cfe2>] kasan_report_error+0x222/0x600
  [<ffffffffae57d571>] __asan_report_load8_noabort+0x61/0x70
  [<ffffffffae4f8924>] anon_vma_interval_tree_insert+0x304/0x430
  [<ffffffffae52f811>] anon_vma_chain_link+0x91/0xd0
  [<ffffffffae536e46>] anon_vma_clone+0x136/0x3f0
  [<ffffffffae537181>] anon_vma_fork+0x81/0x4c0
  [<ffffffffae125663>] copy_process.part.47+0x2c43/0x5b20
  [<ffffffffae12895d>] _do_fork+0x16d/0xbd0
  [<ffffffffae129469>] SyS_clone+0x19/0x20
  [<ffffffffae0064b0>] do_syscall_64+0x1a0/0x4e0
  [<ffffffffafa09b1a>] entry_SYSCALL64_slow_path+0x25/0x25

Fix this by putting an object in the quarantine after all other operations.

Fixes: 80a9201a5965 ("mm, kasan: switch SLUB to stackdepot, enable memory quarantine for SLUB")
Link: http://lkml.kernel.org/r/1470062715-14077-1-git-send-email-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Reported-by: Dave Jones <davej@codemonkey.org.uk>
Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
Reported-by: Sasha Levin <alexander.levin@verizon.com>
Acked-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/kasan/kasan.c~mm-kasan-fix-corruptions-and-false-positive-reports mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~mm-kasan-fix-corruptions-and-false-positive-reports
+++ a/mm/kasan/kasan.c
@@ -543,9 +543,9 @@ bool kasan_slab_free(struct kmem_cache *
 		switch (alloc_info->state) {
 		case KASAN_STATE_ALLOC:
 			alloc_info->state = KASAN_STATE_QUARANTINE;
-			quarantine_put(free_info, cache);
 			set_track(&free_info->track, GFP_NOWAIT);
 			kasan_poison_slab_free(cache, object);
+			quarantine_put(free_info, cache);
 			return true;
 		case KASAN_STATE_QUARANTINE:
 		case KASAN_STATE_FREE:
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

mm-kasan-fix-corruptions-and-false-positive-reports.patch
mm-kasan-dont-reduce-quarantine-in-atomic-contexts.patch
mm-kasan-slub-dont-disable-interrupts-when-object-leaves-quarantine.patch
mm-kasan-get-rid-of-alloc_size-in-struct-kasan_alloc_meta.patch
mm-kasan-get-rid-of-state-in-struct-kasan_alloc_meta.patch
kasan-improve-double-free-reports.patch

