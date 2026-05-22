Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93119346A18
	for <mm-commits@vger.kernel.org>; Fri, 22 May 2026 03:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779422041; cv=none; b=dnRo8HUQDq3SaLvqrkOLul7WQhu0XxCDyg4AvGJDRMGLIZVuYWF0r1Oh+EbmVUKJQSZC3cOAxx/qq3ap9rgzJ8Hna+Uc0hh4Yzy7JnyVNsB2qphx+Lj3wTNsSmKvZZumAZIQxD6KsnC5Jch40WPg+RPddBLgwXhbzXxKRr2hYAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779422041; c=relaxed/simple;
	bh=wR1AOyfDLAp5VvING3+Z8S0SuW7nu4PGzm4bi7jzBx0=;
	h=Date:To:From:Subject:Message-Id; b=egfZ5/zsLi/7UBIBcNytI4QsEuqZFzmbmYlMZKuchcnjRILKLZzRZCyesCZHdKQcujb0zMMtkSvGNh+/F6T0cMC/F+IeT2Re5pRmlEQNG8nVw4L02YUVMar07yCpXLS10V6qgy3QBN/JKgUdFTSimRBgY7UgfpQvqqm8ZK/3tBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ieEnRPGT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ieEnRPGT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410A91F000E9;
	Fri, 22 May 2026 03:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779422040;
	bh=CWtZ5nTxEw3EFs1m2iXUrUj2hXrV75jPKqbXrHWZU80=;
	h=Date:To:From:Subject;
	b=ieEnRPGTTbisCRuWEvQ+VqiVozEl68zi6b7dqbkE4S4p01TFWUpiabsv5qbDjgq0r
	 dgRJtqo3igltn2fzPYkg4eSPCkI4ZPOiFd6mDiZ2gc0e59G+wsPacVVAyHnYUGt0S8
	 cm3oreVXI2SHXAuhmZIuv+/xy1CfL3qWTKtycwSg=
Date: Thu, 21 May 2026 20:53:59 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,paulmck@kernel.org,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20260522035400.410A91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi-fix.patch

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
Subject: lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi-fix
Date: Fri, 22 May 2026 09:46:26 +0800

avoid hard-coding "10" in two places and in a comment

Link: https://lore.kernel.org/ag-1ciG0FSomBf7q@U-2FWC9VHC-2323.local
Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/nmi_backtrace.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/lib/nmi_backtrace.c~lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi-fix
+++ a/lib/nmi_backtrace.c
@@ -27,6 +27,8 @@ static DECLARE_BITMAP(backtrace_mask, NR
 /* "in progress" flag of arch_trigger_cpumask_backtrace */
 static unsigned long backtrace_flag;
 
+#define NMI_BT_TIMEOUT_SEC	10
+
 /*
  * When raise() is called it will be passed a pointer to the
  * backtrace_mask. Architectures that call nmi_cpu_backtrace()
@@ -68,8 +70,8 @@ void nmi_trigger_cpumask_backtrace(const
 		raise(to_cpumask(backtrace_mask));
 	}
 
-	/* Wait for up to 10 seconds for all CPUs to do the backtrace */
-	for (i = 0; i < 10 * 1000; i++) {
+	/* Wait for up to NMI_BT_TIMEOUT_SEC seconds for all CPUs to do the backtrace */
+	for (i = 0; i < NMI_BT_TIMEOUT_SEC * 1000; i++) {
 		if (cpumask_empty(to_cpumask(backtrace_mask)))
 			break;
 		mdelay(1);
@@ -77,8 +79,8 @@ void nmi_trigger_cpumask_backtrace(const
 	}
 
 	if (!cpumask_empty(to_cpumask(backtrace_mask))) {
-		pr_warn("After 10 seconds, these CPUS still haven't responded to the NMI: %*pbl\n",
-			cpumask_pr_args(to_cpumask(backtrace_mask)));
+		pr_warn("After %d seconds, these CPUS still haven't responded to the NMI: %*pbl\n",
+			NMI_BT_TIMEOUT_SEC, cpumask_pr_args(to_cpumask(backtrace_mask)));
 
 		nmi_backtrace_stall_check(to_cpumask(backtrace_mask));
 	}
_

Patches currently in -mm which might be from feng.tang@linux.alibaba.com are

lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi.patch
lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi-fix.patch

