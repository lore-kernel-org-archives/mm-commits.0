Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3771C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  7 Sep 2021 20:57:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6E5D6109D
	for <mm-commits@archiver.kernel.org>; Tue,  7 Sep 2021 20:57:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhIGU6e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 16:58:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236693AbhIGU6e (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 16:58:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5217F604E9;
        Tue,  7 Sep 2021 20:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631048247;
        bh=vYGoVV+n/11knNJSM1ZDdX0hE7YIkiGwe472zP0XFrk=;
        h=Date:From:To:Subject:From;
        b=BGbIVwMlrHUEx3eD77p7Ok5PUvkggaCVXq0iFmaUaW/SvclihXDwNetrQyDu8WUPY
         kU9TnZZjiyJnapZtvoIvvCnhcXgk/JkpxTCNUMdx+wdr3z9W4f1xaUGz4ox/7tA9Er
         uZXmOOCGpn6G7B2LmOuCCETjhEA5hJYj5l9edy1o=
Date:   Tue, 07 Sep 2021 13:57:26 -0700
From:   akpm@linux-foundation.org
To:     catalin.marinas@arm.com, djwong@kernel.org,
        mm-commits@vger.kernel.org, naohiro.aota@wdc.com
Subject:  +
 mm-kmemleak-allow-__gfp_nolockdep-passed-to-kmemleaks-gfp.patch added to
 -mm tree
Message-ID: <20210907205726.oW6hfC-eh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kmemleak: allow __GFP_NOLOCKDEP passed to kmemleak's gfp
has been added to the -mm tree.  Its filename is
     mm-kmemleak-allow-__gfp_nolockdep-passed-to-kmemleaks-gfp.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-kmemleak-allow-__gfp_nolockdep-passed-to-kmemleaks-gfp.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-kmemleak-allow-__gfp_nolockdep-passed-to-kmemleaks-gfp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naohiro Aota <naohiro.aota@wdc.com>
Subject: mm/kmemleak: allow __GFP_NOLOCKDEP passed to kmemleak's gfp

In a memory pressure situation, I'm seeing the lockdep WARNING below. 
Actually, this is similar to a known false positive which is already
addressed by commit 6dcde60efd94 ("xfs: more lockdep whackamole with
kmem_alloc*").

This warning still persists because it's not from kmalloc() itself but
from an allocation for kmemleak object.  While kmalloc() itself suppress
the warning with __GFP_NOLOCKDEP, gfp_kmemleak_mask() is dropping the flag
for the kmemleak's allocation.

Allow __GFP_NOLOCKDEP to be passed to kmemleak's allocation, so that the
warning for it is also suppressed.

  ======================================================
  WARNING: possible circular locking dependency detected
  5.14.0-rc7-BTRFS-ZNS+ #37 Not tainted
  ------------------------------------------------------
  kswapd0/288 is trying to acquire lock:
  ffff88825ab45df0 (&xfs_nondir_ilock_class){++++}-{3:3}, at: xfs_ilock+0x8a/0x250

  but task is already holding lock:
  ffffffff848cc1e0 (fs_reclaim){+.+.}-{0:0}, at: __fs_reclaim_acquire+0x5/0x30

  which lock already depends on the new lock.

  the existing dependency chain (in reverse order) is:

  -> #1 (fs_reclaim){+.+.}-{0:0}:
         fs_reclaim_acquire+0x112/0x160
         kmem_cache_alloc+0x48/0x400
         create_object.isra.0+0x42/0xb10
         kmemleak_alloc+0x48/0x80
         __kmalloc+0x228/0x440
         kmem_alloc+0xd3/0x2b0
         kmem_alloc_large+0x5a/0x1c0
         xfs_attr_copy_value+0x112/0x190
         xfs_attr_shortform_getvalue+0x1fc/0x300
         xfs_attr_get_ilocked+0x125/0x170
         xfs_attr_get+0x329/0x450
         xfs_get_acl+0x18d/0x430
         get_acl.part.0+0xb6/0x1e0
         posix_acl_xattr_get+0x13a/0x230
         vfs_getxattr+0x21d/0x270
         getxattr+0x126/0x310
         __x64_sys_fgetxattr+0x1a6/0x2a0
         do_syscall_64+0x3b/0x90
         entry_SYSCALL_64_after_hwframe+0x44/0xae

  -> #0 (&xfs_nondir_ilock_class){++++}-{3:3}:
         __lock_acquire+0x2c0f/0x5a00
         lock_acquire+0x1a1/0x4b0
         down_read_nested+0x50/0x90
         xfs_ilock+0x8a/0x250
         xfs_can_free_eofblocks+0x34f/0x570
         xfs_inactive+0x411/0x520
         xfs_fs_destroy_inode+0x2c8/0x710
         destroy_inode+0xc5/0x1a0
         evict+0x444/0x620
         dispose_list+0xfe/0x1c0
         prune_icache_sb+0xdc/0x160
         super_cache_scan+0x31e/0x510
         do_shrink_slab+0x337/0x8e0
         shrink_slab+0x362/0x5c0
         shrink_node+0x7a7/0x1a40
         balance_pgdat+0x64e/0xfe0
         kswapd+0x590/0xa80
         kthread+0x38c/0x460
         ret_from_fork+0x22/0x30

  other info that might help us debug this:
   Possible unsafe locking scenario:
         CPU0                    CPU1
         ----                    ----
    lock(fs_reclaim);
                                 lock(&xfs_nondir_ilock_class);
                                 lock(fs_reclaim);
    lock(&xfs_nondir_ilock_class);

   *** DEADLOCK ***
  3 locks held by kswapd0/288:
   #0: ffffffff848cc1e0 (fs_reclaim){+.+.}-{0:0}, at: __fs_reclaim_acquire+0x5/0x30
   #1: ffffffff848a08d8 (shrinker_rwsem){++++}-{3:3}, at: shrink_slab+0x269/0x5c0
   #2: ffff8881a7a820e8 (&type->s_umount_key#60){++++}-{3:3}, at: super_cache_scan+0x5a/0x510

Link: https://lkml.kernel.org/r/20210907055659.3182992-1-naohiro.aota@wdc.com
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/kmemleak.c~mm-kmemleak-allow-__gfp_nolockdep-passed-to-kmemleaks-gfp
+++ a/mm/kmemleak.c
@@ -113,7 +113,8 @@
 #define BYTES_PER_POINTER	sizeof(void *)
 
 /* GFP bitmask for kmemleak internal allocations */
-#define gfp_kmemleak_mask(gfp)	(((gfp) & (GFP_KERNEL | GFP_ATOMIC)) | \
+#define gfp_kmemleak_mask(gfp)	(((gfp) & (GFP_KERNEL | GFP_ATOMIC | \
+					   __GFP_NOLOCKDEP)) | \
 				 __GFP_NORETRY | __GFP_NOMEMALLOC | \
 				 __GFP_NOWARN)
 
_

Patches currently in -mm which might be from naohiro.aota@wdc.com are

mm-kmemleak-allow-__gfp_nolockdep-passed-to-kmemleaks-gfp.patch

