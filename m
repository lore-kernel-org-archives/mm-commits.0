Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1C6BC433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:54:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8709861458
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:54:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbhD3Fyt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:54:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230291AbhD3Fyt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:54:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12726613F8;
        Fri, 30 Apr 2021 05:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762040;
        bh=4a/XTG4LuO45vZLIU4A9hVkSTdNK7dU2jJuXDEyWLIs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=iB/HYSVKdLVVexZgp6cTc16wwbamgdbPY9rQrvPUBLVj2OSV+cCxf2/bxI36DYIW3
         upttfbP5eikFQImznU4FCzxOMrNBTWXIpjnuVY7qV1AwXHY1XJ7L/B6jolYsrr/11W
         uoUeA02oip29hIU/C+sdbrZst8QZBZ+ZFCAfvHo4=
Date:   Thu, 29 Apr 2021 22:53:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dalias@libc.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        ysato@users.osdn.me, zhang.yunkai@zte.com.cn
Subject:  [patch 015/178] arch/sh/include/asm/tlb.h: remove
 duplicate include
Message-ID: <20210430055359.Jbad4DY22%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
