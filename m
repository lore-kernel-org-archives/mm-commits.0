Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19F7EC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 22:16:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B19AC64F53
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 22:15:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhCQWP1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Mar 2021 18:15:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230341AbhCQWPX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Mar 2021 18:15:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1205964F2A;
        Wed, 17 Mar 2021 22:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616019323;
        bh=3fn1mf3VV0hl0vUpUi1Pxy/D08NoTTUUhQj4hHSAqHk=;
        h=Date:From:To:Subject:From;
        b=gTDKUsuo2FlMHV7T003xR/iIW0Jxa9FEWysq/zY5CwdrXj3hGMmh0S4Sijy2mvcDI
         usPsV8W1dqZM1b/VrqdMLgMakJFey3wo5wyDkX0Kx2YwXlfLhLnhOISsTDOE3ZFegN
         INhEugWroca+Vpv8vquNdRqZtSy+dpFg13lsWaiU=
Date:   Wed, 17 Mar 2021 15:15:22 -0700
From:   akpm@linux-foundation.org
To:     lkp@intel.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com
Subject:  +
 riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch
 added to -mm tree
Message-ID: <20210317221522.I8iVkz__K%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: riscv/Kconfig: make direct map manipulation options depend on MMU
has been added to the -mm tree.  Its filename is
     riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: riscv/Kconfig: make direct map manipulation options depend on MMU

ARCH_HAS_SET_DIRECT_MAP and ARCH_HAS_SET_MEMORY configuration options have
no meaning when CONFIG_MMU is disabled and there is no point to enable
them for the nommu case.

Add an explicit dependency on MMU for these options.

Link: https://lkml.kernel.org/r/20210303162209.8609-4-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/riscv/Kconfig~riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu
+++ a/arch/riscv/Kconfig
@@ -26,8 +26,8 @@ config RISCV
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_MMIOWB
 	select ARCH_HAS_PTE_SPECIAL
-	select ARCH_HAS_SET_DIRECT_MAP
-	select ARCH_HAS_SET_MEMORY
+	select ARCH_HAS_SET_DIRECT_MAP if MMU
+	select ARCH_HAS_SET_MEMORY if MMU
 	select ARCH_HAS_STRICT_KERNEL_RWX if MMU
 	select ARCH_OPTIONAL_KERNEL_RWX if ARCH_HAS_STRICT_KERNEL_RWX
 	select ARCH_OPTIONAL_KERNEL_RWX_DEFAULT
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-add-definition-of-pmd_page_order.patch
mmap-make-mlock_future_check-global.patch
riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch

