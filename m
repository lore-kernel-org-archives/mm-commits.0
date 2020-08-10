Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78089C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:37:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F55F206CD
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027036;
	bh=pHM/7IbYLnFC+k6aeDo/INxzPRIZS6djLrGpTJognlE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=vei3Dqr29W/q7BFPOV3QJa6ffIsvOUdVs6W1WSFVWgnzAmabeABNgYO/RzwR1oob2
	 NHHXXoSkpQk0xKyLZPi3oWeVBPrGSAKVDuEUlAIpJxwsU+1vuKUl8+SkVTzORaQ+tj
	 A0A3clwMS37FMgoIYY75XwYrlWVf7NVyjxUsXDUk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgHJChQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:37:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgHJChP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:37:15 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DF36206C3;
        Mon, 10 Aug 2020 02:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027034;
        bh=pHM/7IbYLnFC+k6aeDo/INxzPRIZS6djLrGpTJognlE=;
        h=Date:From:To:Subject:From;
        b=poRJ+RxzXco/T53y0XKtNGR3PgriXFamWTN8L2mUlJK6PJwGu3VqnDf6y5NiqS6iu
         2l77DEuMMkCvr6auFDzcb6NGRdXMOnQQFBJL1qo/DyWHKK3XdaQLFZ4Gd22UFD+ybE
         iM7mEClK41XSqVKlFvwNGutK33N9whI2UfwKN1wU=
Date:   Sun, 09 Aug 2020 19:37:14 -0700
From:   akpm@linux-foundation.org
To:     chris@chrisdown.name, domas@fb.com, guro@fb.com,
        hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, tj@kernel.org
Subject:  [merged]
 mm-memcontrol-avoid-workload-stalls-when-lowering-memoryhigh.patch removed
 from -mm tree
Message-ID: <20200810023714.I7Df-LsA8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: avoid workload stalls when lowering memory.high
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-avoid-workload-stalls-when-lowering-memoryhigh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: memcontrol: avoid workload stalls when lowering memory.high

Memory.high limit is implemented in a way such that the kernel penalizes
all threads which are allocating a memory over the limit.  Forcing all
threads into the synchronous reclaim and adding some artificial delays
allows to slow down the memory consumption and potentially give some time
for userspace oom handlers/resource control agents to react.

It works nicely if the memory usage is hitting the limit from below,
however it works sub-optimal if a user adjusts memory.high to a value way
below the current memory usage.  It basically forces all workload threads
(doing any memory allocations) into the synchronous reclaim and sleep. 
This makes the workload completely unresponsive for a long period of time
and can also lead to a system-wide contention on lru locks.  It can happen
even if the workload is not actually tight on memory and has, for example,
a ton of cold pagecache.

In the current implementation writing to memory.high causes an atomic
update of page counter's high value followed by an attempt to reclaim
enough memory to fit into the new limit.  To fix the problem described
above, all we need is to change the order of execution: try to push the
memory usage under the limit first, and only then set the new high limit.

Link: http://lkml.kernel.org/r/20200709194718.189231-1-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reported-by: Domas Mituzas <domas@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Chris Down <chris@chrisdown.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-avoid-workload-stalls-when-lowering-memoryhigh
+++ a/mm/memcontrol.c
@@ -6213,8 +6213,6 @@ static ssize_t memory_high_write(struct
 	if (err)
 		return err;
 
-	page_counter_set_high(&memcg->memory, high);
-
 	for (;;) {
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
 		unsigned long reclaimed;
@@ -6238,6 +6236,8 @@ static ssize_t memory_high_write(struct
 			break;
 	}
 
+	page_counter_set_high(&memcg->memory, high);
+
 	return nbytes;
 }
 
_

Patches currently in -mm which might be from guro@fb.com are

percpu-return-number-of-released-bytes-from-pcpu_free_area.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics-v3.patch
mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup.patch
kselftests-cgroup-add-perpcu-memory-accounting-test.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

