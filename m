Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7506CC7EE23
	for <mm-commits@archiver.kernel.org>; Tue, 30 May 2023 21:43:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233580AbjE3Vnc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 May 2023 17:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbjE3Vn2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2023 17:43:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B71710D
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 14:43:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2388461B72
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 21:43:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E094C433EF;
        Tue, 30 May 2023 21:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685483005;
        bh=IcYGq756XnbPJPCWBkPfFm1qaFseLT/kTREeXxsoMLA=;
        h=Date:To:From:Subject:From;
        b=A3hhBpfaalmFOII2GQPxGDWRKQ2vz1Lc/JMkj8B0OzR3goTLQkfY4U+5AcgDB4uUu
         ax630fxfM7zGsPB02UTDFXfWUyY2eSsbfL4EGLeE6N3YlTa4H4e/q+/rRDFxkm+fh4
         TNgQnBT4JgAtVVx4PY/CbdHygagVsYy8/ks+PLlQ=
Date:   Tue, 30 May 2023 14:43:24 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, mhocko@suse.com,
        haifeng.xu@shopee.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-remove-free_area_init_memoryless_node.patch added to mm-unstable branch
Message-Id: <20230530214325.7E094C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mm_init.c: remove free_area_init_memoryless_node()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_initc-remove-free_area_init_memoryless_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_initc-remove-free_area_init_memoryless_node.patch

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
Subject: mm/mm_init.c: remove free_area_init_memoryless_node()
Date: Sun, 28 May 2023 04:57:20 +0000

free_area_init_memoryless_node() is just a wrapper of
free_area_init_node(), remove it to clean up.

Link: https://lkml.kernel.org/r/20230528045720.4835-1-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/mm/mm_init.c~mm-mm_initc-remove-free_area_init_memoryless_node
+++ a/mm/mm_init.c
@@ -1754,11 +1754,6 @@ void __init setup_nr_node_ids(void)
 }
 #endif
 
-static void __init free_area_init_memoryless_node(int nid)
-{
-	free_area_init_node(nid);
-}
-
 /*
  * Some architectures, e.g. ARC may have ZONE_HIGHMEM below ZONE_NORMAL. For
  * such cases we allow max_zone_pfn sorted in the descending order
@@ -1869,7 +1864,7 @@ void __init free_area_init(unsigned long
 				panic("Cannot allocate %zuB for node %d.\n",
 				       sizeof(*pgdat), nid);
 			arch_refresh_nodedata(nid, pgdat);
-			free_area_init_memoryless_node(nid);
+			free_area_init_node(nid);
 
 			/*
 			 * We do not want to confuse userspace by sysfs
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
fork-optimize-memcg_charge_kernel_stack-a-bit.patch

