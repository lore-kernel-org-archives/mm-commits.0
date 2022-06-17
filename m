Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 907DACCA481
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:49:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379837AbiFQCtq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379811AbiFQCtg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:49:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CCF6541D
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:49:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E571FB826EF
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:49:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A793DC3411A;
        Fri, 17 Jun 2022 02:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434170;
        bh=/jHYZYhgfBw3n0O4IxNm3Kfgv/IamOUFtjxhEy/IYag=;
        h=Date:To:From:Subject:From;
        b=tX/P1IFYkcbnbwPtkZYNYFpV1nlCnzbYFMQykPpXVWRT0R3MLKPl+hxo2uNDYHYz5
         eSynUznfPOyhJatB9nfnp+wlnOX9UvV6oSJlwm6QJQzCpyNKyMz89KBjLl5K84FJAc
         ocptwZYfXYHjRg/ygYeoBcc+Z2GDNOuFrwczJ7fI=
Date:   Thu, 16 Jun 2022 19:49:30 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memremap-fix-wrong-function-name-above-memremap_pages.patch removed from -mm tree
Message-Id: <20220617024930.A793DC3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memremap: fix wrong function name above memremap_pages()
has been removed from the -mm tree.  Its filename was
     mm-memremap-fix-wrong-function-name-above-memremap_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memremap: fix wrong function name above memremap_pages()
Date: Tue, 7 Jun 2022 22:36:21 +0800

Fix the wrong function name dev_memremap_pages above memremap_pages() to
avoid confusion.  Minor readability improvement.

Link: https://lkml.kernel.org/r/20220607143621.58989-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memremap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memremap.c~mm-memremap-fix-wrong-function-name-above-memremap_pages
+++ a/mm/memremap.c
@@ -279,8 +279,8 @@ err_pfn_remap:
 
 
 /*
- * Not device managed version of dev_memremap_pages, undone by
- * memunmap_pages().  Please use dev_memremap_pages if you have a struct
+ * Not device managed version of devm_memremap_pages, undone by
+ * memunmap_pages().  Please use devm_memremap_pages if you have a struct
  * device available.
  */
 void *memremap_pages(struct dev_pagemap *pgmap, int nid)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-reduce-the-rcu-lock-duration.patch
mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
mm-migration-return-errno-when-isolate_huge_page-failed.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-swapfile-make-security_vm_enough_memory_mm-work-as-expected.patch
mm-swapfile-fix-possible-data-races-of-inuse_pages.patch
mm-swap-remove-swap_cache_info-statistics.patch
mm-vmscan-dont-try-to-reclaim-freed-folios.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch

