Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F134C7EE29
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jun 2023 20:22:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjFAUWl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jun 2023 16:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231985AbjFAUWi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2023 16:22:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECD71BD
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 13:22:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5971864974
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 20:21:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB86C433D2;
        Thu,  1 Jun 2023 20:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685650894;
        bh=8GJelgxt+mlW1VsfXzqzeGkzLE1TmDsqbFg7spCC2cE=;
        h=Date:To:From:Subject:From;
        b=mh5AMb5nQx6Fp//bhvYDxfm+vhcOzbHhBcKWHvsM9weIIxvS5KgPOhv7L8CORSs3e
         7IYkssn4NnBkvUH27NUWOKskeNw3rHMI1fOo33eScFXWpHcBKsJf1vrHz6K+9nkKSW
         y/4QyeZT8vcB9jI163wJOEUpJ+wIut+R/4YJxD2o=
Date:   Thu, 01 Jun 2023 13:21:33 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, mhocko@kernel.org,
        haifeng.xu@shopee.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-move-set_pageblock_order-to-free_area_init.patch added to mm-unstable branch
Message-Id: <20230601202134.ADB86C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mm_init.c: move set_pageblock_order() to free_area_init()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_initc-move-set_pageblock_order-to-free_area_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_initc-move-set_pageblock_order-to-free_area_init.patch

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
From: Haifeng Xu <haifeng.xu@shopee.com>
Subject: mm/mm_init.c: move set_pageblock_order() to free_area_init()
Date: Thu, 1 Jun 2023 06:35:35 +0000

pageblock_order only needs to be set once, there is no need to initialize
it in every zone/node.

Link: https://lkml.kernel.org/r/20230601063536.26882-1-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/mm_init.c~mm-mm_initc-move-set_pageblock_order-to-free_area_init
+++ a/mm/mm_init.c
@@ -1585,7 +1585,6 @@ static void __init free_area_init_core(s
 		if (!size)
 			continue;
 
-		set_pageblock_order();
 		setup_usemap(zone);
 		init_currently_empty_zone(zone, zone->zone_start_pfn, size);
 	}
@@ -1852,6 +1851,8 @@ void __init free_area_init(unsigned long
 	/* Initialise every node */
 	mminit_verify_pageflags_layout();
 	setup_nr_node_ids();
+	set_pageblock_order();
+
 	for_each_node(nid) {
 		pg_data_t *pgdat;
 
_

Patches currently in -mm which might be from haifeng.xu@shopee.com are

memcg-oom-remove-unnecessary-check-in-mem_cgroup_oom_synchronize.patch
memcg-oom-remove-explicit-wakeup-in-mem_cgroup_oom_synchronize.patch
mm-oom-do-not-check-0-mask-in-out_of_memory.patch
mm-memcontrol-fix-typo-in-comment.patch
selftests-cgroup-fix-unexpected-failure-on-test_memcg_low.patch
mm-mm_initc-introduce-reset_memoryless_node_totalpages.patch
mm-mm_initc-do-not-calculate-zone_start_pfn-zone_end_pfn-in-zone_absent_pages_in_node.patch
mm-mm_initc-remove-free_area_init_memoryless_node.patch
mm-mm_initc-move-set_pageblock_order-to-free_area_init.patch
fork-optimize-memcg_charge_kernel_stack-a-bit.patch

