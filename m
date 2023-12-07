Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 388DCC46CA3
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 00:13:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442091AbjLGANd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 19:13:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442038AbjLGAN2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 19:13:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B52D519E
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 16:13:32 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50979C433C7;
        Thu,  7 Dec 2023 00:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701908012;
        bh=MGN/hlO8Z1WsegDguruVNZ44OqzlfEMJKO3m3ginqGU=;
        h=Date:To:From:Subject:From;
        b=ju18WEMn/CvuQhXKLF7OI4/n/sR+5hviDkRk/c4HnOSCgRzRFlzw6B/eSjLS7OM5X
         rzjTww5qxdYgcU+LLJRTKH52UTXh6ymtAS4QIqQX+cFHAZMcp6nwmxI0kij3sZ+Xl8
         49mpvQzOnLSRgUogjnIuOJf0l3MziuDjjWtevsco=
Date:   Wed, 06 Dec 2023 16:13:31 -0800
To:     mm-commits@vger.kernel.org, zhouchengming@bytedance.com,
        yi.zhang@redhat.com, stable@vger.kernel.org, kbusch@kernel.org,
        guazhang@redhat.com, axboe@kernel.dk, ming.lei@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] lib-group_cpusc-avoid-to-acquire-cpu-hotplug-lock-in-group_cpus_evenly.patch removed from -mm tree
Message-Id: <20231207001332.50979C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/group_cpus.c: avoid acquiring cpu hotplug lock in group_cpus_evenly
has been removed from the -mm tree.  Its filename was
     lib-group_cpusc-avoid-to-acquire-cpu-hotplug-lock-in-group_cpus_evenly.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ming Lei <ming.lei@redhat.com>
Subject: lib/group_cpus.c: avoid acquiring cpu hotplug lock in group_cpus_evenly
Date: Mon, 20 Nov 2023 16:35:59 +0800

group_cpus_evenly() could be part of storage driver's error handler, such
as nvme driver, when may happen during CPU hotplug, in which storage queue
has to drain its pending IOs because all CPUs associated with the queue
are offline and the queue is becoming inactive.  And handling IO needs
error handler to provide forward progress.

Then deadlock is caused:

1) inside CPU hotplug handler, CPU hotplug lock is held, and blk-mq's
   handler is waiting for inflight IO

2) error handler is waiting for CPU hotplug lock

3) inflight IO can't be completed in blk-mq's CPU hotplug handler
   because error handling can't provide forward progress.

Solve the deadlock by not holding CPU hotplug lock in group_cpus_evenly(),
in which two stage spreads are taken: 1) the 1st stage is over all present
CPUs; 2) the end stage is over all other CPUs.

Turns out the two stage spread just needs consistent 'cpu_present_mask',
and remove the CPU hotplug lock by storing it into one local cache.  This
way doesn't change correctness, because all CPUs are still covered.

Link: https://lkml.kernel.org/r/20231120083559.285174-1-ming.lei@redhat.com
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reported-by: Yi Zhang <yi.zhang@redhat.com>
Reported-by: Guangwu Zhang <guazhang@redhat.com>
Tested-by: Guangwu Zhang <guazhang@redhat.com>
Reviewed-by: Chengming Zhou <zhouchengming@bytedance.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <kbusch@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/group_cpus.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/lib/group_cpus.c~lib-group_cpusc-avoid-to-acquire-cpu-hotplug-lock-in-group_cpus_evenly
+++ a/lib/group_cpus.c
@@ -366,13 +366,25 @@ struct cpumask *group_cpus_evenly(unsign
 	if (!masks)
 		goto fail_node_to_cpumask;
 
-	/* Stabilize the cpumasks */
-	cpus_read_lock();
 	build_node_to_cpumask(node_to_cpumask);
 
+	/*
+	 * Make a local cache of 'cpu_present_mask', so the two stages
+	 * spread can observe consistent 'cpu_present_mask' without holding
+	 * cpu hotplug lock, then we can reduce deadlock risk with cpu
+	 * hotplug code.
+	 *
+	 * Here CPU hotplug may happen when reading `cpu_present_mask`, and
+	 * we can live with the case because it only affects that hotplug
+	 * CPU is handled in the 1st or 2nd stage, and either way is correct
+	 * from API user viewpoint since 2-stage spread is sort of
+	 * optimization.
+	 */
+	cpumask_copy(npresmsk, data_race(cpu_present_mask));
+
 	/* grouping present CPUs first */
 	ret = __group_cpus_evenly(curgrp, numgrps, node_to_cpumask,
-				  cpu_present_mask, nmsk, masks);
+				  npresmsk, nmsk, masks);
 	if (ret < 0)
 		goto fail_build_affinity;
 	nr_present = ret;
@@ -387,15 +399,13 @@ struct cpumask *group_cpus_evenly(unsign
 		curgrp = 0;
 	else
 		curgrp = nr_present;
-	cpumask_andnot(npresmsk, cpu_possible_mask, cpu_present_mask);
+	cpumask_andnot(npresmsk, cpu_possible_mask, npresmsk);
 	ret = __group_cpus_evenly(curgrp, numgrps, node_to_cpumask,
 				  npresmsk, nmsk, masks);
 	if (ret >= 0)
 		nr_others = ret;
 
  fail_build_affinity:
-	cpus_read_unlock();
-
 	if (ret >= 0)
 		WARN_ON(nr_present + nr_others < numgrps);
 
_

Patches currently in -mm which might be from ming.lei@redhat.com are


