From: akpm@linux-foundation.org
Subject: [merged] fsnotify-update-comments-concerning-locking-scheme.patch removed from -mm tree
Date: Tue, 09 Jul 2013 16:19:18 -0700
Message-ID: <51dc9a76.0e7js/19IJlifden%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38783 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab3GIXTS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:19:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, eparis@redhat.com, LinoSanfilippo@gmx.de

Subject: [merged] fsnotify-update-comments-concerning-locking-scheme.patch removed from -mm tree
To: LinoSanfilippo@gmx.de,eparis@redhat.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:19:18 -0700


The patch titled
     Subject: fsnotify: update comments concerning locking scheme
has been removed from the -mm tree.  Its filename was
     fsnotify-update-comments-concerning-locking-scheme.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: fsnotify: update comments concerning locking scheme

There have been changes in the locking scheme of fsnotify but the comments
in the source code have not been updated yet.  This patch corrects this.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/mark.c |   50 +++++++++++++++++++--------------------------
 1 file changed, 22 insertions(+), 28 deletions(-)

diff -puN fs/notify/mark.c~fsnotify-update-comments-concerning-locking-scheme fs/notify/mark.c
--- a/fs/notify/mark.c~fsnotify-update-comments-concerning-locking-scheme
+++ a/fs/notify/mark.c
@@ -20,28 +20,29 @@
  * fsnotify inode mark locking/lifetime/and refcnting
  *
  * REFCNT:
- * The mark->refcnt tells how many "things" in the kernel currently are
- * referencing this object.  The object typically will live inside the kernel
- * with a refcnt of 2, one for each list it is on (i_list, g_list).  Any task
- * which can find this object holding the appropriete locks, can take a reference
- * and the object itself is guaranteed to survive until the reference is dropped.
+ * The group->recnt and mark->refcnt tell how many "things" in the kernel
+ * currently are referencing the objects. Both kind of objects typically will
+ * live inside the kernel with a refcnt of 2, one for its creation and one for
+ * the reference a group and a mark hold to each other.
+ * If you are holding the appropriate locks, you can take a reference and the
+ * object itself is guaranteed to survive until the reference is dropped.
  *
  * LOCKING:
- * There are 3 spinlocks involved with fsnotify inode marks and they MUST
- * be taken in order as follows:
+ * There are 3 locks involved with fsnotify inode marks and they MUST be taken
+ * in order as follows:
  *
+ * group->mark_mutex
  * mark->lock
- * group->mark_lock
  * inode->i_lock
  *
- * mark->lock protects 2 things, mark->group and mark->inode.  You must hold
- * that lock to dereference either of these things (they could be NULL even with
- * the lock)
- *
- * group->mark_lock protects the marks_list anchored inside a given group
- * and each mark is hooked via the g_list.  It also sorta protects the
- * free_g_list, which when used is anchored by a private list on the stack of the
- * task which held the group->mark_lock.
+ * group->mark_mutex protects the marks_list anchored inside a given group and
+ * each mark is hooked via the g_list.  It also protects the groups private
+ * data (i.e group limits).
+
+ * mark->lock protects the marks attributes like its masks and flags.
+ * Furthermore it protects the access to a reference of the group that the mark
+ * is assigned to as well as the access to a reference of the inode/vfsmount
+ * that is being watched by the mark.
  *
  * inode->i_lock protects the i_fsnotify_marks list anchored inside a
  * given inode and each mark is hooked via the i_list. (and sorta the
@@ -64,18 +65,11 @@
  * inode.  We take i_lock and walk the i_fsnotify_marks safely.  For each
  * mark on the list we take a reference (so the mark can't disappear under us).
  * We remove that mark form the inode's list of marks and we add this mark to a
- * private list anchored on the stack using i_free_list;  At this point we no
- * longer fear anything finding the mark using the inode's list of marks.
- *
- * We can safely and locklessly run the private list on the stack of everything
- * we just unattached from the original inode.  For each mark on the private list
- * we grab the mark-> and can thus dereference mark->group and mark->inode.  If
- * we see the group and inode are not NULL we take those locks.  Now holding all
- * 3 locks we can completely remove the mark from other tasks finding it in the
- * future.  Remember, 10 things might already be referencing this mark, but they
- * better be holding a ref.  We drop our reference we took before we unhooked it
- * from the inode.  When the ref hits 0 we can free the mark.
- *
+ * private list anchored on the stack using i_free_list; we walk i_free_list
+ * and before we destroy the mark we make sure that we dont race with a
+ * concurrent destroy_group by getting a ref to the marks group and taking the
+ * groups mutex.
+
  * Very similarly for freeing by group, except we use free_g_list.
  *
  * This has the very interesting property of being able to run concurrently with
_

Patches currently in -mm which might be from LinoSanfilippo@gmx.de are

origin.patch

