Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ADDCC43217
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236411AbiCVVrE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236489AbiCVVrA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:47:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A0E5F8DE
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:45:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A0BEB81DAD
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:45:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0493DC340EE;
        Tue, 22 Mar 2022 21:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985518;
        bh=KgFxigUkeYF+PFEggiPurq/9Jlhixybpa2gQoa4tROE=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=yFEY1JqFq+c/WASd69mRQGgIsHZuntzedT1Dy/MC7tuoM2VPZ8NcYRfu9TkQ3Tfcx
         9PjuN1yvKoeIQQI6RDLQvZhlhAPAm4MdistvVRCG0USTxptNzKgX/yd1T5y/LmvJfj
         4OF15R7wpAyScgMIq1GQpzdV1UU0HTkuuPZuCIs8=
Date:   Tue, 22 Mar 2022 14:45:15 -0700
To:     tglx@linutronix.de, paul.walmsley@sifive.com, palmer@dabbelt.com,
        mingo@redhat.com, mike.kravetz@oracle.com, linux@armlinux.org.uk,
        anshuman.khandual@arm.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 133/227] mm/hugetlb: generalize ARCH_WANT_GENERAL_HUGETLB
Message-Id: <20220322214518.0493DC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/hugetlb: generalize ARCH_WANT_GENERAL_HUGETLB

ARCH_WANT_GENERAL_HUGETLB config has duplicate definitions on platforms
that subscribe it.  Instead make it a generic config option which can be
selected on applicable platforms when required.

Link: https://lkml.kernel.org/r/1643718465-4324-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig   |    4 +---
 arch/riscv/Kconfig |    4 +---
 arch/x86/Kconfig   |    4 +---
 mm/Kconfig         |    3 +++
 4 files changed, 6 insertions(+), 9 deletions(-)

--- a/arch/arm/Kconfig~mm-hugetlb-generalize-arch_want_general_hugetlb
+++ a/arch/arm/Kconfig
@@ -37,6 +37,7 @@ config ARM
 	select ARCH_USE_CMPXCHG_LOCKREF
 	select ARCH_USE_MEMTEST
 	select ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT if MMU
+	select ARCH_WANT_GENERAL_HUGETLB
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select ARCH_WANT_LD_ORPHAN_WARN
 	select BINFMT_FLAT_ARGVP_ENVP_ON_STACK
@@ -1508,9 +1509,6 @@ config HW_PERF_EVENTS
 	def_bool y
 	depends on ARM_PMU
 
-config ARCH_WANT_GENERAL_HUGETLB
-	def_bool y
-
 config ARM_MODULE_PLTS
 	bool "Use PLTs to allow module memory to spill over into vmalloc area"
 	depends on MODULES
--- a/arch/riscv/Kconfig~mm-hugetlb-generalize-arch_want_general_hugetlb
+++ a/arch/riscv/Kconfig
@@ -40,6 +40,7 @@ config RISCV
 	select ARCH_USE_MEMTEST
 	select ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT if MMU
 	select ARCH_WANT_FRAME_POINTERS
+	select ARCH_WANT_GENERAL_HUGETLB
 	select ARCH_WANT_HUGE_PMD_SHARE if 64BIT
 	select BINFMT_FLAT_NO_DATA_START_OFFSET if !MMU
 	select BUILDTIME_TABLE_SORT if MMU
@@ -171,9 +172,6 @@ config ARCH_SPARSEMEM_ENABLE
 config ARCH_SELECT_MEMORY_MODEL
 	def_bool ARCH_SPARSEMEM_ENABLE
 
-config ARCH_WANT_GENERAL_HUGETLB
-	def_bool y
-
 config ARCH_SUPPORTS_UPROBES
 	def_bool y
 
--- a/arch/x86/Kconfig~mm-hugetlb-generalize-arch_want_general_hugetlb
+++ a/arch/x86/Kconfig
@@ -118,6 +118,7 @@ config X86
 	select ARCH_WANT_DEFAULT_BPF_JIT	if X86_64
 	select ARCH_WANTS_DYNAMIC_TASK_STRUCT
 	select ARCH_WANTS_NO_INSTR
+	select ARCH_WANT_GENERAL_HUGETLB
 	select ARCH_WANT_HUGE_PMD_SHARE
 	select ARCH_WANT_LD_ORPHAN_WARN
 	select ARCH_WANTS_THP_SWAP		if X86_64
@@ -347,9 +348,6 @@ config ARCH_NR_GPIO
 config ARCH_SUSPEND_POSSIBLE
 	def_bool y
 
-config ARCH_WANT_GENERAL_HUGETLB
-	def_bool y
-
 config AUDIT_ARCH
 	def_bool y if X86_64
 
--- a/mm/Kconfig~mm-hugetlb-generalize-arch_want_general_hugetlb
+++ a/mm/Kconfig
@@ -414,6 +414,9 @@ choice
 	  benefit.
 endchoice
 
+config ARCH_WANT_GENERAL_HUGETLB
+	bool
+
 config ARCH_WANTS_THP_SWAP
 	def_bool n
 
_
