Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90028C48BDF
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 23:35:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68D5F6137D
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 23:35:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbhFOXhk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Jun 2021 19:37:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230043AbhFOXhk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Jun 2021 19:37:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2A9A61245;
        Tue, 15 Jun 2021 23:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623800134;
        bh=d2uu+Y1yGUpI1YM797H0sQVBCCxptP7VQwj4rn6y+3Y=;
        h=Date:From:To:Subject:From;
        b=m2bWFae6DLv97Dt/iPnBRBC957dNmsoeN+aHnHZK8M4VAyHCqpdT5FdeoFKNW8Jiz
         f87KsoAAFIgWTZciRmdxv9ls9qRWcR0shLYQY/wKlA4tNK/3DWlBozRp6InuCFv7I4
         oPrig1ynX8EAG4tI8GWS3uxwDAQWHP4cV0mp878g=
Date:   Tue, 15 Jun 2021 16:35:33 -0700
From:   akpm@linux-foundation.org
To:     ardb@kernel.org, arnd@arndb.de, catalin.marinas@arm.com,
        christophe.leroy@csgroup.eu, mm-commits@vger.kernel.org,
        naresh.kamboju@linaro.org, rppt@linux.ibm.com,
        sfr@canb.auug.org.au, will@kernel.org
Subject:  +
 mm-replace-config_need_multiple_nodes-with-config_numa-fix.patch added to
 -mm tree
Message-ID: <20210615233533.1GUYsfxvF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-replace-config_need_multiple_nodes-with-config_numa-fix
has been added to the -mm tree.  Its filename is
     mm-replace-config_need_multiple_nodes-with-config_numa-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-replace-config_need_multiple_nodes-with-config_numa-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-replace-config_need_multiple_nodes-with-config_numa-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-mmzoneh-simplify-is_highmem_idx.patch
alpha-remove-discontigmem-and-numa.patch
arc-update-comment-about-highmem-implementation.patch
arc-remove-support-for-discontigmem.patch
m68k-remove-support-for-discontigmem.patch
mm-remove-config_discontigmem.patch
arch-mm-remove-stale-mentions-of-disconigmem.patch
docs-remove-description-of-discontigmem.patch
mm-replace-config_need_multiple_nodes-with-config_numa.patch
mm-replace-config_need_multiple_nodes-with-config_numa-fix.patch
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

