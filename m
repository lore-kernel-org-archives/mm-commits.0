Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2027C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:19:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AED6C61C97
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbhGFTWb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:22:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231922AbhGFTWa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:22:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E75561C91;
        Tue,  6 Jul 2021 19:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599191;
        bh=jXz03iMmx7HHwxqJCnCAGJOIF/LtbzQLQkd/JhWx8RM=;
        h=Date:From:To:Subject:From;
        b=NFKr9g5JxNXQ3BCFgwj8ix3He5LUgiSCh/byjsRifXuv057nk3j8Z1kuXZMaV1IYT
         vfw1/Z0nEXDGTEbBtxj8Tb6/YhwHnB2fGVmFfqc7OPD/rPI5NGX1nHLW7hUSYNWVTZ
         3cx3P45tSd5HxZY6fHAqyFdACY3zn8be9B0ac9js=
Date:   Tue, 06 Jul 2021 12:19:51 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, gerald.schaefer@linux.ibm.com,
        gor@linux.ibm.com, hca@linux.ibm.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, tglx@linutronix.de
Subject:  [merged]
 =?US-ASCII?Q?mm-thp-make-arch=5Fenable=5Fsplit=5Fpmd=5Fptlock-dependent-o?=
 =?US-ASCII?Q?n-pgtable=5Flevels-2.patch?= removed from -mm tree
Message-ID: <20210706191951.Q1PHQUQmL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: make ARCH_ENABLE_SPLIT_PMD_PTLOCK dependent on PGTABLE_LEVELS > 2
has been removed from the -mm tree.  Its filename was
     mm-thp-make-arch_enable_split_pmd_ptlock-dependent-on-pgtable_levels-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-thp-make-alloc_split_ptlocks-dependent-on-use_split_pte_ptlocks.patch

