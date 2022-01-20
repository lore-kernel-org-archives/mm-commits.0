Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4F79C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:25:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377832AbiATVZG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:25:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57216 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232520AbiATVZD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:25:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A439CB81E68
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:25:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2DB9C340E0;
        Thu, 20 Jan 2022 21:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713901;
        bh=8bvfpFZRQa9rQwm2/h+3zJaEEw5YXaEZz7Sp5jQJu1I=;
        h=Date:From:To:Subject:From;
        b=XUwR+laBuY85EW9ky25m0LOONqydk2aWVfTntxvD9+8Fl+uJuMCvWrU6yUvVV96AM
         PAlL1zFvOoD5Ka/8XrWyreJ9z6boxtskXEA+qOixhcV6iUwNSSwI15WINUviVIWewR
         Hswl4Z+JvJbsTl5WyuHb4P03Dwe0eVMrpb5ULKnA=
Date:   Thu, 20 Jan 2022 13:25:00 -0800
From:   akpm@linux-foundation.org
To:     alexs@kernel.org, chris@chrisdown.name, corbet@lwn.net,
        guro@fb.com, hannes@cmpxchg.org, lizefan.x@bytedance.com,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        richard.weiyang@gmail.com, schatzberg.dan@gmail.com,
        shakeelb@google.com, songmuchun@bytedance.com, tj@kernel.org,
        vdavydov.dev@gmail.com, willy@infradead.org
Subject:  [merged] mm-add-group_oom_kill-memory-event.patch removed
 from -mm tree
Message-ID: <20220120212500.a7mWIsM28%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: add oom_group_kill memory event
has been removed from the -mm tree.  Its filename was
     mm-add-group_oom_kill-memory-event.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Schatzberg <schatzberg.dan@gmail.com>
Subject: mm/memcg: add oom_group_kill memory event

Our container agent wants to know when a container exits if it was OOM
killed or not to report to the user.  We use memory.oom.group = 1 to
ensure that OOM kills within the container's cgroup kill everything. 
Existing memory.events are insufficient for knowing if this triggered:

1) Our current approach reads memory.events oom_kill and reports the
   container was killed if the value is non-zero.  This is erroneous in
   some cases where containers create their children cgroups with
   memory.oom.group=1 as such OOM kills will get counted against the
   container cgroup's oom_kill counter despite not actually OOM killing
   the entire container.

2) Reading memory.events.local will fail to identify OOM kills in leaf
   cgroups (that don't set memory.oom.group) within the container cgroup.

This patch adds a new oom_group_kill event when memory.oom.group triggers
to allow userspace to cleanly identify when an entire cgroup is oom
killed.

[schatzberg.dan@gmail.com: changes from Johannes and Chris]
  Link: https://lkml.kernel.org/r/20211213162511.2492267-1-schatzberg.dan@gmail.com
Link: https://lkml.kernel.org/r/20211203162426.3375036-1-schatzberg.dan@gmail.com
Signed-off-by: Dan Schatzberg <schatzberg.dan@gmail.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Chris Down <chris@chrisdown.name>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    3 +++
 include/linux/memcontrol.h              |    1 +
 mm/memcontrol.c                         |    2 ++
 mm/oom_kill.c                           |    1 +
 4 files changed, 7 insertions(+)

--- a/Documentation/admin-guide/cgroup-v2.rst~mm-add-group_oom_kill-memory-event
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1268,6 +1268,9 @@ PAGE_SIZE multiple when read back.
 		The number of processes belonging to this cgroup
 		killed by any kind of OOM killer.
 
+          oom_group_kill
+                The number of times a group OOM has occurred.
+
   memory.events.local
 	Similar to memory.events but the fields in the file are local
 	to the cgroup i.e. not hierarchical. The file modified event
--- a/include/linux/memcontrol.h~mm-add-group_oom_kill-memory-event
+++ a/include/linux/memcontrol.h
@@ -42,6 +42,7 @@ enum memcg_memory_event {
 	MEMCG_MAX,
 	MEMCG_OOM,
 	MEMCG_OOM_KILL,
+	MEMCG_OOM_GROUP_KILL,
 	MEMCG_SWAP_HIGH,
 	MEMCG_SWAP_MAX,
 	MEMCG_SWAP_FAIL,
--- a/mm/memcontrol.c~mm-add-group_oom_kill-memory-event
+++ a/mm/memcontrol.c
@@ -6318,6 +6318,8 @@ static void __memory_events_show(struct
 	seq_printf(m, "oom %lu\n", atomic_long_read(&events[MEMCG_OOM]));
 	seq_printf(m, "oom_kill %lu\n",
 		   atomic_long_read(&events[MEMCG_OOM_KILL]));
+	seq_printf(m, "oom_group_kill %lu\n",
+		   atomic_long_read(&events[MEMCG_OOM_GROUP_KILL]));
 }
 
 static int memory_events_show(struct seq_file *m, void *v)
--- a/mm/oom_kill.c~mm-add-group_oom_kill-memory-event
+++ a/mm/oom_kill.c
@@ -994,6 +994,7 @@ static void oom_kill_process(struct oom_
 	 * If necessary, kill all tasks in the selected memory cgroup.
 	 */
 	if (oom_group) {
+		memcg_memory_event(oom_group, MEMCG_OOM_GROUP_KILL);
 		mem_cgroup_print_oom_group(oom_group);
 		mem_cgroup_scan_tasks(oom_group, oom_kill_memcg_member,
 				      (void *)message);
_

Patches currently in -mm which might be from schatzberg.dan@gmail.com are


