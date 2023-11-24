Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9464CC61DF4
	for <mm-commits@archiver.kernel.org>; Fri, 24 Nov 2023 19:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345969AbjKXTeq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Nov 2023 14:34:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345941AbjKXTeq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Nov 2023 14:34:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A54391AB
        for <mm-commits@vger.kernel.org>; Fri, 24 Nov 2023 11:34:52 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A8DC433C7;
        Fri, 24 Nov 2023 19:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700854492;
        bh=x3EOuTQk6hexIolApgKB9CvIO70IZIpYNugNjwHoDUQ=;
        h=Date:To:From:Subject:From;
        b=Zyisbiq7SV0vkezgATCNbOzOtavSr/CSa+OesJYs1wnk16I/XeD4cFEXziyAyOf8I
         13tOYAeUIs8NeexXaGeZMl0KUaVw28WDNC/2wtlzlf9Yv80pEeSJUEUIsXWZCM5xJb
         00pdpgEnvXnVpRtRxzSy9w4snceMLEH/4vHcaDqM=
Date:   Fri, 24 Nov 2023 11:34:51 -0800
To:     mm-commits@vger.kernel.org, yang.yang29@zte.com.cn,
        mhocko@suse.com, jiang.xuexin@zte.com.cn, hughd@google.com,
        hannes@cmpxchg.org, wang.yong12@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + =utf-8bw1bbveniigxpbnv4lw5lehrdbw0sig9vbtpkdw1wx3rhc2tzigfkzcbyc3mgzgv0ywlszwqgaw5mb3jtyxrpb24gchjpbnrpbmc==.patch added to mm-unstable branch
Message-Id: <20231124193452.36A8DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom:dump_tasks add rss detailed information printing
has been added to the -mm mm-unstable branch.  Its filename is
     =utf-8bw1bbveniigxpbnv4lw5lehrdbw0sig9vbtpkdw1wx3rhc2tzigfkzcbyc3mgzgv0ywlszwqgaw5mb3jtyxrpb24gchjpbnrpbmc==.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/=utf-8bw1bbveniigxpbnv4lw5lehrdbw0sig9vbtpkdw1wx3rhc2tzigfkzcbyc3mgzgv0ywlszwqgaw5mb3jtyxrpb24gchjpbnrpbmc==.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yong Wang <wang.yong12@zte.com.cn>
Subject: mm, oom:dump_tasks add rss detailed information printing
Date: Thu, 23 Nov 2023 18:40:18 +0800 (CST)

When the system is under oom, it prints out the RSS information of each
process.  However, we don't know the size of rss_anon, rss_file, and
rss_shmem.

To distinguish the memory occupied by anonymous or file mappings
or shmem, could help us identify the root cause of the oom.

So this patch adds RSS details, which refers to the /proc/<pid>/status[1].
It can help us know more about process memory usage.

Example of oom including the new rss_* fields:
[ 1630.902466] Tasks state (memory values in pages):
[ 1630.902870] [  pid  ]   uid  tgid total_vm      rss rss_anon rss_file rss_shmem pgtables_bytes swapents oom_score_adj name
[ 1630.903619] [    149]     0   149      486      288        0      288         0    36864        0             0 ash
[ 1630.904210] [    156]     0   156   153531   153345   153345        0         0  1269760        0             0 mm_test

[1] commit 8cee852ec53f ("mm, procfs: breakdown RSS for anon, shmem and file in /proc/pid/status").

Link: https://lkml.kernel.org/r/202311231840181856667@zte.com.cn
Signed-off-by: Yong Wang <wang.yong12@zte.com.cn>
Reviewed-by: Yang Yang <yang.yang29@zte.com.cn>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Xuexin Jiang <jiang.xuexin@zte.com.cn>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/oom_kill.c~=utf-8bw1bbveniigxpbnv4lw5lehrdbw0sig9vbtpkdw1wx3rhc2tzigfkzcbyc3mgzgv0ywlszwqgaw5mb3jtyxrpb24gchjpbnrpbmc==
+++ a/mm/oom_kill.c
@@ -399,10 +399,11 @@ static int dump_task(struct task_struct
 		return 0;
 	}
 
-	pr_info("[%7d] %5d %5d %8lu %8lu %8ld %8lu         %5hd %s\n",
+	pr_info("[%7d] %5d %5d %8lu %8lu %8lu %8lu %9lu %8ld %8lu         %5hd %s\n",
 		task->pid, from_kuid(&init_user_ns, task_uid(task)),
 		task->tgid, task->mm->total_vm, get_mm_rss(task->mm),
-		mm_pgtables_bytes(task->mm),
+		get_mm_counter(task->mm, MM_ANONPAGES), get_mm_counter(task->mm, MM_FILEPAGES),
+		get_mm_counter(task->mm, MM_SHMEMPAGES), mm_pgtables_bytes(task->mm),
 		get_mm_counter(task->mm, MM_SWAPENTS),
 		task->signal->oom_score_adj, task->comm);
 	task_unlock(task);
@@ -423,7 +424,7 @@ static int dump_task(struct task_struct
 static void dump_tasks(struct oom_control *oc)
 {
 	pr_info("Tasks state (memory values in pages):\n");
-	pr_info("[  pid  ]   uid  tgid total_vm      rss pgtables_bytes swapents oom_score_adj name\n");
+	pr_info("[  pid  ]   uid  tgid total_vm      rss rss_anon rss_file rss_shmem pgtables_bytes swapents oom_score_adj name\n");
 
 	if (is_memcg_oom(oc))
 		mem_cgroup_scan_tasks(oc->memcg, dump_task, oc);
_

Patches currently in -mm which might be from wang.yong12@zte.com.cn are

=utf-8bw1bbveniigxpbnv4lw5lehrdbw0sig9vbtpkdw1wx3rhc2tzigfkzcbyc3mgzgv0ywlszwqgaw5mb3jtyxrpb24gchjpbnrpbmc==.patch

