From: akpm@linux-foundation.org
Subject: + slab-do-not-panic-on-invalid-gfp_mask.patch added to -mm tree
Date: Fri, 10 Jun 2016 15:01:02 -0700
Message-ID: <575b389e.1Cal7w9t8VTq8iNc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53885 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbcFJWBD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jun 2016 18:01:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: do not panic on invalid gfp_mask
has been added to the -mm tree.  Its filename is
     slab-do-not-panic-on-invalid-gfp_mask.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-do-not-panic-on-invalid-gfp_mask.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-do-not-panic-on-invalid-gfp_mask.patch

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
Subject: slab: do not panic on invalid gfp_mask

Both SLAB and SLUB BUG() when a caller provides an invalid gfp_mask.  This
is a rather harsh way to announce a non-critical issue.  Allocator is free
to ignore invalid flags.  Let's simply replace BUG() by dump_stack to tell
the offender and fixup the mask to move on with the allocation request.

This is an example for kmalloc(GFP_KERNEL|__GFP_HIGHMEM) from a test
module.
[   31.914753] Unexpected gfp: 0x2 (__GFP_HIGHMEM). Fixing up to gfp: 0x24000c0 (GFP_KERNEL). Fix your code!
[   31.914754] CPU: 0 PID: 2916 Comm: insmod Tainted: G           O    4.6.0-slabgfp2-00002-g4cdfc2ef4892-dirty #936
[   31.914755] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Debian-1.8.2-1 04/01/2014
[   31.914756]  0000000000000000 ffff88000d777c00 ffffffff8130e2fb ffff88000ec006c0
[   31.914758]  000000000000000c ffff88000d777c58 ffffffff811791dd 0000000000000246
[   31.914759]  0000000000000246 0000000000000046 00000002024000c0 ffff88000fa1d888
[   31.914759] Call Trace:
[   31.914760]  [<ffffffff8130e2fb>] dump_stack+0x67/0x90
[   31.914762]  [<ffffffff811791dd>] cache_alloc_refill+0x201/0x617
[   31.914763]  [<ffffffff81179b3f>] kmem_cache_alloc_trace+0xa7/0x24a
[   31.914764]  [<ffffffffa0005000>] ? 0xffffffffa0005000
[   31.914765]  [<ffffffffa0005020>] mymodule_init+0x20/0x1000 [test_slab]
[   31.914767]  [<ffffffff81000402>] do_one_initcall+0xe7/0x16c
[   31.914768]  [<ffffffff810b02de>] ? rcu_read_lock_sched_held+0x61/0x69
[   31.914769]  [<ffffffff81179c2f>] ? kmem_cache_alloc_trace+0x197/0x24a
[   31.914771]  [<ffffffff81125edc>] do_init_module+0x5f/0x1d9
[   31.914772]  [<ffffffff810d2c66>] load_module+0x1a3d/0x1f21
[   31.914774]  [<ffffffff81622931>] ? retint_kernel+0x2d/0x2d
[   31.914775]  [<ffffffff810d3232>] SyS_init_module+0xe8/0x10e
[   31.914776]  [<ffffffff810d3232>] ? SyS_init_module+0xe8/0x10e
[   31.914778]  [<ffffffff81001d08>] do_syscall_64+0x68/0x13f
[   31.914779]  [<ffffffff8162201a>] entry_SYSCALL64_slow_path+0x25/0x25

Link: http://lkml.kernel.org/r/1465548200-11384-2-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    6 ++++--
 mm/slub.c |    5 +++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff -puN mm/slab.c~slab-do-not-panic-on-invalid-gfp_mask mm/slab.c
--- a/mm/slab.c~slab-do-not-panic-on-invalid-gfp_mask
+++ a/mm/slab.c
@@ -2687,8 +2687,10 @@ static struct page *cache_grow_begin(str
 	 */
 	if (unlikely(flags & GFP_SLAB_BUG_MASK)) {
 		gfp_t invalid_mask = flags & GFP_SLAB_BUG_MASK;
-		pr_emerg("Unexpected gfp: %#x (%pGg)\n", invalid_mask, &invalid_mask);
-		BUG();
+		flags &= ~GFP_SLAB_BUG_MASK;
+		pr_warn("Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n",
+				invalid_mask, &invalid_mask, flags, &flags);
+		dump_stack();
 	}
 	local_flags = flags & (GFP_CONSTRAINT_MASK|GFP_RECLAIM_MASK);
 
diff -puN mm/slub.c~slab-do-not-panic-on-invalid-gfp_mask mm/slub.c
--- a/mm/slub.c~slab-do-not-panic-on-invalid-gfp_mask
+++ a/mm/slub.c
@@ -1613,8 +1613,9 @@ static struct page *new_slab(struct kmem
 {
 	if (unlikely(flags & GFP_SLAB_BUG_MASK)) {
 		gfp_t invalid_mask = flags & GFP_SLAB_BUG_MASK;
-		pr_emerg("Unexpected gfp: %#x (%pGg)\n", invalid_mask, &invalid_mask);
-		BUG();
+		flags &= ~GFP_SLAB_BUG_MASK;
+		pr_warn("Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n",
+				invalid_mask, &invalid_mask, flags, &flags);
 	}
 
 	return allocate_slab(s,
_

Patches currently in -mm which might be from mhocko@suse.com are

tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i.patch
x86-get-rid-of-superfluous-__gfp_repeat.patch
x86-efi-get-rid-of-superfluous-__gfp_repeat.patch
arm64-get-rid-of-superfluous-__gfp_repeat.patch
arc-get-rid-of-superfluous-__gfp_repeat.patch
mips-get-rid-of-superfluous-__gfp_repeat.patch
nios2-get-rid-of-superfluous-__gfp_repeat.patch
parisc-get-rid-of-superfluous-__gfp_repeat.patch
score-get-rid-of-superfluous-__gfp_repeat.patch
powerpc-get-rid-of-superfluous-__gfp_repeat.patch
sparc-get-rid-of-superfluous-__gfp_repeat.patch
s390-get-rid-of-superfluous-__gfp_repeat.patch
sh-get-rid-of-superfluous-__gfp_repeat.patch
tile-get-rid-of-superfluous-__gfp_repeat.patch
unicore32-get-rid-of-superfluous-__gfp_repeat.patch
jbd2-get-rid-of-superfluous-__gfp_repeat.patch
arm-get-rid-of-superfluous-__gfp_repeat.patch
slab-make-gfp_slab_bug_mask-information-more-human-readable.patch
slab-do-not-panic-on-invalid-gfp_mask.patch
mm-oom_reaper-make-sure-that-mmput_async-is-called-only-when-memory-was-reaped.patch
mm-memcg-use-consistent-gfp-flags-during-readahead.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-fix.patch

