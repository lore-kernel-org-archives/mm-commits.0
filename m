From: akpm@linux-foundation.org
Subject: [wrecked] fsnotify-parent-event-notification-dont-slow-everything-down.patch removed from -mm tree
Date: Tue, 26 May 2009 12:34:15 -0700
Message-ID: <200905261934.n4QJYF73005449@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756751AbZEZTeo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 15:34:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, eparis@redhat.com, mm-commits@vger.kernel.org


The patch titled
     fsnotify: don't slow everything down
has been removed from the -mm tree.  Its filename was
     fsnotify-parent-event-notification-dont-slow-everything-down.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fsnotify: don't slow everything down
From: Hugh Dickins <hugh@veritas.com>

Two little fixes to mmotm's fsnotify-parent-event-notification.patch:

Why is copying or building a kernel tree using twice as much system time
as before?  Lots of time spent in __fsnotify_update_child_dentry_flags()
when it shouldn't even get called.  Fix | to & in __fsnotify_parent().

And it's probably a bad idea to have DCACHE_FSNOTIFY_PARENT_WATCHED
sharing the same d_flags bit as DCACHE_COOKIE: though the COOKIE bit has
prior claim, change it to keep the NOTIFY_PARENT_WATCHED bits together.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fsnotify.c   |    2 +-
 include/linux/dcache.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/notify/fsnotify.c~fsnotify-parent-event-notification-dont-slow-everything-down fs/notify/fsnotify.c
--- a/fs/notify/fsnotify.c~fsnotify-parent-event-notification-dont-slow-everything-down
+++ a/fs/notify/fsnotify.c
@@ -84,7 +84,7 @@ void __fsnotify_parent(struct dentry *de
 	bool send = false;
 	bool should_update_children = false;
 
-	if (!(dentry->d_flags | DCACHE_FSNOTIFY_PARENT_WATCHED))
+	if (!(dentry->d_flags & DCACHE_FSNOTIFY_PARENT_WATCHED))
 		return;
 
 	spin_lock(&dentry->d_lock);
diff -puN include/linux/dcache.h~fsnotify-parent-event-notification-dont-slow-everything-down include/linux/dcache.h
--- a/include/linux/dcache.h~fsnotify-parent-event-notification-dont-slow-everything-down
+++ a/include/linux/dcache.h
@@ -183,7 +183,7 @@ d_iput:		no		no		no       yes
 #define DCACHE_INOTIFY_PARENT_WATCHED	0x0020 /* Parent inode is watched by inotify */
 #define DCACHE_FSNOTIFY_PARENT_WATCHED	0x0040 /* Parent inode is watched by some fsnotify listener */
 
-#define DCACHE_COOKIE		0x0040	/* For use by dcookie subsystem */
+#define DCACHE_COOKIE		0x0080	/* For use by dcookie subsystem */
 
 extern spinlock_t dcache_lock;
 extern seqlock_t rename_lock;
_

Patches currently in -mm which might be from hugh@veritas.com are

mm-disable-preemption-in-apply_to_pte_range.patch
ksm-mmu_notifiers-add-set_pte_at_notify.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-page_wrprotect-write-protecting-page.patch
ksm-add-replace_page-change-the-page-pte-is-pointing-to.patch
ksm-add-ksm-kernel-shared-memory-driver.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
ksm-add-ksm-kernel-shared-memory-driver-fix-unsafe-pte-fetching.patch
ksm-add-ksm-kernel-shared-memory-driver-limiting-the-num-of-mem-regions-user-can-register-per-fd.patch
ksm-add-ksm-kernel-shared-memory-driver-dont-allow-overlap-memory-addresses-registrations.patch
ksm-add-ksm-kernel-shared-memory-driver-change-the-ksm_remove_memory_region-ioctl.patch
ksm-add-ksm-kernel-shared-memory-driver-change-the-prot-handling-to-use-the-generic-helper-functions.patch
ksm-add-ksm-kernel-shared-memory-driver-use-another-miscdevice-minor-number.patch
mm-alloc_large_system_hash-check-order.patch
page-allocator-update-nr_free_pages-only-as-necessary-fix.patch
mm-use-alloc_pages_exact-in-alloc_large_system_hash-to-avoid-duplicated-logic.patch
mm-introduce-follow_pte.patch
mm-use-generic-follow_pte-in-follow_phys.patch
mm-introduce-follow_pfn.patch
migration-only-migrate_prep-once-per-move_pages.patch
getrusage-fill-ru_maxrss-value.patch
memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch
fsnotify-parent-event-notification-dont-slow-everything-down.patch
prio_tree-debugging-patch.patch

