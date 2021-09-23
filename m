Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1C96C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 23 Sep 2021 23:17:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABF546124E
	for <mm-commits@archiver.kernel.org>; Thu, 23 Sep 2021 23:17:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243577AbhIWXT3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Sep 2021 19:19:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243572AbhIWXT2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Sep 2021 19:19:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D315460E94;
        Thu, 23 Sep 2021 23:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632439076;
        bh=zC4WELt1aWat3HrF8eNtNwlfGZ/qu9o2nJhPeh5ymFM=;
        h=Date:From:To:Subject:From;
        b=H3Qp0i+V7xUIHNWgThLUDhW1xlSCx0hJB+84FOznSIDCi+vSnXmYvnCJhdHPxdm62
         U9sFCc2vHPHdUiw6NcE0Xe1z9BoHqcKLk+3MRodCWFQZfxPvxW8o+DwBoqHrpQrUDU
         5i6jxhVEUng1rMYZeM1rmnyMX+a5Hr9Ut2z+M32o=
Date:   Thu, 23 Sep 2021 16:17:55 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, songmuchun@bytedance.com,
        zhengqi.arch@bytedance.com
Subject:  + mm-memory_failure-fix-the-missing-pte_unmap-call.patch
 added to -mm tree
Message-ID: <20210923231755.9fkqpZykA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_failure: fix the missing pte_unmap() call
has been added to the -mm tree.  Its filename is
     mm-memory_failure-fix-the-missing-pte_unmap-call.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_failure-fix-the-missing-pte_unmap-call.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_failure-fix-the-missing-pte_unmap-call.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm/memory_failure: fix the missing pte_unmap() call

The paired pte_unmap() call is missing before the
dev_pagemap_mapping_shift() returns.  So fix it.

Davidsaid "I guess this code never runs on 32bit / highmem, that's why we
didn't notice so far".

Link: https://lkml.kernel.org/r/20210923122642.4999-1-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c~mm-memory_failure-fix-the-missing-pte_unmap-call
+++ a/mm/memory-failure.c
@@ -306,6 +306,7 @@ static unsigned long dev_pagemap_mapping
 		struct vm_area_struct *vma)
 {
 	unsigned long address = vma_address(page, vma);
+	unsigned long ret = 0;
 	pgd_t *pgd;
 	p4d_t *p4d;
 	pud_t *pud;
@@ -330,10 +331,12 @@ static unsigned long dev_pagemap_mapping
 		return PMD_SHIFT;
 	pte = pte_offset_map(pmd, address);
 	if (!pte_present(*pte))
-		return 0;
+		goto unmap;
 	if (pte_devmap(*pte))
-		return PAGE_SHIFT;
-	return 0;
+		ret = PAGE_SHIFT;
+unmap:
+	pte_unmap(pte);
+	return ret;
 }
 
 /*
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-memory_failure-fix-the-missing-pte_unmap-call.patch
mm-introduce-pmd_install-helper.patch
mm-remove-redundant-smp_wmb.patch

