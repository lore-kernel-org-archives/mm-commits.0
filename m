Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 352EAC07E9D
	for <mm-commits@archiver.kernel.org>; Mon, 26 Sep 2022 20:58:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbiIZU56 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 16:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbiIZU55 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 16:57:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD95FA0313
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 13:57:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89BF3B8111B
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 20:57:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439EFC433C1;
        Mon, 26 Sep 2022 20:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664225873;
        bh=OJbkJCqyUytOBcHHvThGk+hSgZtl0Du2L5IrKbtJc2k=;
        h=Date:To:From:Subject:From;
        b=JlspnOef/oy2UlRoGyfiGzk4/2RjY0P7CjsNy/Uq7UiUP3xBJJFLXtSAVSKoeFgYI
         r8fj/6xzJ4x91hp9RFNjqQX1FPYW90cixtAHVnuxCDKvcfBOjAHVh1YyUzqHO5TvJj
         D5cPYS/nIXofksl+HPNqvyCDYCEphgSFxD2J7yrE=
Date:   Mon, 26 Sep 2022 13:57:52 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        weixugc@google.com, tim.c.chen@intel.com, sj@kernel.org,
        shy828301@gmail.com, mhocko@kernel.org, jvgediya.oss@gmail.com,
        Jonathan.Cameron@huawei.com, hesham.almatary@huawei.com,
        hannes@cmpxchg.org, dave@stgolabs.net, dave.hansen@intel.com,
        dan.j.williams@intel.com, bharata@amd.com, apopple@nvidia.com,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-demotion-add-hotplug-callbacks-to-handle-new-numa-node-onlined-fix.patch removed from -mm tree
Message-Id: <20220926205753.439EFC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/demotion: fix kernel error with memory hotplug
has been removed from the -mm tree.  Its filename was
     mm-demotion-add-hotplug-callbacks-to-handle-new-numa-node-onlined-fix.patch

This patch was dropped because it was folded into mm-demotion-add-hotplug-callbacks-to-handle-new-numa-node-onlined.patch

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/demotion: fix kernel error with memory hotplug
Date: Thu, 25 Aug 2022 14:50:19 +0530

On memory hot unplug, the kernel removes the node memory type from the
associated memory tier.  Use list_del_init instead of list del such that
the same memory type can be added back to a memory tier on hotplug.

Without this, we get the below warning and return error on
adding memory type to a new memory tier.

[   33.596095] ------------[ cut here ]------------
[   33.596099] WARNING: CPU: 3 PID: 667 at mm/memory-tiers.c:115 set_node_memory_tier+0xd6/0x2e0
[   33.596109] Modules linked in: kmem

...

[   33.596126] RIP: 0010:set_node_memory_tier+0xd6/0x2e0

....
[   33.596196]  memtier_hotplug_callback+0x48/0x68
[   33.596204]  blocking_notifier_call_chain+0x80/0xc0
[   33.596211]  online_pages+0x25e/0x280
[   33.596218]  memory_block_change_state+0x176/0x1f0
[   33.596225]  memory_subsys_online+0x37/0x40
[   33.596230]  online_store+0x9b/0x130
[   33.596236]  kernfs_fop_write_iter+0x128/0x1b0
[   33.596242]  vfs_write+0x24b/0x2c0
[   33.596249]  ksys_write+0x74/0xe0
[   33.596254]  do_syscall_64+0x43/0x90
[   33.596259]  entry_SYSCALL_64_after_hwframe+0x63/0xcd

Link: https://lkml.kernel.org/r/20220825092019.379069-1-aneesh.kumar@linux.ibm.com
Fixes: "mm/demotion: Add hotplug callbacks to handle new numa node onlined"
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Bharata B Rao <bharata@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hesham Almatary <hesham.almatary@huawei.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Jagdish Gediya <jvgediya.oss@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tim Chen <tim.c.chen@intel.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-tiers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-tiers.c~mm-demotion-add-hotplug-callbacks-to-handle-new-numa-node-onlined-fix
+++ a/mm/memory-tiers.c
@@ -134,7 +134,7 @@ static bool clear_node_memory_tier(int n
 		memtype = node_memory_types[node];
 		node_clear(node, memtype->nodes);
 		if (nodes_empty(memtype->nodes)) {
-			list_del(&memtype->tier_sibiling);
+			list_del_init(&memtype->tier_sibiling);
 			memtype->memtier = NULL;
 			if (list_empty(&memtier->memory_types))
 				destroy_memory_tier(memtier);
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-demotion-add-support-for-explicit-memory-tiers.patch
mm-demotion-move-memory-demotion-related-code.patch
mm-demotion-add-hotplug-callbacks-to-handle-new-numa-node-onlined.patch
mm-demotion-dax-kmem-set-nodes-abstract-distance-to-memtier_default_dax_adistance.patch
mm-demotion-dax-kmem-set-nodes-abstract-distance-to-memtier_default_dax_adistance-fix.patch
mm-demotion-build-demotion-targets-based-on-explicit-memory-tiers.patch
mm-demotion-add-pg_data_t-member-to-track-node-memory-tier-details.patch
mm-demotion-drop-memtier-from-memtype.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-3.patch
lib-nodemask-optimize-node_random-for-nodemask-with-single-numa-node.patch
mm-demotion-expose-memory-tier-details-via-sysfs.patch
mm-demotion-expose-memory-tier-details-via-sysfs-v4.patch

