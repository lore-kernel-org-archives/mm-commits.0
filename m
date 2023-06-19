Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 863ACC001DE
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:28:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjFSX2Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjFSX2F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:28:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C640B1BF5
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:26:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CC63610A2
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:26:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B788BC433C8;
        Mon, 19 Jun 2023 23:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687217176;
        bh=Xa8hymHEt7h1BrXfOamBB0w0hCddW0tLVBcOxATCnbI=;
        h=Date:To:From:Subject:From;
        b=0QsJR30pbZuSM1+X8GtKgYXg3dzji+0xyg2XmRSdmN7mLDkxXA8oX/PHnHwWKVLeb
         NnE6irM01wod6OK+UMPiQKGyr9VyvPA9U6Vx4fTAb7L1e+dYeGrRbf6Yz/iVMQowN3
         Nqryda8aWKQlAU6vOUFlwFTo5cP8bpohQQUfZMj0=
Date:   Mon, 19 Jun 2023 16:26:16 -0700
To:     mm-commits@vger.kernel.org, pmladek@suse.com, npiggin@gmail.com,
        mpe@ellerman.id.au, davem@davemloft.net,
        christophe.leroy@csgroup.eu, dianders@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-hardlockup-move-smp-barriers-from-common-code-to-buddy-code.patch removed from -mm tree
Message-Id: <20230619232616.B788BC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: watchdog/hardlockup: move SMP barriers from common code to buddy code
has been removed from the -mm tree.  Its filename was
     watchdog-hardlockup-move-smp-barriers-from-common-code-to-buddy-code.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Douglas Anderson <dianders@chromium.org>
Subject: watchdog/hardlockup: move SMP barriers from common code to buddy code
Date: Fri, 26 May 2023 18:41:39 -0700

It's been suggested that since the SMP barriers are only potentially
useful for the buddy hardlockup detector, not the perf hardlockup
detector, that the barriers belong in the buddy code.  Let's move them and
add clearer comments about why they're needed.

Link: https://lkml.kernel.org/r/20230526184139.9.I5ab0a0eeb0bd52fb23f901d298c72fa5c396e22b@changeid
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Suggested-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c       |    6 ------
 kernel/watchdog_buddy.c |   21 +++++++++++++++++++++
 2 files changed, 21 insertions(+), 6 deletions(-)

--- a/kernel/watchdog_buddy.c~watchdog-hardlockup-move-smp-barriers-from-common-code-to-buddy-code
+++ a/kernel/watchdog_buddy.c
@@ -51,6 +51,13 @@ void watchdog_hardlockup_enable(unsigned
 	if (next_cpu < nr_cpu_ids)
 		watchdog_hardlockup_touch_cpu(next_cpu);
 
+	/*
+	 * Makes sure that watchdog is touched on this CPU before
+	 * other CPUs could see it in watchdog_cpus. The counter
+	 * part is in watchdog_buddy_check_hardlockup().
+	 */
+	smp_wmb();
+
 	cpumask_set_cpu(cpu, &watchdog_cpus);
 }
 
@@ -68,6 +75,13 @@ void watchdog_hardlockup_disable(unsigne
 	if (next_cpu < nr_cpu_ids)
 		watchdog_hardlockup_touch_cpu(next_cpu);
 
+	/*
+	 * Makes sure that watchdog is touched on the next CPU before
+	 * this CPU disappear in watchdog_cpus. The counter part is in
+	 * watchdog_buddy_check_hardlockup().
+	 */
+	smp_wmb();
+
 	cpumask_clear_cpu(cpu, &watchdog_cpus);
 }
 
@@ -88,5 +102,12 @@ void watchdog_buddy_check_hardlockup(int
 	if (next_cpu >= nr_cpu_ids)
 		return;
 
+	/*
+	 * Make sure that the watchdog was touched on next CPU when
+	 * watchdog_next_cpu() returned another one because of
+	 * a change in watchdog_hardlockup_enable()/disable().
+	 */
+	smp_rmb();
+
 	watchdog_hardlockup_check(next_cpu, NULL);
 }
--- a/kernel/watchdog.c~watchdog-hardlockup-move-smp-barriers-from-common-code-to-buddy-code
+++ a/kernel/watchdog.c
@@ -109,9 +109,6 @@ EXPORT_SYMBOL(arch_touch_nmi_watchdog);
 void watchdog_hardlockup_touch_cpu(unsigned int cpu)
 {
 	per_cpu(watchdog_hardlockup_touched, cpu) = true;
-
-	/* Match with smp_rmb() in watchdog_hardlockup_check() */
-	smp_wmb();
 }
 
 static bool is_hardlockup(unsigned int cpu)
@@ -141,9 +138,6 @@ static void watchdog_hardlockup_kick(voi
 
 void watchdog_hardlockup_check(unsigned int cpu, struct pt_regs *regs)
 {
-	/* Match with smp_wmb() in watchdog_hardlockup_touch_cpu() */
-	smp_rmb();
-
 	if (per_cpu(watchdog_hardlockup_touched, cpu)) {
 		per_cpu(watchdog_hardlockup_touched, cpu) = false;
 		return;
_

Patches currently in -mm which might be from dianders@chromium.org are


