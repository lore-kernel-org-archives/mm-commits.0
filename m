Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5E95C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 21 Sep 2021 17:38:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F18461186
	for <mm-commits@archiver.kernel.org>; Tue, 21 Sep 2021 17:38:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbhIURj2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Sep 2021 13:39:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230346AbhIURj1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 21 Sep 2021 13:39:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25D5260FDA;
        Tue, 21 Sep 2021 17:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632245879;
        bh=j+AzABdH0Lq8kTwaY8sy8/QfaSMqU0wZDwHxlzcIy2g=;
        h=Date:From:To:Subject:From;
        b=tT/SSmQt4rWmUKbeBmXPH0HWsq7qT2rmQleQlr2v4qeBcsR/6Bauqmziz9fSb4KFH
         Zj3xnvVELvC4BiSr7GVuahP2b2w51H//Fy61EneeQgHIrfb4MlgTbXQOkFLqNQsmht
         z+r1ce3g+lwfgTX0LEN7iqBAzvmOrRQQPFbdbDKI=
Date:   Tue, 21 Sep 2021 10:37:58 -0700
From:   akpm@linux-foundation.org
To:     mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org,
        rientjes@google.com, sultan@kerneltoast.com
Subject:  + mm-mark-the-oom-reaper-thread-as-freezable.patch added
 to -mm tree
Message-ID: <20210921173758.d5itgR1Qi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mark the OOM reaper thread as freezable
has been added to the -mm tree.  Its filename is
     mm-mark-the-oom-reaper-thread-as-freezable.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mark-the-oom-reaper-thread-as-freezable.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mark-the-oom-reaper-thread-as-freezable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sultan Alsawaf <sultan@kerneltoast.com>
Subject: mm: mark the OOM reaper thread as freezable

The OOM reaper alters user address space which might theoretically
alter the snapshot if reaping is allowed to happen after the freezer
quiescent state.  To this end, the reaper kthread uses
wait_event_freezable() while waiting for any work so that it cannot run
while the system freezes.

However, the current implementation doesn't respect the freezer because
all kernel threads are created with the PF_NOFREEZE flag, so they are
automatically excluded from freezing operations.  This means that the
OOM reaper can race with system snapshotting if it has work to do while
the system is being frozen.

Fix this by adding a set_freezable() call which will clear the
PF_NOFREEZE flag and thus make the OOM reaper visible to the freezer.

Please note that the OOM reaper altering the snapshot this way is
mostly a theoretical concern and has not been observed in practice.

Link: https://lkml.kernel.org/r/20210921165758.6154-1-sultan@kerneltoast.com
Link: https://lkml.kernel.org/r/20210918233920.9174-1-sultan@kerneltoast.com
Fixes: aac453635549 ("mm, oom: introduce oom reaper")
Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/oom_kill.c~mm-mark-the-oom-reaper-thread-as-freezable
+++ a/mm/oom_kill.c
@@ -641,6 +641,8 @@ done:
 
 static int oom_reaper(void *unused)
 {
+	set_freezable();
+
 	while (true) {
 		struct task_struct *tsk = NULL;
 
_

Patches currently in -mm which might be from sultan@kerneltoast.com are

mm-mark-the-oom-reaper-thread-as-freezable.patch

