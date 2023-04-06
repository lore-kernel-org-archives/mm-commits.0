Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E79B2C7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234980AbjDFCrT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235006AbjDFCpU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:45:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B6293FA
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49AC8642A2
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A335EC433D2;
        Thu,  6 Apr 2023 02:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749114;
        bh=INUkwLQ9t9E4uBLl2llh5cPnPlzGjnm1IYmHxNnzV9U=;
        h=Date:To:From:Subject:From;
        b=C5z/09ESJTcRZRJa+H82EzgEJenyrlbCUzaCfW/knvUIIpVtCB9UxcNqm0rwwuIIN
         JhTuScqF2zSRZu6cHCzzTxDXv/zqn1aRB6KY4d6XDZEdvtkL1qg1ZFxIFfWCGIaJea
         RBT3oVwvY9D4xipiSO7YG2Bzcy3O8d/3yBN/BRZQ=
Date:   Wed, 05 Apr 2023 19:45:14 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        tsbogend@alpha.franken.de, opendmb@gmail.com, mhocko@kernel.org,
        mgorman@suse.de, david@redhat.com, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] init-fold-build_all_zonelists-and-page_alloc_init_cpuhp-to-mm_init.patch removed from -mm tree
Message-Id: <20230406024514.A335EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: init: fold build_all_zonelists() and page_alloc_init_cpuhp() to mm_init()
has been removed from the -mm tree.  Its filename was
     init-fold-build_all_zonelists-and-page_alloc_init_cpuhp-to-mm_init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: init: fold build_all_zonelists() and page_alloc_init_cpuhp() to mm_init()
Date: Tue, 21 Mar 2023 19:05:05 +0200

Both build_all_zonelists() and page_alloc_init_cpuhp() must be called
after SMP setup is complete but before the page allocator is set up.

Still, they both are a part of memory management initialization, so move
them to mm_init().

Link: https://lkml.kernel.org/r/20230321170513.2401534-7-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Doug Berger <opendmb@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/init/main.c~init-fold-build_all_zonelists-and-page_alloc_init_cpuhp-to-mm_init
+++ a/init/main.c
@@ -837,6 +837,10 @@ static void __init report_meminit(void)
  */
 static void __init mm_init(void)
 {
+	/* Initializations relying on SMP setup */
+	build_all_zonelists(NULL);
+	page_alloc_init_cpuhp();
+
 	/*
 	 * page_ext requires contiguous pages,
 	 * bigger than MAX_ORDER unless SPARSEMEM.
@@ -972,9 +976,6 @@ asmlinkage __visible void __init __no_sa
 	smp_prepare_boot_cpu();	/* arch-specific boot-cpu hooks */
 	boot_cpu_hotplug_init();
 
-	build_all_zonelists(NULL);
-	page_alloc_init_cpuhp();
-
 	pr_notice("Kernel command line: %s\n", saved_command_line);
 	/* parameters may set static keys */
 	jump_label_init();
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

