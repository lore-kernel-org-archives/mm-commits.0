Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07B79C433ED
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 21:54:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBF6D61439
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 21:54:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233609AbhEMV4C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 May 2021 17:56:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:32880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233574AbhEMV4A (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 May 2021 17:56:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF20861406;
        Thu, 13 May 2021 21:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620942889;
        bh=o2U6Gfd20BWITsIqkXp7GpU6jkfMP6UGAU/YTm8Z07c=;
        h=Date:From:To:Subject:From;
        b=rpIv2u9f0STbeGafBFjb30QX0bS8yLKlulGJcWjJfM21lz3/Az+VV/8x8WwfCMqV2
         6X93z/m+CoNtUJ5S3PfOBq0hFH9DeyhvSy89ERJcsb0/ZOPo1zwUdIW4x/P4nELbeH
         8wkIAk/yK+uDpipgdIC6rlRNElm6QUpN+DIRZjCY=
Date:   Thu, 13 May 2021 14:54:49 -0700
From:   akpm@linux-foundation.org
To:     lkp@intel.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com
Subject:  [to-be-updated]
 riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch
 removed from -mm tree
Message-ID: <20210513215449.EbAlRUkjz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: riscv/Kconfig: make direct map manipulation options depend on MMU
has been removed from the -mm tree.  Its filename was
     riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch

This patch was dropped because an updated version will be merged

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
 	select ARCH_HAS_STRICT_KERNEL_RWX if MMU && !XIP_KERNEL
 	select ARCH_HAS_STRICT_MODULE_RWX if MMU && !XIP_KERNEL
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-mmzoneh-simplify-is_highmem_idx.patch
docs-procrst-meminfo-briefly-describe-gaps-in-memory-accounting.patch
include-linux-mmzoneh-add-documentation-for-pfn_valid.patch
memblock-update-initialization-of-reserved-pages.patch
arm64-decouple-check-whether-pfn-is-in-linear-map-from-pfn_valid.patch
arm64-drop-pfn_valid_within-and-simplify-pfn_valid.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch
secretmem-test-add-basic-selftest-for-memfd_secret2-fix.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix-2.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix-3.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant-fix.patch

