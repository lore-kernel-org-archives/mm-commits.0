Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9551AE936E3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:24:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245016AbjJDUYn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245034AbjJDUXc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:23:32 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21340194
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:23:29 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7542EC433CC;
        Wed,  4 Oct 2023 20:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696451008;
        bh=nejf15bLop6r+eTtsU5W+SvAKxhY5VrXqf/2PUVH1us=;
        h=Date:To:From:Subject:From;
        b=NJdduX96DnhUqZe3V0WuGEZM8b2SpoM0A0ky5K4mOLEou0Hn7sbuj3QL9L57N7v3y
         ftXwlOPg7Gplq2BBOkNuOJTQmNYWTumtiRwR4fEvucV+iqrX841M6oCkg1mdrD6vup
         smMhsrofCu8ro98l7BBHqROcOZvAMu32j7B698RY=
Date:   Wed, 04 Oct 2023 13:23:27 -0700
To:     mm-commits@vger.kernel.org, mark.rutland@arm.com,
        ubizjak@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] panic-use-atomic_try_cmpxchg-in-panic-and-nmi_panic.patch removed from -mm tree
Message-Id: <20231004202328.7542EC433CC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: panic: use atomic_try_cmpxchg in panic() and nmi_panic()
has been removed from the -mm tree.  Its filename was
     panic-use-atomic_try_cmpxchg-in-panic-and-nmi_panic.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Uros Bizjak <ubizjak@gmail.com>
Subject: panic: use atomic_try_cmpxchg in panic() and nmi_panic()
Date: Mon, 4 Sep 2023 17:21:01 +0200

Use atomic_try_cmpxchg instead of atomic_cmpxchg (*ptr, old, new) == old
in panic() and nmi_panic().  x86 CMPXCHG instruction returns success in ZF
flag, so this change saves a compare after cmpxchg (and related move
instruction in front of cmpxchg).

Also, rename cpu variable to this_cpu in nmi_panic() and try to unify
logic flow between panic() and nmi_panic().

No functional change intended.

[ubizjak@gmail.com: clean up if/else block]
  Link: https://lkml.kernel.org/r/20230906191200.68707-1-ubizjak@gmail.com
Link: https://lkml.kernel.org/r/20230904152230.9227-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/kernel/panic.c~panic-use-atomic_try_cmpxchg-in-panic-and-nmi_panic
+++ a/kernel/panic.c
@@ -192,14 +192,15 @@ atomic_t panic_cpu = ATOMIC_INIT(PANIC_C
  */
 void nmi_panic(struct pt_regs *regs, const char *msg)
 {
-	int old_cpu, cpu;
+	int old_cpu, this_cpu;
 
-	cpu = raw_smp_processor_id();
-	old_cpu = atomic_cmpxchg(&panic_cpu, PANIC_CPU_INVALID, cpu);
+	old_cpu = PANIC_CPU_INVALID;
+	this_cpu = raw_smp_processor_id();
 
-	if (old_cpu == PANIC_CPU_INVALID)
+	/* atomic_try_cmpxchg updates old_cpu on failure */
+	if (atomic_try_cmpxchg(&panic_cpu, &old_cpu, this_cpu))
 		panic("%s", msg);
-	else if (old_cpu != cpu)
+	else if (old_cpu != this_cpu)
 		nmi_panic_self_stop(regs);
 }
 EXPORT_SYMBOL(nmi_panic);
@@ -311,15 +312,18 @@ void panic(const char *fmt, ...)
 	 * stop themself or will wait until they are stopped by the 1st CPU
 	 * with smp_send_stop().
 	 *
-	 * `old_cpu == PANIC_CPU_INVALID' means this is the 1st CPU which
-	 * comes here, so go ahead.
+	 * cmpxchg success means this is the 1st CPU which comes here,
+	 * so go ahead.
 	 * `old_cpu == this_cpu' means we came from nmi_panic() which sets
 	 * panic_cpu to this CPU.  In this case, this is also the 1st CPU.
 	 */
+	old_cpu = PANIC_CPU_INVALID;
 	this_cpu = raw_smp_processor_id();
-	old_cpu  = atomic_cmpxchg(&panic_cpu, PANIC_CPU_INVALID, this_cpu);
 
-	if (old_cpu != PANIC_CPU_INVALID && old_cpu != this_cpu)
+	/* atomic_try_cmpxchg updates old_cpu on failure */
+	if (atomic_try_cmpxchg(&panic_cpu, &old_cpu, this_cpu)) {
+		/* go ahead */
+	} else if (old_cpu != this_cpu)
 		panic_smp_self_stop();
 
 	console_verbose();
_

Patches currently in -mm which might be from ubizjak@gmail.com are


