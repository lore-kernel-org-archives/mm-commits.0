Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3AF1C2D0E4
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:04:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A18B223BAB
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgLRWEF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 17:04:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:36832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbgLRWEF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Dec 2020 17:04:05 -0500
Date:   Fri, 18 Dec 2020 14:03:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608329030;
        bh=2lgIsQoKW+rr7/1buXqUkMofgxltHlPWM9zrtbujye4=;
        h=From:To:Subject:In-Reply-To:From;
        b=a2vt7LKsSz7uZ9KWoi1Z1bzSHWdv+X/vgHwLGb+bi3dfQ66Mti0UN0c4iDcU0wF+z
         j/NFefRuXLDsOM8l9vzqgrg7Hm+HCgvswyo+TVC9+in7Y74X2qjknUgUMKM/c7+d/v
         vDUzxMFz/Hm7cnQ+h/dbTmw2vAH2fanRoHRemvNk=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, gor@linux.ibm.com,
        kevin.brodsky@arm.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [patch 44/78] arm64: kasan: align allocations for HW_TAGS
Message-ID: <20201218220349.LMfphKdBC%akpm@linux-foundation.org>
In-Reply-To: <20201218140046.497484741326828e5b5d46ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: arm64: kasan: align allocations for HW_TAGS

Hardware tag-based KASAN uses the memory tagging approach, which requires
all allocations to be aligned to the memory granule size.  Align the
allocations to MTE_GRANULE_SIZE via ARCH_SLAB_MINALIGN when
CONFIG_KASAN_HW_TAGS is enabled.

Link: https://lkml.kernel.org/r/fe64131606b1c2aabfd34ae99554c0d9df18eb19.1606161801.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
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

 arch/arm64/include/asm/cache.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm64/include/asm/cache.h~arm64-kasan-align-allocations-for-hw_tags
+++ a/arch/arm64/include/asm/cache.h
@@ -6,6 +6,7 @@
 #define __ASM_CACHE_H
 
 #include <asm/cputype.h>
+#include <asm/mte-kasan.h>
 
 #define CTR_L1IP_SHIFT		14
 #define CTR_L1IP_MASK		3
@@ -51,6 +52,8 @@
 
 #ifdef CONFIG_KASAN_SW_TAGS
 #define ARCH_SLAB_MINALIGN	(1ULL << KASAN_SHADOW_SCALE_SHIFT)
+#elif defined(CONFIG_KASAN_HW_TAGS)
+#define ARCH_SLAB_MINALIGN	MTE_GRANULE_SIZE
 #endif
 
 #ifndef __ASSEMBLY__
_
