Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CBD7C11F69
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:52:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00F7661476
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:51:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238482AbhGABy2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:54:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:43986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238427AbhGABy2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:54:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B4BF61474;
        Thu,  1 Jul 2021 01:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104318;
        bh=XFuB63iS5k2hf2niZ9v7nEmLoo5ci92rgzRtof4P49s=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=yOisVyqCISVNYNSaG3GxOxYSMeUEZ8eQLd9KGGtdT+pXe2SOlL0VynqF4o1YTpp3y
         QY5WatAd7WuLx2iZvfQfjuW9VccOqC5HO8yQ2rq2P0qh8POYLnIjLP8EHU4RMMDMEm
         uk1Ek+31SV4i+Sow9IOk+7DfYcPwSzFDluMN+O5Y=
Date:   Wed, 30 Jun 2021 18:51:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        gerald.schaefer@linux.ibm.com, gor@linux.ibm.com,
        hca@linux.ibm.com, linux-mm@kvack.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org
Subject:  [patch 090/192] mm/thp: make ARCH_ENABLE_SPLIT_PMD_PTLOCK
 dependent on PGTABLE_LEVELS > 2
Message-ID: <20210701015158.X1cghgNmq%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/thp: make ARCH_ENABLE_SPLIT_PMD_PTLOCK dependent on PGTABLE_LEVELS > 2

ARCH_ENABLE_SPLIT_PMD_PTLOCK is irrelevant unless there are more than two
page table levels including PMD (also per
Documentation/vm/split_page_table_lock.rst).  Make this dependency
explicit on remaining platforms i.e x86 and s390 where
ARCH_ENABLE_SPLIT_PMD_PTLOCK is subscribed.

Link: https://lkml.kernel.org/r/1622013501-20409-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com> # s390
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/Kconfig |    2 +-
 arch/x86/Kconfig  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/s390/Kconfig~mm-thp-make-arch_enable_split_pmd_ptlock-dependent-on-pgtable_levels-2
+++ a/arch/s390/Kconfig
@@ -62,7 +62,7 @@ config S390
 	select ARCH_BINFMT_ELF_STATE
 	select ARCH_ENABLE_MEMORY_HOTPLUG if SPARSEMEM
 	select ARCH_ENABLE_MEMORY_HOTREMOVE
-	select ARCH_ENABLE_SPLIT_PMD_PTLOCK
+	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if PGTABLE_LEVELS > 2
 	select ARCH_HAS_DEBUG_VM_PGTABLE
 	select ARCH_HAS_DEBUG_WX
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
--- a/arch/x86/Kconfig~mm-thp-make-arch_enable_split_pmd_ptlock-dependent-on-pgtable_levels-2
+++ a/arch/x86/Kconfig
@@ -63,7 +63,7 @@ config X86
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if X86_64 && HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_MEMORY_HOTPLUG if X86_64 || (X86_32 && HIGHMEM)
 	select ARCH_ENABLE_MEMORY_HOTREMOVE if MEMORY_HOTPLUG
-	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if X86_64 || X86_PAE
+	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if (PGTABLE_LEVELS > 2) && (X86_64 || X86_PAE)
 	select ARCH_ENABLE_THP_MIGRATION if X86_64 && TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_ACPI_TABLE_UPGRADE	if ACPI
 	select ARCH_HAS_CACHE_LINE_SIZE
_
