Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE9322424C
	for <mm-commits@vger.kernel.org>; Fri, 22 May 2026 03:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779422043; cv=none; b=qJymGvVONYt4CbiAwu4SgbZ1ssMxBtoKt7ZKeIYTSyygkGdvk6ArZ0eymYlcwNtHDZOn4/rXEfIDpKzBFsTjhbvTxGjhubm+Fl/BbFcMR4xcI1rG18I7OHlI2E7txJoGoxRCdfE9NYo7ZMOCwRY6BqoAuYCJuCJPL6S9RKSuOLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779422043; c=relaxed/simple;
	bh=mWwSKT2ZfdObK3MDXMFUPScN/FyjmYYga9ZhhWqJgjs=;
	h=Date:To:From:Subject:Message-Id; b=Ds5LFxgNnXjDO9t0sqacQDvHdJmBmCP+bp8CXlGYLmT90zEsSu1N9MV4IQBcGOqhmztHW2IWbUuz+e6gYxZFJvp+uR6nWjvYrCb+IamRMRDZQYU/dWWQXeHxisQdcS3jXmElItBgW8w178YQ4IDVVowO16bF8uPy5FYBdNSWbN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X2b7msZa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X2b7msZa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6B41F000E9;
	Fri, 22 May 2026 03:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779422042;
	bh=E+QEhnIqEFKGQRTU6vNBN6iE52eXjd53XK4nmOsjFJ0=;
	h=Date:To:From:Subject;
	b=X2b7msZa5vyvL1FD53XMOf0P3y8Xe+cSh1wxekS9SkH1r4XLG1O5xPbuEUL34qgjn
	 solO824mn+XIuhUDpdtJGQojS+Gm1vGGeFJJQ9gtCeIifkmn3YUmQzv8d4UyBShhp6
	 28QIUbFvWb9gR22UY1Abo8oNYmCmcMF0jP4NAtxU=
Date: Thu, 21 May 2026 20:54:01 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,paulmck@kernel.org,feng.tang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi-fix-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20260522035402.2A6B41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi-fix-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi-fix-fix.patch

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

selftests-mm-check-file-initialization-writes-in-split_huge_page_test-fix.patch
mm-memcg-swap-store-cgroup-id-in-cluster-table-directly-fix.patch
mm-swap-merge-zeromap-into-swap-table-fix.patch
mm-swap-merge-zeromap-into-swap-table-fix-2.patch
mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes.patch
proc-rewrite-next_tgid-fix.patch
lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi-fix-fix.patch

