Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA157C25B08
	for <mm-commits@archiver.kernel.org>; Sat, 20 Aug 2022 20:49:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbiHTUtK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 20 Aug 2022 16:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbiHTUtH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 20 Aug 2022 16:49:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A89193E7
        for <mm-commits@vger.kernel.org>; Sat, 20 Aug 2022 13:49:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 538BDB80AE8
        for <mm-commits@vger.kernel.org>; Sat, 20 Aug 2022 20:49:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE09C433D6;
        Sat, 20 Aug 2022 20:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661028544;
        bh=Z+5JWqBrPJjr5GoGEFJ/v1+uaSnAmPezK2znM2oYfU4=;
        h=Date:To:From:Subject:From;
        b=lwVjsSlMmCnFBV6AkXCehRBYF/WbrbeN83PfUpRh0qBFC6qNFyJ/hgtB6d1k2v1CN
         VFzcnmRokeCorDm+6s1AXzfHTU5uwwSRZN1JT0DYWxFF/Ia1Wmtuo9b71aQ48MuY6k
         S4Aq2928YRNdQNtDR8op7vjKll2zgTuMZbHrdlLw=
Date:   Sat, 20 Aug 2022 13:49:03 -0700
To:     mm-commits@vger.kernel.org, matoro_mailinglist_kernel@matoro.tk,
        emeric.maschino@gmail.com, slyich@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency.patch added to mm-nonmm-unstable branch
Message-Id: <20220820204904.0CE09C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: fix clock_getres(CLOCK_MONOTONIC) to report ITC frequency
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency.patch

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
From: Sergei Trofimovich <slyich@gmail.com>
Subject: ia64: fix clock_getres(CLOCK_MONOTONIC) to report ITC frequency
Date: Sat, 20 Aug 2022 19:18:13 +0100

clock_gettime(CLOCK_MONOTONIC, &tp) is very precise on ia64 as it uses ITC
(similar to rdtsc on x86).  It's not quite a hrtimer as it is a few times
slower than 1ns.  Usually 2-3ns.

clock_getres(CLOCK_MONOTONIC, &res) never reflected that fact and reported
0.04s precision (1/HZ value).

In https://bugs.gentoo.org/596382 gstreamer's test suite failed loudly
when it noticed precision discrepancy.

Before the change:

    clock_getres(CLOCK_MONOTONIC, &res) reported 250Hz precision.

After the change:

    clock_getres(CLOCK_MONOTONIC, &res) reports ITC (400Mhz) precision.

The patch is based on matoro's fix. I added a bit of explanation why we
need to special-case arch-specific clock_getres().

Link: https://lkml.kernel.org/r/20220820181813.2275195-1-slyich@gmail.com
Signed-off-by: matoro <matoro_mailinglist_kernel@matoro.tk>
Signed-off-by: Sergei Trofimovich <slyich@gmail.com>
Cc: Émeric Maschino <emeric.maschino@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/sys_ia64.c           |   26 ++++++++++++++++++++++++
 arch/ia64/kernel/syscalls/syscall.tbl |    2 -
 2 files changed, 27 insertions(+), 1 deletion(-)

--- a/arch/ia64/kernel/syscalls/syscall.tbl~ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency
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
--- a/arch/ia64/kernel/sys_ia64.c~ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency
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

ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency.patch

