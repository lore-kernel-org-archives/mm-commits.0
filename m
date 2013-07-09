From: akpm@linux-foundation.org
Subject: [merged]
 fanotify-put-duplicate-code-for-adding-vfsmount-inode-marks-into-an-own-function.patch removed from -mm tree
Date: Tue, 09 Jul 2013 16:19:12 -0700
Message-ID: <51dc9a70.QO2WGucEjZeLfFNE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38773 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab3GIXTM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:19:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, eparis@redhat.com, LinoSanfilippo@gmx.de

Subject: [merged] fanotify-put-duplicate-code-for-adding-vfsmount-inode-marks-into-an-own-function.patch removed from -mm tree
To: LinoSanfilippo@gmx.de,eparis@redhat.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:19:12 -0700


The patch titled
     Subject: fanotify: put duplicate code for adding vfsmount/inode marks into an own function
has been removed from the -mm tree.  Its filename was
     fanotify-put-duplicate-code-for-adding-vfsmount-inode-marks-into-an-own-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: fanotify: put duplicate code for adding vfsmount/inode marks into an own function

The code under the groups mark_mutex in fanotify_add_inode_mark() and
fanotify_add_vfsmount_mark() is almost identical.  So put it into a
seperate function.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify_user.c |   71 +++++++++++++--------------
 1 file changed, 35 insertions(+), 36 deletions(-)

diff -puN fs/notify/fanotify/fanotify_user.c~fanotify-put-duplicate-code-for-adding-vfsmount-inode-marks-into-an-own-function fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fanotify-put-duplicate-code-for-adding-vfsmount-inode-marks-into-an-own-function
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -600,33 +600,45 @@ static __u32 fanotify_mark_add_to_mask(s
 	return mask & ~oldmask;
 }
 
+static struct fsnotify_mark *fanotify_add_new_mark(struct fsnotify_group *group,
+						   struct inode *inode,
+						   struct vfsmount *mnt)
+{
+	struct fsnotify_mark *mark;
+	int ret;
+
+	if (atomic_read(&group->num_marks) > group->fanotify_data.max_marks)
+		return ERR_PTR(-ENOSPC);
+
+	mark = kmem_cache_alloc(fanotify_mark_cache, GFP_KERNEL);
+	if (!mark)
+		return ERR_PTR(-ENOMEM);
+
+	fsnotify_init_mark(mark, fanotify_free_mark);
+	ret = fsnotify_add_mark_locked(mark, group, inode, mnt, 0);
+	if (ret) {
+		fsnotify_put_mark(mark);
+		return ERR_PTR(ret);
+	}
+
+	return mark;
+}
+
+
 static int fanotify_add_vfsmount_mark(struct fsnotify_group *group,
 				      struct vfsmount *mnt, __u32 mask,
 				      unsigned int flags)
 {
 	struct fsnotify_mark *fsn_mark;
 	__u32 added;
-	int ret = 0;
 
 	mutex_lock(&group->mark_mutex);
 	fsn_mark = fsnotify_find_vfsmount_mark(group, mnt);
 	if (!fsn_mark) {
-		if (atomic_read(&group->num_marks) > group->fanotify_data.max_marks) {
-			mutex_unlock(&group->mark_mutex);
-			return -ENOSPC;
-		}
-
-		fsn_mark = kmem_cache_alloc(fanotify_mark_cache, GFP_KERNEL);
-		if (!fsn_mark) {
+		fsn_mark = fanotify_add_new_mark(group, NULL, mnt);
+		if (IS_ERR(fsn_mark)) {
 			mutex_unlock(&group->mark_mutex);
-			return -ENOMEM;
-		}
-
-		fsnotify_init_mark(fsn_mark, fanotify_free_mark);
-		ret = fsnotify_add_mark_locked(fsn_mark, group, NULL, mnt, 0);
-		if (ret) {
-			mutex_unlock(&group->mark_mutex);
-			goto err;
+			return PTR_ERR(fsn_mark);
 		}
 	}
 	added = fanotify_mark_add_to_mask(fsn_mark, mask, flags);
@@ -634,9 +646,9 @@ static int fanotify_add_vfsmount_mark(st
 
 	if (added & ~real_mount(mnt)->mnt_fsnotify_mask)
 		fsnotify_recalc_vfsmount_mask(mnt);
-err:
+
 	fsnotify_put_mark(fsn_mark);
-	return ret;
+	return 0;
 }
 
 static int fanotify_add_inode_mark(struct fsnotify_group *group,
@@ -645,7 +657,6 @@ static int fanotify_add_inode_mark(struc
 {
 	struct fsnotify_mark *fsn_mark;
 	__u32 added;
-	int ret = 0;
 
 	pr_debug("%s: group=%p inode=%p\n", __func__, group, inode);
 
@@ -662,22 +673,10 @@ static int fanotify_add_inode_mark(struc
 	mutex_lock(&group->mark_mutex);
 	fsn_mark = fsnotify_find_inode_mark(group, inode);
 	if (!fsn_mark) {
-		if (atomic_read(&group->num_marks) > group->fanotify_data.max_marks) {
+		fsn_mark = fanotify_add_new_mark(group, inode, NULL);
+		if (IS_ERR(fsn_mark)) {
 			mutex_unlock(&group->mark_mutex);
-			return -ENOSPC;
-		}
-
-		fsn_mark = kmem_cache_alloc(fanotify_mark_cache, GFP_KERNEL);
-		if (!fsn_mark) {
-			mutex_unlock(&group->mark_mutex);
-			return -ENOMEM;
-		}
-
-		fsnotify_init_mark(fsn_mark, fanotify_free_mark);
-		ret = fsnotify_add_mark_locked(fsn_mark, group, inode, NULL, 0);
-		if (ret) {
-			mutex_unlock(&group->mark_mutex);
-			goto err;
+			return PTR_ERR(fsn_mark);
 		}
 	}
 	added = fanotify_mark_add_to_mask(fsn_mark, mask, flags);
@@ -685,9 +684,9 @@ static int fanotify_add_inode_mark(struc
 
 	if (added & ~inode->i_fsnotify_mask)
 		fsnotify_recalc_inode_mask(inode);
-err:
+
 	fsnotify_put_mark(fsn_mark);
-	return ret;
+	return 0;
 }
 
 /* fanotify syscalls */
_

Patches currently in -mm which might be from LinoSanfilippo@gmx.de are

origin.patch

