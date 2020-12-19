Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5926AC4361B
	for <mm-commits@archiver.kernel.org>; Sat, 19 Dec 2020 01:14:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21E0B23BCC
	for <mm-commits@archiver.kernel.org>; Sat, 19 Dec 2020 01:14:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgLSBOl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 20:14:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:37398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725879AbgLSBOl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Dec 2020 20:14:41 -0500
Date:   Fri, 18 Dec 2020 17:14:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608340440;
        bh=BW6XthPkSP0iPy7eUIGYmbXYfRUrg4NQFRrREnobjeg=;
        h=From:To:Subject:From;
        b=RJ5rFiE0wWCzYqorEBOLLTcJhyb0w3+BycuSSZeW28rLsc7swcehCDFGeL6MGtGYI
         aJmmx5e9el+vQLUFgd3Y1QijWZ0BbE5wpH/aPjNEejmEYf18rEWqMz0n7D23IHGPPU
         zVR3z8AvyFvlx/itqeR4YRsibXwnnonS7CUlTA/g=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org
Subject:  + kasan-remove-kfence-leftovers.patch added to -mm tree
Message-ID: <20201219011400.nREh3%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: remove kfence leftovers
has been added to the -mm tree.  Its filename is
     kasan-remove-kfence-leftovers.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-remove-kfence-leftovers.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-remove-kfence-leftovers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kasan-remove-kfence-leftovers.patch
mm.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
kmap-stupid-hacks-to-make-it-compile.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

