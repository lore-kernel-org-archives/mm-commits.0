Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 164EAC433E6
	for <mm-commits@archiver.kernel.org>; Tue, 12 Jan 2021 06:19:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFA892158C
	for <mm-commits@archiver.kernel.org>; Tue, 12 Jan 2021 06:19:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730763AbhALGTS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Jan 2021 01:19:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:50702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730742AbhALGTS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 12 Jan 2021 01:19:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C82DF2075B;
        Tue, 12 Jan 2021 06:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610432317;
        bh=3iItwlilf/TCK/NQscP4WXq4gYrI1OanzAbWwBr2SRg=;
        h=Date:From:To:Subject:From;
        b=Fd+BOpSPjZhhjwlT/NbW7uyntr2MEirKm9eEqX4AT/jllOFk5RdbU2MY1wUxtguCw
         vbtOsiY+X7dnKkMnX9dSefu7w9rlxCVa30pwIz4mduDgJXtazSULDT2aQz1BocKe1P
         avZewO6eFBC1xHmr/xPsu17NjwtHxjEWEGAr7vOE=
Date:   Mon, 11 Jan 2021 22:18:36 -0800
From:   akpm@linux-foundation.org
To:     ardb@kernel.org, aryabinin@virtuozzo.com, dvyukov@google.com,
        glider@google.com, guo.ziliang@zte.com.cn,
        linus.walleij@linaro.org, linux@armlinux.org.uk,
        liu.hailong6@zte.com.cn, mm-commits@vger.kernel.org
Subject:  +
 arm-kasan-fix-the-arry-size-of-kasan_early_shadow_pte.patch added to -mm
 tree
Message-ID: <20210112061836.05lDpBsfp%akpm@linux-foundation.org>
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
has been added to the -mm tree.  Its filename is
     arm-kasan-fix-the-arry-size-of-kasan_early_shadow_pte.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm-kasan-fix-the-arry-size-o=
f-kasan_early_shadow_pte.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm-kasan-fix-the-arry-size-o=
f-kasan_early_shadow_pte.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-page_alloc-add-a-missing-mm_page_alloc_zone_locked-tracepoint.patch
arm-kasan-fix-the-arry-size-of-kasan_early_shadow_pte.patch

