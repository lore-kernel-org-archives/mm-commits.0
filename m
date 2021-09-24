Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72E2CC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 22:43:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CA6E61261
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 22:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345236AbhIXWpc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Sep 2021 18:45:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:44338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345162AbhIXWpb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Sep 2021 18:45:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 802CF61019;
        Fri, 24 Sep 2021 22:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632523437;
        bh=3kBd8Jjyx3uP8qgInDqocUbp+J+zxapq3zaaVjVChcY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=E4KAxqO6gYC6PB0+gbr3QajaBy5qHTVo6ljzA5fqcLODNcuZyz1xkOxPbxoKTZLwo
         W8Udwro9VhA6SGT+8GnDXM5g/OWRRzGkeHKl6jGob5l392k/33QSOwd3Dzi8tdtTsW
         l2Hy5qFaJoAj+zzqDcw68wsHDYo09D89XI0pCGXc=
Date:   Fri, 24 Sep 2021 15:43:57 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        dalias@libc.org, daniel@thingy.jp, geert+renesas@glider.be,
        jacopo+renesas@jmondi.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rob@landley.net,
        torvalds@linux-foundation.org, ysato@users.osdn.me
Subject:  [patch 13/16] sh: pgtable-3level: fix cast to pointer
 from integer of different size
Message-ID: <20210924224357.vxbK4xVVa%akpm@linux-foundation.org>
In-Reply-To: <20210924154257.1dbf6699ab8d88c0460f924f@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
