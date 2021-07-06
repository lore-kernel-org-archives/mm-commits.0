Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24DABC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 20:44:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 001E661C9C
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 20:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhGFUrT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 16:47:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229807AbhGFUrT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 16:47:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B729B61C85;
        Tue,  6 Jul 2021 20:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625604280;
        bh=uPxWk0Y0XBoZqIslbhUJFWCle1IJubSaIbh9QLwcFo8=;
        h=Date:From:To:Subject:From;
        b=Oy4f5LxOFgOOz34D3Ox4DfF7qJEAR235IpXIMGX9zEeDxnRylTtVTQNWeuZR8cp4+
         Z33LDYD5y72Ixt8ifLlHoyRIPI4MoXvs6oQrXWg0iJYO9cLHXDY8ZfK378CA5m1M4O
         UYf+9lOW3ZJae3WPGx9pmjdSUqhp5dupDQpN3stQ=
Date:   Tue, 06 Jul 2021 13:44:37 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, tglx@linutronix.de,
        peterz@infradead.org, mingo@kernel.org, mhocko@kernel.org,
        chuck.lever@oracle.com, brouer@redhat.com, bigeasy@linutronix.de,
        mgorman@techsingularity.net
Subject:  + mm-page_alloc-revert-pahole-zero-sized-workaround.patch
 added to -mm tree
Message-ID: <20210706204437.9HzPy%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: Revert pahole zero-sized workaround
has been added to the -mm tree.  Its filename is
     mm-page_alloc-revert-pahole-zero-sized-workaround.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-revert-pahole-zero-sized-workaround.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-revert-pahole-zero-sized-workaround.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-page_alloc-revert-pahole-zero-sized-workaround.patch

