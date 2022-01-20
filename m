Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB00C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:31:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377936AbiATVba (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:31:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377943AbiATVb3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:31:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D484C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:31:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 366DEB81E68
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD6D4C340E3;
        Thu, 20 Jan 2022 21:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714286;
        bh=ptzHf84GKcTJ7kpQ1Ec872obhhjoag9eRBr8kaZxWzI=;
        h=Date:From:To:Subject:From;
        b=eg5hTBlWtMo0SpJ8ydAkxVW9cwjQLicPIsWMRE1q0xJU0n1GWoJ5sWiIdqDgxMZv8
         lmkz20NXki+VjqTWML/oISc6rmHzgd8VZhYHUhK1U2BPFWL9OVFPTugTPV2EubB4lO
         lYWXDsZBapHOHC7WDcpEOSHzyxLuzR/WX6WAqfnU=
Date:   Thu, 20 Jan 2022 13:31:26 -0800
From:   akpm@linux-foundation.org
To:     arjan@linux.intel.com, bigeasy@linutronix.de, mingo@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        tglx@linutronix.de
Subject:  [merged] panic-remove-oops_id.patch removed from -mm tree
Message-ID: <20220120213126.yLXOMTgY9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: panic: Remove oops_id.
has been removed from the -mm tree.  Its filename was
     panic-remove-oops_id.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: panic: Remove oops_id.

The oops id has been added as part of the end of trace marker for the
kerneloops.org project. The id is used to automatically identify duplicate
submissions of the same report. Identical looking reports with different
a id can be considered as the same oops occurred again.

The early initialisation of the oops_id can create a warning if the
random core is not yet fully initialized. On PREEMPT_RT it is
problematic if the id is initialized on demand from non preemptible
context.

The kernel oops project is not available since 2017.
Remove the oops_id and use 0 in the output in case parser rely on it.

Link: https://bugs.debian.org/953172
Link: https://lkml.kernel.org/r/Ybdi16aP2NEugWHq@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |   19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

--- a/kernel/panic.c~panic-remove-oops_id
+++ a/kernel/panic.c
@@ -534,26 +534,9 @@ void oops_enter(void)
 		trigger_all_cpu_backtrace();
 }
 
-/*
- * 64-bit random ID for oopses:
- */
-static u64 oops_id;
-
-static int init_oops_id(void)
-{
-	if (!oops_id)
-		get_random_bytes(&oops_id, sizeof(oops_id));
-	else
-		oops_id++;
-
-	return 0;
-}
-late_initcall(init_oops_id);
-
 static void print_oops_end_marker(void)
 {
-	init_oops_id();
-	pr_warn("---[ end trace %016llx ]---\n", (unsigned long long)oops_id);
+	pr_warn("---[ end trace %016llx ]---\n", 0ULL);
 }
 
 /*
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

locking-rwlocks-introduce-write_lock_nested-fix-2.patch

