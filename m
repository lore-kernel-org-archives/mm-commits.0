Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1114CC43219
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 22:26:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbiESW0Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 18:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245517AbiESW0O (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 18:26:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244BC2A24D
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 15:25:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B44A361012
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 22:25:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D61C385B8;
        Thu, 19 May 2022 22:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652999157;
        bh=ljkXVglm/CLIHhkaPHaoC1Jy0N1tqZXnP1RBc92CUfI=;
        h=Date:To:From:Subject:From;
        b=gVtvXgCMU1OG1mcYuI25d/ZJuTsXQQqOq4XeYGezqgE2FNeo8fzfi+H0J8lhSYRQh
         G/PFjzg4PCe/EEHSTRtBD1IiWwWs6UeFAx/4tmp6j3nnSZ4W1yi5Qf99iqM9i1pJql
         rb+3Bu7rhQYMsyNcbvPwGHVNTKzuGUQkrSN/s6yA=
Date:   Thu, 19 May 2022 15:25:56 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        syzbot+217f792c92599518a2ab@syzkaller.appspotmail.com,
        rientjes@google.com, wanngchenng@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mempolicy-fix-uninit-value-in-mpol_rebind_policy.patch removed from -mm tree
Message-Id: <20220519222557.17D61C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mempolicy: fix uninit-value in mpol_rebind_policy()
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-fix-uninit-value-in-mpol_rebind_policy.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

This patch seems to fix below bug too.
KMSAN: uninit-value in mpol_rebind_mm (2)
https://syzkaller.appspot.com/bug?id=f2fecd0d7013f54ec4162f60743a2b28df40926b

The uninit-value is pol->w.cpuset_mems_allowed in mpol_rebind_policy().
When syzkaller reproducer runs to the beginning of mpol_new(),

	    mpol_new() mm/mempolicy.c
	  do_mbind() mm/mempolicy.c
	kernel_mbind() mm/mempolicy.c

`mode` is 1(MPOL_PREFERRED), nodes_empty(*nodes) is `true` and `flags`
is 0. Then

	mode = MPOL_LOCAL;
	...
	policy->mode = mode;
	policy->flags = flags;

will be executed. So in mpol_set_nodemask(),

	    mpol_set_nodemask() mm/mempolicy.c
	  do_mbind()
	kernel_mbind()

pol->mode is 4 (MPOL_LOCAL), that `nodemask` in `pol` is not initialized,
which will be accessed in mpol_rebind_policy().

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


