Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D0D9C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:33:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242479AbiCYBfA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357375AbiCYBdo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDA4BD8AB
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B24560B03
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E930C340ED;
        Fri, 25 Mar 2022 01:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171930;
        bh=ovjKrTT95sakvDjmewO2C9YdH3NF0OqI/ENT23yn95I=;
        h=Date:To:From:Subject:From;
        b=tJOxQUmH49WVJsOF57TsJq4iWPEJBnSoxsEVqmQNYlFre2DQTlyRkELtS8LBGzXmh
         AtDHfagsE8wFTrgZboCfb0E7tljOt1GbAUeiUF2CmcOqgGFAu/2KJFKjp/T3M5ECXc
         VyjuM+xkO075C+9o8a/EOGvaJwt0DqFKCF4X0z3o=
Date:   Thu, 24 Mar 2022 18:32:09 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, longman@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-list_lru-optimize-memcg_reparent_list_lru_node.patch removed from -mm tree
Message-Id: <20220325013210.8E930C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/list_lru: optimize memcg_reparent_list_lru_node()
has been removed from the -mm tree.  Its filename was
     mm-list_lru-optimize-memcg_reparent_list_lru_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm/list_lru: optimize memcg_reparent_list_lru_node()

Since commit 2c80cd57c743 ("mm/list_lru.c: fix list_lru_count_node() to be
race free"), we are tracking the total number of lru entries in a
list_lru_node in its nr_items field.  In the case of
memcg_reparent_list_lru_node(), there is nothing to be done if nr_items is
0.  We don't even need to take the nlru->lock as no new lru entry could be
added by a racing list_lru_add() to the draining src_idx memcg at this
point.

On systems that serve a lot of containers, it is possible that there can
be thousands of list_lru's present due to the fact that each container may
mount its own container specific filesystems.  As a typical container uses
only a few cpus, it is likely that only the list_lru_node that contains
those cpus will be utilized while the rests may be empty.  In other words,
there can be a lot of list_lru_node with 0 nr_items.  By skipping a
lock/unlock operation and loading a cacheline from memcg_lrus, a sizeable
number of cpu cycles can be saved.  That can be substantial if we are
talking about thousands of list_lru_node's with 0 nr_items.

Link: https://lkml.kernel.org/r/20220309144000.1470138-1-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/list_lru.c~mm-list_lru-optimize-memcg_reparent_list_lru_node
+++ a/mm/list_lru.c
@@ -395,6 +395,12 @@ static void memcg_reparent_list_lru_node
 	struct list_lru_one *src, *dst;
 
 	/*
+	 * If there is no lru entry in this nlru, we can skip it immediately.
+	 */
+	if (!READ_ONCE(nlru->nr_items))
+		return;
+
+	/*
 	 * Since list_lru_{add,del} may be called under an IRQ-safe lock,
 	 * we have to use IRQ-safe primitives here to avoid deadlock.
 	 */
_

Patches currently in -mm which might be from longman@redhat.com are

lib-vsprintf-avoid-redundant-work-with-0-size.patch
mm-page_owner-use-scnprintf-to-avoid-excessive-buffer-overrun-check.patch
mm-page_owner-print-memcg-information.patch
mm-page_owner-record-task-command-name.patch
ipc-mqueue-use-get_tree_nodev-in-mqueue_get_tree.patch

