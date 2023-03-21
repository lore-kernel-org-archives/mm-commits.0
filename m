Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33CA6C6FD20
	for <mm-commits@archiver.kernel.org>; Tue, 21 Mar 2023 19:39:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbjCUTjZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Mar 2023 15:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbjCUTjK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Mar 2023 15:39:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6DE13B644
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 12:38:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20103B8197B
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 19:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78CDC433EF;
        Tue, 21 Mar 2023 19:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679427422;
        bh=EOKhDIKWH9wHWi9QP2jTYilBY4onqQQyRbB19flbF60=;
        h=Date:To:From:Subject:From;
        b=ARqSBukL/gzJa6vgLOj1HLmyk44wtthavS2cTvb6fIf9iNP8IYTqHQFKq2AQaLA60
         VV00zJ+wSBYE+FxXYkwrl4W/vCbrXmZ+gFGTtNNTFF0Redn8/5gIOxwTy329GtySgb
         WdOIpJgLANsm+hD47JtgKe+RTS5zhjsBdr1C0dBM=
Date:   Tue, 21 Mar 2023 12:37:02 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        tsbogend@alpha.franken.de, opendmb@gmail.com, mhocko@kernel.org,
        mgorman@suse.de, david@redhat.com, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mips-fix-comment-about-pgtable_init.patch added to mm-unstable branch
Message-Id: <20230321193702.C78CDC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mips: fix comment about pgtable_init()
has been added to the -mm mm-unstable branch.  Its filename is
     mips-fix-comment-about-pgtable_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mips-fix-comment-about-pgtable_init.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: mips: fix comment about pgtable_init()
Date: Tue, 21 Mar 2023 19:05:00 +0200

Patch series "mm: move core MM initialization to mm/mm_init.c", v2.

This set moves most of the core MM initialization to mm/mm_init.c.

This largely includes free_area_init() and its helpers, functions used at
boot time, mm_init() from init/main.c and some of the functions it calls.

Aside from gaining some more space before mm/page_alloc.c hits 10k lines,
this makes mm/page_alloc.c to be mostly about buddy allocator and moves
the init code out of the way, which IMO improves maintainability.

Besides, this allows to move a couple of declarations out of include/linux
and make them private to mm/.

And as an added bonus there a slight decrease in vmlinux size.  For
tinyconfig and defconfig on x86 I've got

tinyconfig:
   text	   data	    bss	    dec	    hex	filename
 853206	 289376	1200128	2342710	 23bf36	a/vmlinux
 853198	 289344	1200128	2342670	 23bf0e	b/vmlinux

defconfig:
    text   	   data	    bss	    dec	    	    hex	filename
26152959	9730634	2170884	38054477	244aa4d	a/vmlinux
26152945	9730602	2170884	38054431	244aa1f	b/vmlinux


This patch (of 14):

Comment about fixrange_init() says that its called from pgtable_init()
while the actual caller is pagetabe_init().

Update comment to match the code.

Link: https://lkml.kernel.org/r/20230321170513.2401534-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20230321170513.2401534-2-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Doug Berger <opendmb@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/fixmap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/include/asm/fixmap.h~mips-fix-comment-about-pgtable_init
+++ a/arch/mips/include/asm/fixmap.h
@@ -70,7 +70,7 @@ enum fixed_addresses {
 #include <asm-generic/fixmap.h>
 
 /*
- * Called from pgtable_init()
+ * Called from pagetable_init()
  */
 extern void fixrange_init(unsigned long start, unsigned long end,
 	pgd_t *pgd_base);
_

Patches currently in -mm which might be from rppt@kernel.org are

mips-fix-comment-about-pgtable_init.patch
mm-page_alloc-add-helper-for-checking-if-check_pages_enabled.patch
mm-move-most-of-core-mm-initialization-to-mm-mm_initc.patch
mm-handle-hashdist-initialization-in-mm-mm_initc.patch
mm-page_alloc-rename-page_alloc_init-to-page_alloc_init_cpuhp.patch
init-fold-build_all_zonelists-and-page_alloc_init_cpuhp-to-mm_init.patch
initmm-move-mm_init-to-mm-mm_initc-and-rename-it-to-mm_core_init.patch
mm-call-ptlockpgtable_cache_init-directly-from-mm_core_init.patch
mm-move-init_mem_debugging_and_hardening-to-mm-mm_initc.patch
initmm-fold-late-call-to-page_ext_init-to-page_alloc_init_late.patch
mm-move-mem_init_print_info-to-mm_initc.patch
mm-move-kmem_cache_init-declaration-to-mm-slabh.patch
mm-move-vmalloc_init-declaration-to-mm-internalh.patch
maintainers-extend-memblock-entry-to-include-mm-initialization.patch

