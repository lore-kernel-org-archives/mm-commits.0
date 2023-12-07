Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED784C4167B
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 21:46:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbjLGVql (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Dec 2023 16:46:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbjLGVqj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Dec 2023 16:46:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170E7A9
        for <mm-commits@vger.kernel.org>; Thu,  7 Dec 2023 13:46:46 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C91C433C7;
        Thu,  7 Dec 2023 21:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701985605;
        bh=VSmG4SAXjrhsgg3KhmHM/MfIJV0sQ2eAnOIBkuoC47s=;
        h=Date:To:From:Subject:From;
        b=lAFGg3O4M25myuhdjkmpRddl3fSGTtLVbD9kMJs+ZMwMJSsHzC2MDIrgjiHqBSpVC
         GuvWc0QuvlSmdtny3xrkmcH37ua6tVoRIxABt+j/rp8Rt4iqUtiKbOJFV5Uj+npqXT
         Hfnp6yNJR31sAHhN3NrVrj56nbZ2TK1bx074yi9k=
Date:   Thu, 07 Dec 2023 13:46:44 -0800
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        ming.lei@redhat.com, linux@rasmusvillemoes.dk,
        andriy.shevchenko@linux.intel.com, yury.norov@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-group_cpus-optimize-inner-loop-in-grp_spread_init_one.patch added to mm-nonmm-unstable branch
Message-Id: <20231207214645.A5C91C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/group_cpus: optimize inner loop in grp_spread_init_one()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-group_cpus-optimize-inner-loop-in-grp_spread_init_one.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-group_cpus-optimize-inner-loop-in-grp_spread_init_one.patch

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
Subject: lib/group_cpus: optimize inner loop in grp_spread_init_one()
Date: Thu, 7 Dec 2023 12:38:57 -0800

The loop starts from the beginning every time we switch to the next
sibling mask.  This is the Schlemiel the Painter's style of coding because
we know for sure that nmsk is clear up to current CPU, and we can just
continue from the next CPU.

Also, we can do it nicer if leverage the dedicated for_each() iterator.

Link: https://lkml.kernel.org/r/20231207203900.859776-4-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/group_cpus.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/lib/group_cpus.c~lib-group_cpus-optimize-inner-loop-in-grp_spread_init_one
+++ a/lib/group_cpus.c
@@ -30,13 +30,13 @@ static void grp_spread_init_one(struct c
 
 		/* If the cpu has siblings, use them first */
 		siblmsk = topology_sibling_cpumask(cpu);
-		for (sibl = -1; cpus_per_grp > 0; ) {
-			sibl = cpumask_next(sibl, siblmsk);
-			if (sibl >= nr_cpu_ids)
-				break;
+		sibl = cpu + 1;
+
+		for_each_cpu_and_from(sibl, siblmsk, nmsk) {
 			__cpumask_clear_cpu(sibl, nmsk);
 			__cpumask_set_cpu(sibl, irqmsk);
-			cpus_per_grp--;
+			if (cpus_per_grp-- == 0)
+				return;
 		}
 	}
 }
_

Patches currently in -mm which might be from yury.norov@gmail.com are

cpumask-introduce-for_each_cpu_and_from.patch
lib-group_cpus-relax-atomicity-requirement-in-grp_spread_init_one.patch
lib-group_cpus-optimize-inner-loop-in-grp_spread_init_one.patch
lib-group_cpus-optimize-outer-loop-in-grp_spread_init_one.patch
lib-cgroup_cpusc-dont-zero-cpumasks-in-group_cpus_evenly-on-allocation.patch
lib-group_cpusc-drop-unneeded-cpumask_empty-call-in-__group_cpus_evenly.patch

