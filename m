Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E66EC4361B
	for <mm-commits@archiver.kernel.org>; Sun, 20 Dec 2020 01:41:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EAD123A9C
	for <mm-commits@archiver.kernel.org>; Sun, 20 Dec 2020 01:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgLTBlA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 19 Dec 2020 20:41:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:42710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726732AbgLTBlA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 19 Dec 2020 20:41:00 -0500
Date:   Sat, 19 Dec 2020 17:40:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608428420;
        bh=gbLjj0YK8yucQ1zIU7wz83RhxjMITVomggNqzNxC26g=;
        h=From:To:Subject:From;
        b=J/AjxHVFqEf5l16A/az0FjiZMGVFYZa0rkODyB40rG2HzVZUI739uSedzOM6eezjC
         JXJUfR+1ZTjy2lWnajZOPHnBsJs90/k4ScIjyjvThk+rQ5lRB7kKkRnZAHx0IanPFT
         Cc7vpSy8YiIftZRcXeuYvWTKBNfJvbYEgJ3pEqNY=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will.deacon@arm.com,
        vincenzo.frascino@arm.com, kevin.brodsky@arm.com,
        gor@linux.ibm.com, glider@google.com, eugenis@google.com,
        elver@google.com, dvyukov@google.com, catalin.marinas@arm.com,
        Branislav.Rankov@arm.com, aryabinin@virtuozzo.com,
        andreyknvl@google.com, akpm@linux-foundation.org
Subject:  [folded-merged]
 kasan-split-out-shadowc-from-commonc-fix.patch removed from -mm tree
Message-ID: <20201220014019.b5_2W%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-split-out-shadowc-from-commonc-fix
has been removed from the -mm tree.  Its filename was
     kasan-split-out-shadowc-from-commonc-fix.patch

This patch was dropped because it was folded into kasan-split-out-shadowc-from-commonc.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kasan-split-out-shadowc-from-commonc-fix

Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Marco Elver <elver@google.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/shadow.c |   13 -------------
 1 file changed, 13 deletions(-)

--- a/mm/kasan/shadow.c~kasan-split-out-shadowc-from-commonc-fix
+++ a/mm/kasan/shadow.c
@@ -13,7 +13,6 @@
 #include <linux/init.h>
 #include <linux/kasan.h>
 #include <linux/kernel.h>
-#include <linux/kfence.h>
 #include <linux/kmemleak.h>
 #include <linux/memory.h>
 #include <linux/mm.h>
@@ -84,10 +83,6 @@ void poison_range(const void *address, s
 	 */
 	address = reset_tag(address);
 
-	/* Skip KFENCE memory if called explicitly outside of sl*b. */
-	if (is_kfence_address(address))
-		return;
-
 	shadow_start = kasan_mem_to_shadow(address);
 	shadow_end = kasan_mem_to_shadow(address + size);
 
@@ -105,14 +100,6 @@ void unpoison_range(const void *address,
 	 */
 	address = reset_tag(address);
 
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

kasan-split-out-shadowc-from-commonc.patch
kasan-arm64-implement-hw_tags-runtime-fix.patch
kasan-remove-kfence-leftovers.patch
mm.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
linux-next-rejects.patch
kmap-stupid-hacks-to-make-it-compile.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

