From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?inotify-extend-ioctl-to-allow-to-request-id-of-new-watch-?=
 =?US-ASCII?Q?descriptor-fix.patch?= removed from -mm tree
Date: Thu, 15 Feb 2018 12:10:18 -0800
Message-ID: <20180215201018.ZK1AOrKSe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38960 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751878AbeBOUKT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Feb 2018 15:10:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, amir73il@gmail.com, gorcunov@openvz.org, jack@suse.cz, ktkhai@virtuozzo.com, mawilcox@microsoft.com, mm-commits@vger.kernel.org


The patch titled
     Subject: inotify-extend-ioctl-to-allow-to-request-id-of-new-watch-descriptor-fix
has been removed from the -mm tree.  Its filename was
     inotify-extend-ioctl-to-allow-to-request-id-of-new-watch-descriptor-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: inotify-extend-ioctl-to-allow-to-request-id-of-new-watch-descriptor-fix

cleanup

Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/inotify/inotify_user.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/notify/inotify/inotify_user.c~inotify-extend-ioctl-to-allow-to-request-id-of-new-watch-descriptor-fix fs/notify/inotify/inotify_user.c
--- a/fs/notify/inotify/inotify_user.c~inotify-extend-ioctl-to-allow-to-request-id-of-new-watch-descriptor-fix
+++ a/fs/notify/inotify/inotify_user.c
@@ -285,7 +285,6 @@ static int inotify_release(struct inode
 static long inotify_ioctl(struct file *file, unsigned int cmd,
 			  unsigned long arg)
 {
-	struct inotify_group_private_data *data __maybe_unused;
 	struct fsnotify_group *group;
 	struct fsnotify_event *fsn_event;
 	void __user *p;
@@ -294,7 +293,6 @@ static long inotify_ioctl(struct file *f
 
 	group = file->private_data;
 	p = (void __user *) arg;
-	data = &group->inotify_data;
 
 	pr_debug("%s: group=%p cmd=%u\n", __func__, group, cmd);
 
@@ -313,6 +311,9 @@ static long inotify_ioctl(struct file *f
 	case INOTIFY_IOC_SETNEXTWD:
 		ret = -EINVAL;
 		if (arg >= 1 && arg <= INT_MAX) {
+			struct inotify_group_private_data *data;
+
+			data = &group->inotify_data;
 			spin_lock(&data->idr_lock);
 			idr_set_cursor(&data->idr, (unsigned int)arg);
 			spin_unlock(&data->idr_lock);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
include-linux-sched-mmh-re-inline-mmdrop.patch
mm-zpool-zpool_evictable-fix-mismatch-in-parameter-name-and-kernel-doc-fix.patch
vmalloc-fix-__gfp_highmem-usage-for-vmalloc_32-on-32b-systems-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

