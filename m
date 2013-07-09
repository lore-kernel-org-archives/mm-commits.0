From: akpm@linux-foundation.org
Subject: [merged]
 dnotify-replace-dnotify_mark_mutex-with-mark-mutex-of-dnotify_group.patch
 removed from -mm tree
Date: Tue, 09 Jul 2013 16:19:14 -0700
Message-ID: <51dc9a72.EJjVEAuhk0SucBJV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38776 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab3GIXTO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:19:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, eparis@redhat.com, LinoSanfilippo@gmx.de

Subject: [merged] dnotify-replace-dnotify_mark_mutex-with-mark-mutex-of-dnotify_group.patch removed from -mm tree
To: LinoSanfilippo@gmx.de,eparis@redhat.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:19:14 -0700


The patch titled
     Subject: dnotify: replace dnotify_mark_mutex with mark mutex of dnotify_group
has been removed from the -mm tree.  Its filename was
     dnotify-replace-dnotify_mark_mutex-with-mark-mutex-of-dnotify_group.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: dnotify: replace dnotify_mark_mutex with mark mutex of dnotify_group

There is no need to use a special mutex to protect against the fcntl/close
race (see dnotify.c for a description of this race).  Instead the
dnotify_groups mark mutex can be used.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/dnotify/dnotify.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff -puN fs/notify/dnotify/dnotify.c~dnotify-replace-dnotify_mark_mutex-with-mark-mutex-of-dnotify_group fs/notify/dnotify/dnotify.c
--- a/fs/notify/dnotify/dnotify.c~dnotify-replace-dnotify_mark_mutex-with-mark-mutex-of-dnotify_group
+++ a/fs/notify/dnotify/dnotify.c
@@ -31,7 +31,6 @@ int dir_notify_enable __read_mostly = 1;
 static struct kmem_cache *dnotify_struct_cache __read_mostly;
 static struct kmem_cache *dnotify_mark_cache __read_mostly;
 static struct fsnotify_group *dnotify_group __read_mostly;
-static DEFINE_MUTEX(dnotify_mark_mutex);
 
 /*
  * dnotify will attach one of these to each inode (i_fsnotify_marks) which
@@ -183,7 +182,7 @@ void dnotify_flush(struct file *filp, fl
 		return;
 	dn_mark = container_of(fsn_mark, struct dnotify_mark, fsn_mark);
 
-	mutex_lock(&dnotify_mark_mutex);
+	mutex_lock(&dnotify_group->mark_mutex);
 
 	spin_lock(&fsn_mark->lock);
 	prev = &dn_mark->dn;
@@ -199,11 +198,12 @@ void dnotify_flush(struct file *filp, fl
 
 	spin_unlock(&fsn_mark->lock);
 
-	/* nothing else could have found us thanks to the dnotify_mark_mutex */
+	/* nothing else could have found us thanks to the dnotify_groups
+	   mark_mutex */
 	if (dn_mark->dn == NULL)
-		fsnotify_destroy_mark(fsn_mark, dnotify_group);
+		fsnotify_destroy_mark_locked(fsn_mark, dnotify_group);
 
-	mutex_unlock(&dnotify_mark_mutex);
+	mutex_unlock(&dnotify_group->mark_mutex);
 
 	fsnotify_put_mark(fsn_mark);
 }
@@ -326,7 +326,7 @@ int fcntl_dirnotify(int fd, struct file
 	new_dn_mark->dn = NULL;
 
 	/* this is needed to prevent the fcntl/close race described below */
-	mutex_lock(&dnotify_mark_mutex);
+	mutex_lock(&dnotify_group->mark_mutex);
 
 	/* add the new_fsn_mark or find an old one. */
 	fsn_mark = fsnotify_find_inode_mark(dnotify_group, inode);
@@ -334,7 +334,8 @@ int fcntl_dirnotify(int fd, struct file
 		dn_mark = container_of(fsn_mark, struct dnotify_mark, fsn_mark);
 		spin_lock(&fsn_mark->lock);
 	} else {
-		fsnotify_add_mark(new_fsn_mark, dnotify_group, inode, NULL, 0);
+		fsnotify_add_mark_locked(new_fsn_mark, dnotify_group, inode,
+					 NULL, 0);
 		spin_lock(&new_fsn_mark->lock);
 		fsn_mark = new_fsn_mark;
 		dn_mark = new_dn_mark;
@@ -348,9 +349,9 @@ int fcntl_dirnotify(int fd, struct file
 
 	/* if (f != filp) means that we lost a race and another task/thread
 	 * actually closed the fd we are still playing with before we grabbed
-	 * the dnotify_mark_mutex and fsn_mark->lock.  Since closing the fd is the
-	 * only time we clean up the marks we need to get our mark off
-	 * the list. */
+	 * the dnotify_groups mark_mutex and fsn_mark->lock.  Since closing the
+	 * fd is the only time we clean up the marks we need to get our mark
+	 * off the list. */
 	if (f != filp) {
 		/* if we added ourselves, shoot ourselves, it's possible that
 		 * the flush actually did shoot this fsn_mark.  That's fine too
@@ -385,9 +386,9 @@ out:
 	spin_unlock(&fsn_mark->lock);
 
 	if (destroy)
-		fsnotify_destroy_mark(fsn_mark, dnotify_group);
+		fsnotify_destroy_mark_locked(fsn_mark, dnotify_group);
 
-	mutex_unlock(&dnotify_mark_mutex);
+	mutex_unlock(&dnotify_group->mark_mutex);
 	fsnotify_put_mark(fsn_mark);
 out_err:
 	if (new_fsn_mark)
_

Patches currently in -mm which might be from LinoSanfilippo@gmx.de are

origin.patch

