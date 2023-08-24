Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E751CC3DA6F
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244086AbjHXXWd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244046AbjHXXWA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:22:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E67A1
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:21:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92BC362D48
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:21:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC641C433C8;
        Thu, 24 Aug 2023 23:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919318;
        bh=BuGSGav+zvVqOKyFa+SPps2fy2dds+/j2dnVKYJzt/U=;
        h=Date:To:From:Subject:From;
        b=PAsKLaE5Vt4f0CajkqUlyizgcH/KDjc6q47ZevXNlO6Q075VoOvWOKmFm3wPxaHlX
         Sh2WLf9xSNxS/oODDQ4wprTJkA5EFKmb9JA7mlB4MDyTBoFjrh01YlkDNNxpPdktMn
         Yo6oZE+CTtwSV/K3f6Wcf3L9QMHOu/cl8x7Vynis=
Date:   Thu, 24 Aug 2023 16:21:57 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        wangkefeng.wang@huawei.com, pasha.tatashin@soleen.com,
        muchun.song@linux.dev, catalin.marinas@arm.com,
        zhengqi.arch@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-mm-use-ptep_clear-instead-of-pte_clear-in-clear_flush.patch removed from -mm tree
Message-Id: <20230824232157.EC641C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arm64: mm: use ptep_clear() instead of pte_clear() in clear_flush()
has been removed from the -mm tree.  Its filename was
     arm64-mm-use-ptep_clear-instead-of-pte_clear-in-clear_flush.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: arm64: mm: use ptep_clear() instead of pte_clear() in clear_flush()
Date: Thu, 10 Aug 2023 09:32:41 +0000

In clear_flush(), the original pte may be a present entry, so we should
use ptep_clear() to let page_table_check track the pte clearing operation,
otherwise it may cause false positive in subsequent set_pte_at().

Link: https://lkml.kernel.org/r/20230810093241.1181142-1-qi.zheng@linux.dev
Fixes: 42b2547137f5 ("arm64/mm: enable ARCH_SUPPORTS_PAGE_TABLE_CHECK")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
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

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


