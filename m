Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFD51C07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:16:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F06761C91
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:16:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbhGFTTg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:19:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231742AbhGFTTf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:19:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DF1861C85;
        Tue,  6 Jul 2021 19:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599016;
        bh=F7qaqDOoCXY9sCjmZ9Di+hk6lQfNpmJqUMUqdHxRGbg=;
        h=Date:From:To:Subject:From;
        b=ufNAGpNAE5h9AmUomC//RRGm0s4lVZmSr6j04D8zC5BthlX/w738SyX/tz/398LWZ
         eBvuNmhCQcEDDVL3hvpp/L5AT8Jww+HqS6lPVDWl5i8duI26RXAlXzRo4uEyVjNxgY
         XVUUjfyeIyXO+8dXe+xtNNaBhZg8yY9m/tF1K/m8=
Date:   Tue, 06 Jul 2021 12:16:56 -0700
From:   akpm@linux-foundation.org
To:     benh@kernel.crashing.org, christophe.leroy@csgroup.eu,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, npiggin@gmail.com, paulus@samba.org,
        rppt@kernel.org, uladzislau.rezki@sony.com
Subject:  [merged]
 mm-vmalloc-enable-mapping-of-huge-pages-at-pte-level-in-vmalloc.patch
 removed from -mm tree
Message-ID: <20210706191656.MLLO_c6_6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: enable mapping of huge pages at pte level in vmalloc
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-enable-mapping-of-huge-pages-at-pte-level-in-vmalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: mm/vmalloc: enable mapping of huge pages at pte level in vmalloc

On some architectures like powerpc, there are huge pages that are mapped
at pte level.

Enable it in vmalloc.

For that, architectures can provide arch_vmap_pte_supported_shift() that
returns the shift for pages to map at pte level.

Link: https://lkml.kernel.org/r/2c717e3b1fba1894d890feb7669f83025bfa314d.1620795204.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Uladzislau Rezki <uladzislau.rezki@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    7 +++++++
 mm/vmalloc.c            |   13 +++++++------
 2 files changed, 14 insertions(+), 6 deletions(-)

--- a/include/linux/vmalloc.h~mm-vmalloc-enable-mapping-of-huge-pages-at-pte-level-in-vmalloc
+++ a/include/linux/vmalloc.h
@@ -112,6 +112,13 @@ static inline unsigned long arch_vmap_pt
 }
 #endif
 
+#ifndef arch_vmap_pte_supported_shift
+static inline int arch_vmap_pte_supported_shift(unsigned long size)
+{
+	return PAGE_SHIFT;
+}
+#endif
+
 /*
  *	Highlevel APIs for driver use
  */
--- a/mm/vmalloc.c~mm-vmalloc-enable-mapping-of-huge-pages-at-pte-level-in-vmalloc
+++ a/mm/vmalloc.c
@@ -2927,8 +2927,7 @@ void *__vmalloc_node_range(unsigned long
 		return NULL;
 	}
 
-	if (vmap_allow_huge && !(vm_flags & VM_NO_HUGE_VMAP) &&
-			arch_vmap_pmd_supported(prot)) {
+	if (vmap_allow_huge && !(vm_flags & VM_NO_HUGE_VMAP)) {
 		unsigned long size_per_node;
 
 		/*
@@ -2941,11 +2940,13 @@ void *__vmalloc_node_range(unsigned long
 		size_per_node = size;
 		if (node == NUMA_NO_NODE)
 			size_per_node /= num_online_nodes();
-		if (size_per_node >= PMD_SIZE) {
+		if (arch_vmap_pmd_supported(prot) && size_per_node >= PMD_SIZE)
 			shift = PMD_SHIFT;
-			align = max(real_align, 1UL << shift);
-			size = ALIGN(real_size, 1UL << shift);
-		}
+		else
+			shift = arch_vmap_pte_supported_shift(size_per_node);
+
+		align = max(real_align, 1UL << shift);
+		size = ALIGN(real_size, 1UL << shift);
 	}
 
 again:
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are


