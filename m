Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 391AEC4338F
	for <mm-commits@archiver.kernel.org>; Wed, 28 Jul 2021 22:30:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A5E860FED
	for <mm-commits@archiver.kernel.org>; Wed, 28 Jul 2021 22:30:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbhG1WaN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Jul 2021 18:30:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232163AbhG1WaN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 28 Jul 2021 18:30:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C14B5603E9;
        Wed, 28 Jul 2021 22:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627511410;
        bh=5QAEO1XOajmOiWTHC6vIxZwmo2f3/DSlcOsPzjXoBT8=;
        h=Date:From:To:Subject:From;
        b=z+xrQbAgXe4dgHL1iuT0p0R+S4L2c1ecb++zE4vEgt7FbefraMe35dN3HBV2ZbgeS
         abp1cv9V8eCvoenDo3bfq7AkLwMA7MQNropFbyHvBpiWYStpWHm0/+QvJp+XoKRG3t
         qq2+lQsby8LFbEEtv94fyyIboc7b0OLTjdLVAMR0=
Date:   Wed, 28 Jul 2021 15:30:08 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, shakeelb@google.com, mhocko@suse.com,
        hannes@cmpxchg.org, guro@fb.com, vvs@virtuozzo.com
Subject:  +
 memcg-replace-in_interrupt-by-in_task-in-active_memcg.patch added to -mm tree
Message-ID: <20210728223008.Pq4is%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: replace in_interrupt() by !in_task() in active_memcg()
has been added to the -mm tree.  Its filename is
     memcg-replace-in_interrupt-by-in_task-in-active_memcg.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcg-replace-in_interrupt-by-in_task-in-active_memcg.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcg-replace-in_interrupt-by-in_task-in-active_memcg.patch

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
Subject: memcg: replace in_interrupt() by !in_task() in active_memcg()

set_active_memcg() uses in_interrupt() check to select proper storage for
cgroup: pointer on task struct or per-cpu pointer.

It isn't fully correct: obsoleted in_interrupt() includes tasks with
disabled BH.  It's better to use '!in_task()' instead.

Link: https://lkml.org/lkml/2021/7/26/487
Link: https://lkml.kernel.org/r/ed4448b0-4970-616f-7368-ef9dd3cb628d@virtuozzo.com
Fixes: 37d5985c003d ("mm: kmem: prepare remote memcg charging infra for interrupt contexts")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/mm.h |    2 +-
 mm/memcontrol.c          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/sched/mm.h~memcg-replace-in_interrupt-by-in_task-in-active_memcg
+++ a/include/linux/sched/mm.h
@@ -306,7 +306,7 @@ set_active_memcg(struct mem_cgroup *memc
 {
 	struct mem_cgroup *old;
 
-	if (in_interrupt()) {
+	if (!in_task()) {
 		old = this_cpu_read(int_active_memcg);
 		this_cpu_write(int_active_memcg, memcg);
 	} else {
--- a/mm/memcontrol.c~memcg-replace-in_interrupt-by-in_task-in-active_memcg
+++ a/mm/memcontrol.c
@@ -878,7 +878,7 @@ EXPORT_SYMBOL(mem_cgroup_from_task);
 
 static __always_inline struct mem_cgroup *active_memcg(void)
 {
-	if (in_interrupt())
+	if (!in_task())
 		return this_cpu_read(int_active_memcg);
 	else
 		return current->active_memcg;
_

Patches currently in -mm which might be from vvs@virtuozzo.com are

memcg-enable-accounting-for-pids-in-nested-pid-namespaces.patch
memcg-enable-accounting-for-mnt_cache-entries.patch
memcg-enable-accounting-for-pollfd-and-select-bits-arrays.patch
memcg-enable-accounting-for-file-lock-caches.patch
memcg-enable-accounting-for-fasync_cache.patch
memcg-enable-accounting-for-new-namesapces-and-struct-nsproxy.patch
memcg-enable-accounting-of-ipc-resources.patch
memcg-enable-accounting-for-signals.patch
memcg-enable-accounting-for-posix_timers_cache-slab.patch
memcg-enable-accounting-for-ldt_struct-objects.patch
memcg-replace-in_interrupt-by-in_task-in-active_memcg.patch

