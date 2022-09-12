Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE926ECAAD5
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 04:58:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiILE57 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 00:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbiILE5A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 00:57:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2447728707
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 21:56:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9833860AF4
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 04:56:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFAAC433D6;
        Mon, 12 Sep 2022 04:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662958613;
        bh=op366NBNI0kgY9vu7F9cS+e0fBu1OccoORUDJdgpnXM=;
        h=Date:To:From:Subject:From;
        b=PAmTMFUhIZxDFE7Ig5Ldv/ju8N0TxQRioqYqlXIBTEGhA0luoRtU3YCOcGdFdIFGL
         NMDgAQUULU7AzuTGM2uvWvrH3MxOxygUTgNo3YD5M/YlH12tvMngy2jhS+sgFvXwVd
         hYuUgXAqiP8+DKO1YmvxZFwZmX90bC58R1O1Z+GE=
Date:   Sun, 11 Sep 2022 21:56:52 -0700
To:     mm-commits@vger.kernel.org, ubizjak@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] smpboot-use-atomic_try_cmpxchg-in-cpu_wait_death-and-cpu_report_death.patch removed from -mm tree
Message-Id: <20220912045652.EFFAAC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: smpboot: use atomic_try_cmpxchg in cpu_wait_death and cpu_report_death
has been removed from the -mm tree.  Its filename was
     smpboot-use-atomic_try_cmpxchg-in-cpu_wait_death-and-cpu_report_death.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Uros Bizjak <ubizjak@gmail.com>
Subject: smpboot: use atomic_try_cmpxchg in cpu_wait_death and cpu_report_death
Date: Thu, 25 Aug 2022 16:56:03 +0200

Use atomic_try_cmpxchg instead of atomic_cmpxchg (*ptr, old, new) == old
in cpu_wait_death and cpu_report_death.  x86 CMPXCHG instruction returns
success in ZF flag, so this change saves a compare after cmpxchg (and
related move instruction in front of cmpxchg).  Also, atomic_try_cmpxchg
implicitly assigns old *ptr value to "old" when cmpxchg fails, enabling
further code simplifications.

No functional change intended.

Link: https://lkml.kernel.org/r/20220825145603.5811-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smpboot.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/kernel/smpboot.c~smpboot-use-atomic_try_cmpxchg-in-cpu_wait_death-and-cpu_report_death
+++ a/kernel/smpboot.c
@@ -433,7 +433,7 @@ bool cpu_wait_death(unsigned int cpu, in
 
 	/* The outgoing CPU will normally get done quite quickly. */
 	if (atomic_read(&per_cpu(cpu_hotplug_state, cpu)) == CPU_DEAD)
-		goto update_state;
+		goto update_state_early;
 	udelay(5);
 
 	/* But if the outgoing CPU dawdles, wait increasingly long times. */
@@ -444,16 +444,17 @@ bool cpu_wait_death(unsigned int cpu, in
 			break;
 		sleep_jf = DIV_ROUND_UP(sleep_jf * 11, 10);
 	}
-update_state:
+update_state_early:
 	oldstate = atomic_read(&per_cpu(cpu_hotplug_state, cpu));
+update_state:
 	if (oldstate == CPU_DEAD) {
 		/* Outgoing CPU died normally, update state. */
 		smp_mb(); /* atomic_read() before update. */
 		atomic_set(&per_cpu(cpu_hotplug_state, cpu), CPU_POST_DEAD);
 	} else {
 		/* Outgoing CPU still hasn't died, set state accordingly. */
-		if (atomic_cmpxchg(&per_cpu(cpu_hotplug_state, cpu),
-				   oldstate, CPU_BROKEN) != oldstate)
+		if (!atomic_try_cmpxchg(&per_cpu(cpu_hotplug_state, cpu),
+					&oldstate, CPU_BROKEN))
 			goto update_state;
 		ret = false;
 	}
@@ -475,14 +476,14 @@ bool cpu_report_death(void)
 	int newstate;
 	int cpu = smp_processor_id();
 
+	oldstate = atomic_read(&per_cpu(cpu_hotplug_state, cpu));
 	do {
-		oldstate = atomic_read(&per_cpu(cpu_hotplug_state, cpu));
 		if (oldstate != CPU_BROKEN)
 			newstate = CPU_DEAD;
 		else
 			newstate = CPU_DEAD_FROZEN;
-	} while (atomic_cmpxchg(&per_cpu(cpu_hotplug_state, cpu),
-				oldstate, newstate) != oldstate);
+	} while (!atomic_try_cmpxchg(&per_cpu(cpu_hotplug_state, cpu),
+				     &oldstate, newstate));
 	return newstate == CPU_DEAD;
 }
 
_

Patches currently in -mm which might be from ubizjak@gmail.com are


