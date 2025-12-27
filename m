Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906762877ED
	for <mm-commits@vger.kernel.org>; Thu,  1 Jan 2026 02:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767233432; cv=none; b=IzgwpZsPCRfM/YkOTbaG3krAHGR4OJi+VUh+4lvzZ2gEytssM2024AysaNF+LpOhjKyHwG0y3026QoJ251AlkXIQUC+Oj1njP2YTbOfmFy88Rj14IoG/AxRsKU8m+5PbOA0pcXw1TOqlCIbW4MqrHKT0DvFf8Ip11y3torrpuVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767233432; c=relaxed/simple;
	bh=0N8FFnRxoy0uAHe8d3Q9xUtud40ZUWInsKj+I1Qzg+8=;
	h=Date:To:From:Subject:Message-Id; b=E3oesi3z+1VFpqIe5zAQnwROZUKFxmg7PGDofiUffGpW61dIVZtlyxnHsARTQyyscCMZSIwxlgHsuq1orSSiiu8Bd9vauehe/z73eFPn2V2WkEzj3wkGCc6LIzg1f48aIwTWnTxMFCiEvVFF4uVSzUcgH60WEglxsnsw1q5trLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l6ydrJZq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l6ydrJZq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB6BC113D0;
	Thu,  1 Jan 2026 02:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767233432;
	bh=0N8FFnRxoy0uAHe8d3Q9xUtud40ZUWInsKj+I1Qzg+8=;
	h=Date:To:From:Subject:From;
	b=l6ydrJZqHtOrPfL2hs2KYTZoXN7jWw+qtoBaUScMcom66gce8qrQuqII/Yxs9pFzb
	 0swL/GMf0j7/JephT+cvXhvZ8PFJKXIyEKWNeQg0ilMpfECWg6tMUrauWWQQZ6pWeB
	 r2hGArRbsKKQRGaGBnDTDz0lHYKbBN7ghI77J654=
Date: Wed, 31 Dec 2025 18:10:31 +9900
To: mm-commits@vger.kernel.org,pmladek@suse.com,lkp@intel.com,feng.tang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] kernel-watchdogc-fix-unused-var-warning.patch removed from -mm tree
Message-Id: <20260101021032.5BB6BC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/watchdog.c: fix unused var warning
has been removed from the -mm tree.  Its filename was
     kernel-watchdogc-fix-unused-var-warning.patch

This patch was dropped because it is obsolete

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
@@ -1259,6 +1259,7 @@ static const struct ctl_table watchdog_s
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},
+#if defined(CONFIG_HARDLOCKUP_DETECTOR_COUNTS_HRTIMER)
 	{
 		.procname	= "hardlockup_sys_info",
 		.data		= &hardlockup_si_mask,
@@ -1266,6 +1267,7 @@ static const struct ctl_table watchdog_s
 		.mode		= 0644,
 		.proc_handler	= sysctl_sys_info_handler,
 	},
+#endif
 #ifdef CONFIG_SMP
 	{
 		.procname	= "hardlockup_all_cpu_backtrace",
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free-fix.patch
mm-add-basic-tests-for-lazy_mmu-fix.patch
mm-vmscanc-shrink_folio_list-save-a-tabstop.patch
mm-block-fs-remove-laptop_mode-fix.patch
mm-fix-minor-spelling-mistakes-in-comments-fix.patch

