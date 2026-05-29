Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC75373BF2
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028841; cv=none; b=LNPBPy3+putfysnPDyKaHVqFei4ntXomIpngLubhVIoW4/iczHnmTAV72iHsUA2NyRp4JwGnAdM6AevdWlNULGFPXxorEsILJYXLAP2VTqB2YMGdVH/CLTiUPBvxHANtMb1fAdH3CpOV4qD57Dp9yYUsIgp6Z3G+p1hA9QzbNxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028841; c=relaxed/simple;
	bh=sT1V1pQHI/PIBhqGaDpBuOGQDpxQYjliPbEoizjqyHo=;
	h=Date:To:From:Subject:Message-Id; b=UqQF+HG4bfuZjoknRi7CicLlkDXYDWFeYY3CxCaj3/EGckvfZamDFLO4dh34074aCV+BmSgSYqDOjwxyByi10MgZCKtbJwzqqZok3hfTwapUkrZs5byWexG5F1+PXoRbypyb5hYGeGH3ND+eSFDPwEKGgyCxnD4SUWGFZtgZ+pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SjNFRruw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SjNFRruw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0369C1F00898;
	Fri, 29 May 2026 04:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028840;
	bh=97zqOSyL/O7NrLdRCzMhcQ5SETGS0GSd/6hdDGzLNmE=;
	h=Date:To:From:Subject;
	b=SjNFRruw2LSLlWDqv4dVcpcCu0TvzuWzlwtMDzVkqM7c03SUL/TGmcdixGJ37XIl5
	 QHkmqyIVGGKx/TfidAbjE5+iymFxuKPLyuagW6OYrZ97EKJ4/IzdxwyaxlmZOXMgn/
	 FJ8+EcV7rHIZjuUr3JAun4oC3aqF2BrAvLXYbM5k=
Date: Thu, 28 May 2026 21:27:19 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,paulmck@kernel.org,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi.patch removed from -mm tree
Message-Id: <20260529042720.0369C1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/nmi_backtrace: print out the CPUs which fail to respond to NMI
has been removed from the -mm tree.  Its filename was
     lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Feng Tang <feng.tang@linux.alibaba.com>
Subject: lib/nmi_backtrace: print out the CPUs which fail to respond to NMI
Date: Thu, 21 May 2026 11:03:36 +0800

When debugging RCU stall cases, usually all CPUs will respond to the NMI
and print out the backtrace.  But in some nasty or hardware related cases,
some CPUs may fail to respond in 10 seconds, and very likely this is sign
of severe issues.

Paul McKenney has implemented the NMI backtrace stall check for x86, and
for other architectures, it should be also helpful to at least print out
those CPUs which failed to repond to the NMI, so that users can get an
early heads-up for possible CPU hard stall.

[feng.tang@linux.alibaba.com: avoid hard-coding "10" in two places and in a comment]
  Link: https://lore.kernel.org/ag-1ciG0FSomBf7q@U-2FWC9VHC-2323.local
[akpm@linux-foundation.org: use __stringify()]
Link: https://lore.kernel.org/20260521030336.92172-1-feng.tang@linux.alibaba.com
Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/nmi_backtrace.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/lib/nmi_backtrace.c~lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi
+++ a/lib/nmi_backtrace.c
@@ -16,6 +16,7 @@
 #include <linux/cpumask.h>
 #include <linux/delay.h>
 #include <linux/kprobes.h>
+#include <linux/stringify.h>
 #include <linux/nmi.h>
 #include <linux/cpu.h>
 #include <linux/sched/debug.h>
@@ -27,6 +28,8 @@ static DECLARE_BITMAP(backtrace_mask, NR
 /* "in progress" flag of arch_trigger_cpumask_backtrace */
 static unsigned long backtrace_flag;
 
+#define NMI_BT_TIMEOUT_SEC	10
+
 /*
  * When raise() is called it will be passed a pointer to the
  * backtrace_mask. Architectures that call nmi_cpu_backtrace()
@@ -68,14 +71,20 @@ void nmi_trigger_cpumask_backtrace(const
 		raise(to_cpumask(backtrace_mask));
 	}
 
-	/* Wait for up to 10 seconds for all CPUs to do the backtrace */
-	for (i = 0; i < 10 * 1000; i++) {
+	/* Wait for up to NMI_BT_TIMEOUT_SEC seconds for all CPUs to do the backtrace */
+	for (i = 0; i < NMI_BT_TIMEOUT_SEC * 1000; i++) {
 		if (cpumask_empty(to_cpumask(backtrace_mask)))
 			break;
 		mdelay(1);
 		touch_softlockup_watchdog();
 	}
-	nmi_backtrace_stall_check(to_cpumask(backtrace_mask));
+
+	if (!cpumask_empty(to_cpumask(backtrace_mask))) {
+		pr_warn("After " __stringify(NMI_BT_TIMEOUT_SEC) " seconds, these CPUS still haven't responded to the NMI: %*pbl\n",
+			cpumask_pr_args(to_cpumask(backtrace_mask)));
+
+		nmi_backtrace_stall_check(to_cpumask(backtrace_mask));
+	}
 
 	/*
 	 * Force flush any remote buffers that might be stuck in IRQ context
_

Patches currently in -mm which might be from feng.tang@linux.alibaba.com are


