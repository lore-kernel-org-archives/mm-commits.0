Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71AC8C71153
	for <mm-commits@archiver.kernel.org>; Mon,  4 Sep 2023 19:35:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbjIDTfX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Sep 2023 15:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232752AbjIDTfW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Sep 2023 15:35:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FAB4CFB
        for <mm-commits@vger.kernel.org>; Mon,  4 Sep 2023 12:35:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E0076194A
        for <mm-commits@vger.kernel.org>; Mon,  4 Sep 2023 19:35:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F34FC433C8;
        Mon,  4 Sep 2023 19:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693856101;
        bh=3puDY2jXP+WoP3hDJluhBS1i6cmesl/U7kCOJbLKklk=;
        h=Date:To:From:Subject:From;
        b=Yc+Qz+YvydKbjDfZH//OMnckY7Tw6388V0pwOxVrmPrHdFK8bijUn9LHG05x4egCK
         O1S2dwv8rwyLKg3ASVCbd6ab3Q7BoSn1qWU0y9hJhzag55m8gkIE3dyqvFJjIlGjiM
         Mw8SpY+8EnW9mFRLVJjxBwof/xJEypL2BhLJ6UnI=
Date:   Mon, 04 Sep 2023 12:35:00 -0700
To:     mm-commits@vger.kernel.org, ubizjak@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-use-atomic_try_cmpxchg-in-panic-and-nmi_panic.patch added to mm-nonmm-unstable branch
Message-Id: <20230904193501.5F34FC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: panic: use atomic_try_cmpxchg in panic() and nmi_panic()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-use-atomic_try_cmpxchg-in-panic-and-nmi_panic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-use-atomic_try_cmpxchg-in-panic-and-nmi_panic.patch

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

Link: https://lkml.kernel.org/r/20230904152230.9227-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
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
+	if (atomic_try_cmpxchg(&panic_cpu, &old_cpu, this_cpu))
+		;
+	else if (old_cpu != this_cpu)
 		panic_smp_self_stop();
 
 	console_verbose();
_

Patches currently in -mm which might be from ubizjak@gmail.com are

panic-use-atomic_try_cmpxchg-in-panic-and-nmi_panic.patch

