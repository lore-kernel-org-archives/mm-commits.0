Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDA35C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC0606113A
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349960AbhICVAl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:00:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235866AbhICVAj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:00:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64B586112E;
        Fri,  3 Sep 2021 20:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702779;
        bh=RT+9Axu7uERom+Tw9fnFHLXmgZyM0xrxkOdaDxRygtM=;
        h=Date:From:To:Subject:From;
        b=cAcduLxwuQ7lYS7gSXQJBWLONx5k+XHZe0K17Qg5CKAe1YiiYbqQ0Tss5y0A1Mkig
         ndqabDaGBEVky4y3qESzgn4I8Vc9vRmODvVkedH8CQixazpafs6m8Jl3O4/lu5Os+I
         kPG4VwZbSp1FzUzR/frPOT4dSLk67gZKgJfFkNJA=
Date:   Fri, 03 Sep 2021 13:59:39 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rppt@linux.ibm.com
Subject:  [merged]
 mm-page_alloc-make-alloc_node_mem_map-__init-rather-than-__ref.patch
 removed from -mm tree
Message-ID: <20210903205939._wFwvKsOH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: make alloc_node_mem_map() __init rather than __ref
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-make-alloc_node_mem_map-__init-rather-than-__ref.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -7515,7 +7515,7 @@ static void __init free_area_init_core(s
 }
 
 #ifdef CONFIG_FLATMEM
-static void __ref alloc_node_mem_map(struct pglist_data *pgdat)
+static void __init alloc_node_mem_map(struct pglist_data *pgdat)
 {
 	unsigned long __maybe_unused start = 0;
 	unsigned long __maybe_unused offset = 0;
@@ -7561,7 +7561,7 @@ static void __ref alloc_node_mem_map(str
 #endif
 }
 #else
-static void __ref alloc_node_mem_map(struct pglist_data *pgdat) { }
+static inline void alloc_node_mem_map(struct pglist_data *pgdat) { }
 #endif /* CONFIG_FLATMEM */
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-remove-pfn_valid_within-and-config_holes_in_zone.patch
mm-memory_hotplug-cleanup-after-removal-of-pfn_valid_within.patch

