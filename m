Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B06EC4361B
	for <mm-commits@archiver.kernel.org>; Sun, 20 Dec 2020 01:42:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4179323A9B
	for <mm-commits@archiver.kernel.org>; Sun, 20 Dec 2020 01:42:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbgLTBmw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 19 Dec 2020 20:42:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:42792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726624AbgLTBmw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 19 Dec 2020 20:42:52 -0500
Date:   Sat, 19 Dec 2020 17:42:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608428532;
        bh=LxDu8BGWWtkGx16/CNiu7UzqHnR/dZmeKbGhl7+oqFE=;
        h=From:To:Subject:From;
        b=WnU201mfKEAVb5+QH3XspMCr1nKf9cmUQenNSZa19zSMUT2WqajzHPPsPN/AnZzc8
         73u4CaVy5KNcGWlw4438rdmTVFRzfDthCet8hlkB/NXwzurNd31rx9swVZKMp+ic8T
         V02nkqxxEohi33nPwXVP3UhhARNr/Px1Kv6nL1nY=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org
Subject:  [obsolete] kasan-remove-kfence-leftovers.patch removed from
 -mm tree
Message-ID: <20201220014211.1vSVs%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: remove kfence leftovers
has been removed from the -mm tree.  Its filename was
     kasan-remove-kfence-leftovers.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kasan: remove kfence leftovers

These are remnants of patch series reordering and shouldn't have been
here.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h  |    9 ---------
 mm/kasan/shadow.c |   13 -------------
 2 files changed, 22 deletions(-)

--- a/mm/kasan/kasan.h~kasan-remove-kfence-leftovers
+++ a/mm/kasan/kasan.h
@@ -3,7 +3,6 @@
 #define __MM_KASAN_KASAN_H
 
 #include <linux/kasan.h>
-#include <linux/kfence.h>
 #include <linux/stackdepot.h>
 
 #ifdef CONFIG_KASAN_HW_TAGS
@@ -305,20 +304,12 @@ static inline u8 random_tag(void) { retu
 
 static inline void poison_range(const void *address, size_t size, u8 value)
 {
-	/* Skip KFENCE memory if called explicitly outside of sl*b. */
-	if (is_kfence_address(address))
-		return;
-
 	hw_set_mem_tag_range(kasan_reset_tag(address),
 			round_up(size, KASAN_GRANULE_SIZE), value);
 }
 
 static inline void unpoison_range(const void *address, size_t size)
 {
-	/* Skip KFENCE memory if called explicitly outside of sl*b. */
-	if (is_kfence_address(address))
-		return;
-
 	hw_set_mem_tag_range(kasan_reset_tag(address),
 			round_up(size, KASAN_GRANULE_SIZE), get_tag(address));
 }
--- a/mm/kasan/shadow.c~kasan-remove-kfence-leftovers
+++ a/mm/kasan/shadow.c
@@ -13,7 +13,6 @@
 #include <linux/init.h>
 #include <linux/kasan.h>
 #include <linux/kernel.h>
-#include <linux/kfence.h>
 #include <linux/kmemleak.h>
 #include <linux/memory.h>
 #include <linux/mm.h>
@@ -85,10 +84,6 @@ void poison_range(const void *address, s
 	address = kasan_reset_tag(address);
 	size = round_up(size, KASAN_GRANULE_SIZE);
 
-	/* Skip KFENCE memory if called explicitly outside of sl*b. */
-	if (is_kfence_address(address))
-		return;
-
 	shadow_start = kasan_mem_to_shadow(address);
 	shadow_end = kasan_mem_to_shadow(address + size);
 
@@ -106,14 +101,6 @@ void unpoison_range(const void *address,
 	 */
 	address = kasan_reset_tag(address);
 
-	/*
-	 * Skip KFENCE memory if called explicitly outside of sl*b. Also note
-	 * that calls to ksize(), where size is not a multiple of machine-word
-	 * size, would otherwise poison the invalid portion of the word.
-	 */
-	if (is_kfence_address(address))
-		return;
-
 	poison_range(address, size, tag);
 
 	if (size & KASAN_GRANULE_MASK) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
linux-next-rejects.patch
kmap-stupid-hacks-to-make-it-compile.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

