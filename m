Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AAE7C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 23 Sep 2021 22:17:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E44926124E
	for <mm-commits@archiver.kernel.org>; Thu, 23 Sep 2021 22:17:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243431AbhIWWTX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Sep 2021 18:19:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243437AbhIWWTW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Sep 2021 18:19:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCE9861241;
        Thu, 23 Sep 2021 22:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632435470;
        bh=yP2eOgNxsDxv+SKNfzMYMH1aMsQ+XWPnhLORedaidkA=;
        h=Date:From:To:Subject:From;
        b=V64SqeDnF8V/0PXWTdiQmsTnr4tFZyZ4aQce4FgsBXToJenN62CnYHH6p+y0K3PEZ
         +znI12DHqUObdfRqQC+L5Te/nsM+zCntUUtPeMQkiapawb5FZV/KhASIXI3psjKr98
         iqgyHVFseQtLiAhvdziJmC8Ya0zH2IU1FeQ8Uvww=
Date:   Thu, 23 Sep 2021 15:17:49 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, dalias@libc.org, daniel@thingy.jp,
        geert+renesas@glider.be, jacopo+renesas@jmondi.org,
        mm-commits@vger.kernel.org, rob@landley.net, ysato@users.osdn.me
Subject:  +
 sh-pgtable-3level-fix-cast-to-pointer-from-integer-of-different-size.patch
 added to -mm tree
Message-ID: <20210923221749.v8L0APdcA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sh: pgtable-3level: fix cast to pointer from integer of different size
has been added to the -mm tree.  Its filename is
     sh-pgtable-3level-fix-cast-to-pointer-from-integer-of-different-size.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/sh-pgtable-3level-fix-cast-to-pointer-from-integer-of-different-size.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/sh-pgtable-3level-fix-cast-to-pointer-from-integer-of-different-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: sh: pgtable-3level: fix cast to pointer from integer of different size

If X2TLB=y (CPU_SHX2=y or CPU_SHX3=y, e.g. migor_defconfig), pgd_t.pgd
is "unsigned long long", causing:

    In file included from arch/sh/include/asm/pgtable.h:13,
		     from include/linux/pgtable.h:6,
		     from include/linux/mm.h:33,
		     from arch/sh/kernel/asm-offsets.c:14:
    arch/sh/include/asm/pgtable-3level.h: In function `pud_pgtable':
    arch/sh/include/asm/pgtable-3level.h:37:9: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
       37 |  return (pmd_t *)pud_val(pud);
	  |         ^

Fix this by adding an intermediate cast to "unsigned long", which is
basically what the old code did before.

Link: https://lkml.kernel.org/r/2c2eef3c9a2f57e5609100a4864715ccf253d30f.1631713483.git.geert+renesas@glider.be
Fixes: 9cf6fa2458443118 ("mm: rename pud_page_vaddr to pud_pgtable and make it return pmd_t *")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Daniel Palmer <daniel@thingy.jp>
Acked-by: Rob Landley <rob@landley.net>
Cc: Yoshinori Sato <ysato@users.osdn.me>
Cc: Rich Felker <dalias@libc.org>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/pgtable-3level.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sh/include/asm/pgtable-3level.h~sh-pgtable-3level-fix-cast-to-pointer-from-integer-of-different-size
+++ a/arch/sh/include/asm/pgtable-3level.h
@@ -34,7 +34,7 @@ typedef struct { unsigned long long pmd;
 
 static inline pmd_t *pud_pgtable(pud_t pud)
 {
-	return (pmd_t *)pud_val(pud);
+	return (pmd_t *)(unsigned long)pud_val(pud);
 }
 
 /* only used by the stubbed out hugetlb gup code, should never be called */
_

Patches currently in -mm which might be from geert+renesas@glider.be are

sh-pgtable-3level-fix-cast-to-pointer-from-integer-of-different-size.patch
mm-move-node_reclaim_distance-to-fix-numa-without-smp.patch
mm-move-fold_vm_numa_events-to-fix-numa-without-smp.patch

