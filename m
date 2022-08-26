Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70D2AECAAA2
	for <mm-commits@archiver.kernel.org>; Fri, 26 Aug 2022 03:05:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244023AbiHZDFA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Aug 2022 23:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244498AbiHZDEw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Aug 2022 23:04:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6A018B0C
        for <mm-commits@vger.kernel.org>; Thu, 25 Aug 2022 20:04:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BFB461E6E
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 03:04:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE549C433D6;
        Fri, 26 Aug 2022 03:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661483088;
        bh=jA22JPoZprLaEfbUqO7TKiwVnYpqvgkmnD59q+XSqeU=;
        h=Date:To:From:Subject:From;
        b=Xhmq7l4mVyeh8/bIKv71rS2ylPQ2IYoKwzhUZB+q+zNh1VM2JuTfLPgKDUB4c1G7o
         cG1KQZhSNEg1xYjzB2CqgxLQSu+BcQHTbb2IqNL79gpgtHRNhgXPZ7Qqz/B9NGMNmm
         a/M3VscGJeoxoDheUSRdYREjVrXoseoh4X1SsUPQ=
Date:   Thu, 25 Aug 2022 20:04:47 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        weixugc@google.com, tim.c.chen@intel.com, shy828301@gmail.com,
        mhocko@kernel.org, jvgediya.oss@gmail.com,
        Jonathan.Cameron@huawei.com, hesham.almatary@huawei.com,
        hannes@cmpxchg.org, dave@stgolabs.net, dave.hansen@intel.com,
        dan.j.williams@intel.com, bharata@amd.com, apopple@nvidia.com,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-demotion-add-hotplug-callbacks-to-handle-new-numa-node-onlined-fix.patch added to mm-unstable branch
Message-Id: <20220826030447.DE549C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/demotion: fix kernel error with memory hotplug
has been added to the -mm mm-unstable branch.  Its filename is
     mm-demotion-add-hotplug-callbacks-to-handle-new-numa-node-onlined-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-demotion-add-hotplug-callbacks-to-handle-new-numa-node-onlined-fix.patch

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
mm-demotion-add-hotplug-callbacks-to-handle-new-numa-node-onlined-fix.patch
mm-demotion-dax-kmem-set-nodes-abstract-distance-to-memtier_default_dax_adistance.patch
mm-demotion-build-demotion-targets-based-on-explicit-memory-tiers.patch
mm-demotion-add-pg_data_t-member-to-track-node-memory-tier-details.patch
mm-demotion-drop-memtier-from-memtype.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers.patch
lib-nodemask-optimize-node_random-for-nodemask-with-single-numa-node.patch

