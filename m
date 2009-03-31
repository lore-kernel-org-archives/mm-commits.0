From: akpm@linux-foundation.org
Subject: [folded] memdup_user-introduce-fix.patch removed from -mm tree
Date: Tue, 31 Mar 2009 14:56:08 -0700
Message-ID: <200903312156.n2VLu8Xw014472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44105 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757629AbZCaV7o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Mar 2009 17:59:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, adobriyan@gmail.com, kosaki.motohiro@jp.fujitsu.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     memdup_user: introduce, fix
has been removed from the -mm tree.  Its filename was
     memdup_user-introduce-fix.patch

This patch was dropped because it was folded into memdup_user-introduce.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memdup_user: introduce, fix
From: Li Zefan <lizf@cn.fujitsu.com>

Always use GFP_KERNEL in kmalloc(), since copy_from_user() can sleep and
cause pagefault, thus it's pointless to use GFP_NOFS or GFP_ATOMIC here.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Americo Wang <xiyou.wangcong@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string.h |    2 +-
 mm/util.c              |   10 +++++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff -puN include/linux/string.h~memdup_user-introduce-fix include/linux/string.h
--- a/include/linux/string.h~memdup_user-introduce-fix
+++ a/include/linux/string.h
@@ -12,7 +12,7 @@
 #include <linux/stddef.h>	/* for NULL */
 
 extern char *strndup_user(const char __user *, long);
-extern void *memdup_user(const void __user *, size_t, gfp_t);
+extern void *memdup_user(const void __user *, size_t);
 
 /*
  * Include machine specific inline routines
diff -puN mm/util.c~memdup_user-introduce-fix mm/util.c
--- a/mm/util.c~memdup_user-introduce-fix
+++ a/mm/util.c
@@ -74,15 +74,19 @@ EXPORT_SYMBOL(kmemdup);
  *
  * @src: source address in user space
  * @len: number of bytes to copy
- * @gfp: GFP mask to use
  *
  * Returns an ERR_PTR() on failure.
  */
-void *memdup_user(const void __user *src, size_t len, gfp_t gfp)
+void *memdup_user(const void __user *src, size_t len)
 {
 	void *p;
 
-	p = kmalloc_track_caller(len, gfp);
+	/*
+	 * Always use GFP_KERNEL, since copy_from_user() can sleep and
+	 * cause pagefault, which makes it pointless to use GFP_NOFS
+	 * or GFP_ATOMIC.
+	 */
+	p = kmalloc_track_caller(len, GFP_KERNEL);
 	if (!p)
 		return ERR_PTR(-ENOMEM);
 
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
memdup_user-introduce.patch
memdup_user-introduce-fix.patch
linux-next.patch
cls_cgroup-remove-unneeded-cgroup_lock.patch
relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch
cgroup-css-id-support.patch
cgroup-css-id-support-remove-rcu_read_lock-from-css_get_next.patch
cgroup-fix-frequent-ebusy-at-rmdir.patch
cgroups-more-documentation-for-remount-and-release_agent.patch
cgroups-show-correct-file-mode.patch
cgroups-show-correct-file-mode-fix.patch
cgroups-dont-change-release_agent-when-remount-failed.patch
debug-cgroup-remove-unneeded-cgroup_lock.patch
devcgroup-avoid-using-cgroup_lock.patch
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
cgroups-use-css-id-in-swap-cgroup-for-saving-memory-v5-fix.patch
cpuset-fix-possible-races-in-cpu-memory-hotplug.patch
cgroups-add-data-field-to-struct-cgroup_scanner.patch
cpuset-rewrite-update_tasks_nodemask.patch
cpuset-avoid-changing-cpusets-mems-when-errno-returned.patch
cpuset-remove-struct-cpuset_hotplug_scanner.patch
cpusets-allow-cpusets-to-be-configured-built-on-non-smp-systems.patch

