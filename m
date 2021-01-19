Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0E7BC433E0
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 20:35:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73A972310D
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 20:35:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391934AbhASUfQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jan 2021 15:35:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:59670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731977AbhASUfL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Jan 2021 15:35:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F2BA23104;
        Tue, 19 Jan 2021 20:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611088470;
        bh=OzC46NTCjAWsUB0sWWMWlQ9vC8/qAzk21ZJFwl100fk=;
        h=Date:From:To:Subject:From;
        b=I1oJMgs3ECKyQfJmpe+/7bMt6aLACoANxe7BlJlp4mpMzjgnZ+0qwim6v0ueLhgJq
         WcJru/H4VWASjfIJw92h+kmC71zE+M1epoZlTOoa9MqEEfRBqss+o9Mjl6nb0q5YRa
         EisBJ02V4yeZjiMNwthfNBZ9hNTGZk2/tE1/b26Y=
Date:   Tue, 19 Jan 2021 12:34:29 -0800
From:   akpm@linux-foundation.org
To:     lkp@intel.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com
Subject:  +
 riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch
 added to -mm tree
Message-ID: <20210119203429.5nQ67lGV5%akpm@linux-foundation.org>
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
no meaning when CONFIG_MMU is disabled and there is no point to enable them
for the nommu case.

Add an explicit dependency on MMU for these options.

Link: https://lkml.kernel.org/r/20210118081202.GV832698@linux.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/riscv/Kconfig~riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu
+++ a/arch/riscv/Kconfig
@@ -25,8 +25,8 @@ config RISCV
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

x86-setup-dont-remove-e820_type_ram-for-pfn-0.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout.patch
mm-add-definition-of-pmd_page_order.patch
mmap-make-mlock_future_check-global.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch
secretmem-use-pmd-size-pages-to-amortize-direct-map-fragmentation.patch
secretmem-add-memcg-accounting.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch

