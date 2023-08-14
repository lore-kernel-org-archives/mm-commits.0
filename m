Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D933EB64DD
	for <mm-commits@archiver.kernel.org>; Mon, 14 Aug 2023 19:34:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbjHNTd7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Aug 2023 15:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbjHNTd3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Aug 2023 15:33:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47900BB
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 12:33:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D18B96209C
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 19:33:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC58C433C8;
        Mon, 14 Aug 2023 19:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692041607;
        bh=85p84AhMB1HKGRXc5yAHKXDnnj98COkUNwvxt+SFLIs=;
        h=Date:To:From:Subject:From;
        b=nWYaNd6Ti89sO0NYwi2eCaJ45N8PnLGOnQlzuM4wV0q272dFTjhJnn4w/FqjVS8bN
         V+BpqUOFTrEdCVwQ4HE799qk3JKN7nvr0Z9+CjbWKsWPDkeMJsWnV6Om6UlQPunmU5
         +qozP+067/r+i235wHsKT3PIx9aTM1nPlXhgFdW8=
Date:   Mon, 14 Aug 2023 12:33:26 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, palmer@dabbelt.com,
        mike.kravetz@oracle.com, linux@armlinux.org.uk,
        catalin.marinas@arm.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-include-asm-cacheflushh-in-asm-hugetlbh.patch added to mm-unstable branch
Message-Id: <20230814193327.2EC58C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: riscv: include asm/cacheflush.h in asm/hugetlb.h
has been added to the -mm mm-unstable branch.  Its filename is
     riscv-include-asm-cacheflushh-in-asm-hugetlbh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-include-asm-cacheflushh-in-asm-hugetlbh.patch

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
From: Hugh Dickins <hughd@google.com>
Subject: riscv: include asm/cacheflush.h in asm/hugetlb.h
Date: Sun, 13 Aug 2023 21:53:57 -0700 (PDT)

PG_dcache_clean is used in asm/hugetlb.h but defined in asm/cacheflush.h:
builds rely on an accident of that being included via linux/mempolicy.h,
but better include it directly (like arch/sh/include/asm/hugetlb.h does).

Link: https://lkml.kernel.org/r/84bd3b96-8dbe-51b1-d7d1-6e4f9d8937d8@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/include/asm/hugetlb.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/riscv/include/asm/hugetlb.h~riscv-include-asm-cacheflushh-in-asm-hugetlbh
+++ a/arch/riscv/include/asm/hugetlb.h
@@ -2,6 +2,7 @@
 #ifndef _ASM_RISCV_HUGETLB_H
 #define _ASM_RISCV_HUGETLB_H
 
+#include <asm/cacheflush.h>
 #include <asm/page.h>
 
 static inline void arch_clear_hugepage_flags(struct page *page)
_

Patches currently in -mm which might be from hughd@google.com are

arm-include-asm-cacheflushh-in-asm-hugetlbh.patch
arm64-include-asm-cacheflushh-in-asm-hugetlbh.patch
riscv-include-asm-cacheflushh-in-asm-hugetlbh.patch

