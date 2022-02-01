Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3108C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  1 Feb 2022 20:42:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241053AbiBAUmE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Feb 2022 15:42:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241474AbiBAUlp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Feb 2022 15:41:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7073EC06173B
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 12:41:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6BFB616EA
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 20:41:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF719C340EB;
        Tue,  1 Feb 2022 20:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643748088;
        bh=Am9SahDQZa9acwUxxlRD3BQ6pnaM/fLAedj9IEP8DQg=;
        h=Date:To:From:Subject:From;
        b=1mEgiTZeD9b0WT/Est3IGB7JQrfS9GgtK1E3ly7+yXXODrrlk7qwWjETBnI7jXk5f
         i0zv+QyIux3H0HG+dAl8Xs/jk53hhrkRSXwKvcEKKLvkIGfqZ0k5TGcYO61y9ccOzu
         pb4bUwd6zN70H7bUBuDO0LiC5392DFZrvjGLr2sk=
Received: by hp1 (sSMTP sendmail emulation); Tue, 01 Feb 2022 12:41:26 -0800
Date:   Tue, 01 Feb 2022 12:41:26 -0800
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        paul.walmsley@sifive.com, palmer@dabbelt.com, mingo@redhat.com,
        mike.kravetz@oracle.com, linux@armlinux.org.uk,
        anshuman.khandual@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-generalize-arch_want_general_hugetlb.patch added to -mm tree
Message-Id: <20220201204126.DF719C340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: generalize ARCH_WANT_GENERAL_HUGETLB
has been added to the -mm tree.  Its filename is
     mm-hugetlb-generalize-arch_want_general_hugetlb.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-generalize-arch_want_general_hugetlb.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-generalize-arch_want_general_hugetlb.patch

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
@@ -344,9 +345,6 @@ config ARCH_NR_GPIO
 config ARCH_SUSPEND_POSSIBLE
 	def_bool y
 
-config ARCH_WANT_GENERAL_HUGETLB
-	def_bool y
-
 config AUDIT_ARCH
 	def_bool y if X86_64
 
--- a/mm/Kconfig~mm-hugetlb-generalize-arch_want_general_hugetlb
+++ a/mm/Kconfig
@@ -411,6 +411,9 @@ choice
 	  benefit.
 endchoice
 
+config ARCH_WANT_GENERAL_HUGETLB
+	bool
+
 config ARCH_WANTS_THP_SWAP
 	def_bool n
 
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-generalize-arch_has_filter_pgprot.patch
mm-hugetlb-generalize-arch_want_general_hugetlb.patch
mm-migration-add-trace-events-for-thp-migrations.patch
mm-migration-add-trace-events-for-base-page-and-hugetlb-migrations.patch

