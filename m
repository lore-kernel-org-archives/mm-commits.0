Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FF87C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jan 2022 01:58:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S3411687AbiAYAe2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jan 2022 19:34:28 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51706 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2359703AbiAXXeo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jan 2022 18:34:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 889B26104E
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 23:34:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6890C340E4;
        Mon, 24 Jan 2022 23:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643067281;
        bh=4m6ieTN478D1hvKyEsoVlWXiEW4WCW+MBE38Axy9L7c=;
        h=Date:From:To:Subject:From;
        b=XLkbNIk0htR5rcMyCc/sBPqHLsKgymhY2nO2O6ZFqIdZSuSPbtiCmDnu7dQQmC7fv
         IG376NDnNoxwskg+w+wqBJpFNlGthPqt6XMSGomt+C+LYV5GDDk3JpcS2mRcJR4Qtj
         zTB8JRdFSn7eRXj0DSTLyaQmEOkUDx5/BaoeFyVY=
Date:   Mon, 24 Jan 2022 15:34:40 -0800
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, catalin.marinas@arm.com, hpa@zytor.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, tglx@linutronix.de,
        will@kernel.org
Subject:  + mm-generalize-arch_has_filter_pgprot.patch added to -mm
 tree
Message-ID: <20220124233440.EHadPLfph%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: generalize ARCH_HAS_FILTER_PGPROT
has been added to the -mm tree.  Its filename is
     mm-generalize-arch_has_filter_pgprot.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-generalize-arch_has_filter_pgprot.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-generalize-arch_has_filter_pgprot.patch

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
Subject: mm: generalize ARCH_HAS_FILTER_PGPROT

ARCH_HAS_FILTER_PGPROT config has duplicate definitions on platforms that
subscribe it.  Instead make it a generic config option which can be
selected on applicable platforms when required.

Link: https://lkml.kernel.org/r/1643004823-16441-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig |    4 +---
 arch/x86/Kconfig   |    3 ---
 mm/Kconfig         |    3 +++
 3 files changed, 4 insertions(+), 6 deletions(-)

--- a/arch/arm64/Kconfig~mm-generalize-arch_has_filter_pgprot
+++ a/arch/arm64/Kconfig
@@ -23,6 +23,7 @@ config ARM64
 	select ARCH_HAS_DMA_PREP_COHERENT
 	select ARCH_HAS_ACPI_TABLE_UPGRADE if ACPI
 	select ARCH_HAS_FAST_MULTIPLIER
+	select ARCH_HAS_FILTER_PGPROT
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_GIGANTIC_PAGE
@@ -1166,9 +1167,6 @@ config HW_PERF_EVENTS
 	def_bool y
 	depends on ARM_PMU
 
-config ARCH_HAS_FILTER_PGPROT
-	def_bool y
-
 # Supported by clang >= 7.0
 config CC_HAVE_SHADOW_CALL_STACK
 	def_bool $(cc-option, -fsanitize=shadow-call-stack -ffixed-x18)
--- a/arch/x86/Kconfig~mm-generalize-arch_has_filter_pgprot
+++ a/arch/x86/Kconfig
@@ -332,9 +332,6 @@ config GENERIC_CALIBRATE_DELAY
 config ARCH_HAS_CPU_RELAX
 	def_bool y
 
-config ARCH_HAS_FILTER_PGPROT
-	def_bool y
-
 config ARCH_HIBERNATION_POSSIBLE
 	def_bool y
 
--- a/mm/Kconfig~mm-generalize-arch_has_filter_pgprot
+++ a/mm/Kconfig
@@ -744,6 +744,9 @@ config IDLE_PAGE_TRACKING
 config ARCH_HAS_CACHE_LINE_SIZE
 	bool
 
+config ARCH_HAS_FILTER_PGPROT
+	bool
+
 config ARCH_HAS_PTE_DEVMAP
 	bool
 
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-generalize-arch_has_filter_pgprot.patch

