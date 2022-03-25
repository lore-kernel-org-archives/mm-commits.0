Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10721C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354408AbiCYBdl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357366AbiCYBcZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:32:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D093DDED
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:30:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78358B81DEA
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 374C8C340EE;
        Fri, 25 Mar 2022 01:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171849;
        bh=peABFAexf+29PP01yGujmeicv6c/XMumnbCX04Lljjs=;
        h=Date:To:From:Subject:From;
        b=nMkCYN9uvVPISH4Sioc7PyYTUXALKFAYmumG1zNOmYOSqsZo2V+OXEYNzkGLKmXH0
         k+0je2O3kVK/mtVTEDp/yBsDVA8IHivi42zVOVcJmhKuP+rzVKU7Lv7OBc7zhWukGY
         V2n4rayWmL6Mvxs/txqqsk3UiJmPeUkL0++CK42A=
Date:   Thu, 24 Mar 2022 18:30:48 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        stefan.kristiansson@saunalahti.fi, rppt@linux.ibm.com,
        rmk+kernel@armlinux.org.uk, nickhu@andestech.com,
        jonas@southpole.se, green.hu@gmail.com, deanbo422@gmail.com,
        david@redhat.com, dave.hansen@linux.intel.com,
        christophe.leroy@c-s.fr, bcain@codeaurora.org, shorne@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-remove-mmu_gathers-storage-from-remaining-architectures.patch removed from -mm tree
Message-Id: <20220325013049.374C8C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove mmu_gathers storage from remaining architectures
has been removed from the -mm tree.  Its filename was
     mm-remove-mmu_gathers-storage-from-remaining-architectures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from shorne@gmail.com are


