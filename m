Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 562C1C77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:39:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbjDRXi7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbjDRXg4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:36:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1FB7D9A
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:35:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C564863A06
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B83AC433EF;
        Tue, 18 Apr 2023 23:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860950;
        bh=3YIOWkOsTIy219qEK1k2jGIISCZ6ELOozK3IlvbSQns=;
        h=Date:To:From:Subject:From;
        b=1MIokMjFN6/+ad37xpokZefmtiUk0dc8zhPZxw3Q9V5EjdAN1TKmAwrBBPu8quWFa
         ewLDIWqDRoM0vGmiS484xblIne0FVfq+0ke0gJidOUE8dk3B60Qo3slgKE9Yj4r1Y0
         bbUNlBx0k8o5KfhV5YIH2zX2gg+8yzZWhmdCkVXo=
Date:   Tue, 18 Apr 2023 16:35:49 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        viro@zeniv.linux.org.uk, vbabka@suse.cz,
        tim.c.chen@linux.intel.com, shakeelb@google.com,
        roman.gushchin@linux.dev, rientjes@google.com, peterx@redhat.com,
        neilb@suse.de, mhocko@suse.com, linmiaohe@huawei.com,
        iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, djwong@kernel.org,
        david@redhat.com, david@fromorbit.com, cl@linux.com,
        42.hyeyoo@gmail.com, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-move-set_task_reclaim_state-near-flush_reclaim_state.patch removed from -mm tree
Message-Id: <20230418233550.2B83AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: vmscan: move set_task_reclaim_state() near flush_reclaim_state()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-move-set_task_reclaim_state-near-flush_reclaim_state.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: vmscan: move set_task_reclaim_state() near flush_reclaim_state()
Date: Thu, 13 Apr 2023 10:40:33 +0000

Move set_task_reclaim_state() near flush_reclaim_state() so that all
helpers manipulating reclaim_state are in close proximity.

Link: https://lkml.kernel.org/r/20230413104034.1086717-3-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Lameter <cl@linux.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-move-set_task_reclaim_state-near-flush_reclaim_state
+++ a/mm/vmscan.c
@@ -189,18 +189,6 @@ struct scan_control {
  */
 int vm_swappiness = 60;
 
-static void set_task_reclaim_state(struct task_struct *task,
-				   struct reclaim_state *rs)
-{
-	/* Check for an overwrite */
-	WARN_ON_ONCE(rs && task->reclaim_state);
-
-	/* Check for the nulling of an already-nulled member */
-	WARN_ON_ONCE(!rs && !task->reclaim_state);
-
-	task->reclaim_state = rs;
-}
-
 LIST_HEAD(shrinker_list);
 DEFINE_MUTEX(shrinker_mutex);
 DEFINE_SRCU(shrinker_srcu);
@@ -528,6 +516,18 @@ static bool writeback_throttling_sane(st
 }
 #endif
 
+static void set_task_reclaim_state(struct task_struct *task,
+				   struct reclaim_state *rs)
+{
+	/* Check for an overwrite */
+	WARN_ON_ONCE(rs && task->reclaim_state);
+
+	/* Check for the nulling of an already-nulled member */
+	WARN_ON_ONCE(!rs && !task->reclaim_state);
+
+	task->reclaim_state = rs;
+}
+
 /*
  * flush_reclaim_state(): add pages reclaimed outside of LRU-based reclaim to
  * scan_control->nr_reclaimed.
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-vmscan-refactor-updating-current-reclaim_state.patch

