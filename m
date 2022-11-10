Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FBF6C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 10 Nov 2022 01:14:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbiKJBOr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Nov 2022 20:14:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiKJBOr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2022 20:14:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F92820BFC
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 17:14:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECA9CB82051
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2022 01:14:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89AB3C433C1;
        Thu, 10 Nov 2022 01:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668042883;
        bh=0I0O/Sx3iznG04vKbY1v2DFpWy/IwjqiLNIMC4njMtk=;
        h=Date:To:From:Subject:From;
        b=zLwH7IqjhJa2hDnPZAioy2zyMRbRyqp65ziJUt54dquo1U0camlGhfAN1q3DOL7Ny
         xMLBqlTTizB9sLu1Kzhikj1vqr2fiwDzYDv5qGYZJW+e+xxB4ThzGkUSpTOP6RnXrW
         vxAE+TdekbkDJ6dpboNKkgjlMLjN66DyAp92PjIM=
Date:   Wed, 09 Nov 2022 17:14:42 -0800
To:     mm-commits@vger.kernel.org, peterz@infradead.org,
        glider@google.com, elver@google.com, dvyukov@google.com,
        quic_pkondeti@quicinc.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kfence-remove-hung_task-cruft.patch added to mm-unstable branch
Message-Id: <20221110011443.89AB3C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kfence: remove hung_task cruft
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kfence-remove-hung_task-cruft.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kfence-remove-hung_task-cruft.patch

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
From: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Subject: mm/kfence: remove hung_task cruft
Date: Wed, 9 Nov 2022 14:56:46 +0530

commit fdf756f71271 ("sched: Fix more TASK_state comparisons") makes
hung_task not to monitor TASK_IDLE tasks.  The special handling to
workaround hung_task warnings is not required anymore.

Link: https://lkml.kernel.org/r/1667986006-25420-1-git-send-email-quic_pkondeti@quicinc.com
Signed-off-by: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- a/mm/kfence/core.c~mm-kfence-remove-hung_task-cruft
+++ a/mm/kfence/core.c
@@ -26,7 +26,6 @@
 #include <linux/random.h>
 #include <linux/rcupdate.h>
 #include <linux/sched/clock.h>
-#include <linux/sched/sysctl.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
@@ -799,16 +798,7 @@ static void toggle_allocation_gate(struc
 	/* Enable static key, and await allocation to happen. */
 	static_branch_enable(&kfence_allocation_key);
 
-	if (sysctl_hung_task_timeout_secs) {
-		/*
-		 * During low activity with no allocations we might wait a
-		 * while; let's avoid the hung task warning.
-		 */
-		wait_event_idle_timeout(allocation_wait, atomic_read(&kfence_allocation_gate),
-					sysctl_hung_task_timeout_secs * HZ / 2);
-	} else {
-		wait_event_idle(allocation_wait, atomic_read(&kfence_allocation_gate));
-	}
+	wait_event_idle(allocation_wait, atomic_read(&kfence_allocation_gate));
 
 	/* Disable static key and reset timer. */
 	static_branch_disable(&kfence_allocation_key);
_

Patches currently in -mm which might be from quic_pkondeti@quicinc.com are

mm-kfence-remove-hung_task-cruft.patch

