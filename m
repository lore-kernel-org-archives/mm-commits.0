Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19E7EC433F5
	for <mm-commits@archiver.kernel.org>; Sat, 26 Feb 2022 00:04:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239968AbiBZAFZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Feb 2022 19:05:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239844AbiBZAFZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Feb 2022 19:05:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3D71EF350
        for <mm-commits@vger.kernel.org>; Fri, 25 Feb 2022 16:04:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A49861D23
        for <mm-commits@vger.kernel.org>; Sat, 26 Feb 2022 00:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4ED6C340E7;
        Sat, 26 Feb 2022 00:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645833890;
        bh=5+OjPH0GUNokkuZ8Gh0tGwtnM//55dBJtnWLlGku5NY=;
        h=Date:To:From:Subject:From;
        b=kCkJzsKvGITEwti11q2NcEssmeHwgzpck1i+ePzcoyAiBS4gtMrGFDuwRn19BsW9D
         JlDCGN/q6tlZKgz1C1gUa0+9eeO5n+Yj3g+Y/3qAutcLc9r9V5VDpOat2ksF8lkulu
         KlcjMMb3r2pK3JoIYaw7hTp7Vqg78ZPg155SxNMU=
Date:   Fri, 25 Feb 2022 16:04:50 -0800
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        bigeasy@linutronix.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-protect-per-cpu-counter-by-disabling-preemption-on-preempt_rt-where-needed-fix-2.patch added to -mm tree
Message-Id: <20220226000450.B4ED6C340E7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: only perform the debug checks on !PREEMPT_RT
has been added to the -mm tree.  Its filename is
     mm-memcg-protect-per-cpu-counter-by-disabling-preemption-on-preempt_rt-where-needed-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-protect-per-cpu-counter-by-disabling-preemption-on-preempt_rt-where-needed-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-protect-per-cpu-counter-by-disabling-preemption-on-preempt_rt-where-needed-fix-2.patch

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
Subject: mm/memcg: only perform the debug checks on !PREEMPT_RT

On PREEMPT_RT interrupts and preemption is always enabled.  The locking
function __memcg_stats_lock() always disabled preemptions.  The recently
added checks need to performed only on !PREEMPT_RT where preemption and
disabled interrupts are used.

Please fold into:
	"Protect per-CPU counter by disabling preemption on PREEMPT_RT"

Link: https://lkml.kernel.org/r/Yhlf29/HqyNMOvGb@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-protect-per-cpu-counter-by-disabling-preemption-on-preempt_rt-where-needed-fix-2
+++ a/mm/memcontrol.c
@@ -741,7 +741,7 @@ void __mod_memcg_lruvec_state(struct lru
 	 * interrupt context while other caller need to have disabled interrupt.
 	 */
 	__memcg_stats_lock();
-	if (IS_ENABLED(CONFIG_DEBUG_VM)) {
+	if (IS_ENABLED(CONFIG_DEBUG_VM) && !IS_ENABLED(CONFIG_PREEMPT_RT)) {
 		switch (idx) {
 		case NR_ANON_MAPPED:
 		case NR_FILE_MAPPED:
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

mm-memcg-disable-threshold-event-handlers-on-preempt_rt.patch
mm-memcg-protect-per-cpu-counter-by-disabling-preemption-on-preempt_rt-where-needed.patch
mm-memcg-protect-per-cpu-counter-by-disabling-preemption-on-preempt_rt-where-needed-fix.patch
mm-memcg-protect-per-cpu-counter-by-disabling-preemption-on-preempt_rt-where-needed-fix-2.patch
mm-memcg-protect-memcg_stock-with-a-local_lock_t.patch
mm-memcg-disable-migration-instead-of-preemption-in-drain_all_stock.patch

