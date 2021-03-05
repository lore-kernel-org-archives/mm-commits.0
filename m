Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0020EC433E6
	for <mm-commits@archiver.kernel.org>; Fri,  5 Mar 2021 01:46:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F8E56500D
	for <mm-commits@archiver.kernel.org>; Fri,  5 Mar 2021 01:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbhCEBqe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 4 Mar 2021 20:46:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:53626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229601AbhCEBqd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Mar 2021 20:46:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDD9C65009;
        Fri,  5 Mar 2021 01:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614908792;
        bh=RBIY3teTZ0yTEc4QZALrPcbK9HNJ8f1OG4uKzLXHuiU=;
        h=Date:From:To:Subject:From;
        b=Cx1u4zdTJuFxsHiSf8Q7S9CLcv7EnVtrYGfh5+4AUKAXLgHqC2G0LfBz23AklOhvj
         ppwaqVkflNx3YCunpP/AuQEpPfIIsaRCRm7Pis2VpNJzcDdMhXGI2zDHYIDdTUozZm
         qrPNVRL/meKRQ//G/upCGL0QpHfUeu8pHUVX3brQ=
Date:   Thu, 04 Mar 2021 17:46:31 -0800
From:   akpm@linux-foundation.org
To:     dalias@libc.org, mm-commits@vger.kernel.org, ysato@users.osdn.me,
        zhang.yunkai@zte.com.cn
Subject:  + sh-remove-duplicate-include-in-tlbh.patch added to -mm
 tree
Message-ID: <20210305014631.NN3xNV9pI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch/sh/include/asm/tlb.h: remove duplicate include
has been added to the -mm tree.  Its filename is
     sh-remove-duplicate-include-in-tlbh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/sh-remove-duplicate-include-in-tlbh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/sh-remove-duplicate-include-in-tlbh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

module-remove-duplicate-include-in-arch-ia64-kernel-heads.patch
sh-remove-duplicate-include-in-tlbh.patch

