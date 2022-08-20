Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09493C25B08
	for <mm-commits@archiver.kernel.org>; Sat, 20 Aug 2022 21:03:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiHTVDc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 20 Aug 2022 17:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiHTVDb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 20 Aug 2022 17:03:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4909613CCB
        for <mm-commits@vger.kernel.org>; Sat, 20 Aug 2022 14:03:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D90FD60BCA
        for <mm-commits@vger.kernel.org>; Sat, 20 Aug 2022 21:03:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37857C433D7;
        Sat, 20 Aug 2022 21:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661029408;
        bh=iUdUDv2fn1W6bBSJ2J8wUUy50AZZKuK9kwwVDwj8jsQ=;
        h=Date:To:From:Subject:From;
        b=ZpZmQKKtYMf7Ovqw9eUwHI+BH3e3JNYWgI6n4J4RxuQqkdKJmdYBpJnPTipBeFqEI
         bnLPnjUWCYtFD6EnI245GwHstt4Osor2jW1h+KrbLhaah/4N+h9CPlshFS+zkEJ5YS
         aVdXwTM5AAMzNSuDm4oU5Gwc90PQ59/AtYDDYhc8=
Date:   Sat, 20 Aug 2022 14:03:27 -0700
To:     mm-commits@vger.kernel.org, slyich@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes.patch added to mm-nonmm-unstable branch
Message-Id: <20220820210328.37857C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes.patch

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
Subject: ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes
Date: Sat Aug 20 02:01:10 PM PDT 2022

ERROR: switch and case should be at the same indent
#70: FILE: arch/ia64/kernel/sys_ia64.c:185:
+	switch (which_clock) {
+		case CLOCK_REALTIME:
+		case CLOCK_MONOTONIC:

WARNING: Missing a blank line after declarations
#75: FILE: arch/ia64/kernel/sys_ia64.c:190:
+			struct timespec64 rtn_tp = ns_to_timespec64(tick_ns);
+			return put_timespec64(&rtn_tp, tp);

total: 1 errors, 1 warnings, 37 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Sergei Trofimovich <slyich@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/sys_ia64.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/ia64/kernel/sys_ia64.c~ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes
+++ a/arch/ia64/kernel/sys_ia64.c
@@ -183,11 +183,11 @@ ia64_clock_getres(const clockid_t which_
 	 * clocks.
 	 */
 	switch (which_clock) {
-		case CLOCK_REALTIME:
-		case CLOCK_MONOTONIC:
-			s64 tick_ns = DIV_ROUND_UP(NSEC_PER_SEC, local_cpu_data->itc_freq);
-			struct timespec64 rtn_tp = ns_to_timespec64(tick_ns);
-			return put_timespec64(&rtn_tp, tp);
+	case CLOCK_REALTIME:
+	case CLOCK_MONOTONIC:
+		s64 tick_ns = DIV_ROUND_UP(NSEC_PER_SEC, local_cpu_data->itc_freq);
+		struct timespec64 rtn_tp = ns_to_timespec64(tick_ns);
+		return put_timespec64(&rtn_tp, tp);
 	}
 
 	return sys_clock_getres(which_clock, tp);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

asm-generic-sections-refactor-memory_intersects-fix.patch
procfs-add-path-to-proc-pid-fdinfo-fix.patch
zsmalloc-zs_object_copy-add-clarifying-comment-fix.patch
mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch
zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes.patch
mm-demotion-add-support-for-explicit-memory-tiers-fix.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2.patch
ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes.patch

