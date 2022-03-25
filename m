Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F74CC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:33:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351159AbiCYBee (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357619AbiCYBdf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B07BD8AB
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2040E60A50
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C47EC340EC;
        Fri, 25 Mar 2022 01:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171921;
        bh=Dss5TT27VbM5EOS9bF4NRRY8zThtvuK9GqYTZmP1t2Y=;
        h=Date:To:From:Subject:From;
        b=LBqx6iUJPHnQXt+O63pU8i0d92wI9+FpvZiFJK+MvwGu9Z2FV21mVSsD4WeLckaz7
         hgumVqKCuEMeTqde6kcImT7rov3YZxMeqRHP0JHDA8KXJL8NdSUrLuiqcttktNusnR
         tA9oySA7jkZ4a8o5C7IuHIpc7Qpoozi5QYpX96o4=
Date:   Thu, 24 Mar 2022 18:32:00 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        paul.walmsley@sifive.com, palmer@dabbelt.com, mingo@redhat.com,
        mike.kravetz@oracle.com, linux@armlinux.org.uk,
        anshuman.khandual@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-hugetlb-generalize-arch_want_general_hugetlb.patch removed from -mm tree
Message-Id: <20220325013201.7C47EC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: generalize ARCH_WANT_GENERAL_HUGETLB
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-generalize-arch_want_general_hugetlb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-migration-add-trace-events-for-thp-migrations.patch
mm-migration-add-trace-events-for-base-page-and-hugetlb-migrations.patch
mm-generalize-arch_has_filter_pgprot.patch

