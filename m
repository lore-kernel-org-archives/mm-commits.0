Return-Path: <SRS0=v6Vt=IE=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BCA5C433E0
	for <mm-commits@archiver.kernel.org>; Sat,  6 Mar 2021 00:32:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 293FB65059
	for <mm-commits@archiver.kernel.org>; Sat,  6 Mar 2021 00:32:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbhCFAcP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Mar 2021 19:32:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:37374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhCFAcE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Mar 2021 19:32:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB89C65059;
        Sat,  6 Mar 2021 00:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614990724;
        bh=w/2TcGs+NYGpL43ybEORZDUuMpt2owZhjcKXbbcXQAM=;
        h=Date:From:To:Subject:From;
        b=K95IQ6z0yO9YpbKwjdzWS3qOTWbXW0uXjv1ptpUZS/VqHCtXcfCwk7L8Lu/47GqTI
         LIcxgLytWWmD1h5j7P5PMd6qI9tHeyhvGpnFqBE8yTGnZn+6KdN/q9/7j3dZNxvedZ
         8FGLISjdWUwOnMNKOL61oKAdibw2JdN/+81ez2+0=
Date:   Fri, 05 Mar 2021 16:32:03 -0800
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, benh@kernel.crashing.org,
        christophe.leroy@csgroup.eu, hch@lst.de, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org
Subject:  + mm-generalize-hugetlb_page_size_variable.patch added to
 -mm tree
Message-ID: <20210306003203.5ibiisNtJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: generalize HUGETLB_PAGE_SIZE_VARIABLE
has been added to the -mm tree.  Its filename is
     mm-generalize-hugetlb_page_size_variable.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-generalize-hugetlb_page_size_variable.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-generalize-hugetlb_page_size_variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -231,6 +231,7 @@ config PPC
 	select HAVE_HARDLOCKUP_DETECTOR_PERF	if PERF_EVENTS && HAVE_PERF_EVENTS_NMI && !HAVE_HARDLOCKUP_DETECTOR_ARCH
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
+	select HUGETLB_PAGE_SIZE_VARIABLE	if PPC_BOOK3S_64 && HUGETLB_PAGE
 	select MMU_GATHER_RCU_TABLE_FREE
 	select MMU_GATHER_PAGE_SIZE
 	select HAVE_REGS_AND_STACK_ACCESS_API
@@ -415,11 +416,6 @@ config HIGHMEM
 
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
@@ -274,6 +274,13 @@ config ARCH_ENABLE_HUGEPAGE_MIGRATION
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

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-generalize-hugetlb_page_size_variable.patch

