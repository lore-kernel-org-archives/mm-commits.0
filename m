Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CF83C07E95
	for <mm-commits@archiver.kernel.org>; Tue, 13 Jul 2021 22:41:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D90461284
	for <mm-commits@archiver.kernel.org>; Tue, 13 Jul 2021 22:41:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236668AbhGMWoW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Jul 2021 18:44:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235536AbhGMWoW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Jul 2021 18:44:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFC9E6127C;
        Tue, 13 Jul 2021 22:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626216092;
        bh=7SfPnqdF/gZnzadl2l51kIV99TM7zsqVB0B9QiiaFtU=;
        h=Date:From:To:Subject:From;
        b=1Ko+cu52lUKn+ySa/VhzaH+PArbd23UuZLHNApMyM+9NzYcb54NoN7EEi/THNvTAe
         eE5YBEHoVoU2KxmksZ1XL7MNnnM0IBxr4/zTjoGvmw93eeVpZbyXylhdypPrzkg1Bq
         yiOPs1SOh8z9IFNzsHjK4jK4OAWiPQIbX4K3dmls=
Date:   Tue, 13 Jul 2021 15:41:31 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, brouer@redhat.com, chuck.lever@oracle.com,
        mgorman@techsingularity.net, mhocko@kernel.org, mingo@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        tglx@linutronix.de, vbabka@suse.cz
Subject:  [merged]
 mm-page_alloc-revert-pahole-zero-sized-workaround.patch removed from -mm
 tree
Message-ID: <20210713224131.wTxYl5alO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: Revert pahole zero-sized workaround
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-revert-pahole-zero-sized-workaround.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: Revert pahole zero-sized workaround

Commit dbbee9d5cd83 ("mm/page_alloc: convert per-cpu list protection to
local_lock") folded in a workaround patch for pahole that was unable to
deal with zero-sized percpu structures.  A superior workaround is achieved
with commit a0b8200d06ad ("kbuild: skip per-CPU BTF generation for pahole
v1.18-v1.21").  This patch reverts the dummy field and the pahole version
check.

Link: https://lkml.kernel.org/r/20210705095117.GM3840@techsingularity.net
Fixes: dbbee9d5cd83 ("mm/page_alloc: convert per-cpu list protection to local_lock")
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Chuck Lever III <chuck.lever@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    3 ---
 mm/page_alloc.c   |   11 -----------
 2 files changed, 14 deletions(-)

--- a/lib/Kconfig.debug~mm-page_alloc-revert-pahole-zero-sized-workaround
+++ a/lib/Kconfig.debug
@@ -313,9 +313,6 @@ config DEBUG_INFO_BTF
 config PAHOLE_HAS_SPLIT_BTF
 	def_bool $(success, test `$(PAHOLE) --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/'` -ge "119")
 
-config PAHOLE_HAS_ZEROSIZE_PERCPU_SUPPORT
-	def_bool $(success, test `$(PAHOLE) --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/'` -ge "122")
-
 config DEBUG_INFO_BTF_MODULES
 	def_bool y
 	depends on DEBUG_INFO_BTF && MODULES && PAHOLE_HAS_SPLIT_BTF
--- a/mm/page_alloc.c~mm-page_alloc-revert-pahole-zero-sized-workaround
+++ a/mm/page_alloc.c
@@ -124,17 +124,6 @@ static DEFINE_MUTEX(pcp_batch_high_lock)
 
 struct pagesets {
 	local_lock_t lock;
-#if defined(CONFIG_DEBUG_INFO_BTF) &&				\
-	!defined(CONFIG_DEBUG_LOCK_ALLOC) &&			\
-	!defined(CONFIG_PAHOLE_HAS_ZEROSIZE_PERCPU_SUPPORT)
-	/*
-	 * pahole 1.21 and earlier gets confused by zero-sized per-CPU
-	 * variables and produces invalid BTF. Ensure that
-	 * sizeof(struct pagesets) != 0 for older versions of pahole.
-	 */
-	char __pahole_hack;
-	#warning "pahole too old to support zero-sized struct pagesets"
-#endif
 };
 static DEFINE_PER_CPU(struct pagesets, pagesets) = {
 	.lock = INIT_LOCAL_LOCK(lock),
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-avoid-page-allocator-recursion-with-pagesetslock-held.patch

