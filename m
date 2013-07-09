From: akpm@linux-foundation.org
Subject: [merged] fanotify-fix-races-when-adding-removing-marks.patch
 removed from -mm tree
Date: Tue, 09 Jul 2013 16:19:10 -0700
Message-ID: <51dc9a6e.W08GuTF1ywT+pnoi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38770 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab3GIXTL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:19:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, eparis@redhat.com, LinoSanfilippo@gmx.de

Subject: [merged] fanotify-fix-races-when-adding-removing-marks.patch removed from -mm tree
To: LinoSanfilippo@gmx.de,eparis@redhat.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:19:10 -0700


The patch titled
     Subject: fanotify: fix races when adding/removing marks
has been removed from the -mm tree.  Its filename was
     fanotify-fix-races-when-adding-removing-marks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: fanotify: fix races when adding/removing marks

For both adding an event to an existing mark and destroying a mark we
first have to find it via fsnotify_find_[inode|vfsmount]_mark().  But
getting the mark and adding an event (or destroying it) is not done
atomically.  This opens a race where a thread is about to destroy a mark
while another thread still finds the same mark and adds an event to its
mask although it will be destroyed.

Another race exists concerning the excess of a groups number of marks
limit: When a mark is added the number of group marks is checked against
the max number of marks per group and increased afterwards.  Since check
and increment is also not done atomically, this may result in 2 or more
processes passing the check at the same time and increasing the number of
group marks above the allowed limit.

With this patch both races are avoided by doing the concerning operations
with the groups mark mutex locked.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify_user.c |   49 ++++++++++++++++++++-------
 1 file changed, 37 insertions(+), 12 deletions(-)

diff -puN fs/notify/fanotify/fanotify_user.c~fanotify-fix-races-when-adding-removing-marks fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fanotify-fix-races-when-adding-removing-marks
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -524,14 +524,18 @@ static int fanotify_remove_vfsmount_mark
 	__u32 removed;
 	int destroy_mark;
 
+	mutex_lock(&group->mark_mutex);
 	fsn_mark = fsnotify_find_vfsmount_mark(group, mnt);
-	if (!fsn_mark)
+	if (!fsn_mark) {
+		mutex_unlock(&group->mark_mutex);
 		return -ENOENT;
+	}
 
 	removed = fanotify_mark_remove_from_mask(fsn_mark, mask, flags,
 						 &destroy_mark);
 	if (destroy_mark)
-		fsnotify_destroy_mark(fsn_mark, group);
+		fsnotify_destroy_mark_locked(fsn_mark, group);
+	mutex_unlock(&group->mark_mutex);
 
 	fsnotify_put_mark(fsn_mark);
 	if (removed & real_mount(mnt)->mnt_fsnotify_mask)
@@ -548,14 +552,19 @@ static int fanotify_remove_inode_mark(st
 	__u32 removed;
 	int destroy_mark;
 
+	mutex_lock(&group->mark_mutex);
 	fsn_mark = fsnotify_find_inode_mark(group, inode);
-	if (!fsn_mark)
+	if (!fsn_mark) {
+		mutex_unlock(&group->mark_mutex);
 		return -ENOENT;
+	}
 
 	removed = fanotify_mark_remove_from_mask(fsn_mark, mask, flags,
 						 &destroy_mark);
 	if (destroy_mark)
-		fsnotify_destroy_mark(fsn_mark, group);
+		fsnotify_destroy_mark_locked(fsn_mark, group);
+	mutex_unlock(&group->mark_mutex);
+
 	/* matches the fsnotify_find_inode_mark() */
 	fsnotify_put_mark(fsn_mark);
 	if (removed & inode->i_fsnotify_mask)
@@ -599,21 +608,29 @@ static int fanotify_add_vfsmount_mark(st
 	__u32 added;
 	int ret = 0;
 
+	mutex_lock(&group->mark_mutex);
 	fsn_mark = fsnotify_find_vfsmount_mark(group, mnt);
 	if (!fsn_mark) {
-		if (atomic_read(&group->num_marks) > group->fanotify_data.max_marks)
+		if (atomic_read(&group->num_marks) > group->fanotify_data.max_marks) {
+			mutex_unlock(&group->mark_mutex);
 			return -ENOSPC;
+		}
 
 		fsn_mark = kmem_cache_alloc(fanotify_mark_cache, GFP_KERNEL);
-		if (!fsn_mark)
+		if (!fsn_mark) {
+			mutex_unlock(&group->mark_mutex);
 			return -ENOMEM;
+		}
 
 		fsnotify_init_mark(fsn_mark, fanotify_free_mark);
-		ret = fsnotify_add_mark(fsn_mark, group, NULL, mnt, 0);
-		if (ret)
+		ret = fsnotify_add_mark_locked(fsn_mark, group, NULL, mnt, 0);
+		if (ret) {
+			mutex_unlock(&group->mark_mutex);
 			goto err;
+		}
 	}
 	added = fanotify_mark_add_to_mask(fsn_mark, mask, flags);
+	mutex_unlock(&group->mark_mutex);
 
 	if (added & ~real_mount(mnt)->mnt_fsnotify_mask)
 		fsnotify_recalc_vfsmount_mask(mnt);
@@ -642,21 +659,29 @@ static int fanotify_add_inode_mark(struc
 	    (atomic_read(&inode->i_writecount) > 0))
 		return 0;
 
+	mutex_lock(&group->mark_mutex);
 	fsn_mark = fsnotify_find_inode_mark(group, inode);
 	if (!fsn_mark) {
-		if (atomic_read(&group->num_marks) > group->fanotify_data.max_marks)
+		if (atomic_read(&group->num_marks) > group->fanotify_data.max_marks) {
+			mutex_unlock(&group->mark_mutex);
 			return -ENOSPC;
+		}
 
 		fsn_mark = kmem_cache_alloc(fanotify_mark_cache, GFP_KERNEL);
-		if (!fsn_mark)
+		if (!fsn_mark) {
+			mutex_unlock(&group->mark_mutex);
 			return -ENOMEM;
+		}
 
 		fsnotify_init_mark(fsn_mark, fanotify_free_mark);
-		ret = fsnotify_add_mark(fsn_mark, group, inode, NULL, 0);
-		if (ret)
+		ret = fsnotify_add_mark_locked(fsn_mark, group, inode, NULL, 0);
+		if (ret) {
+			mutex_unlock(&group->mark_mutex);
 			goto err;
+		}
 	}
 	added = fanotify_mark_add_to_mask(fsn_mark, mask, flags);
+	mutex_unlock(&group->mark_mutex);
 
 	if (added & ~inode->i_fsnotify_mask)
 		fsnotify_recalc_inode_mask(inode);
_

Patches currently in -mm which might be from LinoSanfilippo@gmx.de are

origin.patch

