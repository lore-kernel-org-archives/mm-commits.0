Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6ECBC46CA0
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 21:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbjLGVqy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Dec 2023 16:46:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235274AbjLGVqw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Dec 2023 16:46:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1581171C
        for <mm-commits@vger.kernel.org>; Thu,  7 Dec 2023 13:46:49 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72207C433C8;
        Thu,  7 Dec 2023 21:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701985609;
        bh=cb6OkXmUGJDQwqEXYwG+06ZB77FI6/Yop3Wrvy+jN+8=;
        h=Date:To:From:Subject:From;
        b=yrOetT9txH4devf7K1HIALj4H+ObeKXvoJNQ7sWEdxQC47NaELEQCCfISvpPsLT49
         oOuKra7O2JGgnO58kQYGfkgH+bmi9rPEdDB651AzlZQpoRabcBBi6uorZDapMhhmU0
         0xMUxv5pWq4RECJgIbsipKVOUN7/Ra22P0nQxD4o=
Date:   Thu, 07 Dec 2023 13:46:47 -0800
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        ming.lei@redhat.com, linux@rasmusvillemoes.dk,
        andriy.shevchenko@linux.intel.com, yury.norov@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-group_cpusc-drop-unneeded-cpumask_empty-call-in-__group_cpus_evenly.patch added to mm-nonmm-unstable branch
Message-Id: <20231207214649.72207C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/group_cpus.c: drop unneeded cpumask_empty() call in __group_cpus_evenly()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-group_cpusc-drop-unneeded-cpumask_empty-call-in-__group_cpus_evenly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-group_cpusc-drop-unneeded-cpumask_empty-call-in-__group_cpus_evenly.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Yury Norov <yury.norov@gmail.com>
Subject: lib/group_cpus.c: drop unneeded cpumask_empty() call in __group_cpus_evenly()
Date: Thu, 7 Dec 2023 12:39:00 -0800

The function is called twice. First time it's called with
cpumask_present as a parameter, which can't be empty. Second time it's
called with a mask created with cpumask_andnot(), which returns false if
the result is an empty mask.

We can safely drop redundant cpumask_empty() call from the
__group_cpus_evenly() and save few cycles.

Link: https://lkml.kernel.org/r/20231207203900.859776-7-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/group_cpus.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/lib/group_cpus.c~lib-group_cpusc-drop-unneeded-cpumask_empty-call-in-__group_cpus_evenly
+++ a/lib/group_cpus.c
@@ -252,9 +252,6 @@ static int __group_cpus_evenly(unsigned
 	nodemask_t nodemsk = NODE_MASK_NONE;
 	struct node_groups *node_groups;
 
-	if (cpumask_empty(cpu_mask))
-		return 0;
-
 	nodes = get_nodes_in_cpumask(node_to_cpumask, cpu_mask, &nodemsk);
 
 	/*
@@ -394,9 +391,14 @@ struct cpumask *group_cpus_evenly(unsign
 		curgrp = 0;
 	else
 		curgrp = nr_present;
-	cpumask_andnot(npresmsk, cpu_possible_mask, npresmsk);
-	ret = __group_cpus_evenly(curgrp, numgrps, node_to_cpumask,
-				  npresmsk, nmsk, masks);
+
+	if (cpumask_andnot(npresmsk, cpu_possible_mask, npresmsk))
+		/* If npresmsk is not empty */
+		ret = __group_cpus_evenly(curgrp, numgrps, node_to_cpumask,
+					  npresmsk, nmsk, masks);
+	else
+		ret = 0;
+
 	if (ret >= 0)
 		nr_others = ret;
 
_

Patches currently in -mm which might be from yury.norov@gmail.com are

cpumask-introduce-for_each_cpu_and_from.patch
lib-group_cpus-relax-atomicity-requirement-in-grp_spread_init_one.patch
lib-group_cpus-optimize-inner-loop-in-grp_spread_init_one.patch
lib-group_cpus-optimize-outer-loop-in-grp_spread_init_one.patch
lib-cgroup_cpusc-dont-zero-cpumasks-in-group_cpus_evenly-on-allocation.patch
lib-group_cpusc-drop-unneeded-cpumask_empty-call-in-__group_cpus_evenly.patch

