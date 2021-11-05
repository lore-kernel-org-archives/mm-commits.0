Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1660C4332F
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD9E26135A
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233504AbhKEUqH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:46:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232810AbhKEUqG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:46:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59D626135E;
        Fri,  5 Nov 2021 20:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145006;
        bh=yelT7RDN9BELjHO/lKSQkIlOI+NNDDjK6q3o/D/CS6o=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=t7QVdXzr6Vl9NffqXrFw8GVXcr8LIufoa5R08gu15KMIlad3x90GpFj3vJXVtSrkR
         3q6opN8XgYdasurcGXkjq5zd4GkdZDRgS5ydSRXR1uOCMCiWbuOR/QPBMiA5ZUmrOS
         r2ZHsf4rzyXVS75dIcHDDqE2W1gTItJzFIVrI/vI=
Date:   Fri, 05 Nov 2021 13:43:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org, mgorman@suse.de,
        mhocko@suse.com, mm-commits@vger.kernel.org, rientjes@google.com,
        sultan@kerneltoast.com, torvalds@linux-foundation.org
Subject:  [patch 168/262] mm: mark the OOM reaper thread as
 freezable
Message-ID: <20211105204325.8b8llOGWT%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
