Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43236C7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:47:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234857AbjDFCra (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234656AbjDFCpq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:45:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A022976B
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C2F8642A2
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6830C433EF;
        Thu,  6 Apr 2023 02:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749119;
        bh=+uln6RngsO4b1WAk18nprjeRB2+AkL4TUwMzyhnbl7c=;
        h=Date:To:From:Subject:From;
        b=vXfkAMqg3c5VvPuXm52CDR8i2x1UU2SpY4DEN68JDg3grCLCEjNDGDX0s3xEDSP74
         GPt8mZcjhI9YD4j60jmXa1nJI9uFSdNuWTeDN7vich8wbpvW+CVP6g89dGqUbi8nFW
         kRU441r6XJH0Gg/MP1fDZ8gayOKNo0heiQJ8Bop4=
Date:   Wed, 05 Apr 2023 19:45:19 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        tsbogend@alpha.franken.de, opendmb@gmail.com, mhocko@kernel.org,
        mgorman@suse.de, david@redhat.com, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] initmm-fold-late-call-to-page_ext_init-to-page_alloc_init_late.patch removed from -mm tree
Message-Id: <20230406024519.D6830C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: init,mm: fold late call to page_ext_init() to page_alloc_init_late()
has been removed from the -mm tree.  Its filename was
     initmm-fold-late-call-to-page_ext_init-to-page_alloc_init_late.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: init,mm: fold late call to page_ext_init() to page_alloc_init_late()
Date: Tue, 21 Mar 2023 19:05:09 +0200

When deferred initialization of struct pages is enabled, page_ext_init()
must be called after all the deferred initialization is done, but there is
no point to keep it a separate call from kernel_init_freeable() right
after page_alloc_init_late().

Fold the call to page_ext_init() into page_alloc_init_late() and localize
deferred_struct_pages variable.

Link: https://lkml.kernel.org/r/20230321170513.2401534-11-rppt@kernel.org
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

 include/linux/page_ext.h |    2 --
 init/main.c              |    4 ----
 mm/mm_init.c             |    6 +++++-
 3 files changed, 5 insertions(+), 7 deletions(-)

--- a/include/linux/page_ext.h~initmm-fold-late-call-to-page_ext_init-to-page_alloc_init_late
+++ a/include/linux/page_ext.h
@@ -29,8 +29,6 @@ struct page_ext_operations {
 	bool need_shared_flags;
 };
 
-extern bool deferred_struct_pages;
-
 #ifdef CONFIG_PAGE_EXTENSION
 
 /*
--- a/init/main.c~initmm-fold-late-call-to-page_ext_init-to-page_alloc_init_late
+++ a/init/main.c
@@ -62,7 +62,6 @@
 #include <linux/rmap.h>
 #include <linux/mempolicy.h>
 #include <linux/key.h>
-#include <linux/page_ext.h>
 #include <linux/debug_locks.h>
 #include <linux/debugobjects.h>
 #include <linux/lockdep.h>
@@ -1565,9 +1564,6 @@ static noinline void __init kernel_init_
 
 	padata_init();
 	page_alloc_init_late();
-	/* Initialize page ext after all struct pages are initialized. */
-	if (deferred_struct_pages)
-		page_ext_init();
 
 	do_basic_setup();
 
--- a/mm/mm_init.c~initmm-fold-late-call-to-page_ext_init-to-page_alloc_init_late
+++ a/mm/mm_init.c
@@ -225,7 +225,7 @@ static unsigned long nr_kernel_pages __i
 static unsigned long nr_all_pages __initdata;
 static unsigned long dma_reserve __initdata;
 
-bool deferred_struct_pages __meminitdata;
+static bool deferred_struct_pages __meminitdata;
 
 static DEFINE_PER_CPU(struct per_cpu_nodestat, boot_nodestats);
 
@@ -2358,6 +2358,10 @@ void __init page_alloc_init_late(void)
 
 	for_each_populated_zone(zone)
 		set_zone_contiguous(zone);
+
+	/* Initialize page ext after all struct pages are initialized. */
+	if (deferred_struct_pages)
+		page_ext_init();
 }
 
 #ifndef __HAVE_ARCH_RESERVED_KERNEL_PAGES
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

