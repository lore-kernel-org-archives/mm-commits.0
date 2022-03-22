Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FF78C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:40:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235932AbiCVVmU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236090AbiCVVmL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:42:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85965EDFD
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:40:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5254B60A14
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:40:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6819C340EE;
        Tue, 22 Mar 2022 21:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985238;
        bh=KT+NPJJrwHEXCM5HymWRmRika9piNngSILhdKqRhzN0=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=whkXKU+SAG5J70E60H3TsNvgfkOJ4NZYn9D7GzUHSVtsnSbCrk1US5CPtfSwvYBhY
         IXJIhUh/Lb1VzNCkcea9Wfn8MHe7QVJztlo+e/ympg0VPxMam9W+b+HVBjUX1knvod
         n9tJonwap5i87Q86jum4lPWiIqnk7doWtl9xhfDo=
Date:   Tue, 22 Mar 2022 14:40:38 -0700
To:     vdavydov.dev@gmail.com, tglx@linutronix.de, shakeelb@google.com,
        peterz@infradead.org, oliver.sang@intel.com, mkoutny@suse.com,
        mhocko@suse.com, mhocko@kernel.org, longman@redhat.com,
        hannes@cmpxchg.org, guro@fb.com, bigeasy@linutronix.de,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 042/227] mm/memcg: disable threshold event handlers on PREEMPT_RT
Message-Id: <20220322214038.A6819C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm/memcg: disable threshold event handlers on PREEMPT_RT

During the integration of PREEMPT_RT support, the code flow around
memcg_check_events() resulted in `twisted code'.  Moving the code around
and avoiding then would then lead to an additional local-irq-save section
within memcg_check_events().  While looking better, it adds a
local-irq-save section to code flow which is usually within an
local-irq-off block on non-PREEMPT_RT configurations.

The threshold event handler is a deprecated memcg v1 feature.  Instead of
trying to get it to work under PREEMPT_RT just disable it.  There should
be no users on PREEMPT_RT.  From that perspective it makes even less sense
to get it to work under PREEMPT_RT while having zero users.

Make memory.soft_limit_in_bytes and cgroup.event_control return
-EOPNOTSUPP on PREEMPT_RT.  Make an empty memcg_check_events() and
memcg_write_event_control() which return only -EOPNOTSUPP on PREEMPT_RT. 
Document that the two knobs are disabled on PREEMPT_RT.

Link: https://lkml.kernel.org/r/20220226204144.1008339-3-bigeasy@linutronix.de
Suggested-by: Michal Hocko <mhocko@kernel.org>
Suggested-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v1/memory.rst |    2 ++
 mm/memcontrol.c                                |   14 ++++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/cgroup-v1/memory.rst~mm-memcg-disable-threshold-event-handlers-on-preempt_rt
+++ a/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -64,6 +64,7 @@ Brief summary of control files.
 				     threads
  cgroup.procs			     show list of processes
  cgroup.event_control		     an interface for event_fd()
+				     This knob is not available on CONFIG_PREEMPT_RT systems.
  memory.usage_in_bytes		     show current usage for memory
 				     (See 5.5 for details)
  memory.memsw.usage_in_bytes	     show current usage for memory+Swap
@@ -75,6 +76,7 @@ Brief summary of control files.
  memory.max_usage_in_bytes	     show max memory usage recorded
  memory.memsw.max_usage_in_bytes     show max memory+Swap usage recorded
  memory.soft_limit_in_bytes	     set/show soft limit of memory usage
+				     This knob is not available on CONFIG_PREEMPT_RT systems.
  memory.stat			     show various statistics
  memory.use_hierarchy		     set/show hierarchical account enabled
                                      This knob is deprecated and shouldn't be
--- a/mm/memcontrol.c~mm-memcg-disable-threshold-event-handlers-on-preempt_rt
+++ a/mm/memcontrol.c
@@ -858,6 +858,9 @@ static bool mem_cgroup_event_ratelimit(s
  */
 static void memcg_check_events(struct mem_cgroup *memcg, int nid)
 {
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		return;
+
 	/* threshold event is triggered in finer grain than soft limit */
 	if (unlikely(mem_cgroup_event_ratelimit(memcg,
 						MEM_CGROUP_TARGET_THRESH))) {
@@ -3731,8 +3734,12 @@ static ssize_t mem_cgroup_write(struct k
 		}
 		break;
 	case RES_SOFT_LIMIT:
-		memcg->soft_limit = nr_pages;
-		ret = 0;
+		if (IS_ENABLED(CONFIG_PREEMPT_RT)) {
+			ret = -EOPNOTSUPP;
+		} else {
+			memcg->soft_limit = nr_pages;
+			ret = 0;
+		}
 		break;
 	}
 	return ret ?: nbytes;
@@ -4708,6 +4715,9 @@ static ssize_t memcg_write_event_control
 	char *endp;
 	int ret;
 
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		return -EOPNOTSUPP;
+
 	buf = strstrip(buf);
 
 	efd = simple_strtoul(buf, &endp, 10);
_
