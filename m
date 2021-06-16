Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75FD1C48BE8
	for <mm-commits@archiver.kernel.org>; Wed, 16 Jun 2021 23:08:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5552960FF1
	for <mm-commits@archiver.kernel.org>; Wed, 16 Jun 2021 23:08:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234438AbhFPXKW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Jun 2021 19:10:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:45120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234424AbhFPXKU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Jun 2021 19:10:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BCED61027;
        Wed, 16 Jun 2021 23:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623884892;
        bh=P39LtQHx+eug+A8ntxfr6IVwDYBM8q6dTmfzzMVs4vc=;
        h=Date:From:To:Subject:From;
        b=U/oBrcCJyFismtRRrX9uNzG7aZ2bAEVxWNu0XrtZYOu1f/AxduAnmhmaTNVAZeP1S
         19ejq/B9FVBzSU72lF4AUIINzC+Juy9QTBURlyPH50mfxLGkhd4I/Gux6ISszX8TtR
         BROV22GljRr75nlAxQuImkXzKPXh5HtZTPzGuAvA=
Date:   Wed, 16 Jun 2021 16:08:12 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject:  [to-be-updated]
 mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t-fix.patch
 removed from -mm tree
Message-ID: <20210616230812.NNORSeb8w%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t-fix
has been removed from the -mm tree.  Its filename was
     mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t-fix

m68k build error reported by kernel robot.

  We may want to fixup pgd_page_vaddr correctly later. pgd_page_vaddr() gets
  cast to different pointer types based on architecture. But for now this
  should work? This ensure we keep the pgd_page_vaddr() same as before.

Link: https://lkml.kernel.org/r/87tulxnb2v.fsf@linux.ibm.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgtable-nop4d.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/asm-generic/pgtable-nop4d.h~mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t-fix
+++ a/include/asm-generic/pgtable-nop4d.h
@@ -42,7 +42,7 @@ static inline p4d_t *p4d_offset(pgd_t *p
 #define __p4d(x)				((p4d_t) { __pgd(x) })
 
 #define pgd_page(pgd)				(p4d_page((p4d_t){ pgd }))
-#define pgd_page_vaddr(pgd)			(p4d_pgtable((p4d_t){ pgd }))
+#define pgd_page_vaddr(pgd)			((unsigned long)(p4d_pgtable((p4d_t){ pgd })))
 
 /*
  * allocating and freeing a p4d is trivial: the 1-entry p4d is
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are


