Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D67E9C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 19:55:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1F68610CC
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 19:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233248AbhJGT5o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Oct 2021 15:57:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231513AbhJGT5n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 Oct 2021 15:57:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89A27610C7;
        Thu,  7 Oct 2021 19:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633636549;
        bh=A4RGyeIObG0SFHwaHGQEY81QuRLTyNqnrrRz5qkvUk4=;
        h=Date:From:To:Subject:From;
        b=a3in9C9GePTl37K8f9dBtI5nVX7FNboY8PkmE5nXUOeO9CaxFDVieqbUpGS64f36S
         SL15S9Eq/YIYg5pM3z1ZVlgrYoVVTfQXhFZYPld2gu7fs0iOsojIJ/GwXtEypC313B
         oy7GEn3XxCNh+ybklGkZl/C78FgnxDOufO/Lz51o=
Date:   Thu, 07 Oct 2021 12:55:49 -0700
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        penguin-kernel@i-love.sakura.ne.jp, urezki@gmail.com,
        vdavydov.dev@gmail.com, vvs@virtuozzo.com
Subject:  +
 vmalloc-back-off-when-the-current-task-is-oom-killed.patch added to -mm
 tree
Message-ID: <20211007195549.8BiLeNERd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vmalloc: back off when the current task is OOM-killed
has been added to the -mm tree.  Its filename is
     vmalloc-back-off-when-the-current-task-is-oom-killed.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/vmalloc-back-off-when-the-current-task-is-oom-killed.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/vmalloc-back-off-when-the-current-task-is-oom-killed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -2887,6 +2887,9 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 
 	page = NULL;
 	while (nr_allocated < nr_pages) {
+		if (fatal_signal_pending(current))
+			break;
+
 		if (nid == NUMA_NO_NODE)
 			page = alloc_pages(gfp, order);
 		else
_

Patches currently in -mm which might be from vvs@virtuozzo.com are

memcg-prohibit-unconditional-exceeding-the-limit-of-dying-tasks.patch
mm-vmalloc-repair-warn_allocs-in-__vmalloc_area_node.patch
vmalloc-back-off-when-the-current-task-is-oom-killed.patch

