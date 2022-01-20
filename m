Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88921C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:10:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232838AbiATCKG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:10:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiATCKB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:10:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C52AC061574
        for <mm-commits@vger.kernel.org>; Wed, 19 Jan 2022 18:10:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A9D46145A
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:10:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A80CC004E1;
        Thu, 20 Jan 2022 02:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644600;
        bh=k3l4WPprdN521D4cSqXMtBQBQ8+c2HPKPIPs2RPFBm8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=yJcKETMQL4AjiTwDgEkZjVha9OI3R+IYGYuDhxOD3LnT738uuUwP7Xgdv4b3YMi8N
         mAF7Cov0/Bpw3WxG8dtg6Zj5kbvRoC+Jco3eKaBYxj+LOSXSlIDn9U8fjdsKeZD9cI
         lAmhvCWMQwszVvPGYd66NMlWoSizqmNlhIU96AFE=
Date:   Wed, 19 Jan 2022 18:09:59 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arjan@linux.intel.com,
        bigeasy@linutronix.de, linux-mm@kvack.org, mingo@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        tglx@linutronix.de, torvalds@linux-foundation.org
Subject:  [patch 43/55] panic: remove oops_id
Message-ID: <20220120020959.FI9fF_AQ5%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: panic: remove oops_id

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
