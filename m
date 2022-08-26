Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23D07ECAAA2
	for <mm-commits@archiver.kernel.org>; Fri, 26 Aug 2022 01:08:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243798AbiHZBIg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Aug 2022 21:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243837AbiHZBIe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Aug 2022 21:08:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B10BFC9908
        for <mm-commits@vger.kernel.org>; Thu, 25 Aug 2022 18:08:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AD8761DA0
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 01:08:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1CFC433C1;
        Fri, 26 Aug 2022 01:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661476112;
        bh=sTpaWN8HeF1qtKyM/aYLXnGwng/wrl/PSTVkHtbXpGc=;
        h=Date:To:From:Subject:From;
        b=u+DbwvItsbWJjH8xNqqSeIy8Z0xShNbOOhtHce/SJE8DF5jkAbIwetbNk73EwgTwF
         fI878st6/3RboSDGlFgI/ZfZE5SIL3BGIgWeK1xQVumschwOTK6WMRZz0vCyTH8A6b
         RVWvXJPMPfe3f602uBaY03qjugnnXKNEigohMxXw=
Date:   Thu, 25 Aug 2022 18:08:31 -0700
To:     mm-commits@vger.kernel.org, ubizjak@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] smpboot-use-atomic_try_cmpxchg-in-cpu_wait_death-and-cpu_report_death.patch removed from -mm tree
Message-Id: <20220826010832.9D1CFC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: smpboot: use atomic_try_cmpxchg in cpu_wait_death and cpu_report_death
has been removed from the -mm tree.  Its filename was
     smpboot-use-atomic_try_cmpxchg-in-cpu_wait_death-and-cpu_report_death.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Uros Bizjak <ubizjak@gmail.com>
Subject: smpboot: use atomic_try_cmpxchg in cpu_wait_death and cpu_report_death
Date: Tue, 23 Aug 2022 17:13:36 +0200

Use atomic_try_cmpxchg instead of atomic_cmpxchg (*ptr, old, new) == old
in cpu_wait_death and cpu_report_death.  x86 CMPXCHG instruction returns
success in ZF flag, so this change saves a compare after cmpxchg (and
related move instruction in front of cmpxchg).

Also, atomic_try_cmpxchg implicitly assigns old *ptr value to "old" when
cmpxchg fails, enabling further code simplifications.

No functional change intended.

Link: https://lkml.kernel.org/r/20220823151336.3984-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smpboot.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/kernel/smpboot.c~smpboot-use-atomic_try_cmpxchg-in-cpu_wait_death-and-cpu_report_death
+++ a/kernel/smpboot.c
@@ -444,16 +444,16 @@ bool cpu_wait_death(unsigned int cpu, in
 			break;
 		sleep_jf = DIV_ROUND_UP(sleep_jf * 11, 10);
 	}
-update_state:
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
@@ -475,14 +475,14 @@ bool cpu_report_death(void)
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

llist-use-try_cmpxchg-in-llist_add_batch-and-llist_del_first.patch
epoll-use-try_cmpxchg-in-list_add_tail_lockless.patch
buffer-use-try_cmpxchg-in-discard_buffer.patch
aio-use-atomic_try_cmpxchg-in-__get_reqs_available.patch
iversion-use-atomic64_try_cmpxchg.patch
bitops-use-try_cmpxchg-in-set_mask_bits-and-bit_clear_unless.patch
task_work-use-try_cmpxchg-in-task_work_add-task_work_cancel_match-and-task_work_run.patch

