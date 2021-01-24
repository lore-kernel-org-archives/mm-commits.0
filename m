Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50381C433E0
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:53:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A80D22D07
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:53:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbhAXBxm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 23 Jan 2021 20:53:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:50840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726433AbhAXBxl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 23 Jan 2021 20:53:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D362227BF;
        Sun, 24 Jan 2021 01:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611453180;
        bh=bD+9OWZmdBoC0mpNyNWrjOFrQ2BYcwcReFzex48IiXg=;
        h=Date:From:To:Subject:From;
        b=eD15unr/1OQtWOMEsCgIV/k8Z8Iu91dSoir6ZRnxr40Zo1ANWpULQW4gUt2dODf/m
         92a1b7P13stXd8FjUnfwfcRRDI8ez653E6bDSrvvEeefxNE0vHITtSLzbNm+NFK7Z5
         t3EOHIFuIqJ6VcdOgSGjlg5Y+feFqWOTIbqbDsRI=
Date:   Sat, 23 Jan 2021 17:52:59 -0800
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, david@redhat.com, lkp@intel.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com
Subject:  + mm-fix-prototype-warning-from-kernel-test-robot.patch
 added to -mm tree
Message-ID: <20210124015259.N5n7H-lRD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix prototype warning from kernel test robot
has been added to the -mm tree.  Its filename is
     mm-fix-prototype-warning-from-kernel-test-robot.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-prototype-warning-from-kernel-test-robot.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-prototype-warning-from-kernel-test-robot.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2442,6 +2442,8 @@ extern void set_dma_reserve(unsigned lon
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

mm-fix-prototype-warning-from-kernel-test-robot.patch
mm-rename-memmap_init-and-memmap_init_zone.patch
mm-simplify-parater-of-function-memmap_init_zone.patch
mm-simplify-parameter-of-setup_usemap.patch
mm-remove-unneeded-local-variable-in-free_area_init_core.patch

