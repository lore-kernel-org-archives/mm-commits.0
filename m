Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18904C48BE5
	for <mm-commits@archiver.kernel.org>; Wed,  9 Jun 2021 00:26:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03A95613CB
	for <mm-commits@archiver.kernel.org>; Wed,  9 Jun 2021 00:26:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234977AbhFIA16 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Jun 2021 20:27:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234874AbhFIA15 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 8 Jun 2021 20:27:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5399613BD;
        Wed,  9 Jun 2021 00:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623198358;
        bh=DIg7du1VtxXDNW0TSej1FIOektsaJ6CIAZu/yGTSuBs=;
        h=Date:From:To:Subject:From;
        b=jlwaN918ZasHrRjQMeRCRkaLLGe08sUzXt5xVpMRqg5KE7rGNs3jmwrqFp3Y4D02H
         1cMIGppIKMfI2LyAF8fFlMTCP1CX/0ewKv1Drfoae2zNox4Z5Yor87HAIZp8WNyimj
         o62fFOcO3d8FDxAc/sNDw7BoroLRH0ksmLcn7hOU=
Date:   Tue, 08 Jun 2021 17:25:57 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, corbet@lwn.net, geert@linux-m68k.org,
        ink@jurassic.park.msu.ru, mattst88@gmail.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com, rth@twiddle.net,
        vgupta@synopsys.com
Subject:  + docs-remove-description-of-discontigmem.patch added to
 -mm tree
Message-ID: <20210609002557.K-V8WgKoi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: docs: remove description of DISCONTIGMEM
has been added to the -mm tree.  Its filename is
     docs-remove-description-of-discontigmem.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/docs-remove-description-of-discontigmem.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/docs-remove-description-of-discontigmem.patch

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
Subject: docs: remove description of DISCONTIGMEM

Remove description of DISCONTIGMEM from the "Memory Models" document and
update VM sysctl description so that it won't mention DISCONIGMEM.

Link: https://lkml.kernel.org/r/20210608091316.3622-8-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/vm.rst |   12 ++---
 Documentation/vm/memory-model.rst       |   45 ----------------------
 2 files changed, 8 insertions(+), 49 deletions(-)

--- a/Documentation/admin-guide/sysctl/vm.rst~docs-remove-description-of-discontigmem
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -938,12 +938,12 @@ allocations, THP and hugetlbfs pages.
 
 To make it sensible with respect to the watermark_scale_factor
 parameter, the unit is in fractions of 10,000. The default value of
-15,000 on !DISCONTIGMEM configurations means that up to 150% of the high
-watermark will be reclaimed in the event of a pageblock being mixed due
-to fragmentation. The level of reclaim is determined by the number of
-fragmentation events that occurred in the recent past. If this value is
-smaller than a pageblock then a pageblocks worth of pages will be reclaimed
-(e.g.  2MB on 64-bit x86). A boost factor of 0 will disable the feature.
+15,000 means that up to 150% of the high watermark will be reclaimed in the
+event of a pageblock being mixed due to fragmentation. The level of reclaim
+is determined by the number of fragmentation events that occurred in the
+recent past. If this value is smaller than a pageblock then a pageblocks
+worth of pages will be reclaimed (e.g.  2MB on 64-bit x86). A boost factor
+of 0 will disable the feature.
 
 
 watermark_scale_factor
--- a/Documentation/vm/memory-model.rst~docs-remove-description-of-discontigmem
+++ a/Documentation/vm/memory-model.rst
@@ -14,15 +14,11 @@ for the CPU. Then there could be several
 completely distinct addresses. And, don't forget about NUMA, where
 different memory banks are attached to different CPUs.
 
-Linux abstracts this diversity using one of the three memory models:
-FLATMEM, DISCONTIGMEM and SPARSEMEM. Each architecture defines what
+Linux abstracts this diversity using one of the two memory models:
+FLATMEM and SPARSEMEM. Each architecture defines what
 memory models it supports, what the default memory model is and
 whether it is possible to manually override that default.
 
-.. note::
-   At time of this writing, DISCONTIGMEM is considered deprecated,
-   although it is still in use by several architectures.
-
 All the memory models track the status of physical page frames using
 struct page arranged in one or more arrays.
 
@@ -63,43 +59,6 @@ straightforward: `PFN - ARCH_PFN_OFFSET`
 The `ARCH_PFN_OFFSET` defines the first page frame number for
 systems with physical memory starting at address different from 0.
 
-DISCONTIGMEM
-============
-
-The DISCONTIGMEM model treats the physical memory as a collection of
-`nodes` similarly to how Linux NUMA support does. For each node Linux
-constructs an independent memory management subsystem represented by
-`struct pglist_data` (or `pg_data_t` for short). Among other
-things, `pg_data_t` holds the `node_mem_map` array that maps
-physical pages belonging to that node. The `node_start_pfn` field of
-`pg_data_t` is the number of the first page frame belonging to that
-node.
-
-The architecture setup code should call :c:func:`free_area_init_node` for
-each node in the system to initialize the `pg_data_t` object and its
-`node_mem_map`.
-
-Every `node_mem_map` behaves exactly as FLATMEM's `mem_map` -
-every physical page frame in a node has a `struct page` entry in the
-`node_mem_map` array. When DISCONTIGMEM is enabled, a portion of the
-`flags` field of the `struct page` encodes the node number of the
-node hosting that page.
-
-The conversion between a PFN and the `struct page` in the
-DISCONTIGMEM model became slightly more complex as it has to determine
-which node hosts the physical page and which `pg_data_t` object
-holds the `struct page`.
-
-Architectures that support DISCONTIGMEM provide :c:func:`pfn_to_nid`
-to convert PFN to the node number. The opposite conversion helper
-:c:func:`page_to_nid` is generic as it uses the node number encoded in
-page->flags.
-
-Once the node number is known, the PFN can be used to index
-appropriate `node_mem_map` array to access the `struct page` and
-the offset of the `struct page` from the `node_mem_map` plus
-`node_start_pfn` is the PFN of that page.
-
 SPARSEMEM
 =========
 
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

