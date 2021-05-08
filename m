Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0429BC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:43:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D06D9613C5
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:43:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhEHWoC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:44:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:51036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229559AbhEHWoC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:44:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B111D613EA;
        Sat,  8 May 2021 22:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513780;
        bh=C5KZOhp2V1DxNh3rNSUPFOGynHE/zakrZtTDN6wISSg=;
        h=Date:From:To:Subject:From;
        b=gzBlMktRdhCrOtLW8njSzmqi1uuWiKTY/o/QFrWEV/LPTQBezGh3LUY26DBsG8r7y
         jXbnWU5gWs6LqEHNtAeZBljChLFUfxClr0xdpjqzn3y5B63nET4lEqokJnQ0aEdBRA
         qYDI9hIF9flxuxByyfOQokCq7VX6IWpqEtyWS7TQ=
Date:   Sat, 08 May 2021 15:42:59 -0700
From:   akpm@linux-foundation.org
To:     bp@alien8.de, catalin.marinas@arm.com, dingtianhong@huawei.com,
        hch@lst.de, hpa@zytor.com, linmiaohe@huawei.com,
        linux@armlinux.org.uk, mingo@redhat.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com,
        tglx@linutronix.de, urezki@gmail.com, will@kernel.org
Subject:  [merged]
 mm-vmalloc-provide-fallback-arch-huge-vmap-support-functions.patch removed
 from -mm tree
Message-ID: <20210508224259.XcBu36cQ9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: provide fallback arch huge vmap support functions
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-provide-fallback-arch-huge-vmap-support-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from npiggin@gmail.com are


