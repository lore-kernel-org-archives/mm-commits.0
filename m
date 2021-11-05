Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28B8DC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:39:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17CF061279
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:39:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233469AbhKEUmT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:42:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233440AbhKEUmS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:42:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63AA461252;
        Fri,  5 Nov 2021 20:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144778;
        bh=qjRCMovY/TzXTgGOY2iBP3gdzjaB4kLvhWPEcXRxeb8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=tqndgzKekZt6BsM77J/TyD61JJ4W90IQASUCaXIlmgL8UqZ3jH2Fmp5tDAwvgXsDW
         4oRf0e1KKqxFlZ3aDXHMawGAkJOvfXHVATDUHwGfwLTDtSSZc8sXha0T1ehLiuNmz6
         2ho9EvPov4xH2/3CITv2h5vP9U/awGlqadR38A+w=
Date:   Fri, 05 Nov 2021 13:39:37 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        penguin-kernel@i-love.sakura.ne.jp, torvalds@linux-foundation.org,
        urezki@gmail.com, vdavydov.dev@gmail.com, vvs@virtuozzo.com
Subject:  [patch 095/262] vmalloc: back off when the current task
 is OOM-killed
Message-ID: <20211105203937.PoPS-YPxz%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>
Subject: vmalloc: back off when the current task is OOM-killed

Huge vmalloc allocation on heavy loaded node can lead to a global memory
shortage.  Task called vmalloc can have worst badness and be selected by
OOM-killer, however taken fatal signal does not interrupt allocation
cycle.  Vmalloc repeat page allocaions again and again, exacerbating the
crisis and consuming the memory freed up by another killed tasks.

After a successful completion of the allocation procedure, a fatal signal
will be processed and task will be destroyed finally.  However it may not
release the consumed memory, since the allocated object may have a
lifetime unrelated to the completed task.  In the worst case, this can
lead to the host will panic due to "Out of memory and no killable
processes..."

This patch allows OOM-killer to break vmalloc cycle, makes OOM more
effective and avoid host panic.  It does not check oom condition directly,
however, and breaks page allocation cycle when fatal signal was received.

This may trigger some hidden problems, when caller does not handle vmalloc
failures, or when rollaback after failed vmalloc calls own vmallocs
inside.  However all of these scenarios are incorrect: vmalloc does not
guarantee successful allocation, it has never been called with
__GFP_NOFAIL and threfore either should not be used for any rollbacks or
should handle such errors correctly and not lead to critical failures.

Link: https://lkml.kernel.org/r/83efc664-3a65-2adb-d7c4-2885784cf109@virtuozzo.com
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/vmalloc.c~vmalloc-back-off-when-the-current-task-is-oom-killed
+++ a/mm/vmalloc.c
@@ -2871,6 +2871,9 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 	/* High-order pages or fallback path if "bulk" fails. */
 
 	while (nr_allocated < nr_pages) {
+		if (fatal_signal_pending(current))
+			break;
+
 		if (nid == NUMA_NO_NODE)
 			page = alloc_pages(gfp, order);
 		else
_
