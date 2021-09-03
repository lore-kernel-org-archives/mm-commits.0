Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71B7AC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D086610FB
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235926AbhICU7F (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:59:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238770AbhICU7D (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:59:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7679E6112E;
        Fri,  3 Sep 2021 20:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702682;
        bh=OE0ZuPfm3EpUf2ewF2+83G7uFHsoCtOQm42UOMicfSY=;
        h=Date:From:To:Subject:From;
        b=vgK95aPUwyYRqtvygQ+AzpqyvDPBCgif9kCaCV6b5slQG6GWbtDe/5bXRFamSZDhz
         TTAZ9eu1VOYawJnfCwJRJmYSqA1xqDyKZcRrFErolBJHF5a8Yli8r045fax1343OCW
         WiKnDhb4e7aQpvg+m7UHKK0A92fNA/0WZDzcq48c=
Date:   Fri, 03 Sep 2021 13:58:02 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com, vvs@virtuozzo.com
Subject:  [merged]
 memcg-replace-in_interrupt-by-in_task-in-active_memcg.patch removed from
 -mm tree
Message-ID: <20210903205802.X0ZS4VtJJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: replace in_interrupt() by !in_task() in active_memcg()
has been removed from the -mm tree.  Its filename was
     memcg-replace-in_interrupt-by-in_task-in-active_memcg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


