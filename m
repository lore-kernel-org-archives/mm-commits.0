Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E261C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 18:57:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383424AbiEMS5d (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 14:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383418AbiEMS5c (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 14:57:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FA36B7E3
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 11:57:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECDD5B83133
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 18:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC00C34100;
        Fri, 13 May 2022 18:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652468248;
        bh=5XkrAhDb5fGmEcVIIjJYFTK+mfyrjUjtK7qfEj02Jwg=;
        h=Date:To:From:Subject:From;
        b=ADi1HLQa4fBNJ+nVAWgSTINbCogzCcEZoRrFSM2e50m0Z0zLEs5TvspCtVI8YO/w2
         ajCatmoz/sU0w7FAkzOM8VWom/AX6ZL+magew4ChQ2XJtm6HJqn50sMBdc6BgL6RL5
         yGsQhD7uYor6xE4LQeFAGbBfYCAPWARX6heMxADc=
Date:   Fri, 13 May 2022 11:57:27 -0700
To:     mm-commits@vger.kernel.org, sjenning@redhat.com,
        shakeelb@google.com, minchan@kernel.org, mhocko@suse.com,
        guro@fb.com, ddstreet@ieee.org, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zswap-memcg-accounting-fix-2.patch added to mm-unstable branch
Message-Id: <20220513185728.9FC00C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zswap-memcg-accounting-fix-2
has been added to the -mm mm-unstable branch.  Its filename is
     zswap-memcg-accounting-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zswap-memcg-accounting-fix-2.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: zswap-memcg-accounting-fix-2
Date: Fri, 13 May 2022 14:25:59 -0400

opt out of v1

Link: https://lkml.kernel.org/r/Yn6it9mBYFA+/lTb@cmpxchg.org
Signed-of-by: Johannes Weiner <hannes@cmpxchg.org>
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
@@ -7469,6 +7469,9 @@ bool obj_cgroup_may_zswap(struct obj_cgr
 	struct mem_cgroup *memcg, *original_memcg;
 	bool ret = true;
 
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return true;
+
 	original_memcg = get_mem_cgroup_from_objcg(objcg);
 	for (memcg = original_memcg; memcg != root_mem_cgroup;
 	     memcg = parent_mem_cgroup(memcg)) {
@@ -7505,6 +7508,9 @@ void obj_cgroup_charge_zswap(struct obj_
 {
 	struct mem_cgroup *memcg;
 
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return;
+
 	VM_WARN_ON_ONCE(!(current->flags & PF_MEMALLOC));
 
 	/* PF_MEMALLOC context, charging must succeed */
@@ -7529,6 +7535,9 @@ void obj_cgroup_uncharge_zswap(struct ob
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
documentation-filesystems-proc-update-meminfo-section-fix.patch
documentation-filesystems-proc-update-meminfo-section-fix-2.patch
mm-kconfig-move-swap-and-slab-config-options-to-the-mm-section.patch
mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus.patch
mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus-fix.patch
mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus-fix-fix.patch
mm-kconfig-simplify-zswap-configuration.patch
mm-zswap-add-basic-meminfo-and-vmstat-coverage.patch
zswap-memcg-accounting.patch
zswap-memcg-accounting-fix.patch
zswap-memcg-accounting-fix-2.patch

