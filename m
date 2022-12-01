Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BA25C47089
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbiLAAFh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:05:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbiLAADn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:03:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 312658EE53
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:01:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 453A561E6B
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:01:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD10C433D6;
        Thu,  1 Dec 2022 00:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852901;
        bh=NM4ZewpNZNUw9Ed+I+UntDeNbZ/X3z42ohiXYyVR+Rw=;
        h=Date:To:From:Subject:From;
        b=A+TA7Gdi+HeVgS5Z38cgpOB+Lj/622Y/gk8zsaInFwyY9rCDdICBLoK9zLChqJReH
         7IXKxWBNHYux87B3rzAzBji4fSNXpDOeYEvV6Q+V9RiQr6ZGe0I2tQSE/nT7W1Qtno
         qAevHQiUse7EPWUCpvN5wbMaurYCDuXcMrntzqj4=
Date:   Wed, 30 Nov 2022 16:01:40 -0800
To:     mm-commits@vger.kernel.org, peterz@infradead.org,
        glider@google.com, elver@google.com, dvyukov@google.com,
        quic_pkondeti@quicinc.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kfence-remove-hung_task-cruft.patch removed from -mm tree
Message-Id: <20221201000141.6FD10C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/kfence: remove hung_task cruft
has been removed from the -mm tree.  Its filename was
     mm-kfence-remove-hung_task-cruft.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Subject: mm/kfence: remove hung_task cruft
Date: Wed, 9 Nov 2022 14:56:46 +0530

commit fdf756f71271 ("sched: Fix more TASK_state comparisons") makes
hung_task not to monitor TASK_IDLE tasks.  The special handling to
workaround hung_task warnings is not required anymore.

Link: https://lkml.kernel.org/r/1667986006-25420-1-git-send-email-quic_pkondeti@quicinc.com
Signed-off-by: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
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

mm-madvise-fix-madvise_pageout-for-private-file-mappings.patch

