Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E82C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 13 Dec 2021 20:56:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242397AbhLMU4b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Dec 2021 15:56:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233931AbhLMU4b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Dec 2021 15:56:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1FC7C061574
        for <mm-commits@vger.kernel.org>; Mon, 13 Dec 2021 12:56:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8006261204
        for <mm-commits@vger.kernel.org>; Mon, 13 Dec 2021 20:56:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F31C34600;
        Mon, 13 Dec 2021 20:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639428989;
        bh=agO0uSClWvzVtOYYwmROiTyPp0kopJIWPHH6ro7ycq0=;
        h=Date:From:To:Subject:From;
        b=zCVakra99BcQy83RVdPszXIZ3/DpJQ22Q4Ti9NzLrtagZk0a8z0xTR6rPWDOCVdrC
         pK860YVoVBFniExxOCIJ0d6I6FVmlkmHOIfQbr3MD3sjjSUekTerym2FLyYmNMvFWm
         bwXT9srsO5+BYrtEgUuRUo5fuUyReiGlqajJFRiU=
Date:   Mon, 13 Dec 2021 12:56:29 -0800
From:   akpm@linux-foundation.org
To:     arjan@linux.intel.com, bigeasy@linutronix.de, mingo@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        tglx@linutronix.de
Subject:  + panic-remove-oops_id.patch added to -mm tree
Message-ID: <20211213205629.SZkFS5zeh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: panic: Remove oops_id.
has been added to the -mm tree.  Its filename is
     panic-remove-oops_id.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/panic-remove-oops_id.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/panic-remove-oops_id.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
panic-remove-oops_id.patch

