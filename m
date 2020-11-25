Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FEE3C56202
	for <mm-commits@archiver.kernel.org>; Wed, 25 Nov 2020 22:34:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3403C20872
	for <mm-commits@archiver.kernel.org>; Wed, 25 Nov 2020 22:34:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EHgrOyZN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgKYWen (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Nov 2020 17:34:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:55940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726114AbgKYWen (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 25 Nov 2020 17:34:43 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EC7F2075A;
        Wed, 25 Nov 2020 22:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606343682;
        bh=FaFgZPnB+Dynp9Gwp6jqvhCuM9xydqR4bdAhPn/53TQ=;
        h=Date:From:To:Subject:From;
        b=EHgrOyZNv84dNa5xDJaHz+rz9RWnmNkWEOQtTpWI1QoBiVeuKZjD6v5gwfdFswWnG
         Z7Z63bGezJDBWuop+YsnBsL1acoSfbzx0OEifpNyacFwbzRVPX96uf+NcwIb9OaCu2
         xj3WDjBkUYdjQJQXvqbQD5+X9uXiyq4XVbnU0ebA=
Date:   Wed, 25 Nov 2020 14:34:41 -0800
From:   akpm@linux-foundation.org
To:     andi.kleen@intel.com, chris@chrisdown.name, feng.tang@intel.com,
        guro@fb.com, hannes@cmpxchg.org, laoar.shao@gmail.com,
        longman@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        rong.a.chen@intel.com, shakeelb@google.com, tj@kernel.org,
        vdavydov.dev@gmail.com, ying.huang@intel.com,
        zhengjun.xing@linux.intel.com
Subject:  +
 mm-memcg-relayout-structure-mem_cgroup-to-avoid-cache-interfereing.patch
 added to -mm tree
Message-ID: <20201125223441.V7bW3D_dD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: relayout structure mem_cgroup to avoid cache interference
has been added to the -mm tree.  Its filename is
     mm-memcg-relayout-structure-mem_cgroup-to-avoid-cache-interfereing.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-relayout-structure-mem_cgroup-to-avoid-cache-interfereing.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-relayout-structure-mem_cgroup-to-avoid-cache-interfereing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Feng Tang <feng.tang@intel.com>
Subject: mm: memcg: relayout structure mem_cgroup to avoid cache interference

0day reported one -22.7% regression for will-it-scale page_fault2 case [1]
on a 4 sockets 144 CPU platform, and bisected to it to be caused by
Waiman's optimization (commit bd0b230fe1) of saving one 'struct
page_counter' space for 'struct mem_cgroup'.

Initially we thought it was due to the cache alignment change introduced
by the patch, but further debug shows that it is due to some hot data
members ('vmstats_local', 'vmstats_percpu', 'vmstats') sit in 2 adjacent
cacheline (2N and 2N+1 cacheline), and when adjacent cache line prefetch
is enabled, it triggers an "extended level" of cache false sharing for 2
adjacent cache lines.

So exchange the 2 member blocks, while keeping mostly the original cache
alignment, which can restore and even enhance the performance, and save 64
bytes of space for 'struct mem_cgroup' (from 2880 to 2816, with 0day's
default RHEL-8.3 kernel config)

[1]. https://lore.kernel.org/lkml/20201102091543.GM31092@shao2-debian/

Link: https://lkml.kernel.org/r/20201125062445.GA51005@shbuild999.sh.intel.com
Fixes: bd0b230fe145 ("mm/memcg: unify swap and memsw page counters")
Signed-off-by: Feng Tang <feng.tang@intel.com>
Reported-by: kernel test robot <rong.a.chen@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <andi.kleen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-relayout-structure-mem_cgroup-to-avoid-cache-interfereing
+++ a/include/linux/memcontrol.h
@@ -282,20 +282,6 @@ struct mem_cgroup {
 
 	MEMCG_PADDING(_pad1_);
 
-	/*
-	 * set > 0 if pages under this cgroup are moving to other cgroup.
-	 */
-	atomic_t		moving_account;
-	struct task_struct	*move_lock_task;
-
-	/* Legacy local VM stats and events */
-	struct memcg_vmstats_percpu __percpu *vmstats_local;
-
-	/* Subtree VM stats and events (batched updates) */
-	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
-
-	MEMCG_PADDING(_pad2_);
-
 	atomic_long_t		vmstats[MEMCG_NR_STAT];
 	atomic_long_t		vmevents[NR_VM_EVENT_ITEMS];
 
@@ -317,6 +303,20 @@ struct mem_cgroup {
 	struct list_head objcg_list; /* list of inherited objcgs */
 #endif
 
+	MEMCG_PADDING(_pad2_);
+
+	/*
+	 * set > 0 if pages under this cgroup are moving to other cgroup.
+	 */
+	atomic_t		moving_account;
+	struct task_struct	*move_lock_task;
+
+	/* Legacy local VM stats and events */
+	struct memcg_vmstats_percpu __percpu *vmstats_local;
+
+	/* Subtree VM stats and events (batched updates) */
+	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
+
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct list_head cgwb_list;
 	struct wb_domain cgwb_domain;
_

Patches currently in -mm which might be from feng.tang@intel.com are

mm-memcg-relayout-structure-mem_cgroup-to-avoid-cache-interfereing.patch

