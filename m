From: akpm@linux-foundation.org
Subject: +
 slub-fix-sysfs-duplicate-filename-creation-when-slub_debug=o.patch added to
 -mm tree
Date: Tue, 14 Nov 2017 21:36:05 -0800
Message-ID: <20171115053605.-u110hVuG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51782 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755997AbdKOFgH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 00:36:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, iamjoonsoo.kim@lge.com, miles.chen@mediatek.com, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com


The patch titled
     Subject: slub: fix sysfs duplicate filename creation when slub_debug=O
has been added to the -mm tree.  Its filename is
     slub-fix-sysfs-duplicate-filename-creation-when-slub_debug=o.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-fix-sysfs-duplicate-filename-creation-when-slub_debug%3Do.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-fix-sysfs-duplicate-filename-creation-when-slub_debug%3Do.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miles Chen <miles.chen@mediatek.com>
Subject: slub: fix sysfs duplicate filename creation when slub_debug=O

When slub_debug=O is set.  It is possible to clear debug flags for an
"unmergeable" slab cache in kmem_cache_open().  It makes the "unmergeable"
cache became "mergeable" in sysfs_slab_add().

These caches will generate their "unique IDs" by create_unique_id(), but
it is possible to create identical unique IDs.  In my experiment,
sgpool-128, names_cache, biovec-256 generate the same ID ":Ft-0004096" and
the kernel reports "sysfs: cannot create duplicate filename
'/kernel/slab/:Ft-0004096'".

To repeat my experiment, set disable_higher_order_debug=1,
CONFIG_SLUB_DEBUG_ON=y in kernel-4.14.

Fix this issue by setting unmergeable=1 if slub_debug=O and the the
default slub_debug contains any no-merge flags.

call path:
kmem_cache_create()
  __kmem_cache_alias()	-> we set SLAB_NEVER_MERGE flags here
  create_cache()
    __kmem_cache_create()
      kmem_cache_open()	-> clear DEBUG_METADATA_FLAGS
      sysfs_slab_add()	-> the slab cache is mergeable now

[    0.674272] sysfs: cannot create duplicate filename '/kernel/slab/:Ft-0004096'
[    0.674473] ------------[ cut here ]------------
[    0.674653] WARNING: CPU: 0 PID: 1 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x60/0x7c
[    0.674847] Modules linked in:
[    0.674969] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W       4.14.0-rc7ajb-00131-gd4c2e9f-dirty #123
[    0.675211] Hardware name: linux,dummy-virt (DT)
[    0.675342] task: ffffffc07d4e0080 task.stack: ffffff8008008000
[    0.675505] PC is at sysfs_warn_dup+0x60/0x7c
[    0.675633] LR is at sysfs_warn_dup+0x60/0x7c
[    0.675759] pc : [<ffffff8008235808>] lr : [<ffffff8008235808>] pstate: 60000145
[    0.675948] sp : ffffff800800bb40
[    0.676048] x29: ffffff800800bb40 x28: 0000000000000040
[    0.676209] x27: ffffffc07c52a380 x26: 0000000000000000
[    0.676369] x25: ffffff8008af4ad0 x24: ffffff8008af4000
[    0.676528] x23: ffffffc07c532580 x22: ffffffc07cf04598
[    0.676695] x21: ffffffc07cf26578 x20: ffffffc07c533700
[    0.676857] x19: ffffffc07ce67000 x18: 0000000000000002
[    0.677017] x17: 0000000000007ffe x16: 0000000000000007
[    0.677176] x15: 0000000000000001 x14: 0000000000007fff
[    0.677335] x13: 0000000000000394 x12: 0000000000000000
[    0.677492] x11: 00000000000001ab x10: 0000000000000007
[    0.677651] x9 : 00000000000001ac x8 : ffffff800835d114
[    0.677809] x7 : 656b2f2720656d61 x6 : 0000000000000017
[    0.677967] x5 : ffffffc07ffdb9a8 x4 : 0000000000000000
[    0.678124] x3 : 0000000000000000 x2 : ffffffffffffffff
[    0.678282] x1 : ffffff8008a4e878 x0 : 0000000000000042
[    0.678442] Call trace:
[    0.678528] Exception stack(0xffffff800800ba00 to 0xffffff800800bb40)
[    0.678706] ba00: 0000000000000042 ffffff8008a4e878 ffffffffffffffff 0000000000000000
[    0.678914] ba20: 0000000000000000 ffffffc07ffdb9a8 0000000000000017 656b2f2720656d61
[    0.679121] ba40: ffffff800835d114 00000000000001ac 0000000000000007 00000000000001ab
[    0.679326] ba60: 0000000000000000 0000000000000394 0000000000007fff 0000000000000001
[    0.679532] ba80: 0000000000000007 0000000000007ffe 0000000000000002 ffffffc07ce67000
[    0.679739] baa0: ffffffc07c533700 ffffffc07cf26578 ffffffc07cf04598 ffffffc07c532580
[    0.679944] bac0: ffffff8008af4000 ffffff8008af4ad0 0000000000000000 ffffffc07c52a380
[    0.680149] bae0: 0000000000000040 ffffff800800bb40 ffffff8008235808 ffffff800800bb40
[    0.680354] bb00: ffffff8008235808 0000000060000145 ffffffc07c533700 0000000062616c73
[    0.680560] bb20: ffffffffffffffff 0000000000000000 ffffff800800bb40 ffffff8008235808
[    0.680774] [<ffffff8008235808>] sysfs_warn_dup+0x60/0x7c
[    0.680928] [<ffffff8008235920>] sysfs_create_dir_ns+0x98/0xa0
[    0.681095] [<ffffff8008539274>] kobject_add_internal+0xa0/0x294
[    0.681267] [<ffffff80085394f8>] kobject_init_and_add+0x90/0xb4
[    0.681435] [<ffffff80081b524c>] sysfs_slab_add+0x90/0x200
[    0.681592] [<ffffff80081b62a0>] __kmem_cache_create+0x26c/0x438
[    0.681769] [<ffffff80081858a4>] kmem_cache_create+0x164/0x1f4
[    0.681940] [<ffffff80086caa98>] sg_pool_init+0x60/0x100
[    0.682094] [<ffffff8008084144>] do_one_initcall+0x38/0x12c
[    0.682254] [<ffffff80086a0d10>] kernel_init_freeable+0x138/0x1d4
[    0.682423] [<ffffff8008547388>] kernel_init+0x10/0xfc
[    0.682571] [<ffffff80080851e0>] ret_from_fork+0x10/0x18

Link: http://lkml.kernel.org/r/1510365805-5155-1-git-send-email-miles.chen@mediatek.com
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/slub.c~slub-fix-sysfs-duplicate-filename-creation-when-slub_debug=o mm/slub.c
--- a/mm/slub.c~slub-fix-sysfs-duplicate-filename-creation-when-slub_debug=o
+++ a/mm/slub.c
@@ -5706,6 +5706,10 @@ static int sysfs_slab_add(struct kmem_ca
 		return 0;
 	}
 
+	if (!unmergeable && disable_higher_order_debug &&
+			(slub_debug & DEBUG_METADATA_FLAGS))
+		unmergeable = 1;
+
 	if (unmergeable) {
 		/*
 		 * Slabcache can never be merged so we can use the name proper.
_

Patches currently in -mm which might be from miles.chen@mediatek.com are

dma-debug-fix-incorrect-pfn-calculation.patch
mm-slob-remove-an-unnecessary-check-for-__gfp_zero.patch
slub-fix-sysfs-duplicate-filename-creation-when-slub_debug=o.patch
checkpatch-support-function-pointers-for-unnamed-function-definition-arguments.patch

