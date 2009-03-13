From: akpm@linux-foundation.org
Subject: [merged] vfs-add-missing-unlock-in-sget.patch removed from -mm tree
Date: Fri, 13 Mar 2009 11:19:27 -0700
Message-ID: <200903131819.n2DIJRCc008586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754781AbZCMSW4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Mar 2009 14:22:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, a.p.zijlstra@chello.nl, menage@google.com, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: add missing unlock in sget()
has been removed from the -mm tree.  Its filename was
     vfs-add-missing-unlock-in-sget.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: add missing unlock in sget()
From: Li Zefan <lizf@cn.fujitsu.com>

In sget(), destroy_super(s) is called with s->s_umount held, which makes
lockdep unhappy.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/super.c~vfs-add-missing-unlock-in-sget fs/super.c
--- a/fs/super.c~vfs-add-missing-unlock-in-sget
+++ a/fs/super.c
@@ -371,8 +371,10 @@ retry:
 				continue;
 			if (!grab_super(old))
 				goto retry;
-			if (s)
+			if (s) {
+				up_write(&s->s_umount);
 				destroy_super(s);
+			}
 			return old;
 		}
 	}
@@ -387,6 +389,7 @@ retry:
 	err = set(s, data);
 	if (err) {
 		spin_unlock(&sb_lock);
+		up_write(&s->s_umount);
 		destroy_super(s);
 		return ERR_PTR(err);
 	}
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch
cls_cgroup-remove-unneeded-cgroup_lock.patch
memdup_user-introduce.patch
memdup_user-introduce-fix.patch
relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch
cgroup-css-id-support.patch
cgroup-css-id-support-remove-rcu_read_lock-from-css_get_next.patch
cgroup-fix-frequent-ebusy-at-rmdir.patch
cgroups-more-documentation-for-remount-and-release_agent.patch
cgroups-show-correct-file-mode.patch
cgroups-show-correct-file-mode-fix.patch
cgroups-dont-change-release_agent-when-remount-failed.patch
debug-cgroup-remove-unneeded-cgroup_lock.patch
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
memcg-charge-swapcache-to-proper-memcg.patch
cgroups-use-css-id-in-swap-cgroup-for-saving-memory-v5.patch
cpuset-fix-possible-races-in-cpu-memory-hotplug.patch
cgroups-add-data-field-to-struct-cgroup_scanner.patch
cpuset-rewrite-update_tasks_nodemask.patch
cpuset-avoid-changing-cpusets-mems-when-errno-returned.patch
cpuset-remove-struct-cpuset_hotplug_scanner.patch
cpusets-allow-cpusets-to-be-configured-built-on-non-smp-systems.patch

