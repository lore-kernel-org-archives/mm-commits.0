Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0432EB87D
	for <mm-commits@vger.kernel.org>; Wed,  3 Dec 2025 22:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764801912; cv=none; b=Oy/Tiq/q7N0UMzjPrfFgabPugRASZTvat8GvMkJ5SKd9nFyiFSf1O6LFoNuADbkBZv6PT9xod7k5EDBZpIFkh0lZCLYJ0/0jYg6TNqCPU6AFZQzhpPT9cADEtsHy+6mtM3DENc18P6B6U/gAEFeQC1O3pvV1LDQhnSKsHfxQkkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764801912; c=relaxed/simple;
	bh=w0xGHcRFNKcUqW4NqPWwdfgNjUqWC7k4sd3+6bcKW1U=;
	h=Date:To:From:Subject:Message-Id; b=bvhhNYaxBvFlqBAH4E+efyqbSrPXdVGuf48ukrxp4MzWIlozzgqxLXrh7oq88tXnJhp1LkLUw+EOgHTIJrNw1LkP/F3o9BP6gnVtoDl8pKx/CwXgJRA/qfz9LvhM1CK6eToERix0X07UVF++E7pmh1sj/Uv14+IlpRdtEbKHegQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HrEUJ7NK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HrEUJ7NK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF93C4CEF5;
	Wed,  3 Dec 2025 22:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764801911;
	bh=w0xGHcRFNKcUqW4NqPWwdfgNjUqWC7k4sd3+6bcKW1U=;
	h=Date:To:From:Subject:From;
	b=HrEUJ7NKGTdzdquqnEmp/cX71uSj3MSpfAcbwE/uI93pbn9VM94luHdVK2wwrsZsJ
	 sHNx1r6oNkf4o2OizThDeIlGvsnT7w/PyTJc6vSjU9sI46Yihqq8wGCbPiqPmW9cN3
	 WDejQDLFqeH6IpQVO82wByTbmZS533hVO3IPD3z8=
Date: Wed, 03 Dec 2025 14:45:11 -0800
To: mm-commits@vger.kernel.org,pmladek@suse.com,lkp@intel.com,feng.tang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-watchdogc-fix-unused-var-warning.patch added to mm-nonmm-unstable branch
Message-Id: <20251203224511.BEF93C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel/watchdog.c: fix unused var warning
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-watchdogc-fix-unused-var-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-watchdogc-fix-unused-var-warning.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel/watchdog.c: fix unused var warning
Date: Wed Dec  3 02:34:40 PM PST 2025

>> kernel/watchdog.c:74:22: warning: unused variable 'hardlockup_si_mask' [-Wunused-variable]
      74 | static unsigned long hardlockup_si_mask;
         |                      ^~~~~~~~~~~~~~~~~~
   1 warning generated.

Fixes: a9af76a78760 ("watchdog: add sys_info sysctls to dump sys info on system lockup")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202512030920.NFKtekA7-lkp@intel.com/
Link: https://lkml.kernel.org/r/202512030920.NFKtekA7-lkp@intel.com
Cc: Feng Tang <feng.tang@linux.alibaba.com>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/kernel/watchdog.c~kernel-watchdogc-fix-unused-var-warning
+++ a/kernel/watchdog.c
@@ -66,13 +66,6 @@ int __read_mostly sysctl_hardlockup_all_
 unsigned int __read_mostly hardlockup_panic =
 			IS_ENABLED(CONFIG_BOOTPARAM_HARDLOCKUP_PANIC);
 
-/*
- * bitmasks to control what kinds of system info to be printed when
- * hard lockup is detected, it could be task, memory, lock etc.
- * Refer include/linux/sys_info.h for detailed bit definition.
- */
-static unsigned long hardlockup_si_mask;
-
 #ifdef CONFIG_SYSFS
 
 static unsigned int hardlockup_count;
@@ -135,6 +128,13 @@ __setup("nmi_watchdog=", hardlockup_pani
 
 #if defined(CONFIG_HARDLOCKUP_DETECTOR_COUNTS_HRTIMER)
 
+/*
+ * bitmask to control what kinds of system info to be printed when
+ * hard lockup is detected, it could be task, memory, lock etc.
+ * Refer include/linux/sys_info.h for detailed bit definition.
+ */
+static unsigned long hardlockup_si_mask;
+
 static DEFINE_PER_CPU(atomic_t, hrtimer_interrupts);
 static DEFINE_PER_CPU(int, hrtimer_interrupts_saved);
 static DEFINE_PER_CPU(bool, watchdog_hardlockup_warned);
@@ -1250,6 +1250,7 @@ static const struct ctl_table watchdog_s
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},
+#if defined(CONFIG_HARDLOCKUP_DETECTOR_COUNTS_HRTIMER)
 	{
 		.procname	= "hardlockup_sys_info",
 		.data		= &hardlockup_si_mask,
@@ -1257,6 +1258,7 @@ static const struct ctl_table watchdog_s
 		.mode		= 0644,
 		.proc_handler	= sysctl_sys_info_handler,
 	},
+#endif
 #ifdef CONFIG_SMP
 	{
 		.procname	= "hardlockup_all_cpu_backtrace",
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

genalloch-fix-htmldocs-warning.patch
x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer-fix.patch
mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free-fix.patch
kernel-watchdogc-fix-unused-var-warning.patch

