Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBC0CC433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93C0F64F3C
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbhBYTaI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:30:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:36870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234438AbhBYT1u (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:27:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E3A064F8F;
        Thu, 25 Feb 2021 19:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280563;
        bh=aUb7k/IsYwTYlpDDvB9NSWP26FpDLjH9apyRGixM+l0=;
        h=Date:From:To:Subject:From;
        b=fPhfQ/pYg3MrQVJJAVymoowEPQqS9z7CRlvDeEvobLJzRnFl17vgAnr4zsiq05LD8
         zH7aH+GfDuiAiUzyOXEfHz40o+3mT4tXAChzGvLQUX1MoIM/QBduQAbGz8+owKcq7r
         FBREvnahABiN0R1Ezan4Liffm1YsoKjWsP2V6Cb4=
Date:   Thu, 25 Feb 2021 11:16:03 -0800
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, david@redhat.com, lkp@intel.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com
Subject:  [merged]
 mm-fix-prototype-warning-from-kernel-test-robot.patch removed from -mm tree
Message-ID: <20210225191603.DoV0t0GtN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix prototype warning from kernel test robot
has been removed from the -mm tree.  Its filename was
     mm-fix-prototype-warning-from-kernel-test-robot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm: fix prototype warning from kernel test robot

Patch series "mm: clean up names and parameters of memmap_init_xxxx functions", v5.

This patchset corrects inappropriate function names of memmap_init_xxx,
and simplify parameters of functions in the code flow.  And also fix a
prototype warning reported by lkp.


This patch (of 5);

Kernel test robot calling make with 'W=1' is triggering warning like
below for memmap_init_zone() function.

mm/page_alloc.c:6259:23: warning: no previous prototype for 'memmap_init_zone' [-Wmissing-prototypes]
 6259 | void __meminit __weak memmap_init_zone(unsigned long size, int nid,
      |                       ^~~~~~~~~~~~~~~~

Fix it by adding the function declaration in include/linux/mm.h.  Since
memmap_init_zone() has a generic version with '__weak', the declaratoin in
ia64 header file can be simply removed.

Link: https://lkml.kernel.org/r/20210122135956.5946-1-bhe@redhat.com
Link: https://lkml.kernel.org/r/20210122135956.5946-2-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/pgtable.h |    6 ------
 include/linux/mm.h              |    2 ++
 2 files changed, 2 insertions(+), 6 deletions(-)

--- a/arch/ia64/include/asm/pgtable.h~mm-fix-prototype-warning-from-kernel-test-robot
+++ a/arch/ia64/include/asm/pgtable.h
@@ -517,12 +517,6 @@ extern struct page *zero_page_memmap_ptr
 	__changed;							\
 })
 #endif
-
-#  ifdef CONFIG_VIRTUAL_MEM_MAP
-  /* arch mem_map init routine is needed due to holes in a virtual mem_map */
-    extern void memmap_init (unsigned long size, int nid, unsigned long zone,
-			     unsigned long start_pfn);
-#  endif /* CONFIG_VIRTUAL_MEM_MAP */
 # endif /* !__ASSEMBLY__ */
 
 /*
--- a/include/linux/mm.h~mm-fix-prototype-warning-from-kernel-test-robot
+++ a/include/linux/mm.h
@@ -2408,6 +2408,8 @@ extern void set_dma_reserve(unsigned lon
 extern void memmap_init_zone(unsigned long, int, unsigned long,
 		unsigned long, unsigned long, enum meminit_context,
 		struct vmem_altmap *, int migratetype);
+extern void memmap_init(unsigned long size, int nid,
+		unsigned long zone, unsigned long range_start_pfn);
 extern void setup_per_zone_wmarks(void);
 extern int __meminit init_per_zone_wmark_min(void);
 extern void mem_init(void);
_

Patches currently in -mm which might be from bhe@redhat.com are


