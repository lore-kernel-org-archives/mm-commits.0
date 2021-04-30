Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DA15C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:58:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00B6061480
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:58:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbhD3F7h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:59:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230253AbhD3F7g (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:59:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2D8361463;
        Fri, 30 Apr 2021 05:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762327;
        bh=5+w/tQjelFNR06I9eDuw/gfKPbyNpjZbxbZubCt4wA4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vmlabJLWJ12GIaYZPDK51LdY80fQkVq3eqDfYaN/Utz9CkfBbUOvlFLF5wDJAcxTQ
         degjvHwOzYnk3mvIMIdfAb2inbKP/a68rO3bU+oZDjq7BKO9Mw1RbQES6BVi9uafqS
         Kb5hhkNxAZJH7PlAyw8RPOlArwd9RLGc3Ipfa0lk=
Date:   Thu, 29 Apr 2021 22:58:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bp@alien8.de, catalin.marinas@arm.com,
        dingtianhong@huawei.com, hch@lst.de, hpa@zytor.com,
        linmiaohe@huawei.com, linux-mm@kvack.org, linux@armlinux.org.uk,
        mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        npiggin@gmail.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, urezki@gmail.com, will@kernel.org
Subject:  [patch 108/178] mm/vmalloc: add vmap_range_noflush
 variant
Message-ID: <20210430055846.AKiMboLau%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>
Subject: mm/vmalloc: add vmap_range_noflush variant

As a side-effect, the order of flush_cache_vmap() and
arch_sync_kernel_mappings() calls are switched, but that now matches the
other callers in this file.

Link: https://lkml.kernel.org/r/20210317062402.533919-13-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

 mm/vmalloc.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-add-vmap_range_noflush-variant
+++ a/mm/vmalloc.c
@@ -240,7 +240,7 @@ static int vmap_p4d_range(pgd_t *pgd, un
 	return 0;
 }
 
-int vmap_range(unsigned long addr, unsigned long end,
+static int vmap_range_noflush(unsigned long addr, unsigned long end,
 			phys_addr_t phys_addr, pgprot_t prot,
 			unsigned int max_page_shift)
 {
@@ -263,13 +263,23 @@ int vmap_range(unsigned long addr, unsig
 			break;
 	} while (pgd++, phys_addr += (next - addr), addr = next, addr != end);
 
-	flush_cache_vmap(start, end);
-
 	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
 		arch_sync_kernel_mappings(start, end);
 
 	return err;
 }
+
+int vmap_range(unsigned long addr, unsigned long end,
+			phys_addr_t phys_addr, pgprot_t prot,
+			unsigned int max_page_shift)
+{
+	int err;
+
+	err = vmap_range_noflush(addr, end, phys_addr, prot, max_page_shift);
+	flush_cache_vmap(addr, end);
+
+	return err;
+}
 
 static void vunmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			     pgtbl_mod_mask *mask)
_
