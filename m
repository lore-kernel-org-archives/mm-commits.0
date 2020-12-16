Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7085C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:12:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BDD5233FE
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:12:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgLPRMV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:12:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:33200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726826AbgLPRMV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:12:21 -0500
Date:   Wed, 16 Dec 2020 09:12:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138725;
        bh=wURrN1UDYsSdVUDPz1STNsSwzkg8rUCpDwxthk1k2xE=;
        h=From:To:Subject:From;
        b=mZPkWJYdp+Q4TwuwMgqvHJOp3IsDtFIDulRArNeg7qiaHZAsSgrgHkJuLdX9Yeria
         nuToYUDHUpiTPJ4Ve3Ow9TpaQfGSgBXPiKT5xJ8FSgsQJh/RQUXQbh0S6nboFmNTyI
         Gg8ti00pZzKZ8nsrzxxnkhM/JPRPm2bM6pFOdkgA=
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, daniel@ffwll.ch, hch@lst.de,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [merged] mm-unexport-follow_pte_pmd.patch removed from
 -mm tree
Message-ID: <20201216171205.rT5-Q4REV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: unexport follow_pte_pmd
has been removed from the -mm tree.  Its filename was
     mm-unexport-follow_pte_pmd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: unexport follow_pte_pmd

Patch series "simplify follow_pte a bit".

This small series drops the not needed follow_pte_pmd exports, and
simplifies the follow_pte family of functions a bit.


This patch (of 2):

follow_pte_pmd() is only used by the DAX code, which can't be modular.

Link: https://lkml.kernel.org/r/20201029101432.47011-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/memory.c~mm-unexport-follow_pte_pmd
+++ a/mm/memory.c
@@ -4798,7 +4798,6 @@ int follow_pte_pmd(struct mm_struct *mm,
 						    ptepp, pmdpp, ptlp)));
 	return res;
 }
-EXPORT_SYMBOL(follow_pte_pmd);
 
 /**
  * follow_pfn - look up PFN at a user virtual address
_

Patches currently in -mm which might be from hch@lst.de are


