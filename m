Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4E8BC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Dec 2021 20:17:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383068AbhLCUUz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Dec 2021 15:20:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234814AbhLCUUu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Dec 2021 15:20:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E28DC061354
        for <mm-commits@vger.kernel.org>; Fri,  3 Dec 2021 12:17:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E7BDB8293D
        for <mm-commits@vger.kernel.org>; Fri,  3 Dec 2021 20:17:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB530C53FAD;
        Fri,  3 Dec 2021 20:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638562643;
        bh=Gd0zxdCzDj6X/55qGwnO/JPw/444HPMmnOrp8WgmCY0=;
        h=Date:From:To:Subject:From;
        b=CLkGhwf5HVocAFRZnQ7BMubrfuMo0DMGHuWd5nvJO72qOKWWGDV5gJ+upA+jTMpa+
         YGM9W/DBqUDMp1OUui8VtV3tpRC4C2fz0c25Usf342S0OfUR4RF7hz3DbfAIS8lwhq
         +Qg5IOfeXDTLnBZuSH3OvS9QTxTt6axO0IYwzwlw=
Date:   Fri, 03 Dec 2021 12:17:22 -0800
From:   akpm@linux-foundation.org
To:     alexs@kernel.org, corbet@lwn.net, guro@fb.com,
        lizefan.x@bytedance.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, richard.weiyang@gmail.com,
        schatzberg.dan@gmail.com, shakeelb@google.com,
        songmuchun@bytedance.com, tj@kernel.org, vdavydov.dev@gmail.com,
        willy@infradead.org
Subject:  + mm-add-group_oom_kill-memory-event.patch added to -mm
 tree
Message-ID: <20211203201722._w29ad300%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: add group_oom_kill memory event
has been added to the -mm tree.  Its filename is
     mm-add-group_oom_kill-memory-event.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-add-group_oom_kill-memory-event.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-add-group_oom_kill-memory-event.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Schatzberg <schatzberg.dan@gmail.com>
Subject: mm/memcg: add group_oom_kill memory event

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

Link: https://lkml.kernel.org/r/20211203162426.3375036-1-schatzberg.dan@gmail.com
Signed-off-by: Dan Schatzberg <schatzberg.dan@gmail.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    4 ++++
 include/linux/memcontrol.h              |    1 +
 mm/memcontrol.c                         |    5 +++++
 mm/oom_kill.c                           |    1 +
 4 files changed, 11 insertions(+)

--- a/Documentation/admin-guide/cgroup-v2.rst~mm-add-group_oom_kill-memory-event
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1268,6 +1268,10 @@ PAGE_SIZE multiple when read back.
 		The number of processes belonging to this cgroup
 		killed by any kind of OOM killer.
 
+          oom_group_kill
+                The number of times all tasks in the cgroup were killed
+                due to memory.oom.group.
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
@@ -4390,6 +4390,9 @@ static int mem_cgroup_oom_control_read(s
 	seq_printf(sf, "under_oom %d\n", (bool)memcg->under_oom);
 	seq_printf(sf, "oom_kill %lu\n",
 		   atomic_long_read(&memcg->memory_events[MEMCG_OOM_KILL]));
+	seq_printf(sf, "oom_group_kill %lu\n",
+		   atomic_long_read(
+			&memcg->memory_events[MEMCG_OOM_GROUP_KILL]));
 	return 0;
 }
 
@@ -6318,6 +6321,8 @@ static void __memory_events_show(struct
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

mm-add-group_oom_kill-memory-event.patch

