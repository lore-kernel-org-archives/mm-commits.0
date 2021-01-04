Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CEFBC433E0
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 21:03:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7F3C207B0
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 21:03:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbhADVD0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Jan 2021 16:03:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:37618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725921AbhADVD0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 4 Jan 2021 16:03:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF49E216C4;
        Mon,  4 Jan 2021 21:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609794165;
        bh=AoF6CUse/6REJ6mrf3edEvskIc8P1k8xOr0kcM0/zZs=;
        h=Date:From:To:Subject:From;
        b=A3+8Ctg3XPQZ7ImGdfqLvntxVkUVF0Vk6x3bIy9Lep75mErhvsrzeShIEYpyMsRPt
         et/GKe/g2/hQY3WnHW72uX5KElb4ysEUeiCxQzfv+Lmx5TlRgWvKXBcGDGY7th13qN
         5/RH0oUZU0+JKx3b+FjJVKKeNp9j2/CBrkCCVF+s=
Date:   Mon, 04 Jan 2021 13:02:44 -0800
From:   akpm@linux-foundation.org
To:     aryabinin@virtuozzo.com, dan.j.williams@intel.com,
        dvyukov@google.com, glider@google.com, lecopzer.chen@mediatek.com,
        lecopzer@gmail.com, mm-commits@vger.kernel.org,
        yj.chiang@mediatek.com
Subject:  +
 kasan-fix-unaligned-address-is-unhandled-in-kasan_remove_zero_shadow.patch
 added to -mm tree
Message-ID: <20210104210244.Vu5o0IsWt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix unaligned address is unhandled in kasan_remove_zero_shadow
has been added to the -mm tree.  Its filename is
     kasan-fix-unaligned-address-is-unhandled-in-kasan_remove_zero_shadow.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-fix-unaligned-address-is-unhandled-in-kasan_remove_zero_shadow.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-fix-unaligned-address-is-unhandled-in-kasan_remove_zero_shadow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lecopzer Chen <lecopzer@gmail.com>
Subject: kasan: fix unaligned address is unhandled in kasan_remove_zero_shadow

During testing kasan_populate_early_shadow and kasan_remove_zero_shadow,
if the shadow start and end address in kasan_remove_zero_shadow() is not
aligned to PMD_SIZE, the remain unaligned PTE won't be removed.

In the test case for kasan_remove_zero_shadow():
    shadow_start: 0xffffffb802000000, shadow end: 0xffffffbfbe000000
    3-level page table:
      PUD_SIZE: 0x40000000 PMD_SIZE: 0x200000 PAGE_SIZE: 4K
0xffffffbf80000000 ~ 0xffffffbfbdf80000 will not be removed because
in kasan_remove_pud_table(), kasan_pmd_table(*pud) is true but the
next address is 0xffffffbfbdf80000 which is not aligned to PUD_SIZE.

In the correct condition, this should fallback to the next level
kasan_remove_pmd_table() but the condition flow always continue to skip
the unaligned part.

Fix by correcting the condition when next and addr are neither aligned.

Link: https://lkml.kernel.org/r/20210103135621.83129-1-lecopzer@gmail.com
Fixes: 0207df4fa1a86 ("kernel/memremap, kasan: make ZONE_DEVICE with work with KASAN")
Signed-off-by: Lecopzer Chen <lecopzer.chen@mediatek.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: YJ Chiang <yj.chiang@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/init.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/mm/kasan/init.c~kasan-fix-unaligned-address-is-unhandled-in-kasan_remove_zero_shadow
+++ a/mm/kasan/init.c
@@ -372,9 +372,10 @@ static void kasan_remove_pmd_table(pmd_t
 
 		if (kasan_pte_table(*pmd)) {
 			if (IS_ALIGNED(addr, PMD_SIZE) &&
-			    IS_ALIGNED(next, PMD_SIZE))
+			    IS_ALIGNED(next, PMD_SIZE)) {
 				pmd_clear(pmd);
-			continue;
+				continue;
+			}
 		}
 		pte = pte_offset_kernel(pmd, addr);
 		kasan_remove_pte_table(pte, addr, next);
@@ -397,9 +398,10 @@ static void kasan_remove_pud_table(pud_t
 
 		if (kasan_pmd_table(*pud)) {
 			if (IS_ALIGNED(addr, PUD_SIZE) &&
-			    IS_ALIGNED(next, PUD_SIZE))
+			    IS_ALIGNED(next, PUD_SIZE)) {
 				pud_clear(pud);
-			continue;
+				continue;
+			}
 		}
 		pmd = pmd_offset(pud, addr);
 		pmd_base = pmd_offset(pud, 0);
@@ -423,9 +425,10 @@ static void kasan_remove_p4d_table(p4d_t
 
 		if (kasan_pud_table(*p4d)) {
 			if (IS_ALIGNED(addr, P4D_SIZE) &&
-			    IS_ALIGNED(next, P4D_SIZE))
+			    IS_ALIGNED(next, P4D_SIZE)) {
 				p4d_clear(p4d);
-			continue;
+				continue;
+			}
 		}
 		pud = pud_offset(p4d, addr);
 		kasan_remove_pud_table(pud, addr, next);
@@ -456,9 +459,10 @@ void kasan_remove_zero_shadow(void *star
 
 		if (kasan_p4d_table(*pgd)) {
 			if (IS_ALIGNED(addr, PGDIR_SIZE) &&
-			    IS_ALIGNED(next, PGDIR_SIZE))
+			    IS_ALIGNED(next, PGDIR_SIZE)) {
 				pgd_clear(pgd);
-			continue;
+				continue;
+			}
 		}
 
 		p4d = p4d_offset(pgd, addr);
_

Patches currently in -mm which might be from lecopzer@gmail.com are

kasan-fix-unaligned-address-is-unhandled-in-kasan_remove_zero_shadow.patch

