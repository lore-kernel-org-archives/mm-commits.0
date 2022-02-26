Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6AAEC433F5
	for <mm-commits@archiver.kernel.org>; Sat, 26 Feb 2022 00:03:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239951AbiBZAEN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Feb 2022 19:04:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239844AbiBZAEM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Feb 2022 19:04:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6F51D528A
        for <mm-commits@vger.kernel.org>; Fri, 25 Feb 2022 16:03:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B745B833C2
        for <mm-commits@vger.kernel.org>; Sat, 26 Feb 2022 00:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B381C340E7;
        Sat, 26 Feb 2022 00:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645833817;
        bh=8YtqAXN7wSDuQTJMElrCI491w3k/dHjQOWa4m/vgMGM=;
        h=Date:To:From:Subject:From;
        b=nQK5FN3FlzEJ6TAeE5gHleSLA+ZlefFfk/5mnIFAlozOfndT5aC0g/c3LMgMUMs86
         zME8xW2kj9rzdLFc6xehw40Ri9Ov9zvgqf+VYWMEOr4VLbgP5nJSRslETRYJDpgMen
         D4YSbrsmMdKI0+6vlZl03YEiT4GskQgggNjGURrc=
Date:   Fri, 25 Feb 2022 16:03:36 -0800
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        bigeasy@linutronix.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-protect-per-cpu-counter-by-disabling-preemption-on-preempt_rt-where-needed-fix.patch added to -mm tree
Message-Id: <20220226000337.1B381C340E7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: add missing counter index which are not update in interrupt.
has been added to the -mm tree.  Its filename is
     mm-memcg-protect-per-cpu-counter-by-disabling-preemption-on-preempt_rt-where-needed-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-protect-per-cpu-counter-by-disabling-preemption-on-preempt_rt-where-needed-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-protect-per-cpu-counter-by-disabling-preemption-on-preempt_rt-where-needed-fix.patch

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
Subject: mm/memcg: add missing counter index which are not update in interrupt.

Shakeel Butt reported that I missed a few counters which are not updated
in-interrupt context and therefore disabling preemption is fine.

Please fold into:
     "Protect per-CPU counter by disabling preemption on PREEMPT_RT"

Link: https://lkml.kernel.org/r/YhjzE/8LgbULbj/C@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-protect-per-cpu-counter-by-disabling-preemption-on-preempt_rt-where-needed-fix
+++ a/mm/memcontrol.c
@@ -742,10 +742,17 @@ void __mod_memcg_lruvec_state(struct lru
 	 */
 	__memcg_stats_lock();
 	if (IS_ENABLED(CONFIG_DEBUG_VM)) {
-		if (idx == NR_ANON_MAPPED || idx == NR_FILE_MAPPED)
+		switch (idx) {
+		case NR_ANON_MAPPED:
+		case NR_FILE_MAPPED:
+		case NR_ANON_THPS:
+		case NR_SHMEM_PMDMAPPED:
+		case NR_FILE_PMDMAPPED:
 			WARN_ON_ONCE(!in_task());
-		else
+			break;
+		default:
 			WARN_ON_ONCE(!irqs_disabled());
+		}
 	}
 
 	/* Update memcg */
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

mm-memcg-disable-threshold-event-handlers-on-preempt_rt.patch
mm-memcg-protect-per-cpu-counter-by-disabling-preemption-on-preempt_rt-where-needed.patch
mm-memcg-protect-per-cpu-counter-by-disabling-preemption-on-preempt_rt-where-needed-fix.patch
mm-memcg-protect-memcg_stock-with-a-local_lock_t.patch
mm-memcg-disable-migration-instead-of-preemption-in-drain_all_stock.patch

