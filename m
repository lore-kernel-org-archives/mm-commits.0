Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA5E9C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90BAF20B1F
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602630768;
	bh=9VKXXHsFxhR/iaOs2zcT1a8tIue96X+CfQeB0gK/cDw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=dxjfW10NGXmhZAtwK4EpKUftteELLvpIKrNY7mXEF+2vhmMshpTzKb5r0vJmYRpoj
	 el1EJ9sp6+CvWTKJiE97W/m5+EUc4FMST5mKHg9B6ZNj8JAN4R0GDi+clXeL1W3+ys
	 QS93ZVP8WX4y9/g7qnjNZm+SLnqyyg0GzLO+PFxU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgJMXMs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:12:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:46970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726773AbgJMXMs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:12:48 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A7DF20B1F;
        Tue, 13 Oct 2020 23:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602630767;
        bh=9VKXXHsFxhR/iaOs2zcT1a8tIue96X+CfQeB0gK/cDw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=m91kkFQbPn5ELVXl4f6hExWAi18ruv80O2DbjomA9OBZ+rXH3KKomAkZiWw0orJ0t
         Naa5HMpO3MDkkRnUwRHTz4xg51jKUpjwgPtDyxXzmbg5XKtJ2PK1FfCf6gwX3ml7sC
         tmo96Phxv20Kkqzt38gGwHQyX1WC9sEHvBaFimjU=
Date:   Tue, 13 Oct 2020 16:12:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, mateusznosek0@gmail.com,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 mm-page_allocc-clean-code-by-removing-unnecessary-initialization-fix.patch
 removed from -mm tree
Message-ID: <20201013231247.yAhtZ98H_%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_allocc-clean-code-by-removing-unnecessary-initialization-fix
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-clean-code-by-removing-unnecessary-initialization-fix.patch

This patch was dropped because it was folded into mm-page_allocc-clean-code-by-removing-unnecessary-initialization.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_allocc-clean-code-by-removing-unnecessary-initialization-fix

remove `tmp' altogether

Cc: Mateusz Nosek <mateusznosek0@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-clean-code-by-removing-unnecessary-initialization-fix
+++ a/mm/page_alloc.c
@@ -5651,7 +5651,6 @@ static int find_next_best_node(int node,
 	int n, val;
 	int min_val = INT_MAX;
 	int best_node = NUMA_NO_NODE;
-	const struct cpumask *tmp;
 
 	/* Use the local node if we haven't already */
 	if (!node_isset(node, *used_node_mask)) {
@@ -5672,8 +5671,7 @@ static int find_next_best_node(int node,
 		val += (n < node);
 
 		/* Give preference to headless and unused nodes */
-		tmp = cpumask_of_node(n);
-		if (!cpumask_empty(tmp))
+		if (!cpumask_empty(cpumask_of_node(n)))
 			val += PENALTY_FOR_NODE_WITH_CPUS;
 
 		/* Slight preference for less loaded node */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_allocc-clean-code-by-removing-unnecessary-initialization.patch
mm-mempool-add-else-to-split-mutually-exclusive-case-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
mm.patch
powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch
xarray-add-xa_get_order-fix.patch
xarray-add-xas_split-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-memory_hotplug-simplify-page-offlining-fix.patch
checkpatch-warn-on-self-assignments-checkpatch-fixes.patch
checkpatch-emit-a-warning-on-embedded-filenames-fix.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
linux-next-rejects.patch
fs-fuse-virtio_fsc-fix-for-mm-memremap_pages-convert-to-struct-range.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

