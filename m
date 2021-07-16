Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B60F9C636CA
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jul 2021 23:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CDF8613E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jul 2021 23:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237481AbhGPXht (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Jul 2021 19:37:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:32876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230104AbhGPXht (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Jul 2021 19:37:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D97961357;
        Fri, 16 Jul 2021 23:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626478493;
        bh=uC0GQQfwUTcxbu8nehWeZLZTy4FEe6BmqOiNT+CHvtc=;
        h=Date:From:To:Subject:From;
        b=vtFx/6t9oC37BFklkMRGmulUH1E5GkGAHLyftCGdz0aZTLBGK8rPT0kXLxWs8hIaM
         32qtygLj2InS78kfPV6oM6i17YJ062gupgW7f4QicqP8DZrd98Q0zeFHzvx3kk/GWY
         b4Mm08auhubci1+SC5ti3ma+vxu+mXO4sdlCOKH4=
Date:   Fri, 16 Jul 2021 16:34:53 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rppt@linux.ibm.com
Subject:  +
 mm-page_alloc-make-alloc_node_mem_map-__init-rather-than-__ref.patch added
 to -mm tree
Message-ID: <20210716233453.wQ8ETR2bM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: make alloc_node_mem_map() __init rather than __ref
has been added to the -mm tree.  Its filename is
     mm-page_alloc-make-alloc_node_mem_map-__init-rather-than-__ref.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-make-alloc_node_mem_map-__init-rather-than-__ref.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-make-alloc_node_mem_map-__init-rather-than-__ref.patch

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
Subject: mm/page_alloc: make alloc_node_mem_map() __init rather than __ref

alloc_node_mem_map() is never only called from free_area_init_node() that
is an __init function.

Make the actual alloc_node_mem_map() also __init and its stub version
static inline.

Link: https://lkml.kernel.org/r/20210716064124.31865-1-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-make-alloc_node_mem_map-__init-rather-than-__ref
+++ a/mm/page_alloc.c
@@ -7514,7 +7514,7 @@ static void __init free_area_init_core(s
 }
 
 #ifdef CONFIG_FLATMEM
-static void __ref alloc_node_mem_map(struct pglist_data *pgdat)
+static void __init alloc_node_mem_map(struct pglist_data *pgdat)
 {
 	unsigned long __maybe_unused start = 0;
 	unsigned long __maybe_unused offset = 0;
@@ -7560,7 +7560,7 @@ static void __ref alloc_node_mem_map(str
 #endif
 }
 #else
-static void __ref alloc_node_mem_map(struct pglist_data *pgdat) { }
+static inline void alloc_node_mem_map(struct pglist_data *pgdat) { }
 #endif /* CONFIG_FLATMEM */
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

memblock-make-for_each_mem_range-traverse-memblock_hotplug-regions.patch
mm-page_alloc-always-initialize-memory-map-for-the-holes.patch
microblaze-simplify-pte_alloc_one_kernel.patch
mm-introduce-memmap_alloc-to-unify-memory-map-allocation.patch
memblock-stop-poisoning-raw-allocations.patch
mm-page_alloc-make-alloc_node_mem_map-__init-rather-than-__ref.patch
mm-remove-pfn_valid_within-and-config_holes_in_zone.patch
mm-memory_hotplug-cleanup-after-removal-of-pfn_valid_within.patch

