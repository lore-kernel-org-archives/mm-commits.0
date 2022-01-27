Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 770F7C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jan 2022 20:23:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234414AbiA0UX5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jan 2022 15:23:57 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57606 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbiA0UX5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jan 2022 15:23:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E833618C8
        for <mm-commits@vger.kernel.org>; Thu, 27 Jan 2022 20:23:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CCF7C340E4;
        Thu, 27 Jan 2022 20:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643315036;
        bh=EHb2Ig84CjXpWdNXUwQMm3oqQ95IKV1DOEr85r2PN/I=;
        h=Date:From:To:Subject:From;
        b=NTGOhajXduFUd0FzbM5zXHAWBtyU04heJpQFk3nfD3rQIY+SmyIa2zkeU2QwXBs2L
         fAdX7q1rp72jqzAzviZEFVB/kcl49GhNBv4lzqbvcdANUgFqQxNSKq/hT5Nk2iGcTd
         yCn6p2XOVv+EycSF9xvJPmaswhD0YTinJzxLvJnQ=
Date:   Thu, 27 Jan 2022 12:23:55 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com, vvs@virtuozzo.com
Subject:  + memcg-replace-in_interrupt-with-in_task.patch added to
 -mm tree
Message-ID: <20220127202355.xQMKP2Eel%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: replace in_interrupt() with !in_task()
has been added to the -mm tree.  Its filename is
     memcg-replace-in_interrupt-with-in_task.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcg-replace-in_interrupt-with-in_task.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcg-replace-in_interrupt-with-in_task.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: memcg: replace in_interrupt() with !in_task()

Replace the deprecated in_interrupt() with !in_task() because
in_interrupt() returns true for BH disabled even if the call happens in
the task context.  in_task() is the right interface to differentiate task
context from NMI, hard IRQ and softirq contexts.

Link: https://lkml.kernel.org/r/20220127162636.3461256-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Cc: Vasily Averin <vvs@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~memcg-replace-in_interrupt-with-in_task
+++ a/mm/memcontrol.c
@@ -2688,7 +2688,7 @@ done_restock:
 			READ_ONCE(memcg->swap.high);
 
 		/* Don't bother a random interrupted task */
-		if (in_interrupt()) {
+		if (!in_task()) {
 			if (mem_high) {
 				schedule_work(&memcg->high_work);
 				break;
@@ -6968,7 +6968,7 @@ void mem_cgroup_sk_alloc(struct sock *sk
 		return;
 
 	/* Do not associate the sock with unrelated interrupted task's memcg. */
-	if (in_interrupt())
+	if (!in_task())
 		return;
 
 	rcu_read_lock();
_

Patches currently in -mm which might be from shakeelb@google.com are

memcg-replace-in_interrupt-with-in_task.patch

