Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4646EC61DA3
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 22:37:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbjCCWhq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Mar 2023 17:37:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233145AbjCCWh3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2023 17:37:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5079C5A6DF
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 14:35:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5313061957
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 22:32:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD18CC433EF;
        Fri,  3 Mar 2023 22:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677882764;
        bh=/QYX+IKp5ywCN+DxJDcwNBin0FRkKgNJCgPKDlf1OQg=;
        h=Date:To:From:Subject:From;
        b=ZFg6hPKvqQUUXbYGYIiCfSGEO945ZZGIqBLxe8s/nPto8KyiDj/VhT1CntwQp8aPj
         n3sjd7Mg4F4Va5kqv/bnXWfwDSxyVbJreQMtR9In116TST7BiBRV/TYHI0FEcKT2IH
         3VV86UiF//0Me25UMgUfXUbNZK3lnOeJZzT1kF3M=
Date:   Fri, 03 Mar 2023 14:32:44 -0800
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, peterx@redhat.com,
        mingo@elte.hu, linux@armlinux.org.uk, hpa@zytor.com,
        hca@linux.ibm.com, frederic@kernel.org, david@redhat.com,
        cl@linux.com, chenhuacai@kernel.org, atomlin@atomlin.com,
        mtosatti@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmstat-switch-vmstat-shepherd-to-flush-per-cpu-counters-remotely.patch added to mm-unstable branch
Message-Id: <20230303223244.AD18CC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat: switch vmstat shepherd to flush per-CPU counters remotely
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmstat-switch-vmstat-shepherd-to-flush-per-cpu-counters-remotely.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmstat-switch-vmstat-shepherd-to-flush-per-cpu-counters-remotely.patch

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
From: Marcelo Tosatti <mtosatti@redhat.com>
Subject: mm/vmstat: switch vmstat shepherd to flush per-CPU counters remotely
Date: Fri, 03 Mar 2023 16:58:51 -0300

Now that the counters are modified via cmpxchg both CPU locally (via the
account functions), and remotely (via cpu_vm_stats_fold), its possible to
switch vmstat_shepherd to perform the per-CPU vmstats folding remotely.

This fixes the following two problems:

 1. A customer provided some evidence which indicates that
    the idle tick was stopped; albeit, CPU-specific vmstat
    counters still remained populated.

    Thus one can only assume quiet_vmstat() was not
    invoked on return to the idle loop. If I understand
    correctly, I suspect this divergence might erroneously
    prevent a reclaim attempt by kswapd. If the number of
    zone specific free pages are below their per-cpu drift
    value then zone_page_state_snapshot() is used to
    compute a more accurate view of the aforementioned
    statistic.  Thus any task blocked on the NUMA node
    specific pfmemalloc_wait queue will be unable to make
    significant progress via direct reclaim unless it is
    killed after being woken up by kswapd
    (see throttle_direct_reclaim())

 2. With a SCHED_FIFO task that busy loops on a given CPU,
    and kworker for that CPU at SCHED_OTHER priority,
    queuing work to sync per-vmstats will either cause that
    work to never execute, or stalld (i.e. stall daemon)
    boosts kworker priority which causes a latency
    violation

Link: https://lkml.kernel.org/r/20230303195909.003776725@redhat.com
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Xu <peterx@redhat.com>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmstat.c~mm-vmstat-switch-vmstat-shepherd-to-flush-per-cpu-counters-remotely
+++ a/mm/vmstat.c
@@ -2010,6 +2010,23 @@ static void vmstat_shepherd(struct work_
 
 static DECLARE_DEFERRABLE_WORK(shepherd, vmstat_shepherd);
 
+#ifdef CONFIG_HAVE_CMPXCHG_LOCAL
+/* Flush counters remotely if CPU uses cmpxchg to update its per-CPU counters */
+static void vmstat_shepherd(struct work_struct *w)
+{
+	int cpu;
+
+	cpus_read_lock();
+	for_each_online_cpu(cpu) {
+		cpu_vm_stats_fold(cpu);
+		cond_resched();
+	}
+	cpus_read_unlock();
+
+	schedule_delayed_work(&shepherd,
+		round_jiffies_relative(sysctl_stat_interval));
+}
+#else
 static void vmstat_shepherd(struct work_struct *w)
 {
 	int cpu;
@@ -2029,6 +2046,7 @@ static void vmstat_shepherd(struct work_
 	schedule_delayed_work(&shepherd,
 		round_jiffies_relative(sysctl_stat_interval));
 }
+#endif
 
 static void __init start_shepherd_timer(void)
 {
_

Patches currently in -mm which might be from mtosatti@redhat.com are

mm-vmstat-remove-remote-node-draining.patch
this_cpu_cmpxchg-arm64-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-loongarch-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-s390-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-x86-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
add-this_cpu_cmpxchg_local-and-asm-generic-definitions.patch
convert-this_cpu_cmpxchg-users-to-this_cpu_cmpxchg_local.patch
mm-vmstat-switch-counter-modification-to-cmpxchg.patch
mm-vmstat-use-xchg-in-cpu_vm_stats_fold.patch
mm-vmstat-switch-vmstat-shepherd-to-flush-per-cpu-counters-remotely.patch
mm-vmstat-refresh-stats-remotely-instead-of-via-work-item.patch

