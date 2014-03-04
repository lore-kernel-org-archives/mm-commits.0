From: akpm@linux-foundation.org
Subject: + fanotify-reorganize-loop-in-fanotify_read.patch added to -mm
 tree
Date: Tue, 04 Mar 2014 13:12:03 -0800
Message-ID: <531641a3.VrlGgm1eS+W+9wWj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42166 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932828AbaCDVME (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 16:12:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, eparis@redhat.com, jack@suse.cz

Subject: + fanotify-reorganize-loop-in-fanotify_read.patch added to -mm tree
To: jack@suse.cz,eparis@redhat.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 13:12:03 -0800


The patch titled
     Subject: fanotify: reorganize loop in fanotify_read()
has been added to the -mm tree.  Its filename is
     fanotify-reorganize-loop-in-fanotify_read.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fanotify-reorganize-loop-in-fanotify_read.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fanotify-reorganize-loop-in-fanotify_read.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: fanotify: reorganize loop in fanotify_read()

Swap the error / "read ok" branches in the main loop of fanotify_read(). 
We will grow the "read ok" part in the next patch and this makes the
indentation easier.  Also it is more common to have error conditions
inside an 'if' instead of the fast path.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify_user.c |   46 ++++++++++++++-------------
 1 file changed, 24 insertions(+), 22 deletions(-)

diff -puN fs/notify/fanotify/fanotify_user.c~fanotify-reorganize-loop-in-fanotify_read fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fanotify-reorganize-loop-in-fanotify_read
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -272,35 +272,37 @@ static ssize_t fanotify_read(struct file
 		kevent = get_one_event(group, count);
 		mutex_unlock(&group->notification_mutex);
 
-		if (kevent) {
+		if (IS_ERR(kevent)) {
 			ret = PTR_ERR(kevent);
-			if (IS_ERR(kevent))
+			break;
+		}
+
+		if (!kevent) {
+			ret = -EAGAIN;
+			if (file->f_flags & O_NONBLOCK)
+				break;
+
+			ret = -ERESTARTSYS;
+			if (signal_pending(current))
 				break;
-			ret = copy_event_to_user(group, kevent, buf);
-			/*
-			 * Permission events get queued to wait for response.
-			 * Other events can be destroyed now.
-			 */
-			if (!(kevent->mask & FAN_ALL_PERM_EVENTS))
-				fsnotify_destroy_event(group, kevent);
-			if (ret < 0)
+
+			if (start != buf)
 				break;
-			buf += ret;
-			count -= ret;
+			schedule();
 			continue;
 		}
 
-		ret = -EAGAIN;
-		if (file->f_flags & O_NONBLOCK)
-			break;
-		ret = -ERESTARTSYS;
-		if (signal_pending(current))
+		ret = copy_event_to_user(group, kevent, buf);
+		/*
+		 * Permission events get queued to wait for response.  Other
+		 * events can be destroyed now.
+		 */
+		if (!(kevent->mask & FAN_ALL_PERM_EVENTS))
+			fsnotify_destroy_event(group, kevent);
+		if (ret < 0)
 			break;
-
-		if (start != buf)
-			break;
-
-		schedule();
+		buf += ret;
+		count -= ret;
 	}
 
 	finish_wait(&group->notification_waitq, &wait);
_

Patches currently in -mm which might be from jack@suse.cz are

ocfs2-fix-quota-file-corruption.patch
backing_dev-fix-hung-task-on-sync.patch
kthread-ensure-locality-of-task_struct-allocations.patch
fanotify-remove-useless-bypass_perm-check.patch
fanotify-use-fanotify-event-structure-for-permission-response-processing.patch
fanotify-convert-access_mutex-to-spinlock.patch
fanotify-reorganize-loop-in-fanotify_read.patch
fanotify-move-unrelated-handling-from-copy_event_to_user.patch
ocfs2-remove-ocfs2_inode_skip_delete-flag.patch
ocfs2-move-dquot_initialize-in-ocfs2_delete_inode-somewhat-later.patch
quota-provide-function-to-grab-quota-structure-reference.patch
ocfs2-implement-delayed-dropping-of-last-dquot-reference.patch
ocfs2-avoid-blocking-in-ocfs2_mark_lockres_freeing-in-downconvert-thread.patch
ocfs2-revert-iput-deferring-code-in-ocfs2_drop_dentry_lock.patch
mm-vmstat-fix-up-zone-state-accounting.patch
fs-cachefiles-use-add_to_page_cache_lru.patch
lib-radix-tree-radix_tree_delete_item.patch
mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages.patch
mm-filemap-move-radix-tree-hole-searching-here.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch
mm-fs-store-shadow-entries-in-page-cache.patch
mm-thrash-detection-based-file-cache-sizing.patch
lib-radix_tree-tree-node-interface.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch
mm-readaheadc-fix-readahead-failure-for-memoryless-numa-nodes-and-limit-readahead-pages.patch
printk-remove-duplicated-check-for-log-level.patch
printk-remove-obsolete-check-for-log-level-c.patch
printk-add-comment-about-tricky-check-for-text-buffer-size.patch
printk-use-also-the-last-bytes-in-the-ring-buffer.patch
printk-do-not-compute-the-size-of-the-message-twice.patch
linux-next.patch
mm-add-strictlimit-knob-v2.patch

