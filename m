Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABB69CCA473
	for <mm-commits@archiver.kernel.org>; Sun,  3 Jul 2022 22:44:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbiGCWoF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 18:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbiGCWnx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 18:43:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38E3DF2
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 15:43:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FA3FB80CEA
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 22:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207CFC341CE;
        Sun,  3 Jul 2022 22:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656888230;
        bh=zRxvcZgSPGLSocad3djridfnWleshFHtIcurRi5i1CE=;
        h=Date:To:From:Subject:From;
        b=v7/b7DxnAgGb/+UApJImedM0lOEV4oMdArIUMG1WSRZcSQSGFg4MMbBSwnuRVoDjr
         laEUS9aBnNBJE/7iErB5paWGCvWzeHWXPh5ttqH0YIp639p5o+k+yrFzcACKQXAHnY
         DA7NZxScjyDZlPG2Ur6iSleH7T1PeJWpm285BrUo=
Date:   Sun, 03 Jul 2022 15:43:49 -0700
To:     mm-commits@vger.kernel.org, tongtiangen@huawei.com,
        paul.walmsley@sifive.com, pasha.tatashin@soleen.com,
        palmer@dabbelt.com, aou@eecs.berkeley.edu, yuehaibing@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] riscv-mm-fix-build-error-while-page_table_check-enabled-without-mmu.patch removed from -mm tree
Message-Id: <20220703224350.207CFC341CE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: riscv/mm: fix build error while PAGE_TABLE_CHECK enabled without MMU
has been removed from the -mm tree.  Its filename was
     riscv-mm-fix-build-error-while-page_table_check-enabled-without-mmu.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: YueHaibing <yuehaibing@huawei.com>
Subject: riscv/mm: fix build error while PAGE_TABLE_CHECK enabled without MMU
Date: Fri, 24 Jun 2022 16:52:36 +0800

mm/page_table_check.c: In function `__page_table_check_pte_clear':
mm/page_table_check.c:148:6: error: implicit declaration of function `pte_user_accessible_page'; did you mean `user_access_save'? [-Werror=implicit-function-declaration]
  if (pte_user_accessible_page(pte)) {
      ^~~~~~~~~~~~~~~~~~~~~~~~
      user_access_save

ARCH_SUPPORTS_PAGE_TABLE_CHECK should only enabled with MMU.

Link: https://lkml.kernel.org/r/20220624085236.18544-1-yuehaibing@huawei.com
Fixes: 3fee229a8eb9 ("riscv/mm: enable ARCH_SUPPORTS_PAGE_TABLE_CHECK")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Tong Tiangen <tongtiangen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/Kconfig~riscv-mm-fix-build-error-while-page_table_check-enabled-without-mmu
+++ a/arch/riscv/Kconfig
@@ -38,7 +38,7 @@ config RISCV
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_DEBUG_PAGEALLOC if MMU
 	select ARCH_SUPPORTS_HUGETLBFS if MMU
-	select ARCH_SUPPORTS_PAGE_TABLE_CHECK
+	select ARCH_SUPPORTS_PAGE_TABLE_CHECK if MMU
 	select ARCH_USE_MEMTEST
 	select ARCH_USE_QUEUED_RWLOCKS
 	select ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT if MMU
_

Patches currently in -mm which might be from yuehaibing@huawei.com are


