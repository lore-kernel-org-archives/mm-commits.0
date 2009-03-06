From: akpm@linux-foundation.org
Subject: + memdup_user-introduce.patch added to -mm tree
Date: Fri, 06 Mar 2009 15:03:39 -0800
Message-ID: <200903062303.n26N3dO4009647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48034 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757476AbZCFXES (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 18:04:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, adobriyan@gmail.com, kosaki.motohiro@jp.fujitsu.com, xiyou.wangcong@gmail.com


The patch titled
     memdup_user(): introduce
has been added to the -mm tree.  Its filename is
     memdup_user-introduce.patch

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
Subject: memdup_user(): introduce
From: Li Zefan <lizf@cn.fujitsu.com>

I notice there are many places doing copy_from_user() which follows
kmalloc():

        dst = kmalloc(len, GFP_KERNEL);
        if (!dst)
                return -ENOMEM;
        if (copy_from_user(dst, src, len)) {
		kfree(dst);
		return -EFAULT
	}

memdup_user() is a wrapper of the above code.  With this new function, we
don't have to write 'len' twice, which can lead to typos/mistakes.  It
also produces smaller code and kernel text.

A quick grep shows 250+ places where memdup_user() *may* be used.  I'll
prepare a patchset to do this conversion.

v1 -> v2: change the name from kmemdup_from_user to memdup_user.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Americo Wang <xiyou.wangcong@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string.h |    1 +
 mm/util.c              |   26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff -puN include/linux/string.h~memdup_user-introduce include/linux/string.h
--- a/include/linux/string.h~memdup_user-introduce
+++ a/include/linux/string.h
@@ -12,6 +12,7 @@
 #include <linux/stddef.h>	/* for NULL */
 
 extern char *strndup_user(const char __user *, long);
+extern void *memdup_user(const void __user *, size_t, gfp_t);
 
 /*
  * Include machine specific inline routines
diff -puN mm/util.c~memdup_user-introduce mm/util.c
--- a/mm/util.c~memdup_user-introduce
+++ a/mm/util.c
@@ -70,6 +70,32 @@ void *kmemdup(const void *src, size_t le
 EXPORT_SYMBOL(kmemdup);
 
 /**
+ * memdup_user - duplicate memory region from user space
+ *
+ * @src: source address in user space
+ * @len: number of bytes to copy
+ * @gfp: GFP mask to use
+ *
+ * Returns an ERR_PTR() on failure.
+ */
+void *memdup_user(const void __user *src, size_t len, gfp_t gfp)
+{
+	void *p;
+
+	p = kmalloc_track_caller(len, gfp);
+	if (!p)
+		return ERR_PTR(-ENOMEM);
+
+	if (copy_from_user(p, src, len)) {
+		kfree(p);
+		return ERR_PTR(-EFAULT);
+	}
+
+	return p;
+}
+EXPORT_SYMBOL(memdup_user);
+
+/**
  * __krealloc - like krealloc() but don't free @p.
  * @p: object to reallocate memory for.
  * @new_size: how many bytes of memory are required.
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

linux-next.patch
vfs-add-missing-unlock-in-sget.patch
memdup_user-introduce.patch
relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch
cgroup-css-id-support.patch
cgroup-css-id-support-remove-rcu_read_lock-from-css_get_next.patch
cgroup-fix-frequent-ebusy-at-rmdir.patch
cgroups-more-documentation-for-remount-and-release_agent.patch
cgroups-show-correct-file-mode.patch
cgroups-show-correct-file-mode-fix.patch
cgroups-dont-change-release_agent-when-remount-failed.patch
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
use-css-id-in-swap_cgroup-for-saving-memory-v4.patch
cpuset-fix-possible-races-in-cpu-memory-hotplug.patch
cgroups-add-data-field-to-struct-cgroup_scanner.patch
cpuset-rewrite-update_tasks_nodemask.patch
cpuset-avoid-changing-cpusets-mems-when-errno-returned.patch
cpuset-remove-struct-cpuset_hotplug_scanner.patch
cpusets-allow-cpusets-to-be-configured-built-on-non-smp-systems.patch

