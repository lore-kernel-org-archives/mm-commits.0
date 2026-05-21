Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95F626A1C4
	for <mm-commits@vger.kernel.org>; Thu, 21 May 2026 22:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779403068; cv=none; b=bsnIhnMtiMCukWrTGqttdxPHoElSZHryBNmJApApWvExOFDJPxQerPzjf/as0KwTN/nzQvVJX5WejH+LZT5baYHvPV6/4tZfZ4OlVztH+GRNfnu0WSOUEYQrKHClwr6OFKayNZ82we5rdGdp/wxwV5/p3JhrVQNzRAa6wNlWf6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779403068; c=relaxed/simple;
	bh=RKLCKJWUYU9ViQ1kTmbL3aUNDlslnL7Nt9TB9aRh86s=;
	h=Date:To:From:Subject:Message-Id; b=lBUYCgvy+3DhZ0ze5I20keka4bt1LR9C4fO7FtsBgLHAZbQIZV0lMpFOo7zgSrgHbc2hA3MM9mhm4S0S3O5OzQxM0uzpjgUMvUEvYBFvrwIHzHYpLm15q3WElNCRgJyPEPYtKHwC7uhWbVhiN7WE+/koB12AJlNAhFL+HjDSyGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ECXURAMa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ECXURAMa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342DA1F00A3B;
	Thu, 21 May 2026 22:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779403067;
	bh=DPZMGkWafLrtyLdPVh4NL7djslcpAHdccJ3sKfyERXY=;
	h=Date:To:From:Subject;
	b=ECXURAMamv31Jk4/QM7Rj/5uTN9q+tC8V9eMErYVdv2G3vOK9NGWJU8p0FbMU5XH0
	 6E1R/+UGb9GYNXvWQJgMzVX+pP+7oFA6C/WVagXBlBil6YWUrSdZ1LPKWNMkfhOgtl
	 9qjITQJzKfl4WrDrBjpCfbHrXI4i83lo8rHj1eU4=
Date: Thu, 21 May 2026 15:37:46 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,paulmck@kernel.org,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi.patch added to mm-nonmm-unstable branch
Message-Id: <20260521223747.342DA1F00A3B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/nmi_backtrace: print out the CPUs which fail to respond to NMI
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

Link: https://lore.kernel.org/20260521030336.92172-1-feng.tang@linux.alibaba.com
Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/nmi_backtrace.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/lib/nmi_backtrace.c~lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi
+++ a/lib/nmi_backtrace.c
@@ -75,7 +75,13 @@ void nmi_trigger_cpumask_backtrace(const
 		mdelay(1);
 		touch_softlockup_watchdog();
 	}
-	nmi_backtrace_stall_check(to_cpumask(backtrace_mask));
+
+	if (!cpumask_empty(to_cpumask(backtrace_mask))) {
+		pr_warn("After 10 seconds, these CPUS still haven't responded to the NMI: %*pbl\n",
+			cpumask_pr_args(to_cpumask(backtrace_mask)));
+
+		nmi_backtrace_stall_check(to_cpumask(backtrace_mask));
+	}
 
 	/*
 	 * Force flush any remote buffers that might be stuck in IRQ context
_

Patches currently in -mm which might be from feng.tang@linux.alibaba.com are

lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi.patch

