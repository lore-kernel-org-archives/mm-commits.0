Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EA91CCA483
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jun 2022 19:13:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbiFXTNh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jun 2022 15:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbiFXTNT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2022 15:13:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A912F5B8
        for <mm-commits@vger.kernel.org>; Fri, 24 Jun 2022 12:13:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8C7F621A3
        for <mm-commits@vger.kernel.org>; Fri, 24 Jun 2022 19:13:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2784CC3411C;
        Fri, 24 Jun 2022 19:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656097997;
        bh=pIvq8SgqRDUhzheTKkvrfMvGqhlYCbreW4PFEF2Fqn8=;
        h=Date:To:From:Subject:From;
        b=gJR0xNIFrGru+pSd4UISpXPmHEymg6uZn8pW7SuqTH11tggFPBgT8uY8ZTNUdt+CW
         QE/0kA+cvsTwHcHj/hArgevab0qXKmMesyLniZ1PCGb3MuSQDDUY0s3VyDojAx3fjm
         dc8GWwB40OT172RkGzUMnFHPfSl2bzTAYrPesNdo=
Date:   Fri, 24 Jun 2022 12:13:16 -0700
To:     mm-commits@vger.kernel.org, tongtiangen@huawei.com,
        paul.walmsley@sifive.com, pasha.tatashin@soleen.com,
        palmer@dabbelt.com, aou@eecs.berkeley.edu, yuehaibing@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-mm-fix-build-error-while-page_table_check-enabled-without-mmu.patch added to mm-hotfixes-unstable branch
Message-Id: <20220624191317.2784CC3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: riscv/mm: fix build error while PAGE_TABLE_CHECK enabled without MMU
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     riscv-mm-fix-build-error-while-page_table_check-enabled-without-mmu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-mm-fix-build-error-while-page_table_check-enabled-without-mmu.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

riscv-mm-fix-build-error-while-page_table_check-enabled-without-mmu.patch

