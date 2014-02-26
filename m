From: akpm@linux-foundation.org
Subject: [wrecked]
 fanotify-remove-useless-test-from-event-initialization.patch removed from
 -mm tree
Date: Wed, 26 Feb 2014 12:48:35 -0800
Message-ID: <530e5323.s8w4YZEDxWHU15PU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52097 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825AbaBZUsg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Feb 2014 15:48:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, eparis@redhat.com, jack@suse.cz

Subject: [wrecked] fanotify-remove-useless-test-from-event-initialization.patch removed from -mm tree
To: jack@suse.cz,eparis@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 26 Feb 2014 12:48:35 -0800


The patch titled
     Subject: fanotify: remove useless test from event initialization
has been removed from the -mm tree.  Its filename was
     fanotify-remove-useless-test-from-event-initialization.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: fanotify: remove useless test from event initialization

Fanotify processes only path events (fanotify_should_send_event() refuses
any other event) so checking whether event is a path event during
initialization makes no sense.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN fs/notify/fanotify/fanotify.c~fanotify-remove-useless-test-from-event-initialization fs/notify/fanotify/fanotify.c
--- a/fs/notify/fanotify/fanotify.c~fanotify-remove-useless-test-from-event-initialization
+++ a/fs/notify/fanotify/fanotify.c
@@ -166,13 +166,8 @@ static struct fanotify_event_info *alloc
 init: __maybe_unused
 	fsnotify_init_event(&event->fse, inode, mask);
 	event->tgid = get_pid(task_tgid(current));
-	if (data_type == FSNOTIFY_EVENT_PATH) {
-		event->path = *path;
-		path_get(&event->path);
-	} else {
-		event->path.mnt = NULL;
-		event->path.dentry = NULL;
-	}
+	event->path = *path;
+	path_get(&event->path);
 	return event;
 }
 
_

Patches currently in -mm which might be from jack@suse.cz are

ocfs2-fix-quota-file-corruption.patch
backing_dev-fix-hung-task-on-sync.patch
kthread-ensure-locality-of-task_struct-allocations.patch
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
fanotify-convert-access_mutex-to-spinlock.patch
fanotify-reorganize-loop-in-fanotify_read.patch
fanotify-move-unrelated-handling-from-copy_event_to_user.patch
mm-add-strictlimit-knob-v2.patch

