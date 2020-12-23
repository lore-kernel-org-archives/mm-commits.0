Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B8BEC4332B
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 18:29:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 200AA224B0
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 18:29:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbgLWS3n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Dec 2020 13:29:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:45292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728334AbgLWS3n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Dec 2020 13:29:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8379224B2;
        Wed, 23 Dec 2020 18:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608748128;
        bh=rlgNgPrBVTMARTQfSa8TIuqdjk81hFT4g0rk5zKHwCA=;
        h=Date:From:To:Subject:From;
        b=lhYXZVhIjSHPFs37VEwSC1iXS7ZRWCQQO6oUgPn2wVQGX3/Tw3gFx6701cl9jjzXj
         cHzHeMSnW6era+pvOnqs40pjauPj2DBDQ1BDZgE/zNcyoCYkO8xdJERMZgQhbUzXB/
         A6a5xUvw34AtarIDM19l4TQvppQwoYjR9lLQuxvQ=
Date:   Wed, 23 Dec 2020 10:28:47 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, gor@linux.ibm.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  [merged]
 kasan-arm64-rename-kasan_init_tags-and-mark-as-__init.patch removed from
 -mm tree
Message-ID: <20201223182847.zptQg4Osv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, arm64: rename kasan_init_tags and mark as __init
has been removed from the -mm tree.  Its filename was
     kasan-arm64-rename-kasan_init_tags-and-mark-as-__init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, arm64: rename kasan_init_tags and mark as __init

Rename kasan_init_tags() to kasan_init_sw_tags() as the upcoming hardware
tag-based KASAN mode will have its own initialization routine.  Also
similarly to kasan_init() mark kasan_init_tags() as __init.

Link: https://lkml.kernel.org/r/71e52af72a09f4b50c8042f16101c60e50649fbb.1606161801.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Tested-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Marco Elver <elver@google.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/setup.c  |    2 +-
 arch/arm64/mm/kasan_init.c |    2 +-
 include/linux/kasan.h      |    4 ++--
 mm/kasan/sw_tags.c         |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

--- a/arch/arm64/kernel/setup.c~kasan-arm64-rename-kasan_init_tags-and-mark-as-__init
+++ a/arch/arm64/kernel/setup.c
@@ -358,7 +358,7 @@ void __init __no_sanitize_address setup_
 	smp_build_mpidr_hash();
 
 	/* Init percpu seeds for random tags after cpus are set up. */
-	kasan_init_tags();
+	kasan_init_sw_tags();
 
 #ifdef CONFIG_ARM64_SW_TTBR0_PAN
 	/*
--- a/arch/arm64/mm/kasan_init.c~kasan-arm64-rename-kasan_init_tags-and-mark-as-__init
+++ a/arch/arm64/mm/kasan_init.c
@@ -283,7 +283,7 @@ void __init kasan_init(void)
 	kasan_init_shadow();
 	kasan_init_depth();
 #if defined(CONFIG_KASAN_GENERIC)
-	/* CONFIG_KASAN_SW_TAGS also requires kasan_init_tags(). */
+	/* CONFIG_KASAN_SW_TAGS also requires kasan_init_sw_tags(). */
 	pr_info("KernelAddressSanitizer initialized\n");
 #endif
 }
--- a/include/linux/kasan.h~kasan-arm64-rename-kasan_init_tags-and-mark-as-__init
+++ a/include/linux/kasan.h
@@ -192,7 +192,7 @@ static inline void kasan_record_aux_stac
 
 #ifdef CONFIG_KASAN_SW_TAGS
 
-void kasan_init_tags(void);
+void __init kasan_init_sw_tags(void);
 
 void *kasan_reset_tag(const void *addr);
 
@@ -201,7 +201,7 @@ bool kasan_report(unsigned long addr, si
 
 #else /* CONFIG_KASAN_SW_TAGS */
 
-static inline void kasan_init_tags(void) { }
+static inline void kasan_init_sw_tags(void) { }
 
 static inline void *kasan_reset_tag(const void *addr)
 {
--- a/mm/kasan/sw_tags.c~kasan-arm64-rename-kasan_init_tags-and-mark-as-__init
+++ a/mm/kasan/sw_tags.c
@@ -35,7 +35,7 @@
 
 static DEFINE_PER_CPU(u32, prng_state);
 
-void kasan_init_tags(void)
+void __init kasan_init_sw_tags(void)
 {
 	int cpu;
 
_

Patches currently in -mm which might be from andreyknvl@google.com are


