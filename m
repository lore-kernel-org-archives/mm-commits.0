Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02F29C4338F
	for <mm-commits@archiver.kernel.org>; Mon, 16 Aug 2021 20:34:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA7D960F39
	for <mm-commits@archiver.kernel.org>; Mon, 16 Aug 2021 20:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231747AbhHPUf0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Aug 2021 16:35:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231203AbhHPUfZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Aug 2021 16:35:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C9196024A;
        Mon, 16 Aug 2021 20:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629146093;
        bh=MGZJPDAX6E9u9oDCXkZOXwi3PupVH7TOBzL+dBkhBrA=;
        h=Date:From:To:Subject:From;
        b=U6H/olx6aRFPMTsg224PHubhG3y83U7kUOBBKLWD9BaPOwN6ZtDxcqvlaTsSuj8Gy
         k+GdeLhjec90XNU0jKP6oBfTfceZEGLl+l1bWd7Y5q6Cg4jaUpvHE/1DinWjOHmUxo
         H+Nykr97s1tNRTHOnaVDxiwhVEuaI7UGK3SvyGkc=
Date:   Mon, 16 Aug 2021 13:34:53 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, catalin.marinas@arm.com,
        chinwen.chang@mediatek.com, elver@google.com, glider@google.com,
        Kuan-Ying.Lee@mediatek.com, mm-commits@vger.kernel.org,
        nicholas.tang@mediatek.com, ryabinin.a.a@gmail.com
Subject:  [merged]
 kasan-kmemleak-reset-tags-when-scanning-block.patch removed from -mm tree
Message-ID: <20210816203453.Spks17YiD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, kmemleak: reset tags when scanning block
has been removed from the -mm tree.  Its filename was
     kasan-kmemleak-reset-tags-when-scanning-block.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Subject: kasan, kmemleak: reset tags when scanning block

Patch series "kasan, slub: reset tag when printing address", v3.

With hardware tag-based kasan enabled, we reset the tag when we access
metadata to avoid from false alarm.


This patch (of 2):

Kmemleak needs to scan kernel memory to check memory leak.  With hardware
tag-based kasan enabled, when it scans on the invalid slab and
dereference, the issue will occur as below.

Hardware tag-based KASAN doesn't use compiler instrumentation, we can not
use kasan_disable_current() to ignore tag check.

Based on the below report, there are 11 0xf7 granules, which amounts to
176 bytes, and the object is allocated from the kmalloc-256 cache.  So
when kmemleak accesses the last 256-176 bytes, it causes faults, as those
are marked with KASAN_KMALLOC_REDZONE == KASAN_TAG_INVALID == 0xfe.

Thus, we reset tags before accessing metadata to avoid from false positives.

[  151.905804] ==================================================================
[  151.907120] BUG: KASAN: out-of-bounds in scan_block+0x58/0x170
[  151.908773] Read at addr f7ff0000c0074eb0 by task kmemleak/138
[  151.909656] Pointer tag: [f7], memory tag: [fe]
[  151.910195]
[  151.910876] CPU: 7 PID: 138 Comm: kmemleak Not tainted 5.14.0-rc2-00001-g8cae8cd89f05-dirty #134
[  151.912085] Hardware name: linux,dummy-virt (DT)
[  151.912868] Call trace:
[  151.913211]  dump_backtrace+0x0/0x1b0
[  151.913796]  show_stack+0x1c/0x30
[  151.914248]  dump_stack_lvl+0x68/0x84
[  151.914778]  print_address_description+0x7c/0x2b4
[  151.915340]  kasan_report+0x138/0x38c
[  151.915804]  __do_kernel_fault+0x190/0x1c4
[  151.916386]  do_tag_check_fault+0x78/0x90
[  151.916856]  do_mem_abort+0x44/0xb4
[  151.917308]  el1_abort+0x40/0x60
[  151.917754]  el1h_64_sync_handler+0xb4/0xd0
[  151.918270]  el1h_64_sync+0x78/0x7c
[  151.918714]  scan_block+0x58/0x170
[  151.919157]  scan_gray_list+0xdc/0x1a0
[  151.919626]  kmemleak_scan+0x2ac/0x560
[  151.920129]  kmemleak_scan_thread+0xb0/0xe0
[  151.920635]  kthread+0x154/0x160
[  151.921115]  ret_from_fork+0x10/0x18
[  151.921717]
[  151.922077] Allocated by task 0:
[  151.922523]  kasan_save_stack+0x2c/0x60
[  151.923099]  __kasan_kmalloc+0xec/0x104
[  151.923502]  __kmalloc+0x224/0x3c4
[  151.924172]  __register_sysctl_paths+0x200/0x290
[  151.924709]  register_sysctl_table+0x2c/0x40
[  151.925175]  sysctl_init+0x20/0x34
[  151.925665]  proc_sys_init+0x3c/0x48
[  151.926136]  proc_root_init+0x80/0x9c
[  151.926547]  start_kernel+0x648/0x6a4
[  151.926987]  __primary_switched+0xc0/0xc8
[  151.927557]
[  151.927994] Freed by task 0:
[  151.928340]  kasan_save_stack+0x2c/0x60
[  151.928766]  kasan_set_track+0x2c/0x40
[  151.929173]  kasan_set_free_info+0x44/0x54
[  151.929568]  ____kasan_slab_free.constprop.0+0x150/0x1b0
[  151.930063]  __kasan_slab_free+0x14/0x20
[  151.930449]  slab_free_freelist_hook+0xa4/0x1fc
[  151.930924]  kfree+0x1e8/0x30c
[  151.931285]  put_fs_context+0x124/0x220
[  151.931731]  vfs_kern_mount.part.0+0x60/0xd4
[  151.932280]  kern_mount+0x24/0x4c
[  151.932686]  bdev_cache_init+0x70/0x9c
[  151.933122]  vfs_caches_init+0xdc/0xf4
[  151.933578]  start_kernel+0x638/0x6a4
[  151.934014]  __primary_switched+0xc0/0xc8
[  151.934478]
[  151.934757] The buggy address belongs to the object at ffff0000c0074e00
[  151.934757]  which belongs to the cache kmalloc-256 of size 256
[  151.935744] The buggy address is located 176 bytes inside of
[  151.935744]  256-byte region [ffff0000c0074e00, ffff0000c0074f00)
[  151.936702] The buggy address belongs to the page:
[  151.937378] page:(____ptrval____) refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x100074
[  151.938682] head:(____ptrval____) order:2 compound_mapcount:0 compound_pincount:0
[  151.939440] flags: 0xbfffc0000010200(slab|head|node=0|zone=2|lastcpupid=0xffff|kasantag=0x0)
[  151.940886] raw: 0bfffc0000010200 0000000000000000 dead000000000122 f5ff0000c0002300
[  151.941634] raw: 0000000000000000 0000000000200020 00000001ffffffff 0000000000000000
[  151.942353] page dumped because: kasan: bad access detected
[  151.942923]
[  151.943214] Memory state around the buggy address:
[  151.943896]  ffff0000c0074c00: f0 f0 f0 f0 f0 f0 f0 f0 f0 fe fe fe fe fe fe fe
[  151.944857]  ffff0000c0074d00: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
[  151.945892] >ffff0000c0074e00: f7 f7 f7 f7 f7 f7 f7 f7 f7 f7 f7 fe fe fe fe fe
[  151.946407]                                                     ^
[  151.946939]  ffff0000c0074f00: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
[  151.947445]  ffff0000c0075000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  151.947999] ==================================================================
[  151.948524] Disabling lock debugging due to kernel taint
[  156.434569] kmemleak: 181 new suspected memory leaks (see /sys/kernel/debug/kmemleak)

Link: https://lkml.kernel.org/r/20210804090957.12393-1-Kuan-Ying.Lee@mediatek.com
Link: https://lkml.kernel.org/r/20210804090957.12393-2-Kuan-Ying.Lee@mediatek.com
Signed-off-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Nicholas Tang <nicholas.tang@mediatek.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/kmemleak.c~kasan-kmemleak-reset-tags-when-scanning-block
+++ a/mm/kmemleak.c
@@ -290,7 +290,7 @@ static void hex_dump_object(struct seq_f
 	warn_or_seq_printf(seq, "  hex dump (first %zu bytes):\n", len);
 	kasan_disable_current();
 	warn_or_seq_hex_dump(seq, DUMP_PREFIX_NONE, HEX_ROW_SIZE,
-			     HEX_GROUP_SIZE, ptr, len, HEX_ASCII);
+			     HEX_GROUP_SIZE, kasan_reset_tag((void *)ptr), len, HEX_ASCII);
 	kasan_enable_current();
 }
 
@@ -1171,7 +1171,7 @@ static bool update_checksum(struct kmeml
 
 	kasan_disable_current();
 	kcsan_disable_current();
-	object->checksum = crc32(0, (void *)object->pointer, object->size);
+	object->checksum = crc32(0, kasan_reset_tag((void *)object->pointer), object->size);
 	kasan_enable_current();
 	kcsan_enable_current();
 
@@ -1246,7 +1246,7 @@ static void scan_block(void *_start, voi
 			break;
 
 		kasan_disable_current();
-		pointer = *ptr;
+		pointer = *(unsigned long *)kasan_reset_tag((void *)ptr);
 		kasan_enable_current();
 
 		untagged_ptr = (unsigned long)kasan_reset_tag((void *)pointer);
_

Patches currently in -mm which might be from Kuan-Ying.Lee@mediatek.com are


