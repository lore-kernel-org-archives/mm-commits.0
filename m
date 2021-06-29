Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5889AC11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:35:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D22E61CE7
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:35:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbhF2Aht (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 20:37:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232060AbhF2Aht (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 20:37:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 328F361CDC;
        Tue, 29 Jun 2021 00:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624926922;
        bh=5vX7/dVzJELo2EUeTaaBag3R1EePXtXpXL/wcTYTuUs=;
        h=Date:From:To:Subject:From;
        b=fvO3XRqIgBXbaQTR3HMmKgnZoqk1WfNqSIX9ou4wPj5b4bgBhaL+V+XUc6hZP9Rq3
         nZndEJfniYkHXowH/vhQAaF8luyOv33wbcrp7Rdcwxk5lQVV+mjNGB2/qZFRvFtMz0
         Sj7iuUxWSBu07W7qtjSZHt1Q5oq+yR7xdI8sH1dE=
Date:   Mon, 28 Jun 2021 17:35:21 -0700
From:   akpm@linux-foundation.org
To:     ardb@kernel.org, arnd@arndb.de, catalin.marinas@arm.com,
        christophe.leroy@csgroup.eu, mm-commits@vger.kernel.org,
        naresh.kamboju@linaro.org, rppt@linux.ibm.com,
        sfr@canb.auug.org.au, will@kernel.org
Subject:  [folded-merged]
 mm-replace-config_need_multiple_nodes-with-config_numa-fix.patch removed
 from -mm tree
Message-ID: <20210629003521.gCzIm8g_Z%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-replace-config_need_multiple_nodes-with-config_numa-fix
has been removed from the -mm tree.  Its filename was
     mm-replace-config_need_multiple_nodes-with-config_numa-fix.patch

This patch was dropped because it was folded into mm-replace-config_need_multiple_nodes-with-config_numa.patch

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm-replace-config_need_multiple_nodes-with-config_numa-fix

Fix arm boot crash

Take into account the change in pgdat_to_phys().

In the long run I think we should get rid of contig_page_data and allocate
NODE_DATA(0) for !NUMA case as well.

Andrew, can you please add this as a fixup to "mm: replace
CONFIG_NEED_MULTIPLE_NODES with CONFIG_NUMA"?

Link: https://lkml.kernel.org/r/YMj9vHhHOiCVN4BF@linux.ibm.com
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Will Deacon <will@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/sparse.c~mm-replace-config_need_multiple_nodes-with-config_numa-fix
+++ a/mm/sparse.c
@@ -346,7 +346,7 @@ size_t mem_section_usage_size(void)
 
 static inline phys_addr_t pgdat_to_phys(struct pglist_data *pgdat)
 {
-#ifndef CONFIG_NEED_MULTIPLE_NODES
+#ifndef CONFIG_NUMA
 	return __pa_symbol(pgdat);
 #else
 	return __pa(pgdat);
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-page_alloc-fix-memory-map-initialization-for-descending-nodes.patch
mm-mmzoneh-simplify-is_highmem_idx.patch
alpha-remove-discontigmem-and-numa.patch
arc-update-comment-about-highmem-implementation.patch
arc-remove-support-for-discontigmem.patch
m68k-remove-support-for-discontigmem.patch
mm-remove-config_discontigmem.patch
arch-mm-remove-stale-mentions-of-disconigmem.patch
docs-remove-description-of-discontigmem.patch
mm-replace-config_need_multiple_nodes-with-config_numa.patch
mm-replace-config_flat_node_mem_map-with-config_flatmem.patch
docs-procrst-meminfo-briefly-describe-gaps-in-memory-accounting.patch
include-linux-mmzoneh-add-documentation-for-pfn_valid.patch
memblock-update-initialization-of-reserved-pages.patch
arm64-decouple-check-whether-pfn-is-in-linear-map-from-pfn_valid.patch
arm64-drop-pfn_valid_within-and-simplify-pfn_valid.patch
mmap-make-mlock_future_check-global.patch
riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch

