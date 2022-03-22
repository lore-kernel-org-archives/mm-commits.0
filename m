Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96330C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236090AbiCVVno (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236107AbiCVVnf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:43:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E7E5F267
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:41:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45200B81DB1
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:41:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF46C340F2;
        Tue, 22 Mar 2022 21:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985311;
        bh=9VpQhWU+v6rIebMhpj+1pe+IbKQ0Me39rlEhhcxuX5U=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=bYG1f6ZhH7QkZ9uuSR3upcqXx2Gm+r7YZKc7VGfmRTLTGPAdXfOzRgzfeL3fAtHQQ
         h2Ui0atfVkAL+Ha3UMLAM2nXVfxxAMNkbWxWr4kB+M53zozg5uitaiLgnAGPJEODO/
         DBopNoFVHgQKFFFl6I4fX8MWb8cCnj18EGzbDF1s=
Date:   Tue, 22 Mar 2022 14:41:50 -0700
To:     wangkefeng.wang@huawei.com, stefan.kristiansson@saunalahti.fi,
        rppt@linux.ibm.com, rmk+kernel@armlinux.org.uk,
        nickhu@andestech.com, jonas@southpole.se, green.hu@gmail.com,
        deanbo422@gmail.com, david@redhat.com, dave.hansen@linux.intel.com,
        christophe.leroy@c-s.fr, bcain@codeaurora.org, shorne@gmail.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 065/227] mm: remove mmu_gathers storage from remaining architectures
Message-Id: <20220322214150.DBF46C340F2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Stafford Horne <shorne@gmail.com>
Subject: mm: remove mmu_gathers storage from remaining architectures

Originally the mmu_gathers were removed in commit 1c3951769621 ("mm: now
that all old mmu_gather code is gone, remove the storage").  However, the
openrisc and hexagon architecture were merged around the same time and
mmu_gathers was not removed.

This patch removes them from openrisc, hexagon and nds32:

Noticed while cleaning this warning:

    arch/openrisc/mm/init.c:41:1: warning: symbol 'mmu_gathers' was not declared. Should it be static?

Link: https://lkml.kernel.org/r/20220205141956.3315419-1-shorne@gmail.com
Signed-off-by: Stafford Horne <shorne@gmail.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Brian Cain <bcain@codeaurora.org>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/mm/init.c  |    2 --
 arch/nds32/mm/init.c    |    1 -
 arch/openrisc/mm/init.c |    2 --
 3 files changed, 5 deletions(-)

--- a/arch/hexagon/mm/init.c~mm-remove-mmu_gathers-storage-from-remaining-architectures
+++ a/arch/hexagon/mm/init.c
@@ -29,8 +29,6 @@ int max_kernel_seg = 0x303;
 /*  indicate pfn's of high memory  */
 unsigned long highstart_pfn, highend_pfn;
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 /* Default cache attribute for newly created page tables */
 unsigned long _dflt_cache_att = CACHEDEF;
 
--- a/arch/nds32/mm/init.c~mm-remove-mmu_gathers-storage-from-remaining-architectures
+++ a/arch/nds32/mm/init.c
@@ -18,7 +18,6 @@
 #include <asm/tlb.h>
 #include <asm/page.h>
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 DEFINE_SPINLOCK(anon_alias_lock);
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 
--- a/arch/openrisc/mm/init.c~mm-remove-mmu_gathers-storage-from-remaining-architectures
+++ a/arch/openrisc/mm/init.c
@@ -38,8 +38,6 @@
 
 int mem_init_done;
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 static void __init zone_sizes_init(void)
 {
 	unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0 };
_
