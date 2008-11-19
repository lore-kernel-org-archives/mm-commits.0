From: akpm@linux-foundation.org
Subject: + cgroups-fix-a-serious-bug-in-cgroupstats.patch added to -mm tree
Date: Wed, 19 Nov 2008 00:25:57 -0800
Message-ID: <200811190825.mAJ8PvV9010471@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752143AbYKSI0M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Nov 2008 03:26:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com, menage@google.com, stable@kernel.org


The patch titled
     cgroups: fix a serious bug in cgroupstats
has been added to the -mm tree.  Its filename is
     cgroups-fix-a-serious-bug-in-cgroupstats.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: fix a serious bug in cgroupstats
From: Li Zefan <lizf@cn.fujitsu.com>

Try this, and you'll get oops immediately:
 # cd Documentation/accounting/
 # gcc -o getdelays getdelays.c
 # mount -t cgroup -o debug xxx /mnt
 # ./getdelays -C /mnt/tasks

Because a normal file's dentry->d_fsdata is a pointer to struct cftype,
not struct cgroup.

After the patch, it returns EINVAL if we try to get cgroupstats
from a normal file.

Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x, 2.6.27.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN kernel/cgroup.c~cgroups-fix-a-serious-bug-in-cgroupstats kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-fix-a-serious-bug-in-cgroupstats
+++ a/kernel/cgroup.c
@@ -2039,10 +2039,13 @@ int cgroupstats_build(struct cgroupstats
 	struct cgroup *cgrp;
 	struct cgroup_iter it;
 	struct task_struct *tsk;
+
 	/*
-	 * Validate dentry by checking the superblock operations
+	 * Validate dentry by checking the superblock operations,
+	 * and make sure it's a directory.
 	 */
-	if (dentry->d_sb->s_op != &cgroup_ops)
+	if (dentry->d_sb->s_op != &cgroup_ops ||
+	    !S_ISDIR(dentry->d_inode->i_mode))
 		 goto err;
 
 	ret = 0;
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

cgroup-fix-potential-deadlock-in-pre_destroy-v2.patch
cpuset-fix-regression-when-failed-to-generate-sched-domains.patch
cgroups-fix-a-serious-bug-in-cgroupstats.patch
linux-next.patch
memcg-memory-hotplug-fix-for-notifier-callback.patch
memcg-reduce-size-of-mem_cgroup-by-using-nr_cpu_ids.patch
memcg-new-force_empty-to-free-pages-under-group.patch
memcg-handle-swap-caches.patch
memcg-memswap-controller-kconfig.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-swap-cgroup-for-remembering-usage-fix.patch
memcg-swap-cgroup-for-remembering-usage-fix-2.patch
memcg-swap-cgroup-for-remembering-usage-fix-3.patch
memcg-swap-cgroup-for-remembering-usage-fix-4.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-synchronized-lru.patch
memcg-add-mem_cgroup_disabled.patch
memcg-add-mem_cgroup_disabled-fix.patch
memory-cgroup-hierarchy-documentation-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memory-cgroup-hierarchy-feature-selector-v4.patch

