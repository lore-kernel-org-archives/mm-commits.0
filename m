Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1805C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:39:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A441F610D2
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbhEHWk0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:40:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEHWkZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:40:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87333613E8;
        Sat,  8 May 2021 22:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513563;
        bh=RZifiiMCF2nzOViT7T8JTSYHOFNWN0bYFv2g1+q00OA=;
        h=Date:From:To:Subject:From;
        b=i62VjtEwcHt3fAyQD2Ujdv28NP2+OuEsZde+neNwv2iRLVCcKOz4ZqqP7nw+j1Ckt
         t8VjSXDcT/r7pjkGGuPIQzd0dopWQExrw6yoh20H0DNl0ACyuMgVCwlb/7h94oGHq5
         N9GeevsZhyU6HRxlQEudo9WTCQstBQVBj4+ovNjA=
Date:   Sat, 08 May 2021 15:39:23 -0700
From:   akpm@linux-foundation.org
To:     dalias@libc.org, mm-commits@vger.kernel.org, ysato@users.osdn.me,
        zhang.yunkai@zte.com.cn
Subject:  [merged] sh-remove-duplicate-include-in-tlbh.patch
 removed from -mm tree
Message-ID: <20210508223923.ppp1daZM3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch/sh/include/asm/tlb.h: remove duplicate include
has been removed from the -mm tree.  Its filename was
     sh-remove-duplicate-include-in-tlbh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yunkai <zhang.yunkai@zte.com.cn>
Subject: arch/sh/include/asm/tlb.h: remove duplicate include

'asm-generic/tlb.h' included in 'asm/tlb.h' is duplicated.

Link: https://lkml.kernel.org/r/20210304132020.196811-1-zhang.yunkai@zte.com.cn
Signed-off-by: Zhang Yunkai <zhang.yunkai@zte.com.cn>
Cc: Yoshinori Sato <ysato@users.osdn.me>
Cc: Rich Felker <dalias@libc.org>
Cc: Zhang Yunkai <zhang.yunkai@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/tlb.h |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/arch/sh/include/asm/tlb.h~sh-remove-duplicate-include-in-tlbh
+++ a/arch/sh/include/asm/tlb.h
@@ -4,12 +4,11 @@
 
 #ifndef __ASSEMBLY__
 #include <linux/pagemap.h>
+#include <asm-generic/tlb.h>
 
 #ifdef CONFIG_MMU
 #include <linux/swap.h>
 
-#include <asm-generic/tlb.h>
-
 #if defined(CONFIG_CPU_SH4)
 extern void tlb_wire_entry(struct vm_area_struct *, unsigned long, pte_t);
 extern void tlb_unwire_entry(void);
@@ -24,12 +23,7 @@ static inline void tlb_unwire_entry(void
 {
 	BUG();
 }
-#endif
-
-#else /* CONFIG_MMU */
-
-#include <asm-generic/tlb.h>
-
+#endif /* CONFIG_CPU_SH4 */
 #endif /* CONFIG_MMU */
 #endif /* __ASSEMBLY__ */
 #endif /* __ASM_SH_TLB_H */
_

Patches currently in -mm which might be from zhang.yunkai@zte.com.cn are


