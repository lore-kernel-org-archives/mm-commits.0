Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D68ACDB482
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 20:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbjJRUJq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 16:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbjJRUJn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 16:09:43 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8218A9F
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 13:09:41 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E21FC433C7;
        Wed, 18 Oct 2023 20:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697659781;
        bh=Bbqj6pn2u52B6Vq0XNRuaPtYGkM7lj0QPSsE8Vml/go=;
        h=Date:To:From:Subject:From;
        b=Twv28ACo/P1dvRiY/ziunJ6bNbhMklsBHfylusXiNXHxtN6pC2DWFdnefK4oP4XYY
         kpcoB2a1Y9bYA1IDrIqM33kr75yR4f/fKPnu5cP89Z1rB0ywNpNIDxaE9mJT8hAtVM
         YgFdCT0SGttDWpx9WeS8ryAsXG3w76aV7tVxHKXA=
Date:   Wed, 18 Oct 2023 13:09:40 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, shuah@kernel.org,
        shakeelb@google.com, roman.gushchin@linux.dev, nphamcs@gmail.com,
        muchun.song@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        ddstreet@ieee.org, cerasuolodomenico@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-add-per-memcg-zswap-writeback-stat.patch added to mm-unstable branch
Message-Id: <20231018200941.1E21FC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: add per-memcg zswap writeback stat
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-add-per-memcg-zswap-writeback-stat.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-add-per-memcg-zswap-writeback-stat.patch

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
From: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Subject: mm: memcg: add per-memcg zswap writeback stat
Date: Tue, 17 Oct 2023 16:21:50 -0700

Since zswap now writes back pages from memcg-specific LRUs, we now need a
new stat to show writebacks count for each memcg.

Link: https://lkml.kernel.org/r/20231017232152.2605440-4-nphamcs@gmail.com
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 ++
 mm/memcontrol.c            |   15 +++++++++++++++
 mm/zswap.c                 |    3 +++
 3 files changed, 20 insertions(+)

--- a/include/linux/memcontrol.h~mm-memcg-add-per-memcg-zswap-writeback-stat
+++ a/include/linux/memcontrol.h
@@ -38,6 +38,7 @@ enum memcg_stat_item {
 	MEMCG_KMEM,
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
+	MEMCG_ZSWAP_WB,
 	MEMCG_NR_STAT,
 };
 
@@ -1884,6 +1885,7 @@ static inline void count_objcg_event(str
 bool obj_cgroup_may_zswap(struct obj_cgroup *objcg);
 void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size);
 void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size);
+void obj_cgroup_report_zswap_wb(struct obj_cgroup *objcg);
 #else
 static inline bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
 {
--- a/mm/memcontrol.c~mm-memcg-add-per-memcg-zswap-writeback-stat
+++ a/mm/memcontrol.c
@@ -1521,6 +1521,7 @@ static const struct memory_stat memory_s
 #if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_ZSWAP)
 	{ "zswap",			MEMCG_ZSWAP_B			},
 	{ "zswapped",			MEMCG_ZSWAPPED			},
+	{ "zswap_wb",			MEMCG_ZSWAP_WB			},
 #endif
 	{ "file_mapped",		NR_FILE_MAPPED			},
 	{ "file_dirty",			NR_FILE_DIRTY			},
@@ -1557,6 +1558,7 @@ static int memcg_page_state_unit(int ite
 	switch (item) {
 	case MEMCG_PERCPU_B:
 	case MEMCG_ZSWAP_B:
+	case MEMCG_ZSWAP_WB:
 	case NR_SLAB_RECLAIMABLE_B:
 	case NR_SLAB_UNRECLAIMABLE_B:
 		return 1;
@@ -7899,6 +7901,19 @@ void obj_cgroup_uncharge_zswap(struct ob
 	rcu_read_unlock();
 }
 
+void obj_cgroup_report_zswap_wb(struct obj_cgroup *objcg)
+{
+	struct mem_cgroup *memcg;
+
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return;
+
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
+	mod_memcg_state(memcg, MEMCG_ZSWAP_WB, 1);
+	rcu_read_unlock();
+}
+
 static u64 zswap_current_read(struct cgroup_subsys_state *css,
 			      struct cftype *cft)
 {
--- a/mm/zswap.c~mm-memcg-add-per-memcg-zswap-writeback-stat
+++ a/mm/zswap.c
@@ -704,6 +704,9 @@ static enum lru_status shrink_memcg_cb(s
 	}
 	zswap_written_back_pages++;
 
+	if (entry->objcg)
+		obj_cgroup_report_zswap_wb(entry->objcg);
+
 	/*
 	 * Writeback started successfully, the page now belongs to the
 	 * swapcache. Drop the entry from zswap - unless invalidate already
_

Patches currently in -mm which might be from cerasuolodomenico@gmail.com are

zswap-make-shrinking-memcg-aware.patch
mm-memcg-add-per-memcg-zswap-writeback-stat.patch
selftests-cgroup-update-per-memcg-zswap-writeback-selftest.patch

