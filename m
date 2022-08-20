Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A675C25B08
	for <mm-commits@archiver.kernel.org>; Sat, 20 Aug 2022 20:48:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiHTUsb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 20 Aug 2022 16:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbiHTUsb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 20 Aug 2022 16:48:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A128E13CC1
        for <mm-commits@vger.kernel.org>; Sat, 20 Aug 2022 13:48:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48F9DB80AE8
        for <mm-commits@vger.kernel.org>; Sat, 20 Aug 2022 20:48:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC85CC433D6;
        Sat, 20 Aug 2022 20:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661028507;
        bh=AiVAdj+ITcv7HIj9c29SuDlJe47Fj7f53TeWdzt90FM=;
        h=Date:To:From:Subject:From;
        b=VxUp8X2kkRSwFlj6ffkEzQh18obrkM/6x0pLwy0KCl64h5XYgcaP5sDasNetGZ5JL
         E0MeaJe67Nk/YB3sC1B4r9uYe4eMO4sdPMyf6vJCpTMbDZ/b5vsRm+VFtZogl6zPdT
         0jo6/kLj6MjcHNJrz0bRal1O5EJxd68vctbZNI6o=
Date:   Sat, 20 Aug 2022 13:48:26 -0700
To:     mm-commits@vger.kernel.org, slyich@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] ia64-fix-clock_getreclock_monotonic-to-report-itc-frequency.patch removed from -mm tree
Message-Id: <20220820204826.EC85CC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ia64: fix clock_getre(CLOCK_MONOTONIC) to report ITC frequency
has been removed from the -mm tree.  Its filename was
     ia64-fix-clock_getreclock_monotonic-to-report-itc-frequency.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Sergei Trofimovich <slyich@gmail.com>
Subject: ia64: fix clock_getre(CLOCK_MONOTONIC) to report ITC frequency
Date: Mon, 15 Aug 2022 06:49:44 +0100

clock_gettime(CLOCK_MONOTONIC, &tp) is very precise on ia64 as it uses
ITC (similar to rdtsc on x86). It's not quite a hrtimer as it is a few
times slower than 1ns. Usually 2-3ns.

clock_getres(CLOCK_MONOTONIC, &res) never reflected that fact and
reported 0.04s precision (1/HZ value).

In https://bugs.gentoo.org/596382 gstreamer's test suite failed loudly
when it noticed precision discrepancy.

Before the change:

    clock_getres(CLOCK_MONOTONIC, &res) reported 250Hz precision.

After the change:

    clock_getres(CLOCK_MONOTONIC, &res) reports ITC (400Mhz) precision.

The patch is based on matoro's fix. It adds a bit of explanation why we
need to special-case arch-specific clock_getres().

Link: https://lkml.kernel.org/r/20220815054944.4130786-1-slyich@gmail.com
Signed-off-by: Sergei Trofimovich <slyich@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/sys_ia64.c           |   26 ++++++++++++++++++++++++
 arch/ia64/kernel/syscalls/syscall.tbl |    2 -
 2 files changed, 27 insertions(+), 1 deletion(-)

--- a/arch/ia64/kernel/syscalls/syscall.tbl~ia64-fix-clock_getreclock_monotonic-to-report-itc-frequency
+++ a/arch/ia64/kernel/syscalls/syscall.tbl
@@ -240,7 +240,7 @@
 228	common	timer_delete			sys_timer_delete
 229	common	clock_settime			sys_clock_settime
 230	common	clock_gettime			sys_clock_gettime
-231	common	clock_getres			sys_clock_getres
+231	common	clock_getres			ia64_clock_getres
 232	common	clock_nanosleep			sys_clock_nanosleep
 233	common	fstatfs64			sys_fstatfs64
 234	common	statfs64			sys_statfs64
--- a/arch/ia64/kernel/sys_ia64.c~ia64-fix-clock_getreclock_monotonic-to-report-itc-frequency
+++ a/arch/ia64/kernel/sys_ia64.c
@@ -166,3 +166,29 @@ ia64_mremap (unsigned long addr, unsigne
 		force_successful_syscall_return();
 	return addr;
 }
+
+asmlinkage long
+ia64_clock_getres(const clockid_t which_clock, struct __kernel_timespec __user *tp)
+{
+	/*
+	 * ia64's clock_gettime() syscall is implemented as a vdso call
+	 * fsys_clock_gettime(). Currently it handles only
+	 * CLOCK_REALTIME and CLOCK_MONOTONIC. Both are based on
+	 * 'ar.itc' counter which gets incremented at a constant
+	 * frequency. It's usually 400MHz, ~2.5x times slower than CPU
+	 * clock frequency. Which is almost a 1ns hrtimer, but not quite.
+	 *
+	 * Let's special-case these timers to report correct precision
+	 * based on ITC frequency and not HZ frequency for supported
+	 * clocks.
+	 */
+	switch (which_clock) {
+		case CLOCK_REALTIME:
+		case CLOCK_MONOTONIC:
+			s64 tick_ns = DIV_ROUND_UP(NSEC_PER_SEC, local_cpu_data->itc_freq);
+			struct timespec64 rtn_tp = ns_to_timespec64(tick_ns);
+			return put_timespec64(&rtn_tp, tp);
+	}
+
+	return sys_clock_getres(which_clock, tp);
+}
_

Patches currently in -mm which might be from slyich@gmail.com are


