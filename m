Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F9B2C4742C
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 22:56:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07E302080A
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 22:56:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="FfN+SqEZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732399AbgKJW44 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Nov 2020 17:56:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:54480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731854AbgKJW44 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Nov 2020 17:56:56 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3ED92204EF;
        Tue, 10 Nov 2020 22:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605049015;
        bh=L6oJX7/W2CxhJoLVE8KK2+vjfJSpfv8r01epVtF0Ib8=;
        h=Date:From:To:Subject:From;
        b=FfN+SqEZGv4Kyvdiw/Bj/GNjN4zxV3dZivGJEnqNyA0s/8LP88Vb5dseCBW19Ff4M
         frCi01isq3N/RYDdVl+Wc4w9JMBlbOSNUzXsLl4l58c64qPDBN4lP0q0cKp2lT/57x
         6d6EClznEhFXAkz/0il/Y7yqNexDgATvP483C1/8=
Date:   Tue, 10 Nov 2020 14:56:54 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, gor@linux.ibm.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  + arm64-kasan-allow-enabling-in-kernel-mte.patch added to
 -mm tree
Message-ID: <20201110225654.ctzUzVEnQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: kasan: allow enabling in-kernel MTE
has been added to the -mm tree.  Its filename is
     arm64-kasan-allow-enabling-in-kernel-mte.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm64-kasan-allow-enabling-in-kernel-mte.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm64-kasan-allow-enabling-in-kernel-mte.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: arm64: kasan: allow enabling in-kernel MTE

Hardware tag-based KASAN relies on Memory Tagging Extension (MTE)
feature and requires it to be enabled. MTE supports

This patch adds a new mte_init_tags() helper, that enables MTE in
Synchronous mode in EL1 and is intended to be called from KASAN runtime
during initialization.

The Tag Checking operation causes a synchronous data abort as
a consequence of a tag check fault when MTE is configured in
synchronous mode.

As part of this change enable match-all tag for EL1 to allow the
kernel to access user pages without faulting. This is required because
the kernel does not have knowledge of the tags set by the user in a
page.

Note: For MTE, the TCF bit field in SCTLR_EL1 affects only EL1 in a
similar way as TCF0 affects EL0.

MTE that is built on top of the Top Byte Ignore (TBI) feature hence we
enable it as part of this patch as well.

Link: https://lkml.kernel.org/r/5ce2fc45920e59623a4a9d8d39b6c96792f1e055.1605046192.git.andreyknvl@google.com
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Co-developed-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Marco Elver <elver@google.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/mte-kasan.h |    6 ++++++
 arch/arm64/kernel/mte.c            |    7 +++++++
 arch/arm64/mm/proc.S               |   23 ++++++++++++++++++++---
 3 files changed, 33 insertions(+), 3 deletions(-)

--- a/arch/arm64/include/asm/mte-kasan.h~arm64-kasan-allow-enabling-in-kernel-mte
+++ a/arch/arm64/include/asm/mte-kasan.h
@@ -29,6 +29,8 @@ u8 mte_get_mem_tag(void *addr);
 u8 mte_get_random_tag(void);
 void *mte_set_mem_tag_range(void *addr, size_t size, u8 tag);
 
+void mte_enable(void);
+
 #else /* CONFIG_ARM64_MTE */
 
 static inline u8 mte_get_ptr_tag(void *ptr)
@@ -49,6 +51,10 @@ static inline void *mte_set_mem_tag_rang
 	return addr;
 }
 
+static inline void mte_enable(void)
+{
+}
+
 #endif /* CONFIG_ARM64_MTE */
 
 #endif /* __ASSEMBLY__ */
--- a/arch/arm64/kernel/mte.c~arm64-kasan-allow-enabling-in-kernel-mte
+++ a/arch/arm64/kernel/mte.c
@@ -129,6 +129,13 @@ void *mte_set_mem_tag_range(void *addr,
 	return ptr;
 }
 
+void mte_enable(void)
+{
+	/* Enable MTE Sync Mode for EL1. */
+	sysreg_clear_set(sctlr_el1, SCTLR_ELx_TCF_MASK, SCTLR_ELx_TCF_SYNC);
+	isb();
+}
+
 static void update_sctlr_el1_tcf0(u64 tcf0)
 {
 	/* ISB required for the kernel uaccess routines */
--- a/arch/arm64/mm/proc.S~arm64-kasan-allow-enabling-in-kernel-mte
+++ a/arch/arm64/mm/proc.S
@@ -40,9 +40,15 @@
 #define TCR_CACHE_FLAGS	TCR_IRGN_WBWA | TCR_ORGN_WBWA
 
 #ifdef CONFIG_KASAN_SW_TAGS
-#define TCR_KASAN_FLAGS TCR_TBI1
+#define TCR_KASAN_SW_FLAGS TCR_TBI1
 #else
-#define TCR_KASAN_FLAGS 0
+#define TCR_KASAN_SW_FLAGS 0
+#endif
+
+#ifdef CONFIG_KASAN_HW_TAGS
+#define TCR_KASAN_HW_FLAGS SYS_TCR_EL1_TCMA1 | TCR_TBI1
+#else
+#define TCR_KASAN_HW_FLAGS 0
 #endif
 
 /*
@@ -427,6 +433,10 @@ SYM_FUNC_START(__cpu_setup)
 	 */
 	mov_q	x5, MAIR_EL1_SET
 #ifdef CONFIG_ARM64_MTE
+	mte_tcr	.req	x20
+
+	mov	mte_tcr, #0
+
 	/*
 	 * Update MAIR_EL1, GCR_EL1 and TFSR*_EL1 if MTE is supported
 	 * (ID_AA64PFR1_EL1[11:8] > 1).
@@ -447,6 +457,9 @@ SYM_FUNC_START(__cpu_setup)
 	/* clear any pending tag check faults in TFSR*_EL1 */
 	msr_s	SYS_TFSR_EL1, xzr
 	msr_s	SYS_TFSRE0_EL1, xzr
+
+	/* set the TCR_EL1 bits */
+	mov_q	mte_tcr, TCR_KASAN_HW_FLAGS
 1:
 #endif
 	msr	mair_el1, x5
@@ -456,7 +469,11 @@ SYM_FUNC_START(__cpu_setup)
 	 */
 	mov_q	x10, TCR_TxSZ(VA_BITS) | TCR_CACHE_FLAGS | TCR_SMP_FLAGS | \
 			TCR_TG_FLAGS | TCR_KASLR_FLAGS | TCR_ASID16 | \
-			TCR_TBI0 | TCR_A1 | TCR_KASAN_FLAGS
+			TCR_TBI0 | TCR_A1 | TCR_KASAN_SW_FLAGS
+#ifdef CONFIG_ARM64_MTE
+	orr	x10, x10, mte_tcr
+	.unreq	mte_tcr
+#endif
 	tcr_clear_errata_bits x10, x9, x5
 
 #ifdef CONFIG_ARM64_VA_BITS_52
_

Patches currently in -mm which might be from vincenzo.frascino@arm.com are

mm-vmalloc-fix-kasan-shadow-poisoning-size.patch
arm64-enable-armv85-a-asm-arch-option.patch
arm64-mte-add-in-kernel-mte-helpers.patch
arm64-mte-reset-the-page-tag-in-page-flags.patch
arm64-mte-add-in-kernel-tag-fault-handler.patch
arm64-kasan-allow-enabling-in-kernel-mte.patch
arm64-mte-convert-gcr_user-into-an-exclude-mask.patch
arm64-mte-switch-gcr_el1-in-kernel-entry-and-exit.patch
kasan-mm-untag-page-address-in-free_reserved_area.patch
kselftest-arm64-check-gcr_el1-after-context-switch.patch

