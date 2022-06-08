Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 239CBC43334
	for <mm-commits@archiver.kernel.org>; Wed,  8 Jun 2022 19:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235529AbiFHT3h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Jun 2022 15:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235582AbiFHT3f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jun 2022 15:29:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB921E7346
        for <mm-commits@vger.kernel.org>; Wed,  8 Jun 2022 12:29:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03E3860FAB
        for <mm-commits@vger.kernel.org>; Wed,  8 Jun 2022 19:29:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5279DC34116;
        Wed,  8 Jun 2022 19:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654716573;
        bh=Iql3LL18AvZgVjSKSFOuTA0daLhkPPVY13By/Zee2ec=;
        h=Date:To:From:Subject:From;
        b=cezHrvDpaJ0HX/qMAR1Hnn/ccKBp5LPYcK4xGO3cwDhk07zvlsNw53nXUUdjR9uL+
         bydqb5vqbfLS9TjZcUjvh7PiN1aa7DqpSYThPeGbqSxVZRivYL2agVO73fWpdY7wnp
         k/lksK9R169kLS4F4r30KgapL7x48eT7d4ovNDJ8=
Date:   Wed, 08 Jun 2022 12:29:32 -0700
To:     mm-commits@vger.kernel.org, ytk.lee@samsung.com, s.suk@samsung.com,
        senozhatsky@chromium.org, ngupta@vflare.org, minchan@kernel.org,
        avromanov@sberdevices.ru, jaewon31.kim@samsung.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] zram_drv-add-__gfp_nomemalloc-not-to-use-alloc_no_watermarks.patch removed from -mm tree
Message-Id: <20220608192933.5279DC34116@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram_drv: add __GFP_NOMEMALLOC not to use ALLOC_NO_WATERMARKS
has been removed from the -mm tree.  Its filename was
     zram_drv-add-__gfp_nomemalloc-not-to-use-alloc_no_watermarks.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jaewon Kim <jaewon31.kim@samsung.com>
Subject: zram_drv: add __GFP_NOMEMALLOC not to use ALLOC_NO_WATERMARKS
Date: Fri, 3 Jun 2022 14:57:47 +0900

Atomic page allocation failures sometimes happen, and most of them seem to
occur during boot time.

[   59.707645] system_server: page allocation failure: order:0, mode:0xa20(GFP_ATOMIC), nodemask=(null),cpuset=foreground-boost,mems_allowed=0
[   59.707676] CPU: 5 PID: 1209 Comm: system_server Tainted: G S O      5.4.161-qgki-24219806-abA236USQU0AVE1 #1
[   59.707691] Call trace:
[   59.707702]  dump_backtrace.cfi_jt+0x0/0x4
[   59.707712]  show_stack+0x18/0x24
[   59.707719]  dump_stack+0xa4/0xe0
[   59.707728]  warn_alloc+0x114/0x194
[   59.707734]  __alloc_pages_slowpath+0x828/0x83c
[   59.707740]  __alloc_pages_nodemask+0x2b4/0x310
[   59.707747]  alloc_slab_page+0x40/0x5c8
[   59.707753]  new_slab+0x404/0x420
[   59.707759]  ___slab_alloc+0x224/0x3b0
[   59.707765]  __kmalloc+0x37c/0x394
[   59.707773]  context_struct_to_string+0x110/0x1b8
[   59.707778]  context_add_hash+0x6c/0xc8
[   59.707785]  security_compute_sid.llvm.13699573597798246927+0x508/0x5d8
[   59.707792]  security_transition_sid+0x2c/0x38
[   59.707804]  selinux_socket_create+0xa0/0xd8
[   59.707811]  security_socket_create+0x68/0xbc
[   59.707818]  __sock_create+0x8c/0x2f8
[   59.707823]  __sys_socket+0x94/0x19c
[   59.707829]  __arm64_sys_socket+0x20/0x30
[   59.707836]  el0_svc_common+0x100/0x1e0
[   59.707841]  el0_svc_handler+0x68/0x74
[   59.707848]  el0_svc+0x8/0xc
[   59.707853] Mem-Info:
[   59.707890] active_anon:223569 inactive_anon:74412 isolated_anon:0
[   59.707890]  active_file:51395 inactive_file:176622 isolated_file:0
[   59.707890]  unevictable:1018 dirty:211 writeback:4 unstable:0
[   59.707890]  slab_reclaimable:14398 slab_unreclaimable:61909
[   59.707890]  mapped:134779 shmem:1231 pagetables:26706 bounce:0
[   59.707890]  free:528 free_pcp:844 free_cma:147
[   59.707900] Node 0 active_anon:894276kB inactive_anon:297648kB active_file:205580kB inactive_file:706488kB unevictable:4072kB isolated(anon):0kB isolated(file):0kB mapped:539116kB dirty:844kB writeback:16kB shmem:4924kB writeback_tmp:0kB unstable:0kB all_unreclaimable? no
[   59.707912] Normal free:2112kB min:7244kB low:68892kB high:72180kB active_anon:893140kB inactive_anon:297660kB active_file:204740kB inactive_file:706396kB unevictable:4072kB writepending:860kB present:3626812kB managed:3288700kB mlocked:4068kB kernel_stack:62416kB shadow_call_stack:15656kB pagetables:106824kB bounce:0kB free_pcp:3372kB local_pcp:176kB free_cma:588kB
[   59.707915] lowmem_reserve[]: 0 0
[   59.707922] Normal: 8*4kB (H) 5*8kB (H) 13*16kB (H) 25*32kB (H) 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1080kB
[   59.707942] 242549 total pagecache pages
[   59.707951] 12446 pages in swap cache
[   59.707956] Swap cache stats: add 212408, delete 199969, find 36869/71571
[   59.707961] Free swap  = 3445756kB
[   59.707965] Total swap = 4194300kB
[   59.707969] 906703 pages RAM
[   59.707973] 0 pages HighMem/MovableOnly
[   59.707978] 84528 pages reserved
[   59.707982] 49152 pages cma reserved

The kswapd or other reclaim contexts may not prepare enough free pages for
many atomic allocations occurring in a short time.  But zram may not be
helpful for these atomic allocations even though zram is used to reclaim.

To get one zs object for a specific size, zram may allocate several pages.
And this can happen on different class sizes at the same time.  This
means zram may consume more pages to reclaim only one page.  This
inefficiency may cause consumption of all free pages below watermark min
by a process having PF_MEMALLOC like kswapd.

We can avoid this by adding __GFP_NOMEMALLOC.  A PF_MEMALLOC process won't
use ALLOC_NO_WATERMARKS.

Link: https://lkml.kernel.org/r/20220603055747.11694-1-jaewon31.kim@samsung.com
Signed-off-by: Jaewon Kim <jaewon31.kim@samsung.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Sooyong Suk <s.suk@samsung.com>
Cc: Yong-Taek Lee <ytk.lee@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/block/zram/zram_drv.c~zram_drv-add-__gfp_nomemalloc-not-to-use-alloc_no_watermarks
+++ a/drivers/block/zram/zram_drv.c
@@ -1383,6 +1383,7 @@ static int __zram_bvec_write(struct zram
 
 	handle = zs_malloc(zram->mem_pool, comp_len,
 			__GFP_KSWAPD_RECLAIM |
+			__GFP_NOMEMALLOC |
 			__GFP_NOWARN |
 			__GFP_HIGHMEM |
 			__GFP_MOVABLE);
_

Patches currently in -mm which might be from jaewon31.kim@samsung.com are


