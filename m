Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD37C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 13 Dec 2021 20:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233728AbhLMUwJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Dec 2021 15:52:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236136AbhLMUwI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Dec 2021 15:52:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B2DC061574
        for <mm-commits@vger.kernel.org>; Mon, 13 Dec 2021 12:52:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B84561200
        for <mm-commits@vger.kernel.org>; Mon, 13 Dec 2021 20:52:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB6CC34601;
        Mon, 13 Dec 2021 20:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639428726;
        bh=sy/xiXygDao+LsnDrFOA/iBBseTVR6e/avfLes7HV4c=;
        h=Date:From:To:Subject:From;
        b=IS+upeaG001llrXGIHxlwd06UkaPUEojWivgMZzD8UB5vSxuhv/H2s3ortj2dJe2o
         hRQ/2MP83TxiQHszamhYA9a+atxjiBMNzMWAqk/J8UXUt2oQFFS+gw/yCtSjriPGHY
         UGuVefOoxiEAHyoHiV5lgvCXZZUohk5QRsKjqvys=
Date:   Mon, 13 Dec 2021 12:52:06 -0800
From:   akpm@linux-foundation.org
To:     chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org,
        mm-commits@vger.kernel.org, schatzberg.dan@gmail.com
Subject:  + mm-add-group_oom_kill-memoryevent-fix.patch added to
 -mm tree
Message-ID: <20211213205206.McpbmsAM3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add group_oom_kill memory.event fix
has been added to the -mm tree.  Its filename is
     mm-add-group_oom_kill-memoryevent-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-add-group_oom_kill-memoryevent-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-add-group_oom_kill-memoryevent-fix.patch

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
Subject: mm: add group_oom_kill memory.event fix

Andrew, could you please amend the prior patch "mm: add group_oom_kill
memory.event" with these changes from Johannes and Chris?

Also - small nit: it makes better sense to
s/group_oom_kill/oom_group_kill/g in the patch title.

Link: https://lkml.kernel.org/r/20211213162511.2492267-1-schatzberg.dan@gmail.com
Reviewed-by: Roman Gushchin <guro@fb.com>
Acked-by: Chris Down <chris@chrisdown.name>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Dan Schatzberg <schatzberg.dan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    3 +--
 mm/memcontrol.c                         |    3 ---
 2 files changed, 1 insertion(+), 5 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~mm-add-group_oom_kill-memoryevent-fix
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1269,8 +1269,7 @@ PAGE_SIZE multiple when read back.
 		killed by any kind of OOM killer.
 
           oom_group_kill
-                The number of times all tasks in the cgroup were killed
-                due to memory.oom.group.
+                The number of times a group OOM has occurred.
 
   memory.events.local
 	Similar to memory.events but the fields in the file are local
--- a/mm/memcontrol.c~mm-add-group_oom_kill-memoryevent-fix
+++ a/mm/memcontrol.c
@@ -4390,9 +4390,6 @@ static int mem_cgroup_oom_control_read(s
 	seq_printf(sf, "under_oom %d\n", (bool)memcg->under_oom);
 	seq_printf(sf, "oom_kill %lu\n",
 		   atomic_long_read(&memcg->memory_events[MEMCG_OOM_KILL]));
-	seq_printf(sf, "oom_group_kill %lu\n",
-		   atomic_long_read(
-			&memcg->memory_events[MEMCG_OOM_GROUP_KILL]));
 	return 0;
 }
 
_

Patches currently in -mm which might be from schatzberg.dan@gmail.com are

mm-add-group_oom_kill-memory-event.patch
mm-add-group_oom_kill-memoryevent-fix.patch

