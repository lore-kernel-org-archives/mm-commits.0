Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A43FC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  4 Nov 2021 22:08:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3421C61220
	for <mm-commits@archiver.kernel.org>; Thu,  4 Nov 2021 22:08:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbhKDWLJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 4 Nov 2021 18:11:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230512AbhKDWLJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Nov 2021 18:11:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7A2F60EB4;
        Thu,  4 Nov 2021 22:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636063711;
        bh=EX9/YtewIjZJ4UfZG3E/vby6qhyIiVM+r3xsBF+taQo=;
        h=Date:From:To:Subject:From;
        b=1rodEyfDCFJGB2vYFh6ioBMvW9xBom3va7Ic63yYlzZaBOmyLzzUVdlEkaQPitUxS
         4HOcnlAAsRz82mXWwozlotPrctL/iBh/F9RoHWQQ765ZiQglF3P7uHNwdlUra3hj8p
         MoSKljFF8mHDqI7c2yc8Mn8/LkedaUeP7IkXGlJY=
Date:   Thu, 04 Nov 2021 15:08:30 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, minchan@kernel.org,
        mm-commits@vger.kernel.org, tglx@linutronix.de
Subject:  [alternative-merged]
 mm-disable-zsmalloc-on-preempt_rt.patch removed from -mm tree
Message-ID: <20211104220830.F8WznU6bk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: disable zsmalloc on PREEMPT_RT
has been removed from the -mm tree.  Its filename was
     mm-disable-zsmalloc-on-preempt_rt.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm: disable zsmalloc on PREEMPT_RT

For efficiency reasons, zsmalloc is using a slim `handle'.  The value is
the address of a memory allocation of 4 or 8 bytes depending on the size
of the long data type.  The lowest bit in that allocated memory is used as
a bit spin lock.

The usage of the bit spin lock is problematic because with the bit spin
lock held zsmalloc acquires a rwlock_t and spinlock_t which are both
sleeping locks on PREEMPT_RT and therefore must not be acquired with
disabled preemption.

There is a patch which extends the handle on PREEMPT_RT so that a full
spinlock_t fits (even with lockdep enabled) and then eliminates the bit
spin lock.  I'm not sure how sensible zsmalloc on PREEMPT_RT is given that
it is used to store compressed user memory.

Disable ZSMALLOC on PREEMPT_RT. If there is need for it, we can try to
get it to work.

Link: https://lkml.kernel.org/r/20210923170121.1860133-1-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/Kconfig~mm-disable-zsmalloc-on-preempt_rt
+++ a/mm/Kconfig
@@ -636,6 +636,7 @@ config ZSWAP_ZPOOL_DEFAULT_Z3FOLD
 
 config ZSWAP_ZPOOL_DEFAULT_ZSMALLOC
 	bool "zsmalloc"
+	depends on !PREEMPT_RT
 	select ZSMALLOC
 	help
 	  Use the zsmalloc allocator as the default allocator.
@@ -686,7 +687,7 @@ config Z3FOLD
 
 config ZSMALLOC
 	tristate "Memory allocator for compressed pages"
-	depends on MMU
+	depends on MMU && !PREEMPT_RT
 	help
 	  zsmalloc is a slab-based memory allocator designed to store
 	  compressed RAM pages.  zsmalloc uses virtual memory mapping
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

mm-disable-numa_balancing_default_enabled-and-transparent_hugepage-on-preempt_rt.patch
mm-page_alloc-use-migrate_disable-in-drain_local_pages_wq.patch

