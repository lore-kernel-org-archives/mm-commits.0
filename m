Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9315CC77B7A
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 17:51:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjFGRvy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jun 2023 13:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbjFGRvx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jun 2023 13:51:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2451FD6
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 10:51:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A1016396D
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 17:51:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88790C433D2;
        Wed,  7 Jun 2023 17:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686160311;
        bh=8yhFPlvYiPJP9q3++DoTzg4f/Drve0h2YgaB5OkMs9Q=;
        h=Date:To:From:Subject:From;
        b=Fwk++/09O5B7J6BfAx4ig3xLLUplnczetKSAwzkb3nImLHGrJzsGCNtFmMlL/d8mS
         qBsMr6cQz/Lz9T+MlxZx2FO4BZfKXibyyVS6kqA/HkbRmvnGNR9GaOErgocEOmo/Au
         4n2t8U0T5huras0WuUjv+i9VMoLxJUnLeWcXUoXk=
Date:   Wed, 07 Jun 2023 10:51:50 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, osalvador@suse.de,
        mhocko@kernel.org, david@redhat.com, haifeng.xu@shopee.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-remove-reset_node_managed_pages-in-hotadd_init_pgdat.patch added to mm-unstable branch
Message-Id: <20230607175151.88790C433D2@smtp.kernel.org>
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
Date: Wed, 7 Jun 2023 02:45:48 +0000

managed pages has already been set to 0 in free_area_init_core_hotplug(),
via zone_init_internals() on each zone.  It's pointless to reset again.

Furthermore, reset_node_managed_pages() no longer needs to be exposed
outside of mm/memblock.c.  Remove declaration in include/linux/memblock.h
and define it as static.

In addtion to this, the only caller of reset_node_managed_pages() is
reset_all_zones_managed_pages(), which is annotated with __init, so it
should be safe to also mark reset_node_managed_pages() as __init.

Link: https://lkml.kernel.org/r/20230607024548.1240-1-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    1 -
 mm/memblock.c            |    2 +-
 mm/memory_hotplug.c      |    1 -
 3 files changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/memblock.h~mm-memory_hotplug-remove-reset_node_managed_pages-in-hotadd_init_pgdat
+++ a/include/linux/memblock.h
@@ -128,7 +128,6 @@ int memblock_clear_nomap(phys_addr_t bas
 
 void memblock_free_all(void);
 void memblock_free(void *ptr, size_t size);
-void reset_node_managed_pages(pg_data_t *pgdat);
 void reset_all_zones_managed_pages(void);
 
 /* Low level functions */
--- a/mm/memblock.c~mm-memory_hotplug-remove-reset_node_managed_pages-in-hotadd_init_pgdat
+++ a/mm/memblock.c
@@ -2122,7 +2122,7 @@ static unsigned long __init free_low_mem
 
 static int reset_managed_pages_done __initdata;
 
-void reset_node_managed_pages(pg_data_t *pgdat)
+static void __init reset_node_managed_pages(pg_data_t *pgdat)
 {
 	struct zone *z;
 
--- a/mm/memory_hotplug.c~mm-memory_hotplug-remove-reset_node_managed_pages-in-hotadd_init_pgdat
+++ a/mm/memory_hotplug.c
@@ -1194,7 +1194,6 @@ static pg_data_t __ref *hotadd_init_pgda
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
mm-mm_initc-drop-nid-parameter-from-check_for_memory.patch
mm-memory_hotplug-remove-reset_node_managed_pages-in-hotadd_init_pgdat.patch
mm-mm_initc-remove-reset_node_present_pages.patch
fork-optimize-memcg_charge_kernel_stack-a-bit.patch

