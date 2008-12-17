From: akpm@linux-foundation.org
Subject: + configfs-silence-lockdep-on-mkdir-rmdir-and-configfs_depend_item.patch added to -mm tree
Date: Wed, 17 Dec 2008 13:40:28 -0800
Message-ID: <200812172140.mBHLeSx0009678@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53579 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752097AbYLQVlk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Dec 2008 16:41:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: louis.rilling@kerlabs.com, Joel.Becker@oracle.com, a.p.zijlstra@chello.nl, mingo@elte.hu, swhiteho@redhat.com


The patch titled
     configfs: silence lockdep on mkdir(), rmdir() and configfs_depend_item()
has been added to the -mm tree.  Its filename is
     configfs-silence-lockdep-on-mkdir-rmdir-and-configfs_depend_item.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: configfs: silence lockdep on mkdir(), rmdir() and configfs_depend_item()
From: Louis Rilling <louis.rilling@kerlabs.com>

When attaching default groups (subdirs) of a new group (in mkdir() or in
configfs_register()), configfs recursively takes inode's mutexes along the
path from the parent of the new group to the default subdirs.  This is
needed to ensure that the VFS will not race with operations on these
sub-dirs.  This is safe for the following reasons:

- the VFS allows one to lock first an inode and second one of its
  children (The lock subclasses for this pattern are respectively
  I_MUTEX_PARENT and I_MUTEX_CHILD);
- from this rule any inode path can be recursively locked in
  descending order as long as it stays under a single mountpoint and
  does not follow symlinks.

Unfortunately lockdep does not know (yet?) how to handle such recursion.

I've tried to use Peter Zijlstra's lock_set_subclass() helper to upgrade
i_mutexes from I_MUTEX_CHILD to I_MUTEX_PARENT when we know that we might
recursively lock some of their descendant, but this usage does not seem to
fit the purpose of lock_set_subclass() because it leads to several i_mutex
locked with subclass I_MUTEX_PARENT by the same task.

From inside configfs it is not possible to serialize those recursive
locking with a top-level one, because mkdir() and rmdir() are already
called with inodes locked by the VFS.  So using some
mutex_lock_nest_lock() is not an option.

I am proposing two solutions:
1) one that wraps recursive mutex_lock()s with
   lockdep_off()/lockdep_on().
2) (as suggested earlier by Peter Zijlstra) one that puts the
   i_mutexes recursively locked in different classes based on their
   depth from the top-level config_group created. This
   induces an arbitrary limit (MAX_LOCK_DEPTH - 2 == 46) on the
   nesting of configfs default groups whenever lockdep is activated
   but this limit looks reasonably high. Unfortunately, this alos
   isolates VFS operations on configfs default groups from the others
   and thus lowers the chances to detect locking issues.

This patch implements solution 1).

Solution 2) looks better from lockdep's point of view, but fails with
configfs_depend_item(). This needs to rework the locking
scheme of configfs_depend_item() by removing the variable lock recursion
depth, and I think that it's doable thanks to the configfs_dirent_lock.
For now, let's stick to solution 1).

Signed-off-by: Louis Rilling <louis.rilling@kerlabs.com>
Cc: Joel Becker <Joel.Becker@oracle.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/configfs/dir.c |   59 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff -puN fs/configfs/dir.c~configfs-silence-lockdep-on-mkdir-rmdir-and-configfs_depend_item fs/configfs/dir.c
--- a/fs/configfs/dir.c~configfs-silence-lockdep-on-mkdir-rmdir-and-configfs_depend_item
+++ a/fs/configfs/dir.c
@@ -553,12 +553,24 @@ static void detach_groups(struct config_
 
 		child = sd->s_dentry;
 
+		/*
+		 * Note: we hide this from lockdep since we have no way
+		 * to teach lockdep about recursive
+		 * I_MUTEX_PARENT -> I_MUTEX_CHILD patterns along a path
+		 * in an inode tree, which are valid as soon as
+		 * I_MUTEX_PARENT -> I_MUTEX_CHILD is valid from a
+		 * parent inode to one of its children.
+		 */
+		lockdep_off();
 		mutex_lock(&child->d_inode->i_mutex);
+		lockdep_on();
 
 		configfs_detach_group(sd->s_element);
 		child->d_inode->i_flags |= S_DEAD;
 
+		lockdep_off();
 		mutex_unlock(&child->d_inode->i_mutex);
+		lockdep_on();
 
 		d_delete(child);
 		dput(child);
@@ -748,11 +760,22 @@ static int configfs_attach_item(struct c
 			 * We are going to remove an inode and its dentry but
 			 * the VFS may already have hit and used them. Thus,
 			 * we must lock them as rmdir() would.
+			 *
+			 * Note: we hide this from lockdep since we have no way
+			 * to teach lockdep about recursive
+			 * I_MUTEX_PARENT -> I_MUTEX_CHILD patterns along a path
+			 * in an inode tree, which are valid as soon as
+			 * I_MUTEX_PARENT -> I_MUTEX_CHILD is valid from a
+			 * parent inode to one of its children.
 			 */
+			lockdep_off();
 			mutex_lock(&dentry->d_inode->i_mutex);
+			lockdep_on();
 			configfs_remove_dir(item);
 			dentry->d_inode->i_flags |= S_DEAD;
+			lockdep_off();
 			mutex_unlock(&dentry->d_inode->i_mutex);
+			lockdep_on();
 			d_delete(dentry);
 		}
 	}
@@ -787,14 +810,25 @@ static int configfs_attach_group(struct 
 		 *
 		 * We must also lock the inode to remove it safely in case of
 		 * error, as rmdir() would.
+		 *
+		 * Note: we hide this from lockdep since we have no way
+		 * to teach lockdep about recursive
+		 * I_MUTEX_PARENT -> I_MUTEX_CHILD patterns along a path
+		 * in an inode tree, which are valid as soon as
+		 * I_MUTEX_PARENT -> I_MUTEX_CHILD is valid from a
+		 * parent inode to one of its children.
 		 */
+		lockdep_off();
 		mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_CHILD);
+		lockdep_on();
 		ret = populate_groups(to_config_group(item));
 		if (ret) {
 			configfs_detach_item(item);
 			dentry->d_inode->i_flags |= S_DEAD;
 		}
+		lockdep_off();
 		mutex_unlock(&dentry->d_inode->i_mutex);
+		lockdep_on();
 		if (ret)
 			d_delete(dentry);
 	}
@@ -956,7 +990,17 @@ static int configfs_depend_prep(struct d
 	BUG_ON(!origin || !sd);
 
 	/* Lock this guy on the way down */
+	/*
+	 * Note: we hide this from lockdep since we have no way
+	 * to teach lockdep about recursive
+	 * I_MUTEX_PARENT -> I_MUTEX_CHILD patterns along a path
+	 * in an inode tree, which are valid as soon as
+	 * I_MUTEX_PARENT -> I_MUTEX_CHILD is valid from a
+	 * parent inode to one of its children.
+	 */
+	lockdep_off();
 	mutex_lock(&sd->s_dentry->d_inode->i_mutex);
+	lockdep_on();
 	if (sd->s_element == target)  /* Boo-yah */
 		goto out;
 
@@ -970,7 +1014,9 @@ static int configfs_depend_prep(struct d
 	}
 
 	/* We looped all our children and didn't find target */
+	lockdep_off();
 	mutex_unlock(&sd->s_dentry->d_inode->i_mutex);
+	lockdep_on();
 	ret = -ENOENT;
 
 out:
@@ -990,11 +1036,16 @@ static void configfs_depend_rollback(str
 	struct dentry *dentry = item->ci_dentry;
 
 	while (dentry != origin) {
+		/* See comments in configfs_depend_prep() */
+		lockdep_off();
 		mutex_unlock(&dentry->d_inode->i_mutex);
+		lockdep_on();
 		dentry = dentry->d_parent;
 	}
 
+	lockdep_off();
 	mutex_unlock(&origin->d_inode->i_mutex);
+	lockdep_on();
 }
 
 int configfs_depend_item(struct configfs_subsystem *subsys,
@@ -1329,8 +1380,16 @@ static int configfs_rmdir(struct inode *
 			}
 
 			/* Wait until the racing operation terminates */
+			/*
+			 * Note: we hide this from lockdep since we are locked
+			 * with subclass I_MUTEX_NORMAL from vfs_rmdir() (why
+			 * not I_MUTEX_CHILD?), and I_MUTEX_XATTR or
+			 * I_MUTEX_QUOTA are not relevant for the locked inode.
+			 */
+			lockdep_off();
 			mutex_lock(wait_mutex);
 			mutex_unlock(wait_mutex);
+			lockdep_on();
 		}
 	} while (ret == -EAGAIN);
 
_

Patches currently in -mm which might be from louis.rilling@kerlabs.com are

configfs-silence-lockdep-on-mkdir-rmdir-and-configfs_depend_item.patch

