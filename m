Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B726DC10DCE
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 21:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbjLGVqx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Dec 2023 16:46:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232053AbjLGVqm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Dec 2023 16:46:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682D61716
        for <mm-commits@vger.kernel.org>; Thu,  7 Dec 2023 13:46:48 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050FEC433C9;
        Thu,  7 Dec 2023 21:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701985608;
        bh=64bQj6zFDZOgMJnmWkdjtu12pULtFk/O0Y8t/QieHwk=;
        h=Date:To:From:Subject:From;
        b=aqxd2IyliVR3fcameZCnG4yRMpVhJqjNHguh83dBIU4gCW6WYCxazNsD73T3f0Nbg
         xb/qVSkUVRGhcvofqxwtGygbv72Z4YP7JeF/drG+2syVXyPFd9mLa8hDDDmj8BsPcF
         aXwXECvAVO7kxxbLO4YUxBCN5mfUNGj4hXiNzi5g=
Date:   Thu, 07 Dec 2023 13:46:46 -0800
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        ming.lei@redhat.com, linux@rasmusvillemoes.dk,
        andriy.shevchenko@linux.intel.com, yury.norov@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-cgroup_cpusc-dont-zero-cpumasks-in-group_cpus_evenly-on-allocation.patch added to mm-nonmm-unstable branch
Message-Id: <20231207214648.050FEC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/cgroup_cpus.c: don't zero cpumasks in group_cpus_evenly() on allocation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-cgroup_cpusc-dont-zero-cpumasks-in-group_cpus_evenly-on-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-cgroup_cpusc-dont-zero-cpumasks-in-group_cpus_evenly-on-allocation.patch

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
Subject: lib/cgroup_cpus.c: don't zero cpumasks in group_cpus_evenly() on allocation
Date: Thu, 7 Dec 2023 12:38:59 -0800

nmsk and npresmsk are both allocated with zalloc_cpumask_var(), but they
are initialized by copying later in the code, and so may be allocated
uninitialized.

Link: https://lkml.kernel.org/r/20231207203900.859776-6-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/group_cpus.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/group_cpus.c~lib-cgroup_cpusc-dont-zero-cpumasks-in-group_cpus_evenly-on-allocation
+++ a/lib/group_cpus.c
@@ -347,10 +347,10 @@ struct cpumask *group_cpus_evenly(unsign
 	int ret = -ENOMEM;
 	struct cpumask *masks = NULL;
 
-	if (!zalloc_cpumask_var(&nmsk, GFP_KERNEL))
+	if (!alloc_cpumask_var(&nmsk, GFP_KERNEL))
 		return NULL;
 
-	if (!zalloc_cpumask_var(&npresmsk, GFP_KERNEL))
+	if (!alloc_cpumask_var(&npresmsk, GFP_KERNEL))
 		goto fail_nmsk;
 
 	node_to_cpumask = alloc_node_to_cpumask();
_

Patches currently in -mm which might be from yury.norov@gmail.com are

cpumask-introduce-for_each_cpu_and_from.patch
lib-group_cpus-relax-atomicity-requirement-in-grp_spread_init_one.patch
lib-group_cpus-optimize-inner-loop-in-grp_spread_init_one.patch
lib-group_cpus-optimize-outer-loop-in-grp_spread_init_one.patch
lib-cgroup_cpusc-dont-zero-cpumasks-in-group_cpus_evenly-on-allocation.patch
lib-group_cpusc-drop-unneeded-cpumask_empty-call-in-__group_cpus_evenly.patch

