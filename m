Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF980C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 12 May 2022 18:33:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357594AbiELSds (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 14:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357705AbiELSdr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 14:33:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9243866C9E
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 11:33:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E1A8B82A4F
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 18:33:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC404C385B8;
        Thu, 12 May 2022 18:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652380423;
        bh=dakO6MkXJ6WnfIsUHCjPNAGP0uG8wY/jr7sj4gYHwCI=;
        h=Date:To:From:Subject:From;
        b=u6NQ62/1DN+Me8MwUv3coutLrAE3srBjQD7DS7Js8MIKebAx8dEm/osNEAecygEsK
         hG9hU041Zkka5EmnSFp8um42Htw0kbxyYyz1rI47+5UKInnAezrpMFYqkz+V7jHcmv
         F5BbyoTUl5mtr2/OrQUEMFUt5oeMzTbjtiK6LVuo=
Date:   Thu, 12 May 2022 11:33:42 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        syzbot+217f792c92599518a2ab@syzkaller.appspotmail.com,
        rientjes@google.com, wanngchenng@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-fix-uninit-value-in-mpol_rebind_policy.patch added to mm-unstable branch
Message-Id: <20220512183342.EC404C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: fix uninit-value in mpol_rebind_policy()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mempolicy-fix-uninit-value-in-mpol_rebind_policy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-fix-uninit-value-in-mpol_rebind_policy.patch

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
From: Wang Cheng <wanngchenng@gmail.com>
Subject: mm/mempolicy: fix uninit-value in mpol_rebind_policy()

mpol_set_nodemask()(mm/mempolicy.c) does not set up nodemask when
pol->mode is MPOL_LOCAL.  Check pol->mode before access
pol->w.cpuset_mems_allowed in mpol_rebind_policy()(mm/mempolicy.c).

BUG: KMSAN: uninit-value in mpol_rebind_policy mm/mempolicy.c:352 [inline]
BUG: KMSAN: uninit-value in mpol_rebind_task+0x2ac/0x2c0 mm/mempolicy.c:368
 mpol_rebind_policy mm/mempolicy.c:352 [inline]
 mpol_rebind_task+0x2ac/0x2c0 mm/mempolicy.c:368
 cpuset_change_task_nodemask kernel/cgroup/cpuset.c:1711 [inline]
 cpuset_attach+0x787/0x15e0 kernel/cgroup/cpuset.c:2278
 cgroup_migrate_execute+0x1023/0x1d20 kernel/cgroup/cgroup.c:2515
 cgroup_migrate kernel/cgroup/cgroup.c:2771 [inline]
 cgroup_attach_task+0x540/0x8b0 kernel/cgroup/cgroup.c:2804
 __cgroup1_procs_write+0x5cc/0x7a0 kernel/cgroup/cgroup-v1.c:520
 cgroup1_tasks_write+0x94/0xb0 kernel/cgroup/cgroup-v1.c:539
 cgroup_file_write+0x4c2/0x9e0 kernel/cgroup/cgroup.c:3852
 kernfs_fop_write_iter+0x66a/0x9f0 fs/kernfs/file.c:296
 call_write_iter include/linux/fs.h:2162 [inline]
 new_sync_write fs/read_write.c:503 [inline]
 vfs_write+0x1318/0x2030 fs/read_write.c:590
 ksys_write+0x28b/0x510 fs/read_write.c:643
 __do_sys_write fs/read_write.c:655 [inline]
 __se_sys_write fs/read_write.c:652 [inline]
 __x64_sys_write+0xdb/0x120 fs/read_write.c:652
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:524 [inline]
 slab_alloc_node mm/slub.c:3251 [inline]
 slab_alloc mm/slub.c:3259 [inline]
 kmem_cache_alloc+0x902/0x11c0 mm/slub.c:3264
 mpol_new mm/mempolicy.c:293 [inline]
 do_set_mempolicy+0x421/0xb70 mm/mempolicy.c:853
 kernel_set_mempolicy mm/mempolicy.c:1504 [inline]
 __do_sys_set_mempolicy mm/mempolicy.c:1510 [inline]
 __se_sys_set_mempolicy+0x44c/0xb60 mm/mempolicy.c:1507
 __x64_sys_set_mempolicy+0xd8/0x110 mm/mempolicy.c:1507
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

KMSAN: uninit-value in mpol_rebind_task (2)
https://syzkaller.appspot.com/bug?id=d6eb90f952c2a5de9ea718a1b873c55cb13b59dc

Link: https://lkml.kernel.org/r/20220512123428.fq3wofedp6oiotd4@ppc.localdomain
Signed-off-by: Wang Cheng <wanngchenng@gmail.com>
Reported-by: <syzbot+217f792c92599518a2ab@syzkaller.appspotmail.com>
Tested-by: <syzbot+217f792c92599518a2ab@syzkaller.appspotmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-mempolicy-fix-uninit-value-in-mpol_rebind_policy
+++ a/mm/mempolicy.c
@@ -351,7 +351,7 @@ static void mpol_rebind_preferred(struct
  */
 static void mpol_rebind_policy(struct mempolicy *pol, const nodemask_t *newmask)
 {
-	if (!pol)
+	if (!pol || pol->mode == MPOL_LOCAL)
 		return;
 	if (!mpol_store_user_nodemask(pol) &&
 	    nodes_equal(pol->w.cpuset_mems_allowed, *newmask))
_

Patches currently in -mm which might be from wanngchenng@gmail.com are

mm-mempolicy-fix-uninit-value-in-mpol_rebind_policy.patch

