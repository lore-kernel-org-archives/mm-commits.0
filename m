From: akpm@linux-foundation.org
Subject: [merged]
 inotify-extend-ioctl-to-allow-to-request-id-of-new-watch-descriptor.patch
 removed from -mm tree
Date: Thu, 15 Feb 2018 12:10:15 -0800
Message-ID: <20180215201015.PUnPeiI5Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38942 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751878AbeBOUKQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Feb 2018 15:10:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, amir73il@gmail.com, gorcunov@openvz.org, jack@suse.cz, ktkhai@virtuozzo.com, mawilcox@microsoft.com, mm-commits@vger.kernel.org


The patch titled
     Subject: inotify: extend ioctl to allow to request id of new watch descriptor
has been removed from the -mm tree.  Its filename was
     inotify-extend-ioctl-to-allow-to-request-id-of-new-watch-descriptor.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: inotify: extend ioctl to allow to request id of new watch descriptor

Watch descriptor is id of the watch created by inotify_add_watch().  It is
allocated in inotify_add_to_idr(), and takes the numbers starting from 1. 
Every new inotify watch obtains next available number (usually, old + 1),
as served by idr_alloc_cyclic().

CRIU (Checkpoint/Restore In Userspace) project supports inotify files, and
restores watched descriptors with the same numbers they had before dump. 
Since there was no kernel support, we had to use cycle to add a watch with
specific descriptor id:

	while (1) {
		int wd;

		wd = inotify_add_watch(inotify_fd, path, mask);
		if (wd < 0) {
			break;
		} else if (wd == desired_wd_id) {
			ret = 0;
			break;
		}

		inotify_rm_watch(inotify_fd, wd);
	}

(You may find the actual code at the below link:
 https://github.com/checkpoint-restore/criu/blob/v3.7/criu/fsnotify.c#L577)

The cycle is suboptiomal and very expensive, but since there is no better
kernel support, it was the only way to restore that.  Happily, we had met
mostly descriptors with small id, and this approach had worked somehow.

But recent time containers with inotify with big watch descriptors began
to come, and this way stopped to work at all.  When descriptor id is
something about 0x34d71d6, the restoring process spins in busy loop for a
long time, and the restore hangs and delay of migration from node to node
could easily be observed.

This patch aims to solve this problem.  It introduces new ioctl
INOTIFY_IOC_SETNEXTWD, which allows to request the number of next created
watch descriptor from userspace.  It simply calls idr_set_cursor()
primitive to populate idr::idr_next, so that next idr_alloc_cyclic()
allocation will return this id, if it is not occupied.  This is the way
which is used to restore some other resources from userspace.  For
example, /proc/sys/kernel/ns_last_pid works the same for task pids.

The new code is under CONFIG_CHECKPOINT_RESTORE #define, so small system
may exclude it.

Link: http://lkml.kernel.org/r/ca006760-de72-37b3-f6fd-311c86f29b62@virtuozzo.com
Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>
Reviewed-by: Matthew Wilcox <mawilcox@microsoft.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/inotify/inotify_user.c |   13 +++++++++++++
 include/uapi/linux/inotify.h     |    8 ++++++++
 2 files changed, 21 insertions(+)

diff -puN fs/notify/inotify/inotify_user.c~inotify-extend-ioctl-to-allow-to-request-id-of-new-watch-descriptor fs/notify/inotify/inotify_user.c
--- a/fs/notify/inotify/inotify_user.c~inotify-extend-ioctl-to-allow-to-request-id-of-new-watch-descriptor
+++ a/fs/notify/inotify/inotify_user.c
@@ -285,6 +285,7 @@ static int inotify_release(struct inode
 static long inotify_ioctl(struct file *file, unsigned int cmd,
 			  unsigned long arg)
 {
+	struct inotify_group_private_data *data __maybe_unused;
 	struct fsnotify_group *group;
 	struct fsnotify_event *fsn_event;
 	void __user *p;
@@ -293,6 +294,7 @@ static long inotify_ioctl(struct file *f
 
 	group = file->private_data;
 	p = (void __user *) arg;
+	data = &group->inotify_data;
 
 	pr_debug("%s: group=%p cmd=%u\n", __func__, group, cmd);
 
@@ -307,6 +309,17 @@ static long inotify_ioctl(struct file *f
 		spin_unlock(&group->notification_lock);
 		ret = put_user(send_len, (int __user *) p);
 		break;
+#ifdef CONFIG_CHECKPOINT_RESTORE
+	case INOTIFY_IOC_SETNEXTWD:
+		ret = -EINVAL;
+		if (arg >= 1 && arg <= INT_MAX) {
+			spin_lock(&data->idr_lock);
+			idr_set_cursor(&data->idr, (unsigned int)arg);
+			spin_unlock(&data->idr_lock);
+			ret = 0;
+		}
+		break;
+#endif /* CONFIG_CHECKPOINT_RESTORE */
 	}
 
 	return ret;
diff -puN include/uapi/linux/inotify.h~inotify-extend-ioctl-to-allow-to-request-id-of-new-watch-descriptor include/uapi/linux/inotify.h
--- a/include/uapi/linux/inotify.h~inotify-extend-ioctl-to-allow-to-request-id-of-new-watch-descriptor
+++ a/include/uapi/linux/inotify.h
@@ -71,5 +71,13 @@ struct inotify_event {
 #define IN_CLOEXEC O_CLOEXEC
 #define IN_NONBLOCK O_NONBLOCK
 
+/*
+ * ioctl numbers: inotify uses 'I' prefix for all ioctls,
+ * except historical FIONREAD, which is based on 'T'.
+ *
+ * INOTIFY_IOC_SETNEXTWD: set desired number of next created
+ * watch descriptor.
+ */
+#define INOTIFY_IOC_SETNEXTWD	_IOW('I', 0, __s32)
 
 #endif /* _UAPI_LINUX_INOTIFY_H */
_

Patches currently in -mm which might be from ktkhai@virtuozzo.com are

mm-make-count-list_lru_one-nr_items-lockless.patch

