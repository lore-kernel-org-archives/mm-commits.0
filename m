From: akpm@linux-foundation.org
Subject: +
 ocfs2-avoid-system-inode-ref-confusion-by-adding-mutex-lock.patch added to
 -mm tree
Date: Tue, 01 Apr 2014 14:36:15 -0700
Message-ID: <533b314f.NBEcRmte/qA/P+96%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38811 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbaDAVgQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2014 17:36:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, joseph.qi@huawei.com, jlbec@evilplan.org, jiangyiwen@huawei.com

Subject: + ocfs2-avoid-system-inode-ref-confusion-by-adding-mutex-lock.patch added to -mm tree
To: jiangyiwen@huawei.com,jlbec@evilplan.org,joseph.qi@huawei.com,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Tue, 01 Apr 2014 14:36:15 -0700


The patch titled
     Subject: ocfs2: avoid system inode ref confusion by adding mutex lock
has been added to the -mm tree.  Its filename is
     ocfs2-avoid-system-inode-ref-confusion-by-adding-mutex-lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-avoid-system-inode-ref-confusion-by-adding-mutex-lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-avoid-system-inode-ref-confusion-by-adding-mutex-lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: jiangyiwen <jiangyiwen@huawei.com>
Subject: ocfs2: avoid system inode ref confusion by adding mutex lock

The following case may lead to the same system inode ref in confusion.

A thread                            B thread
ocfs2_get_system_file_inode
->get_local_system_inode
->_ocfs2_get_system_file_inode
                                    because of *arr == NULL,
                                    ocfs2_get_system_file_inode
                                    ->get_local_system_inode
                                    ->_ocfs2_get_system_file_inode
gets first ref thru
_ocfs2_get_system_file_inode,
gets second ref thru igrab and
set *arr = inode
                                    at the moment, B thread also gets
                                    two refs, so lead to one more
                                    inode ref.

So add mutex lock to avoid multi thread set two inode ref once at the same
time.

Signed-off-by: jiangyiwen <jiangyiwen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ocfs2.h   |    2 ++
 fs/ocfs2/super.c   |    2 ++
 fs/ocfs2/sysfile.c |    3 +++
 3 files changed, 7 insertions(+)

diff -puN fs/ocfs2/ocfs2.h~ocfs2-avoid-system-inode-ref-confusion-by-adding-mutex-lock fs/ocfs2/ocfs2.h
--- a/fs/ocfs2/ocfs2.h~ocfs2-avoid-system-inode-ref-confusion-by-adding-mutex-lock
+++ a/fs/ocfs2/ocfs2.h
@@ -446,6 +446,8 @@ struct ocfs2_super
 	/* rb tree root for refcount lock. */
 	struct rb_root	osb_rf_lock_tree;
 	struct ocfs2_refcount_tree *osb_ref_tree_lru;
+
+	struct mutex system_file_mutex;
 };
 
 #define OCFS2_SB(sb)	    ((struct ocfs2_super *)(sb)->s_fs_info)
diff -puN fs/ocfs2/super.c~ocfs2-avoid-system-inode-ref-confusion-by-adding-mutex-lock fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-avoid-system-inode-ref-confusion-by-adding-mutex-lock
+++ a/fs/ocfs2/super.c
@@ -2100,6 +2100,8 @@ static int ocfs2_initialize_super(struct
 	spin_lock_init(&osb->osb_xattr_lock);
 	ocfs2_init_steal_slots(osb);
 
+	mutex_init(&osb->system_file_mutex);
+
 	atomic_set(&osb->alloc_stats.moves, 0);
 	atomic_set(&osb->alloc_stats.local_data, 0);
 	atomic_set(&osb->alloc_stats.bitmap_data, 0);
diff -puN fs/ocfs2/sysfile.c~ocfs2-avoid-system-inode-ref-confusion-by-adding-mutex-lock fs/ocfs2/sysfile.c
--- a/fs/ocfs2/sysfile.c~ocfs2-avoid-system-inode-ref-confusion-by-adding-mutex-lock
+++ a/fs/ocfs2/sysfile.c
@@ -113,9 +113,11 @@ struct inode *ocfs2_get_system_file_inod
 	} else
 		arr = get_local_system_inode(osb, type, slot);
 
+	mutex_lock(&osb->system_file_mutex);
 	if (arr && ((inode = *arr) != NULL)) {
 		/* get a ref in addition to the array ref */
 		inode = igrab(inode);
+		mutex_unlock(&osb->system_file_mutex);
 		BUG_ON(!inode);
 
 		return inode;
@@ -129,6 +131,7 @@ struct inode *ocfs2_get_system_file_inod
 		*arr = igrab(inode);
 		BUG_ON(!*arr);
 	}
+	mutex_unlock(&osb->system_file_mutex);
 	return inode;
 }
 
_

Patches currently in -mm which might be from jiangyiwen@huawei.com are

ocfs2-fix-a-tiny-race-when-running-dirop_fileop_racer.patch
ocfs2-iput-inode-alloc-when-failed-locally.patch
ocfs2-avoid-system-inode-ref-confusion-by-adding-mutex-lock.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
ocfs2-manually-do-the-iput-once-ocfs2_add_entry-failed-in-ocfs2_symlink-and-ocfs2_mknod.patch

