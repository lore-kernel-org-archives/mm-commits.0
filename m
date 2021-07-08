Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6E36C07E95
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:10:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C17DC61CD1
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:10:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhGHBMv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 21:12:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:53136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230123AbhGHBMu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Jul 2021 21:12:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD38461CCC;
        Thu,  8 Jul 2021 01:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625706610;
        bh=JtMOv2EapD7UuAYgxjwfH1jNLt0Cvkm2q1slpZ4cydM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=p7ZYH+DNLKcePQjmXjiBiC/KSv20NdDy2nnlwJ7t4LsrrvdH9zZrDIyIm8893ruSw
         8nYyKOkN5O9kQ8Jn6iozPIMx3jf8q69deBS+ycaSPvNSgU7sD1RP/tAO8RagMd0p87
         pPB4lWdgsJVBryhrXEEd1X1j3Pb3xyRuhc3+Ozd4=
Date:   Wed, 07 Jul 2021 18:10:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        christophe.leroy@csgroup.eu, hughd@google.com,
        joel@joelfernandes.org, kaleshsingh@google.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com,
        sfr@canb.auug.org.au, torvalds@linux-foundation.org
Subject:  [patch 49/54] mm/mremap: don't enable optimized PUD move
 if page table levels is 2
Message-ID: <20210708011009.n3XfmL2Xv%akpm@linux-foundation.org>
In-Reply-To: <20210707175950.eceddb86c6c555555d4730e2@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/mremap: don't enable optimized PUD move if page table levels is 2

With two level page table don't enable move_normal_pud.

Link: https://lkml.kernel.org/r/20210616045239.370802-5-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mremap.c~mm-mremap-dont-enable-optimized-pud-move-if-page-table-levels-is-2
+++ a/mm/mremap.c
@@ -276,7 +276,7 @@ static inline bool move_normal_pmd(struc
 }
 #endif
 
-#ifdef CONFIG_HAVE_MOVE_PUD
+#if CONFIG_PGTABLE_LEVELS > 2 && defined(CONFIG_HAVE_MOVE_PUD)
 static bool move_normal_pud(struct vm_area_struct *vma, unsigned long old_addr,
 		  unsigned long new_addr, pud_t *old_pud, pud_t *new_pud)
 {
_
