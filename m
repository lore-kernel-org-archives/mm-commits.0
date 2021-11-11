Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0612DC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:46:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1D0461260
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:46:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234382AbhKKCtU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:49:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:54162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234346AbhKKCtT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:49:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB41E6113B;
        Thu, 11 Nov 2021 02:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598790;
        bh=5nB4a7YK7/zPj/sOJwerMjccbkaX2Mb1TLZruq/8tWk=;
        h=Date:From:To:Subject:From;
        b=FJr89yqE+LNw0a8snRHGEcm4+k7ePf7ruKc8T2EqvV+ZyE/eN9PCA0+N+lvhNv1NX
         iRS7K0XjTGWLMHsAUTp1iRyaT/P6S+/0yDCGDy2yvyunhC7wEfgx9BVFniHCD98fhq
         wMQVR9G1kGQNKBcRWu/Coe5NcgmH+SmBO9489djs=
Date:   Wed, 10 Nov 2021 18:46:30 -0800
From:   akpm@linux-foundation.org
To:     mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org,
        rientjes@google.com, sultan@kerneltoast.com
Subject:  [merged] mm-mark-the-oom-reaper-thread-as-freezable.patch
 removed from -mm tree
Message-ID: <20211111024630._2KcUraqX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mark the OOM reaper thread as freezable
has been removed from the -mm tree.  Its filename was
     mm-mark-the-oom-reaper-thread-as-freezable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


