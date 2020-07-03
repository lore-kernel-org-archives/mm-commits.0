From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-fix-oops-inside-mem_cgroup_get_nr_swap_pages.patch added to
 -mm tree
Date: Fri, 03 Jul 2020 12:24:34 -0700
Message-ID: <20200703192434.lGC0wuGw4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726147AbgGCTYg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Jul 2020 15:24:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhsharma@redhat.com, catalin.marinas@arm.com, hannes@cmpxchg.org, james.morse@arm.com, mark.rutland@arm.com, mhocko@suse.com, mm-commits@vger.kernel.org, pkushwaha@marvell.com, vdavydov.dev@gmail.com, will@kernel.org


The patch titled
     Subject: mm/memcontrol: fix OOPS inside mem_cgroup_get_nr_swap_pages()
has been added to the -mm tree.  Its filename is
     mm-memcontrol-fix-oops-inside-mem_cgroup_get_nr_swap_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-fix-oops-inside-mem_cgroup_get_nr_swap_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-fix-oops-inside-mem_cgroup_get_nr_swap_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bhupesh Sharma <bhsharma@redhat.com>
Subject: mm/memcontrol: fix OOPS inside mem_cgroup_get_nr_swap_pages()

Prabhakar reported an OOPS inside mem_cgroup_get_nr_swap_pages() function
in a corner case seen on some arm64 boards when kdump kernel runs with
"cgroup_disable=memory" passed to the kdump kernel via bootargs.

The root-cause behind the same is that currently mem_cgroup_swap_init()
function is implemented as a subsys_initcall() call instead of a
core_initcall(), this means 'cgroup_memory_noswap' still remains set to
the default value (false) even when memcg is disabled via
"cgroup_disable=memory" boot parameter.

This may result in premature OOPS inside mem_cgroup_get_nr_swap_pages()
function in corner cases:

  [    0.265617] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000188
  [    0.274495] Mem abort info:
  [    0.277311]   ESR = 0x96000006
  [    0.280389]   EC = 0x25: DABT (current EL), IL = 32 bits
  [    0.285751]   SET = 0, FnV = 0
  [    0.288830]   EA = 0, S1PTW = 0
  [    0.291995] Data abort info:
  [    0.294897]   ISV = 0, ISS = 0x00000006
  [    0.298765]   CM = 0, WnR = 0
  [    0.301757] [0000000000000188] user address but active_mm is swapper
  [    0.308174] Internal error: Oops: 96000006 [#1] SMP
  [    0.313097] Modules linked in:
  <..snip..>
  [    0.331384] pstate: 00400009 (nzcv daif +PAN -UAO BTYPE=--)
  [    0.337014] pc : mem_cgroup_get_nr_swap_pages+0x9c/0xf4
  [    0.342289] lr : mem_cgroup_get_nr_swap_pages+0x68/0xf4
  [    0.347564] sp : fffffe0012b6f800
  [    0.350905] x29: fffffe0012b6f800 x28: fffffe00116b3000
  [    0.356268] x27: fffffe0012b6fb00 x26: 0000000000000020
  [    0.361631] x25: 0000000000000000 x24: fffffc00723ffe28
  [    0.366994] x23: fffffe0010d5b468 x22: fffffe00116bfa00
  [    0.372357] x21: fffffe0010aabda8 x20: 0000000000000000
  [    0.377720] x19: 0000000000000000 x18: 0000000000000010
  [    0.383082] x17: 0000000043e612f2 x16: 00000000a9863ed7
  [    0.388445] x15: ffffffffffffffff x14: 202c303d70617773
  [    0.393808] x13: 6f6e5f79726f6d65 x12: 6d5f70756f726763
  [    0.399170] x11: 2073656761705f70 x10: 6177735f726e5f74
  [    0.404533] x9 : fffffe00100e9580 x8 : fffffe0010628160
  [    0.409895] x7 : 00000000000000a8 x6 : fffffe00118f5e5e
  [    0.415258] x5 : 0000000000000001 x4 : 0000000000000000
  [    0.420621] x3 : 0000000000000000 x2 : 0000000000000000
  [    0.425983] x1 : 0000000000000000 x0 : fffffc0060079000
  [    0.431346] Call trace:
  [    0.433809]  mem_cgroup_get_nr_swap_pages+0x9c/0xf4
  [    0.438735]  shrink_lruvec+0x404/0x4f8
  [    0.442516]  shrink_node+0x1a8/0x688
  [    0.446121]  do_try_to_free_pages+0xe8/0x448
  [    0.450429]  try_to_free_pages+0x110/0x230
  [    0.454563]  __alloc_pages_slowpath.constprop.106+0x2b8/0xb48
  [    0.460366]  __alloc_pages_nodemask+0x2ac/0x2f8
  [    0.464938]  alloc_page_interleave+0x20/0x90
  [    0.469246]  alloc_pages_current+0xdc/0xf8
  [    0.473379]  atomic_pool_expand+0x60/0x210
  [    0.477514]  __dma_atomic_pool_init+0x50/0xa4
  [    0.481910]  dma_atomic_pool_init+0xac/0x158
  [    0.486220]  do_one_initcall+0x50/0x218
  [    0.490091]  kernel_init_freeable+0x22c/0x2d0
  [    0.494489]  kernel_init+0x18/0x110
  [    0.498007]  ret_from_fork+0x10/0x18
  [    0.501614] Code: aa1403e3 91106000 97f82a27 14000011 (f940c663)
  [    0.507770] ---[ end trace 9795948475817de4 ]---
  [    0.512429] Kernel panic - not syncing: Fatal exception
  [    0.517705] Rebooting in 10 seconds..

Link: http://lkml.kernel.org/r/1593641660-13254-2-git-send-email-bhsharma@redhat.com
Fixes: eccb52e78809 ("mm: memcontrol: prepare swap controller setup for integration")
Signed-off-by: Bhupesh Sharma <bhsharma@redhat.com>
Reported-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: James Morse <james.morse@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-fix-oops-inside-mem_cgroup_get_nr_swap_pages
+++ a/mm/memcontrol.c
@@ -7186,6 +7186,13 @@ static struct cftype memsw_files[] = {
 	{ },	/* terminate */
 };
 
+/*
+ * If mem_cgroup_swap_init() is implemented as a subsys_initcall()
+ * instead of a core_initcall(), this could mean cgroup_memory_noswap still
+ * remains set to false even when memcg is disabled via "cgroup_disable=memory"
+ * boot parameter. This may result in premature OOPS inside 
+ * mem_cgroup_get_nr_swap_pages() function in corner cases.
+ */
 static int __init mem_cgroup_swap_init(void)
 {
 	/* No memory control -> no swap control */
@@ -7200,6 +7207,6 @@ static int __init mem_cgroup_swap_init(v
 
 	return 0;
 }
-subsys_initcall(mem_cgroup_swap_init);
+core_initcall(mem_cgroup_swap_init);
 
 #endif /* CONFIG_MEMCG_SWAP */
_

Patches currently in -mm which might be from bhsharma@redhat.com are

mm-memcontrol-fix-oops-inside-mem_cgroup_get_nr_swap_pages.patch
