Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41447C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:58:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1557E6147E
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:58:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhD3F73 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:59:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:52674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230286AbhD3F72 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:59:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 552BC613A9;
        Fri, 30 Apr 2021 05:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762320;
        bh=Et8OhQXIYR5dlL4ZxAIyR+qtehXg/sSCd2SRNp3YSa4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=IX9P12A1gmXo2fxO8sCz+zwls9+8bVLEkEJ2nogjawRE/Z+OR0EeoYnovYddoWT/N
         ugg6dPTRy4vIlxvxfDfzmoFOChdLtlQcBPGDHB/Q/vsd24BSkmhTi5WWi8FTXbOjE5
         CoqqGdT1ojuB+D2m8Dw+LHl4uSw2jxyaVNVA76yM=
Date:   Thu, 29 Apr 2021 22:58:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bp@alien8.de, catalin.marinas@arm.com,
        dingtianhong@huawei.com, hch@lst.de, hpa@zytor.com,
        linmiaohe@huawei.com, linux-mm@kvack.org, linux@armlinux.org.uk,
        mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        npiggin@gmail.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, urezki@gmail.com, will@kernel.org
Subject:  [patch 106/178] mm/vmalloc: provide fallback arch huge
 vmap support functions
Message-ID: <20210430055839.bIanNlhaq%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>
Subject: mm/vmalloc: provide fallback arch huge vmap support functions

If an architecture doesn't support a particular page table level as a huge
vmap page size then allow it to skip defining the support query function.

Link: https://lkml.kernel.org/r/20210317062402.533919-11-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Suggested-by: Christoph Hellwig <hch@lst.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ding Tianhong <dingtianhong@huawei.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/vmalloc.h   |    7 +++----
 arch/powerpc/include/asm/vmalloc.h |    7 +++----
 arch/x86/include/asm/vmalloc.h     |   13 +++++--------
 include/linux/vmalloc.h            |   24 ++++++++++++++++++++----
 4 files changed, 31 insertions(+), 20 deletions(-)

--- a/arch/arm64/include/asm/vmalloc.h~mm-vmalloc-provide-fallback-arch-huge-vmap-support-functions
+++ a/arch/arm64/include/asm/vmalloc.h
@@ -4,11 +4,8 @@
 #include <asm/page.h>
 
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
-static inline bool arch_vmap_p4d_supported(pgprot_t prot)
-{
-	return false;
-}
 
+#define arch_vmap_pud_supported arch_vmap_pud_supported
 static inline bool arch_vmap_pud_supported(pgprot_t prot)
 {
 	/*
@@ -19,11 +16,13 @@ static inline bool arch_vmap_pud_support
 	       !IS_ENABLED(CONFIG_PTDUMP_DEBUGFS);
 }
 
+#define arch_vmap_pmd_supported arch_vmap_pmd_supported
 static inline bool arch_vmap_pmd_supported(pgprot_t prot)
 {
 	/* See arch_vmap_pud_supported() */
 	return !IS_ENABLED(CONFIG_PTDUMP_DEBUGFS);
 }
+
 #endif
 
 #endif /* _ASM_ARM64_VMALLOC_H */
--- a/arch/powerpc/include/asm/vmalloc.h~mm-vmalloc-provide-fallback-arch-huge-vmap-support-functions
+++ a/arch/powerpc/include/asm/vmalloc.h
@@ -5,21 +5,20 @@
 #include <asm/page.h>
 
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
-static inline bool arch_vmap_p4d_supported(pgprot_t prot)
-{
-	return false;
-}
 
+#define arch_vmap_pud_supported arch_vmap_pud_supported
 static inline bool arch_vmap_pud_supported(pgprot_t prot)
 {
 	/* HPT does not cope with large pages in the vmalloc area */
 	return radix_enabled();
 }
 
+#define arch_vmap_pmd_supported arch_vmap_pmd_supported
 static inline bool arch_vmap_pmd_supported(pgprot_t prot)
 {
 	return radix_enabled();
 }
+
 #endif
 
 #endif /* _ASM_POWERPC_VMALLOC_H */
--- a/arch/x86/include/asm/vmalloc.h~mm-vmalloc-provide-fallback-arch-huge-vmap-support-functions
+++ a/arch/x86/include/asm/vmalloc.h
@@ -6,24 +6,21 @@
 #include <asm/pgtable_areas.h>
 
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
-static inline bool arch_vmap_p4d_supported(pgprot_t prot)
-{
-	return false;
-}
 
+#ifdef CONFIG_X86_64
+#define arch_vmap_pud_supported arch_vmap_pud_supported
 static inline bool arch_vmap_pud_supported(pgprot_t prot)
 {
-#ifdef CONFIG_X86_64
 	return boot_cpu_has(X86_FEATURE_GBPAGES);
-#else
-	return false;
-#endif
 }
+#endif
 
+#define arch_vmap_pmd_supported arch_vmap_pmd_supported
 static inline bool arch_vmap_pmd_supported(pgprot_t prot)
 {
 	return boot_cpu_has(X86_FEATURE_PSE);
 }
+
 #endif
 
 #endif /* _ASM_X86_VMALLOC_H */
--- a/include/linux/vmalloc.h~mm-vmalloc-provide-fallback-arch-huge-vmap-support-functions
+++ a/include/linux/vmalloc.h
@@ -78,10 +78,26 @@ struct vmap_area {
 	};
 };
 
-#ifndef CONFIG_HAVE_ARCH_HUGE_VMAP
-static inline bool arch_vmap_p4d_supported(pgprot_t prot) { return false; }
-static inline bool arch_vmap_pud_supported(pgprot_t prot) { return false; }
-static inline bool arch_vmap_pmd_supported(pgprot_t prot) { return false; }
+/* archs that select HAVE_ARCH_HUGE_VMAP should override one or more of these */
+#ifndef arch_vmap_p4d_supported
+static inline bool arch_vmap_p4d_supported(pgprot_t prot)
+{
+	return false;
+}
+#endif
+
+#ifndef arch_vmap_pud_supported
+static inline bool arch_vmap_pud_supported(pgprot_t prot)
+{
+	return false;
+}
+#endif
+
+#ifndef arch_vmap_pmd_supported
+static inline bool arch_vmap_pmd_supported(pgprot_t prot)
+{
+	return false;
+}
 #endif
 
 /*
_
