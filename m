Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3F3DC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 21:02:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244973AbiESVCh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 17:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244985AbiESVCg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 17:02:36 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F79A5BD3B
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 14:02:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CCFB5CE27F1
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 21:02:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C30C385B8;
        Thu, 19 May 2022 21:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652994152;
        bh=q63KLFAUh2UlApSx/IMN8h3rBp5jreQl4vwGySBisoU=;
        h=Date:To:From:Subject:From;
        b=SlBWRkxG7XZdTUwgwCQI4NXxzJ05yIK7FK2gV9Fja2lPmNnYxntS6O0U830Tlejnr
         tXxjVTnNf18pMDTZfs0AWn3gBDSp6Ef/UDX4WQcTxFTluiJEQc+W4v/k2mqzuA8d1i
         BSKzojYTz7W9gqcQECGkCTCF5eq1Ok5Ck/l2LoY8=
Date:   Thu, 19 May 2022 14:02:31 -0700
To:     mm-commits@vger.kernel.org, sjenning@redhat.com,
        shakeelb@google.com, minchan@kernel.org, mhocko@suse.com,
        guro@fb.com, ddstreet@ieee.org, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] zswap-memcg-accounting-fix-2.patch removed from -mm tree
Message-Id: <20220519210231.E9C30C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zswap-memcg-accounting-fix-2
has been removed from the -mm tree.  Its filename was
     zswap-memcg-accounting-fix-2.patch

This patch was dropped because it was folded into zswap-memcg-accounting.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: zswap-memcg-accounting-fix-2
Date: Fri, 13 May 2022 14:25:59 -0400

opt out of v1

Link: https://lkml.kernel.org/r/Yn6it9mBYFA+/lTb@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/memcontrol.c~zswap-memcg-accounting-fix-2
+++ a/mm/memcontrol.c
@@ -7484,6 +7484,9 @@ bool obj_cgroup_may_zswap(struct obj_cgr
 	struct mem_cgroup *memcg, *original_memcg;
 	bool ret = true;
 
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return true;
+
 	original_memcg = get_mem_cgroup_from_objcg(objcg);
 	for (memcg = original_memcg; memcg != root_mem_cgroup;
 	     memcg = parent_mem_cgroup(memcg)) {
@@ -7520,6 +7523,9 @@ void obj_cgroup_charge_zswap(struct obj_
 {
 	struct mem_cgroup *memcg;
 
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return;
+
 	VM_WARN_ON_ONCE(!(current->flags & PF_MEMALLOC));
 
 	/* PF_MEMALLOC context, charging must succeed */
@@ -7544,6 +7550,9 @@ void obj_cgroup_uncharge_zswap(struct ob
 {
 	struct mem_cgroup *memcg;
 
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return;
+
 	obj_cgroup_uncharge(objcg, size);
 
 	rcu_read_lock();
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

documentation-filesystems-proc-update-meminfo-section.patch
mm-kconfig-move-swap-and-slab-config-options-to-the-mm-section.patch
mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus.patch
mm-kconfig-simplify-zswap-configuration.patch
mm-zswap-add-basic-meminfo-and-vmstat-coverage.patch
zswap-memcg-accounting.patch
revert-mm-vmscan-never-demote-for-memcg-reclaim.patch

