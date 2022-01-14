Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37B25C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 21:24:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiANVYj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 16:24:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiANVYj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 16:24:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2146C061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 13:24:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE3C6B82A3C
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 21:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76DD9C36AE5;
        Fri, 14 Jan 2022 21:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642195474;
        bh=yzHNc2SjVSNlPh4sSNbzLrgzq71zS8SfLkvnphImrKM=;
        h=Date:From:To:Subject:From;
        b=2NgzPXHxgGSqj7Sw8I/SMctSzdgxX/PUHuk+00+BgbwHyyr+uMEDgDB2UfumdAynE
         7vMjaDTfJfsBY3+m7rjbPtFmPMIYnEjNK3U7L8E25s3NANuOZ1Tx0F2a4/4UBGDoIq
         K7htxDHjDRH56D/PZZ1yfCmRL+PPNVsB1ju73tow=
Date:   Fri, 14 Jan 2022 13:24:34 -0800
From:   akpm@linux-foundation.org
To:     chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        schatzberg.dan@gmail.com
Subject:  [folded-merged]
 mm-add-group_oom_kill-memoryevent-fix.patch removed from -mm tree
Message-ID: <20220114212434.cn2WRM5-u%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add group_oom_kill memory.event fix
has been removed from the -mm tree.  Its filename was
     mm-add-group_oom_kill-memoryevent-fix.patch

This patch was dropped because it was folded into mm-add-group_oom_kill-memory-event.patch

------------------------------------------------------
From: Dan Schatzberg <schatzberg.dan@gmail.com>
Subject: mm: add group_oom_kill memory.event fix

Andrew, could you please amend the prior patch "mm: add group_oom_kill
memory.event" with these changes from Johannes and Chris?

Also - small nit: it makes better sense to
s/group_oom_kill/oom_group_kill/g in the patch title.

Link: https://lkml.kernel.org/r/20211213162511.2492267-1-schatzberg.dan@gmail.com
Signed-off-by: Dan Schatzberg <schatzberg.dan@gmail.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Acked-by: Chris Down <chris@chrisdown.name>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
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

