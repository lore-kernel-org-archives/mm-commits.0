Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CEADC433F5
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 22:15:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 374656113E
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 22:15:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbhJRWRm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Oct 2021 18:17:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhJRWRl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 Oct 2021 18:17:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CE9160F57;
        Mon, 18 Oct 2021 22:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634595330;
        bh=/THTAshXKSUNT2aZPycjxOTAhbytzeCrpI9Rert4xIM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=REphb9pVeRe+CfBsh38qn/knVUwZF9zH60vRJX7e/wbaEiIuOZXHKNZp2ItI3tZ65
         jD7ftMlutgk6NM3W53ARaRUbrZyaKLb11dfMGVaa2TGDjdKC25YASVPpWg+DLDn9zw
         g//MWw5zh8nTVGnhhusVl32FTC8ms35uVcNMOMWw=
Date:   Mon, 18 Oct 2021 15:15:29 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com, david@redhat.com, gthelen@google.com,
        linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        oliver.sang@intel.com, osalvador@suse.de, rientjes@google.com,
        torvalds@linux-foundation.org, weixugc@google.com,
        yang.shi@linux.alibaba.com, ying.huang@intel.com
Subject:  [patch 03/19] mm/migrate: optimize hotplug-time demotion
 order updates
Message-ID: <20211018221529.x0SBH6U6i%akpm@linux-foundation.org>
In-Reply-To: <20211018151438.f2246e2656c041b6753a8bdd@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm/migrate: optimize hotplug-time demotion order updates

Patch series "mm/migrate: 5.15 fixes for automatic demotion", v2.

This contains two fixes for the "automatic demotion" code which was
merged into 5.15:

 * Fix memory hotplug performance regression by watching
   suppressing any real action on irrelevant hotplug events.
 * Ensure CPU hotplug handler is registered when memory hotplug
   is disabled.


This patch (of 2):

== tl;dr ==

Automatic demotion opted for a simple, lazy approach to handling hotplug
events.  This noticeably slows down memory hotplug[1].  Optimize away
updates to the demotion order when memory hotplug events should have no
effect.

This has no effect on CPU hotplug.  There is no known problem on the CPU
side and any work there will be in a separate series.

== Background ==

Automatic demotion is a memory migration strategy to ensure that new
allocations have room in faster memory tiers on tiered memory systems. 
The kernel maintains an array (node_demotion[]) to drive these migrations.

The node_demotion[] path is calculated by starting at nodes with CPUs and
then "walking" to nodes with memory.  Only hotplug events which online or
offline a node with memory (N_ONLINE) or CPUs (N_CPU) will actually affect
the migration order.

== Problem ==

However, the current code is lazy.  It completely regenerates the
migration order on *any* CPU or memory hotplug event.  The logic was that
these events are extremely rare and that the overhead from indiscriminate
order regeneration is minimal.

Part of the update logic involves a synchronize_rcu(), which is a pretty
big hammer.  Its overhead was large enough to be detected by some 0day
tests that watch memory hotplug performance[1].

== Solution ==

Add a new helper (node_demotion_topo_changed()) which can differentiate
between superfluous and impactful hotplug events.  Skip the expensive
update operation for superfluous events.

== Aside: Locking ==

It took me a few moments to declare the locking to be safe enough for
node_demotion_topo_changed() to work.  It all hinges on the memory hotplug
lock:

During memory hotplug events, 'mem_hotplug_lock' is held for write.  This
ensures that two memory hotplug events can not be called simultaneously.

CPU hotplug has a similar lock (cpuhp_state_mutex) which also provides
mutual exclusion between CPU hotplug events.  In addition, the demotion
code acquire and hold the mem_hotplug_lock for read during its CPU hotplug
handlers.  This provides mutual exclusion between the demotion memory
hotplug callbacks and the CPU hotplug callbacks.

This effectively allows treating the migration target generation code to
act as if it is single-threaded.

1. https://lore.kernel.org/all/20210905135932.GE15026@xsang-OptiPlex-9020/

Link: https://lkml.kernel.org/r/20210924161251.093CCD06@davehans-spike.ostc.intel.com
Link: https://lkml.kernel.org/r/20210924161253.D7673E31@davehans-spike.ostc.intel.com
Fixes: 884a6e5d1f93 ("mm/migrate: update node demotion order on hotplug events")
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-optimize-hotplug-time-demotion-order-updates
+++ a/mm/migrate.c
@@ -3239,8 +3239,18 @@ static int migration_offline_cpu(unsigne
  * set_migration_target_nodes().
  */
 static int __meminit migrate_on_reclaim_callback(struct notifier_block *self,
-						 unsigned long action, void *arg)
+						 unsigned long action, void *_arg)
 {
+	struct memory_notify *arg = _arg;
+
+	/*
+	 * Only update the node migration order when a node is
+	 * changing status, like online->offline.  This avoids
+	 * the overhead of synchronize_rcu() in most cases.
+	 */
+	if (arg->status_change_nid < 0)
+		return notifier_from_errno(0);
+
 	switch (action) {
 	case MEM_GOING_OFFLINE:
 		/*
_
