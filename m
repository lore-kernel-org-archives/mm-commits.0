Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E42EC4361B
	for <mm-commits@archiver.kernel.org>; Sun, 20 Dec 2020 01:41:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E0BA23A00
	for <mm-commits@archiver.kernel.org>; Sun, 20 Dec 2020 01:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgLTBlZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 19 Dec 2020 20:41:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:42736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726898AbgLTBlZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 19 Dec 2020 20:41:25 -0500
Date:   Sat, 19 Dec 2020 17:40:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608428444;
        bh=DX8V1F8ANt9kNILClfZtV8RZy3PJfiXF0UWt+5EqNrs=;
        h=From:To:Subject:From;
        b=y5YkVYS0usllJIRDJE1FsNi/lhzKJM98BT5sb79neBVzfx0AdFduVhKYmrO0bnNJC
         J55zT8WSJKFnR717I/F5TfLdMETKG6XaoH2+6kohlNRYsGVAQPpgcDNogDv/FvB/Nb
         rt+fJciC6zWkRkx0+N5Z+XOYrLAoAjrFqDtb4Bys=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will.deacon@arm.com,
        vincenzo.frascino@arm.com, kevin.brodsky@arm.com,
        gor@linux.ibm.com, glider@google.com, eugenis@google.com,
        elver@google.com, dvyukov@google.com, catalin.marinas@arm.com,
        Branislav.Rankov@arm.com, aryabinin@virtuozzo.com,
        andreyknvl@google.com, akpm@linux-foundation.org
Subject:  [folded-merged]
 kasan-arm64-implement-hw_tags-runtime-fix.patch removed from -mm tree
Message-ID: <20201220014044.JfWCL%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-arm64-implement-hw_tags-runtime-fix
has been removed from the -mm tree.  Its filename was
     kasan-arm64-implement-hw_tags-runtime-fix.patch

This patch was dropped because it was folded into kasan-arm64-implement-hw_tags-runtime.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kasan-arm64-implement-hw_tags-runtime-fix

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

 mm/kasan/hw_tags.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/mm/kasan/hw_tags.c~kasan-arm64-implement-hw_tags-runtime-fix
+++ a/mm/kasan/hw_tags.c
@@ -10,7 +10,6 @@
 
 #include <linux/kasan.h>
 #include <linux/kernel.h>
-#include <linux/kfence.h>
 #include <linux/memory.h>
 #include <linux/mm.h>
 #include <linux/string.h>
@@ -38,20 +37,12 @@ void *kasan_reset_tag(const void *addr)
 
 void poison_range(const void *address, size_t size, u8 value)
 {
-	/* Skip KFENCE memory if called explicitly outside of sl*b. */
-	if (is_kfence_address(address))
-		return;
-
 	hw_set_mem_tag_range(reset_tag(address),
 			round_up(size, KASAN_GRANULE_SIZE), value);
 }
 
 void unpoison_range(const void *address, size_t size)
 {
-	/* Skip KFENCE memory if called explicitly outside of sl*b. */
-	if (is_kfence_address(address))
-		return;
-
 	hw_set_mem_tag_range(reset_tag(address),
 			round_up(size, KASAN_GRANULE_SIZE), get_tag(address));
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-arm64-implement-hw_tags-runtime.patch
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

