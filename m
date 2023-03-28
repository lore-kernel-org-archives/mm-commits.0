Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0521DC77B60
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjC1XWN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbjC1XVy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:21:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F1D358E
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C6B8619A3
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7182FC433EF;
        Tue, 28 Mar 2023 23:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045707;
        bh=y9l25tYHfOpMwPIEFZMKZHdLarxGU0UJnpxJ61Ml/iA=;
        h=Date:To:From:Subject:From;
        b=AZDM9yAoAePiq1aItofItnOMdYQHUsy/jqul1YbREyNx+78KNU0rRlHNcfyVz94Fi
         qR2Mas/12u11iqi/tAGYwpwFUhYskPzfZuTQuErU3Xehp0WnhS4jMliWLlOoNqgXnC
         5FJnQsGomCiQvBrJIcCOcd3P6o1fN3tOMF5tsk98=
Date:   Tue, 28 Mar 2023 16:21:47 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tangyeechou@gmail.com, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, findns94@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-prevent-memoryoom_control-load-store-tearing.patch removed from -mm tree
Message-Id: <20230328232147.7182FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, memcg: prevent memory.oom_control load/store tearing
has been removed from the -mm tree.  Its filename was
     mm-memcg-prevent-memoryoom_control-load-store-tearing.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yue Zhao <findns94@gmail.com>
Subject: mm, memcg: Prevent memory.oom_control load/store tearing
Date: Mon, 6 Mar 2023 23:41:37 +0800

The knob for cgroup v1 memory controller: memory.oom_control is not
protected by any locking so it can be modified while it is used.  This is
not an actual problem because races are unlikely.  But it is better to use
[READ|WRITE]_ONCE to prevent compiler from doing anything funky.

The access of memcg->oom_kill_disable is lockless, so it can be
concurrently set at the same time as we are trying to read it.  All
occurrences of memcg->oom_kill_disable are updated with [READ|WRITE]_ONCE.

[findns94@gmail.com: v3]
  Link: https://lkml.kernel.org/r/20230308162555.14195-4-findns94@gmail.com
Link: https://lkml.kernel.org/r/20230306154138.377-4-findns94@gmail.com
Signed-off-by: Yue Zhao <findns94@gmail.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Tang Yizhou <tangyeechou@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-prevent-memoryoom_control-load-store-tearing
+++ a/mm/memcontrol.c
@@ -1929,7 +1929,7 @@ static bool mem_cgroup_oom(struct mem_cg
 	 * Please note that mem_cgroup_out_of_memory might fail to find a
 	 * victim and then we have to bail out from the charge path.
 	 */
-	if (memcg->oom_kill_disable) {
+	if (READ_ONCE(memcg->oom_kill_disable)) {
 		if (current->in_user_fault) {
 			css_get(&memcg->css);
 			current->memcg_in_oom = memcg;
@@ -1999,7 +1999,7 @@ bool mem_cgroup_oom_synchronize(bool han
 	if (locked)
 		mem_cgroup_oom_notify(memcg);
 
-	if (locked && !memcg->oom_kill_disable) {
+	if (locked && !READ_ONCE(memcg->oom_kill_disable)) {
 		mem_cgroup_unmark_under_oom(memcg);
 		finish_wait(&memcg_oom_waitq, &owait.wait);
 		mem_cgroup_out_of_memory(memcg, current->memcg_oom_gfp_mask,
@@ -4515,7 +4515,7 @@ static int mem_cgroup_oom_control_read(s
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(sf);
 
-	seq_printf(sf, "oom_kill_disable %d\n", memcg->oom_kill_disable);
+	seq_printf(sf, "oom_kill_disable %d\n", READ_ONCE(memcg->oom_kill_disable));
 	seq_printf(sf, "under_oom %d\n", (bool)memcg->under_oom);
 	seq_printf(sf, "oom_kill %lu\n",
 		   atomic_long_read(&memcg->memory_events[MEMCG_OOM_KILL]));
@@ -4531,7 +4531,7 @@ static int mem_cgroup_oom_control_write(
 	if (mem_cgroup_is_root(memcg) || !((val == 0) || (val == 1)))
 		return -EINVAL;
 
-	memcg->oom_kill_disable = val;
+	WRITE_ONCE(memcg->oom_kill_disable, val);
 	if (!val)
 		memcg_oom_recover(memcg);
 
@@ -5354,7 +5354,7 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	if (parent) {
 		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
-		memcg->oom_kill_disable = parent->oom_kill_disable;
+		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
 
 		page_counter_init(&memcg->memory, &parent->memory);
 		page_counter_init(&memcg->swap, &parent->swap);
_

Patches currently in -mm which might be from findns94@gmail.com are


