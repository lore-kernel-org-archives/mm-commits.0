From: akpm@linux-foundation.org
Subject: + fanotify-remove-useless-bypass_perm-check.patch added to -mm
 tree
Date: Tue, 04 Mar 2014 13:11:59 -0800
Message-ID: <5316419f.KsLyU6aQRBMjj2nU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42153 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932806AbaCDVMA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 16:12:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, eparis@redhat.com, jack@suse.cz

Subject: + fanotify-remove-useless-bypass_perm-check.patch added to -mm tree
To: jack@suse.cz,eparis@redhat.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 13:11:59 -0800


The patch titled
     Subject: fanotify: remove useless bypass_perm check
has been added to the -mm tree.  Its filename is
     fanotify-remove-useless-bypass_perm-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fanotify-remove-useless-bypass_perm-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fanotify-remove-useless-bypass_perm-check.patch

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
Subject: fanotify: remove useless bypass_perm check

prepare_for_access_response() checks whether
group->fanotify_data.bypass_perm is set.  However this test can never be
true because prepare_for_access_response() is called only from
fanotify_read() which means fanotify group is alive with an active fd
while bypass_perm is set from fanotify_release() when all file descriptors
pointing to the group are closed and the group is going away.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify_user.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN fs/notify/fanotify/fanotify_user.c~fanotify-remove-useless-bypass_perm-check fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fanotify-remove-useless-bypass_perm-check
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -211,14 +211,6 @@ static int prepare_for_access_response(s
 	re->fd = fd;
 
 	mutex_lock(&group->fanotify_data.access_mutex);
-
-	if (atomic_read(&group->fanotify_data.bypass_perm)) {
-		mutex_unlock(&group->fanotify_data.access_mutex);
-		kmem_cache_free(fanotify_response_event_cache, re);
-		FANOTIFY_E(event)->response = FAN_ALLOW;
-		return 0;
-	}
-		
 	list_add_tail(&re->list, &group->fanotify_data.access_list);
 	mutex_unlock(&group->fanotify_data.access_mutex);
 
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

