Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DEA3C77B7E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jun 2023 22:21:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbjFAWVa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jun 2023 18:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232834AbjFAWV3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2023 18:21:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 226AD195
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 15:21:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABCE464741
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 22:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1033BC433EF;
        Thu,  1 Jun 2023 22:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685658087;
        bh=uZUuUEcIXQ/efUCTAvXOkszEB5jtaqI7C4fO2zPsNes=;
        h=Date:To:From:Subject:From;
        b=uv+tcjWFMv3G+5zJ4i8o7R+aooBSdSQZ50yDKiAw1tB6KiSbcjgTxmy/aKH5xsU9U
         5HQx+xAVrkypoggqDshPe7YVOhWJe6ncHVVLwl94tv5o9ySbFmYvav3Azo8SDVClEg
         EVmxDlnSlHImQ2FMH8jDNX59+xTUryZWwOqqNQI0=
Date:   Thu, 01 Jun 2023 15:21:26 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, osalvador@suse.de,
        mhocko@kernel.org, david@redhat.com, akpm@linux-foudation.org,
        haifeng.xu@shopee.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-remove-reset_node_managed_pages-in-hotadd_init_pgdat.patch added to mm-unstable branch
Message-Id: <20230601222127.1033BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: remove reset_node_managed_pages() in hotadd_init_pgdat()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory_hotplug-remove-reset_node_managed_pages-in-hotadd_init_pgdat.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-remove-reset_node_managed_pages-in-hotadd_init_pgdat.patch

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
Subject: mm/memory_hotplug: remove reset_node_managed_pages() in hotadd_init_pgdat()
Date: Thu, 1 Jun 2023 16:26:25 +0000

managed pages has already been set to 0 in free_area_init_core_hotplug(),
so it's pointless to reset again.

Link: https://lkml.kernel.org/r/20230601162626.1030-1-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Reviewed-by: Andrew Morton <akpm@linux-foudation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Haifeng Xu <haifeng.xu@shopee.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-remove-reset_node_managed_pages-in-hotadd_init_pgdat
+++ a/mm/memory_hotplug.c
@@ -1210,7 +1210,6 @@ static pg_data_t __ref *hotadd_init_pgda
 	 * online_pages() and offline_pages().
 	 * TODO: should be in free_area_init_core_hotplug?
 	 */
-	reset_node_managed_pages(pgdat);
 	reset_node_present_pages(pgdat);
 
 	return pgdat;
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
mm-memory_hotplug-remove-reset_node_managed_pages-in-hotadd_init_pgdat.patch
mm-mm_initc-remove-reset_node_present_pages.patch
fork-optimize-memcg_charge_kernel_stack-a-bit.patch

