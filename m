Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33C2EC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:11:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356818AbiCYBNS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357191AbiCYBMx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:12:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32926BD2CC
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:11:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD964B82707
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:11:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93AF3C340F1;
        Fri, 25 Mar 2022 01:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170677;
        bh=m3w3r1c8QaoAa/4E7jG5lgT4qMcnOu+M1qbKI3e9peY=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=rUnjZDt1oaiWD8Cg4oy7ytkk+NLwwVGSgisCBr3cYojPGezrNnTyij2iq0WcAkI2y
         bTP4PSEhbnqpmSuhO5HgVI8upPJkNopr+u2H9aZt2vrc7+003+X8PKE0JvKJwPrcAh
         zNirnb54d7O2skAzzO5vVFi+qC8ZjhMOqTkpwVgY=
Date:   Thu, 24 Mar 2022 18:11:16 -0700
To:     will@kernel.org, vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com,
        pcc@google.com, mark.rutland@arm.com, glider@google.com,
        eugenis@google.com, elver@google.com, dvyukov@google.com,
        catalin.marinas@arm.com, andreyknvl@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 054/114] kasan, vmalloc, arm64: mark vmalloc mappings as pgprot_tagged
Message-Id: <20220325011117.93AF3C340F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, vmalloc, arm64: mark vmalloc mappings as pgprot_tagged

HW_TAGS KASAN relies on ARM Memory Tagging Extension (MTE).  With MTE, a
memory region must be mapped as MT_NORMAL_TAGGED to allow setting memory
tags via MTE-specific instructions.

Add proper protection bits to vmalloc() allocations.  These allocations
are always backed by page_alloc pages, so the tags will actually be
getting set on the corresponding physical memory.

Link: https://lkml.kernel.org/r/983fc33542db2f6b1e77b34ca23448d4640bbb9e.1643047180.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Co-developed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/vmalloc.h |    6 ++++++
 include/linux/vmalloc.h          |    7 +++++++
 mm/vmalloc.c                     |    9 +++++++++
 3 files changed, 22 insertions(+)

--- a/arch/arm64/include/asm/vmalloc.h~kasan-vmalloc-arm64-mark-vmalloc-mappings-as-pgprot_tagged
+++ a/arch/arm64/include/asm/vmalloc.h
@@ -25,4 +25,10 @@ static inline bool arch_vmap_pmd_support
 
 #endif
 
+#define arch_vmap_pgprot_tagged arch_vmap_pgprot_tagged
+static inline pgprot_t arch_vmap_pgprot_tagged(pgprot_t prot)
+{
+	return pgprot_tagged(prot);
+}
+
 #endif /* _ASM_ARM64_VMALLOC_H */
--- a/include/linux/vmalloc.h~kasan-vmalloc-arm64-mark-vmalloc-mappings-as-pgprot_tagged
+++ a/include/linux/vmalloc.h
@@ -115,6 +115,13 @@ static inline int arch_vmap_pte_supporte
 }
 #endif
 
+#ifndef arch_vmap_pgprot_tagged
+static inline pgprot_t arch_vmap_pgprot_tagged(pgprot_t prot)
+{
+	return prot;
+}
+#endif
+
 /*
  *	Highlevel APIs for driver use
  */
--- a/mm/vmalloc.c~kasan-vmalloc-arm64-mark-vmalloc-mappings-as-pgprot_tagged
+++ a/mm/vmalloc.c
@@ -3128,6 +3128,15 @@ again:
 		goto fail;
 	}
 
+	/*
+	 * Modify protection bits to allow tagging.
+	 * This must be done before mapping by __vmalloc_area_node().
+	 */
+	if (kasan_hw_tags_enabled() &&
+	    pgprot_val(prot) == pgprot_val(PAGE_KERNEL))
+		prot = arch_vmap_pgprot_tagged(prot);
+
+	/* Allocate physical pages and map them into vmalloc space. */
 	addr = __vmalloc_area_node(area, gfp_mask, prot, shift, node);
 	if (!addr)
 		goto fail;
_
