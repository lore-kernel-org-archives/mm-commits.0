From: akpm@linux-foundation.org
Subject: + cgroups-fix-possible-use-after-free.patch added to -mm tree
Date: Wed, 11 Feb 2009 14:02:07 -0800
Message-ID: <200902112202.n1BM27CK015458@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42841 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756552AbZBKWCe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 17:02:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, menage@google.com, viro@ZenIV.linux.org.uk


The patch titled
     cgroups: fix possible use after free
has been added to the -mm tree.  Its filename is
     cgroups-fix-possible-use-after-free.patch

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
@@ -1123,8 +1123,8 @@ static void cgroup_kill_sb(struct super_
 
 	mutex_unlock(&cgroup_mutex);
 
-	kfree(root);
 	kill_litter_super(sb);
+	kfree(root);
 }
 
 static struct file_system_type cgroup_fs_type = {
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

cgroups-add-li-zefan-as-a-maintainer.patch
cgroups-fix-lockdep-subclasses-overflow.patch
linux-next.patch
cgroups-fix-possible-use-after-free.patch
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

