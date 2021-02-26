Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22FFDC433E6
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:40:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF2FE64F1F
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:40:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbhBZAkZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 19:40:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:58832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231815AbhBZAkQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 19:40:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B778160202;
        Fri, 26 Feb 2021 00:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614299972;
        bh=W2LF6CQTcJXs/BPX60YA2oUpB1Cyiafgsdto01OMyIs=;
        h=Date:From:To:Subject:From;
        b=hz2NBcSzf+Q653qN8TPDIoMPwSvoKfOzsTBppgt+dpf2q4RxmZ9PvQrF2BIbbBMMY
         R8AX5F8SVhSuefvJBeHuswctt9be4r0rPQR4/GHibVB54UuCFkErP90xQrj+Nwt8j3
         DfGFkBetMYD8FM5rCF2dlux5XnTZlNf0uUkrQUQ8=
Date:   Thu, 25 Feb 2021 16:39:31 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, guro@fb.com, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, rppt@kernel.org, sfr@canb.auug.org.au
Subject:  [folded-merged]
 mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch removed from -mm tree
Message-ID: <20210226003931.irhI_Ewj9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-cma-allocate-cma-areas-bottom-up-fix-3-fix
has been removed from the -mm tree.  Its filename was
     mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch

This patch was dropped because it was folded into mm-cma-allocate-cma-areas-bottom-up.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-cma-allocate-cma-areas-bottom-up-fix-3-fix

build fix

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/cma.c~mm-cma-allocate-cma-areas-bottom-up-fix-3-fix
+++ a/mm/cma.c
@@ -344,7 +344,7 @@ int __init cma_declare_contiguous_nid(ph
 		 * Avoid using first 4GB to not interfere with constrained zones
 		 * like DMA/DMA32.
 		 */
-#if CONFIG_PHYS_ADDR_T_64BIT
+#ifdef CONFIG_PHYS_ADDR_T_64BIT
 		if (!memblock_bottom_up() && memblock_end >= SZ_4G + size) {
 			memblock_set_bottom_up(true);
 			addr = memblock_alloc_range_nid(size, alignment, SZ_4G,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-cma-allocate-cma-areas-bottom-up.patch
mm-memory_hotplug-prevalidate-the-address-range-being-added-with-platform-fix.patch
bdi-use-might_alloc-fix.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
lib-stackdepot-add-support-to-disable-stack-depot-fix.patch
seq_file-document-how-per-entry-resources-are-managed-fix.patch
initramfs-panic-with-memory-information-fix.patch
mm-page_allocc-refactor-initialization-of-struct-page-for-holes-in-memory-layout-fix.patch
mm.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

