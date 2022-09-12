Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BEB9ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 04:18:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiILESY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 00:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiILESX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 00:18:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C200E24941
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 21:18:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 807E3B80B52
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 04:18:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D07FC433D7;
        Mon, 12 Sep 2022 04:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662956299;
        bh=aYBrjQilwJqk7m/Zzi1OVziaR0otJETtrcSnhRTe1P8=;
        h=Date:To:From:Subject:From;
        b=nVtQCIpxE3ubGRUUKPZ26Ygf4CHQhIWV5faVpJJ2G9C8kburkhHKdZLnhK5EqFsXa
         jg2baeWoCgFgVbYLqF7+Sn/SJhqYf1RUmjFDFC1pbYO+swW10Opthx/yHj4eVO4oF9
         wSk3oiTffbvVHHhxCCqgsvQlt/zc+/iKZMXzBYl8=
Date:   Sun, 11 Sep 2022 21:18:18 -0700
To:     mm-commits@vger.kernel.org, slyich@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20220912041819.1D07FC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes.patch

This patch was dropped because it was folded into ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency.patch

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

mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch
mm-demotion-add-support-for-explicit-memory-tiers-fix.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-delete-unused-mmf_oom_victim-flag-vs-mglru.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree-fix.patch
mm-vmscan-fix-a-lot-of-comments-vs-mglru.patch
swap-add-swap_cache_get_folio-fix.patch
memcg-reduce-size-of-memcg-vmstats-structures-fix.patch
mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme-fix.patch
ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency.patch
fs-uninline-inode_maybe_inc_iversion.patch

