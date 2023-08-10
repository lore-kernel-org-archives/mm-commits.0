Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57E6FC04A6A
	for <mm-commits@archiver.kernel.org>; Thu, 10 Aug 2023 16:40:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233148AbjHJQky (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Aug 2023 12:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjHJQkZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2023 12:40:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E260A8
        for <mm-commits@vger.kernel.org>; Thu, 10 Aug 2023 09:40:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B25B360C21
        for <mm-commits@vger.kernel.org>; Thu, 10 Aug 2023 16:40:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12EEC433C8;
        Thu, 10 Aug 2023 16:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691685624;
        bh=MO4/yx3yWbn2cCuvrhTF0qMt87S48s9lwlszhw2szR4=;
        h=Date:To:From:Subject:From;
        b=uA0ETIjiB/rs2nj4MANTFwNQCAZ+2J8sxm43Ch/pjHKkIsngXltYiVseLMyIMEEE4
         fYnZFmVk95GgMvCOtE1Khig3bWc4Ne37LcYbKddkLxLBIy1QEtl69KtpPIoE2UUn/D
         5C+rsIvLDOCWquc1TUaW1dLgC8tSTN+qZvOtY9aA=
Date:   Thu, 10 Aug 2023 09:40:23 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        will@kernel.org, wangkefeng.wang@huawei.com,
        pasha.tatashin@soleen.com, muchun.song@linux.dev,
        catalin.marinas@arm.com, qi.zheng@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-use-ptep_clear-instead-of-pte_clear-in-clear_flush.patch added to mm-unstable branch
Message-Id: <20230810164023.F12EEC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: mm: use ptep_clear() instead of pte_clear() in clear_flush()
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-mm-use-ptep_clear-instead-of-pte_clear-in-clear_flush.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-use-ptep_clear-instead-of-pte_clear-in-clear_flush.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Qi Zheng <qi.zheng@linux.dev>
Subject: arm64: mm: use ptep_clear() instead of pte_clear() in clear_flush()
Date: Thu, 10 Aug 2023 09:32:41 +0000


In clear_flush(), the original pte may be a present entry, so we should
use ptep_clear() to let page_table_check track the pte clearing operation,
otherwise it may cause false positive in subsequent set_pte_at().

Link: https://lkml.kernel.org/r/20230810093241.1181142-1-qi.zheng@linux.dev
Fixes: 42b2547137f5 ("arm64/mm: enable ARCH_SUPPORTS_PAGE_TABLE_CHECK")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/hugetlbpage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/mm/hugetlbpage.c~arm64-mm-use-ptep_clear-instead-of-pte_clear-in-clear_flush
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -236,7 +236,7 @@ static void clear_flush(struct mm_struct
 	unsigned long i, saddr = addr;
 
 	for (i = 0; i < ncontig; i++, addr += pgsize, ptep++)
-		pte_clear(mm, addr, ptep);
+		ptep_clear(mm, addr, ptep);
 
 	flush_tlb_range(&vma, saddr, addr);
 }
_

Patches currently in -mm which might be from qi.zheng@linux.dev are

arm64-mm-use-ptep_clear-instead-of-pte_clear-in-clear_flush.patch

