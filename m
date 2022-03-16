Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F893C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 16 Mar 2022 19:33:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbiCPTea (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Mar 2022 15:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239589AbiCPTe3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2022 15:34:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EDB44BFEB
        for <mm-commits@vger.kernel.org>; Wed, 16 Mar 2022 12:33:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3646BB81CCF
        for <mm-commits@vger.kernel.org>; Wed, 16 Mar 2022 19:33:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA72C340EC;
        Wed, 16 Mar 2022 19:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647459191;
        bh=dzdvHwMl+chpsLrVrdH3ICKzP5Ol37ioQA0RtEIyz80=;
        h=Date:To:From:Subject:From;
        b=cMYNsZblRUZIwG60JNXiPsEeHyjteYEmbtwUf57OcTaxU6g7lhZVkmgi5sn979MSX
         nkp0ED7JAv+dhNUUePTDU3hqLvbRBLLuBxozUbFTBVhOsDNQN/QDUso0uImqRNpxHJ
         j6mn0W8KnVRVLhOv+Vkkw5k1eTYVqsLtUzD7JUAA=
Date:   Wed, 16 Mar 2022 12:33:10 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mkoutny@suse.com, mhocko@suse.com,
        ivan@cloudflare.com, hannes@cmpxchg.org, fhofmann@cloudflare.com,
        dqminh@cloudflare.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] memcg-sync-flush-only-if-periodic-flush-is-delayed-fix.patch removed from -mm tree
Message-Id: <20220316193311.ACA72C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-sync-flush-only-if-periodic-flush-is-delayed-fix
has been removed from the -mm tree.  Its filename was
     memcg-sync-flush-only-if-periodic-flush-is-delayed-fix.patch

This patch was dropped because it was folded into memcg-sync-flush-only-if-periodic-flush-is-delayed.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-sync-flush-only-if-periodic-flush-is-delayed-fix

remove leftover rstat_flush_time, per Shakeel

Cc: Daniel Dao <dqminh@cloudflare.com>
Cc: Frank Hofmann <fhofmann@cloudflare.com>
Cc: Ivan Babrou <ivan@cloudflare.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-sync-flush-only-if-periodic-flush-is-delayed-fix
+++ a/mm/memcontrol.c
@@ -666,7 +666,7 @@ void mem_cgroup_flush_stats(void)
 
 void mem_cgroup_flush_stats_delayed(void)
 {
-	if (rstat_flush_time && time_after64(jiffies_64, flush_next_time))
+	if (time_after64(jiffies_64, flush_next_time))
 		mem_cgroup_flush_stats();
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memcg-sync-flush-only-if-periodic-flush-is-delayed.patch
remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-list_lru-replace-linear-array-with-xarray-fix.patch
mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch
mm-memory-failurec-fix-race-with-changing-page-compound-again-fix.patch
mm-export-pageheadhuge-fix.patch
userfaultfd-provide-unmasked-address-on-page-fault-v3-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-typesh-remove-unnecessary-__bitwise__-fix.patch
taskstats-remove-unneeded-dead-assignment-fix.patch
linux-next-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
mm-slightly-clarify-ksm-logic-in-do_swap_page-fix.patch
mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

