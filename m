Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04D61ECAAA3
	for <mm-commits@archiver.kernel.org>; Fri, 26 Aug 2022 01:54:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiHZByV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Aug 2022 21:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbiHZByU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Aug 2022 21:54:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28EC2C7F9B
        for <mm-commits@vger.kernel.org>; Thu, 25 Aug 2022 18:54:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B097161DFD
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 01:54:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146FDC433D6;
        Fri, 26 Aug 2022 01:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661478855;
        bh=ACbaWK0JXC6Xb4Nm2fK2C1VzBO0x+laDSX83mD4v5P4=;
        h=Date:To:From:Subject:From;
        b=mzEkiugLoehbvKwlHl07g5+K3+zpvceBhP/x1m+71QWBqrWlXncTTOJnhUm0GEqY3
         YRZAU0IhA8+EqKeks/sJzeOF8CPl8E8AsmFqS90RocPDWpkOGxAeP2tp1Hk5eAy/HM
         OMUQbCs7KRawp279CTeFtHmufPUN/fDV4z6u4ttQ=
Date:   Thu, 25 Aug 2022 18:54:14 -0700
To:     mm-commits@vger.kernel.org, ubizjak@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + smpboot-use-atomic_try_cmpxchg-in-cpu_wait_death-and-cpu_report_death.patch added to mm-nonmm-unstable branch
Message-Id: <20220826015415.146FDC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: smpboot: use atomic_try_cmpxchg in cpu_wait_death and cpu_report_death
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     smpboot-use-atomic_try_cmpxchg-in-cpu_wait_death-and-cpu_report_death.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/smpboot-use-atomic_try_cmpxchg-in-cpu_wait_death-and-cpu_report_death.patch

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

llist-use-try_cmpxchg-in-llist_add_batch-and-llist_del_first.patch
epoll-use-try_cmpxchg-in-list_add_tail_lockless.patch
buffer-use-try_cmpxchg-in-discard_buffer.patch
aio-use-atomic_try_cmpxchg-in-__get_reqs_available.patch
iversion-use-atomic64_try_cmpxchg.patch
bitops-use-try_cmpxchg-in-set_mask_bits-and-bit_clear_unless.patch
task_work-use-try_cmpxchg-in-task_work_add-task_work_cancel_match-and-task_work_run.patch
smpboot-use-atomic_try_cmpxchg-in-cpu_wait_death-and-cpu_report_death.patch

