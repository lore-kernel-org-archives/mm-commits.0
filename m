Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B65F8C43461
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:33:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90975613EB
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:33:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbhEEBeQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:34:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231925AbhEEBeQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:34:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50046613EA;
        Wed,  5 May 2021 01:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178400;
        bh=boc8CxfmEQ/VJoIy4E9JlOVP3tFxTqWdcBDxtYOUV+M=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=I6vrF6DP1hbPPBV6KjY3SEtXktcBXU3IrlQrbBp8oGFpWFAdBKLvKHvOANzOEVF6y
         qH4AveBZ6UxIEzw7j2kymzxYj7MnrVMOL9OS2JEp/k3tJkfZK0d2mAR13QzTSbezGo
         0bgW41cLTaQIdZAfm2o9Be4UG6QLDEwx+//zejVk=
Date:   Tue, 04 May 2021 18:33:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        benh@kernel.crashing.org, christophe.leroy@csgroup.eu, hch@lst.de,
        linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org,
        torvalds@linux-foundation.org
Subject:  [patch 011/143] mm: generalize HUGETLB_PAGE_SIZE_VARIABLE
Message-ID: <20210505013319.Q4D8ChnUu%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm: generalize HUGETLB_PAGE_SIZE_VARIABLE

HUGETLB_PAGE_SIZE_VARIABLE need not be defined for each individual
platform subscribing it.  Instead just make it generic.

Link: https://lkml.kernel.org/r/1614914928-22039-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Suggested-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>	[powerpc]
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/Kconfig    |    6 +-----
 arch/powerpc/Kconfig |    6 +-----
 mm/Kconfig           |    7 +++++++
 3 files changed, 9 insertions(+), 10 deletions(-)

--- a/arch/ia64/Kconfig~mm-generalize-hugetlb_page_size_variable
+++ a/arch/ia64/Kconfig
@@ -32,6 +32,7 @@ config IA64
 	select TTY
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_VIRT_CPU_ACCOUNTING
+	select HUGETLB_PAGE_SIZE_VARIABLE if HUGETLB_PAGE
 	select VIRT_TO_BUS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
@@ -82,11 +83,6 @@ config STACKTRACE_SUPPORT
 config GENERIC_LOCKBREAK
 	def_bool n
 
-config HUGETLB_PAGE_SIZE_VARIABLE
-	bool
-	depends on HUGETLB_PAGE
-	default y
-
 config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
--- a/arch/powerpc/Kconfig~mm-generalize-hugetlb_page_size_variable
+++ a/arch/powerpc/Kconfig
@@ -232,6 +232,7 @@ config PPC
 	select HAVE_HARDLOCKUP_DETECTOR_PERF	if PERF_EVENTS && HAVE_PERF_EVENTS_NMI && !HAVE_HARDLOCKUP_DETECTOR_ARCH
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
+	select HUGETLB_PAGE_SIZE_VARIABLE	if PPC_BOOK3S_64 && HUGETLB_PAGE
 	select MMU_GATHER_RCU_TABLE_FREE
 	select MMU_GATHER_PAGE_SIZE
 	select HAVE_REGS_AND_STACK_ACCESS_API
@@ -416,11 +417,6 @@ config HIGHMEM
 
 source "kernel/Kconfig.hz"
 
-config HUGETLB_PAGE_SIZE_VARIABLE
-	bool
-	depends on HUGETLB_PAGE && PPC_BOOK3S_64
-	default y
-
 config MATH_EMULATION
 	bool "Math emulation"
 	depends on 4xx || PPC_8xx || PPC_MPC832x || BOOKE
--- a/mm/Kconfig~mm-generalize-hugetlb_page_size_variable
+++ a/mm/Kconfig
@@ -273,6 +273,13 @@ config ARCH_ENABLE_HUGEPAGE_MIGRATION
 config ARCH_ENABLE_THP_MIGRATION
 	bool
 
+config HUGETLB_PAGE_SIZE_VARIABLE
+	def_bool n
+	help
+	  Allows the pageblock_order value to be dynamic instead of just standard
+	  HUGETLB_PAGE_ORDER when there are multiple HugeTLB page sizes available
+	  on a platform.
+
 config CONTIG_ALLOC
 	def_bool (MEMORY_ISOLATION && COMPACTION) || CMA
 
_
