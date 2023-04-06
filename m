Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41E1FC7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:47:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235042AbjDFCro (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234812AbjDFCpz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:45:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6828B93E0
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1683642B8
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57EBFC433EF;
        Thu,  6 Apr 2023 02:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749122;
        bh=fJvA8mo0aSNb2f2QmAPjlfSMHHPwZbvMCQ0yjHT/kYs=;
        h=Date:To:From:Subject:From;
        b=QOxuw3tazRlMNEo8c36HeekVpgJCvZgFv/Qyzp72k+fJQz2rkbKSBgTA8k/XNvY3p
         RldYtYOLrMnXufrxhQ7O1AyC6DyxAou8eLQzw9BSf2xeRr6FHwuXEc31q0x/nTfEZu
         1qWR7OK5Dsnn0b7QRy54Ew6darqPmk4hSOo2PXkg=
Date:   Wed, 05 Apr 2023 19:45:21 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        tsbogend@alpha.franken.de, opendmb@gmail.com, mhocko@kernel.org,
        mgorman@suse.de, david@redhat.com, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-kmem_cache_init-declaration-to-mm-slabh.patch removed from -mm tree
Message-Id: <20230406024522.57EBFC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: move kmem_cache_init() declaration to mm/slab.h
has been removed from the -mm tree.  Its filename was
     mm-move-kmem_cache_init-declaration-to-mm-slabh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: mm: move kmem_cache_init() declaration to mm/slab.h
Date: Tue, 21 Mar 2023 19:05:11 +0200

kmem_cache_init() is called only from mm_core_init(), there is no need to
declare it in include/linux/slab.h

Move kmem_cache_init() declaration to mm/slab.h

Link: https://lkml.kernel.org/r/20230321170513.2401534-13-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Doug Berger <opendmb@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    1 -
 mm/mm_init.c         |    1 +
 mm/slab.h            |    1 +
 3 files changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/slab.h~mm-move-kmem_cache_init-declaration-to-mm-slabh
+++ a/include/linux/slab.h
@@ -167,7 +167,6 @@ struct mem_cgroup;
 /*
  * struct kmem_cache related prototypes
  */
-void __init kmem_cache_init(void);
 bool slab_is_available(void);
 
 struct kmem_cache *kmem_cache_create(const char *name, unsigned int size,
--- a/mm/mm_init.c~mm-move-kmem_cache_init-declaration-to-mm-slabh
+++ a/mm/mm_init.c
@@ -27,6 +27,7 @@
 #include <linux/swap.h>
 #include <linux/cma.h>
 #include "internal.h"
+#include "slab.h"
 #include "shuffle.h"
 
 #include <asm/setup.h>
--- a/mm/slab.h~mm-move-kmem_cache_init-declaration-to-mm-slabh
+++ a/mm/slab.h
@@ -4,6 +4,7 @@
 /*
  * Internal slab definitions
  */
+void __init kmem_cache_init(void);
 
 /* Reuses the bits in struct page */
 struct slab {
_

Patches currently in -mm which might be from rppt@kernel.org are

arm-reword-arch_force_max_order-prompt-and-help-text.patch
arm64-drop-ranges-in-definition-of-arch_force_max_order.patch
arm64-reword-arch_force_max_order-prompt-and-help-text.patch
arm64-reword-arch_force_max_order-prompt-and-help-text-v3.patch
csky-drop-arch_force_max_order.patch
ia64-dont-allow-users-to-override-arch_force_max_order.patch
m68k-reword-arch_force_max_order-prompt-and-help-text.patch
nios2-reword-arch_force_max_order-prompt-and-help-text.patch
nios2-drop-ranges-for-definition-of-arch_force_max_order.patch
powerpc-reword-arch_force_max_order-prompt-and-help-text.patch
powerpc-drop-ranges-for-definition-of-arch_force_max_order.patch
sh-reword-arch_force_max_order-prompt-and-help-text.patch
sh-reword-arch_force_max_order-prompt-and-help-text-v3.patch
sh-drop-ranges-for-definition-of-arch_force_max_order.patch
sh-drop-ranges-for-definition-of-arch_force_max_order-v3.patch
sparc-reword-arch_force_max_order-prompt-and-help-text.patch
xtensa-reword-arch_force_max_order-prompt-and-help-text.patch
mm-move-free_area_empty-to-mm-internalh.patch

