Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 884F7C433E9
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 02:11:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64A3F22DA7
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 02:11:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbhAQCLd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 16 Jan 2021 21:11:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:41546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727786AbhAQCLc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 16 Jan 2021 21:11:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EA8122CF8;
        Sun, 17 Jan 2021 02:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610849451;
        bh=STv9o+g/zCFlmSZPSl9ayIW12eDVDjzSoPeqimZLU9c=;
        h=Date:From:To:Subject:From;
        b=O2C1NHuI5p0f9TlPXBG9RLHTtqpMcGNuWjsDf8qQjkf6OdyaYy0WbEZ+PuECm6XZL
         hJhbmnYKkYCIinfNtq7TmweWkrlfM1L+fw1giINBFQ2PmiwyR3ZBdDtTre4SGgum2I
         16pkvVkRv0DeyaEuBLRzeLTPMEv3p9SyimQK3tyo=
Date:   Sat, 16 Jan 2021 18:10:51 -0800
From:   akpm@linux-foundation.org
To:     ardb@kernel.org, aryabinin@virtuozzo.com, dvyukov@google.com,
        glider@google.com, guo.ziliang@zte.com.cn,
        linus.walleij@linaro.org, linux@armlinux.org.uk,
        liu.hailong6@zte.com.cn, mm-commits@vger.kernel.org
Subject:  [merged]
 arm-kasan-fix-the-arry-size-of-kasan_early_shadow_pte.patch removed from
 -mm tree
Message-ID: <20210117021051.I96_9w_z3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm/kasan: fix the array size of kasan_early_shadow_pte[]
has been removed from the -mm tree.  Its filename was
     arm-kasan-fix-the-arry-size-of-kasan_early_shadow_pte.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Hailong Liu <liu.hailong6@zte.com.cn>
Subject: arm/kasan: fix the array size of kasan_early_shadow_pte[]

The size of kasan_early_shadow_pte[] now is PTRS_PER_PTE which defined to
512 for arm architecture.  This means that it only covers the prev Linux
pte entries, but not the HWTABLE pte entries for arm.

The reason it works well current is that the symbol
kasan_early_shadow_page immediately following kasan_early_shadow_pte in
memory is page aligned, which makes kasan_early_shadow_pte look like a 4KB
size array.  But we can't ensure the order always right with different
compiler/linker, nor more bss symbols be introduced.

We had a test with QEMU + vexpress=EF=BC=9Aput a 512KB-size symbol with
attribute __section(".bss..page_aligned") after kasan_early_shadow_pte,
and poison it after kasan_early_init().  Then enabled CONFIG_KASAN, it
failed to boot up.

Link: https://lkml.kernel.org/r/20210109044622.8312-1-hailongliiu@yeah.net
Signed-off-by: Hailong Liu <liu.hailong6@zte.com.cn>
Signed-off-by: Ziliang Guo <guo.ziliang@zte.com.cn>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |    6 +++++-
 mm/kasan/init.c       |    3 ++-
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/include/linux/kasan.h~arm-kasan-fix-the-arry-size-of-kasan_early_shad=
ow_pte
+++ a/include/linux/kasan.h
@@ -35,8 +35,12 @@ struct kunit_kasan_expectation {
 #define KASAN_SHADOW_INIT 0
 #endif
=20
+#ifndef PTE_HWTABLE_PTRS
+#define PTE_HWTABLE_PTRS 0
+#endif
+
 extern unsigned char kasan_early_shadow_page[PAGE_SIZE];
-extern pte_t kasan_early_shadow_pte[PTRS_PER_PTE];
+extern pte_t kasan_early_shadow_pte[PTRS_PER_PTE + PTE_HWTABLE_PTRS];
 extern pmd_t kasan_early_shadow_pmd[PTRS_PER_PMD];
 extern pud_t kasan_early_shadow_pud[PTRS_PER_PUD];
 extern p4d_t kasan_early_shadow_p4d[MAX_PTRS_PER_P4D];
--- a/mm/kasan/init.c~arm-kasan-fix-the-arry-size-of-kasan_early_shadow_pte
+++ a/mm/kasan/init.c
@@ -64,7 +64,8 @@ static inline bool kasan_pmd_table(pud_t
 	return false;
 }
 #endif
-pte_t kasan_early_shadow_pte[PTRS_PER_PTE] __page_aligned_bss;
+pte_t kasan_early_shadow_pte[PTRS_PER_PTE + PTE_HWTABLE_PTRS]
+	__page_aligned_bss;
=20
 static inline bool kasan_pte_table(pmd_t pmd)
 {
_

Patches currently in -mm which might be from liu.hailong6@zte.com.cn are


