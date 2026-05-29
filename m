Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367F62E739A
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028374; cv=none; b=BEfkzUF9g5exiJaaCmwdhZZdkFVY5iD3uONeEsWk7bqYi8HL2jRcNR610nkehQZh2ONpDBO/+w9fpqsS/A+snHe0ZQgYt+A+2AxiUXHCYBiDuttacyBWgBd7D4ANSOuDHn/Wr/ZYQqBfXxSOshnFD3r4KMtVGdEZtskOOGbo50s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028374; c=relaxed/simple;
	bh=b1KjA9k9xAD2Q5K0cw8F/M7xwpHuGNih0r27f6CWsCY=;
	h=Date:To:From:Subject:Message-Id; b=sKYNyLfJPVQbhCLY1VFj63nYU1Ku7x61C1Z8BkXTeKpEhB5NiCboUoL4/HRKPQr9CkJfNrwWv8SLvWAjzZ8xlJ31XcSTpyCfc3FPWHwAKwOwgl8y8mxsoQkUIUr/7spvl/g5cwRjFuWcuOm0E3/qWeOV/odKF7Ej6J0RyeunVg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=peewZ9Ja; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="peewZ9Ja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B941F00893;
	Fri, 29 May 2026 04:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028372;
	bh=hxPswzNRJK7N5Rqmj+kCq5DA1p200iG5GlXodUPJW20=;
	h=Date:To:From:Subject;
	b=peewZ9JaCW+0CuLlPbna7X/BTgSnCwtu8Y/SXBhjy97UerPKpoupbyWcmKUO31oHG
	 Fk1r42JoABbfTytu6zuhdcL8N5NVf2a0eHIFUdu54RqlcM7ioFAIUv+Km752F/l07Z
	 3XKPMMd8q5Sgm9TymZIBYExw6rSOpPqhqIKH7uZA=
Date: Thu, 28 May 2026 21:19:32 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,paulmck@kernel.org,feng.tang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi-fix-fix.patch removed from -mm tree
Message-Id: <20260529041932.C1B941F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi-fix-fix
has been removed from the -mm tree.  Its filename was
     lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi-fix-fix.patch

This patch was dropped because it was folded into lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi-fix-fix
Date: Thu May 21 08:49:00 PM PDT 2026

use __stringify()

Cc: Feng Tang <feng.tang@linux.alibaba.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/nmi_backtrace.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/lib/nmi_backtrace.c~lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi-fix-fix
+++ a/lib/nmi_backtrace.c
@@ -16,6 +16,7 @@
 #include <linux/cpumask.h>
 #include <linux/delay.h>
 #include <linux/kprobes.h>
+#include <linux/stringify.h>
 #include <linux/nmi.h>
 #include <linux/cpu.h>
 #include <linux/sched/debug.h>
@@ -79,8 +80,8 @@ void nmi_trigger_cpumask_backtrace(const
 	}
 
 	if (!cpumask_empty(to_cpumask(backtrace_mask))) {
-		pr_warn("After %d seconds, these CPUS still haven't responded to the NMI: %*pbl\n",
-			NMI_BT_TIMEOUT_SEC, cpumask_pr_args(to_cpumask(backtrace_mask)));
+		pr_warn("After " __stringify(NMI_BT_TIMEOUT_SEC) " seconds, these CPUS still haven't responded to the NMI: %*pbl\n",
+			cpumask_pr_args(to_cpumask(backtrace_mask)));
 
 		nmi_backtrace_stall_check(to_cpumask(backtrace_mask));
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memcgv1-dont-compile-swap-functions-when-config_swap=n.patch
mm-switch-deferred-split-shrinker-to-list_lru-fix.patch
mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes.patch
proc-rewrite-next_tgid-fix.patch
lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi.patch
sparc-add-_mcount-prototype.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

