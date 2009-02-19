From: akpm@linux-foundation.org
Subject: [merged] cgroups-fix-possible-use-after-free.patch removed from -mm tree
Date: Thu, 19 Feb 2009 11:16:40 -0800
Message-ID: <200902191916.n1JJGehp016273@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752984AbZBSTQt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 14:16:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, menage@google.com, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     cgroups: fix possible use after free
has been removed from the -mm tree.  Its filename was
     cgroups-fix-possible-use-after-free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: fix possible use after free
From: Li Zefan <lizf@cn.fujitsu.com>

In cgroup_kill_sb(), root is freed before sb is detached from the list, so
another sget() may find this sb and call cgroup_test_super(), which will
access the root that has been freed.

Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/cgroup.c~cgroups-fix-possible-use-after-free kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-fix-possible-use-after-free
+++ a/kernel/cgroup.c
@@ -1122,8 +1122,8 @@ static void cgroup_kill_sb(struct super_
 
 	mutex_unlock(&cgroup_mutex);
 
-	kfree(root);
 	kill_litter_super(sb);
+	kfree(root);
 }
 
 static struct file_system_type cgroup_fs_type = {
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch
vfs-add-missing-unlock-in-sget.patch
relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch
cgroup-css-id-support.patch
cgroup-fix-frequent-ebusy-at-rmdir.patch
memcg-use-css-id.patch
memcg-hierarchical-stat.patch
memcg-fix-shrinking-memory-to-return-ebusy-by-fixing-retry-algorithm.patch
memcg-fix-oom-killer-under-memcg.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
cpuset-fix-possible-races-in-cpu-memory-hotplug.patch

