Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A102E739A
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028372; cv=none; b=qoN/PWk3ZTaAoJsqmLFRG1iXJKndRlwmWK7/QMbzCxMwYkasFKtnx/Sjfypjb9kVMWD/5XdZKhMACjlXa94uUm66VP2waA39OhFROV2cAOTrcfe8fwRZj+oKeo+j5Obg9X2vWTMGsmVbK21dAzx+lkvVHJClUHiv0Vjvi+OiV+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028372; c=relaxed/simple;
	bh=BuSlTmXWQdg6zwYxNSGFzpDmMDaldCYNAXgmGQyoNVs=;
	h=Date:To:From:Subject:Message-Id; b=gfvxEo+62GOfsTvUWxZea+5+sPCZYFMBa/1MVFiWaxmFJvCllFItMo5aFxgLr90daskbKftSRRnBA5FCwOkfGoR6PzQ4a2LrcP2UmvkRvJlioM0mk8h26MW7YyTLds/P5afDbSuGzwvp2TmzEj222MHQ680YUL5p+NagR4uuADE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DKiDLv7B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DKiDLv7B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0605A1F00893;
	Fri, 29 May 2026 04:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028371;
	bh=QsrTz1hoEvpqY/xaECS11nhMEX3XS1mQiHxH+l+dtQw=;
	h=Date:To:From:Subject;
	b=DKiDLv7BYZUxLzYKPX5p0B40AF35kkrPTOI0H2IfU1XNoP5rwPKcc1stxIukK8Dfl
	 X51Cp800+RYQspz97+zSVJs7qmv4syah7zotl9NjV6TdJbfe+tC3lXyzMK+Ksp4uPU
	 l+CliwXCIu6RmiJTgGa1eTp7NuaoIJ2ZwTp8qwmo=
Date: Thu, 28 May 2026 21:19:30 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,paulmck@kernel.org,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi-fix.patch removed from -mm tree
Message-Id: <20260529041931.0605A1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi-fix
has been removed from the -mm tree.  Its filename was
     lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi-fix.patch

This patch was dropped because it was folded into lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi.patch

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

