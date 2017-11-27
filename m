From: akpm@linux-foundation.org
Subject: + ocfs2-add-ocfs2_try_rw_lock-and-ocfs2_try_inode_lock.patch
 added to -mm tree
Date: Mon, 27 Nov 2017 15:36:41 -0800
Message-ID: <5a1ca189.OwuOSfs7UMgNRI4P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46342 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752634AbdK0Xgm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2017 18:36:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghe@suse.com, ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: add ocfs2_try_rw_lock() and ocfs2_try_inode_lock()
has been added to the -mm tree.  Its filename is
     ocfs2-add-ocfs2_try_rw_lock-and-ocfs2_try_inode_lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-add-ocfs2_try_rw_lock-and-ocfs2_try_inode_lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-add-ocfs2_try_rw_lock-and-ocfs2_try_inode_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gang He <ghe@suse.com>
Subject: ocfs2: add ocfs2_try_rw_lock() and ocfs2_try_inode_lock()

Patch series "ocfs2: add nowait aio support".

VFS layer has introduced the non-blocking aio flag IOCB_NOWAIT, which
tells the kernel to bail out if an AIO request will block for reasons such
as file allocations, or writeback triggering, or would block while
allocating requests while performing direct I/O.

Subsequently, pwritev2/preadv2 also can leverage this part of kernel code.
So far, ext4/xfs/btrfs have supported this feature.  Add the related code
for the ocfs2 file system.  


This patch (of 3):

Add ocfs2_try_rw_lock and ocfs2_try_inode_lock functions, which will be
used in non-blocking IO scenarios.

Link: http://lkml.kernel.org/r/1511775987-841-2-git-send-email-ghe@suse.com
Signed-off-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <ge.changwei@h3c.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |   22 ++++++++++++++++++++++
 fs/ocfs2/dlmglue.h |    4 ++++
 2 files changed, 26 insertions(+)

diff -puN fs/ocfs2/dlmglue.c~ocfs2-add-ocfs2_try_rw_lock-and-ocfs2_try_inode_lock fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~ocfs2-add-ocfs2_try_rw_lock-and-ocfs2_try_inode_lock
+++ a/fs/ocfs2/dlmglue.c
@@ -1742,6 +1742,28 @@ int ocfs2_rw_lock(struct inode *inode, i
 	return status;
 }
 
+int ocfs2_try_rw_lock(struct inode *inode, int write)
+{
+	int status, level;
+	struct ocfs2_lock_res *lockres;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
+	mlog(0, "inode %llu try to take %s RW lock\n",
+	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
+	     write ? "EXMODE" : "PRMODE");
+
+	if (ocfs2_mount_local(osb))
+		return 0;
+
+	lockres = &OCFS2_I(inode)->ip_rw_lockres;
+
+	level = write ? DLM_LOCK_EX : DLM_LOCK_PR;
+
+	status = ocfs2_cluster_lock(OCFS2_SB(inode->i_sb), lockres, level,
+				    DLM_LKF_NOQUEUE, 0);
+	return status;
+}
+
 void ocfs2_rw_unlock(struct inode *inode, int write)
 {
 	int level = write ? DLM_LOCK_EX : DLM_LOCK_PR;
diff -puN fs/ocfs2/dlmglue.h~ocfs2-add-ocfs2_try_rw_lock-and-ocfs2_try_inode_lock fs/ocfs2/dlmglue.h
--- a/fs/ocfs2/dlmglue.h~ocfs2-add-ocfs2_try_rw_lock-and-ocfs2_try_inode_lock
+++ a/fs/ocfs2/dlmglue.h
@@ -116,6 +116,7 @@ void ocfs2_lock_res_free(struct ocfs2_lo
 int ocfs2_create_new_inode_locks(struct inode *inode);
 int ocfs2_drop_inode_locks(struct inode *inode);
 int ocfs2_rw_lock(struct inode *inode, int write);
+int ocfs2_try_rw_lock(struct inode *inode, int write);
 void ocfs2_rw_unlock(struct inode *inode, int write);
 int ocfs2_open_lock(struct inode *inode);
 int ocfs2_try_open_lock(struct inode *inode, int write);
@@ -140,6 +141,9 @@ int ocfs2_inode_lock_with_page(struct in
 /* 99% of the time we don't want to supply any additional flags --
  * those are for very specific cases only. */
 #define ocfs2_inode_lock(i, b, e) ocfs2_inode_lock_full_nested(i, b, e, 0, OI_LS_NORMAL)
+#define ocfs2_try_inode_lock(i, b, e)\
+		ocfs2_inode_lock_full_nested(i, b, e, OCFS2_META_LOCK_NOQUEUE,\
+		OI_LS_NORMAL)
 void ocfs2_inode_unlock(struct inode *inode,
 		       int ex);
 int ocfs2_super_lock(struct ocfs2_super *osb,
_

Patches currently in -mm which might be from ghe@suse.com are

ocfs2-get-rid-of-ocfs2_is_o2cb_active-function.patch
ocfs2-give-an-obvious-tip-for-dismatch-cluster-names.patch
ocfs2-give-an-obvious-tip-for-dismatch-cluster-names-v2.patch
ocfs2-move-some-definitions-to-header-file.patch
ocfs2-fix-some-small-problems.patch
ocfs2-add-kobject-for-online-file-check.patch
ocfs2-add-duplicative-ino-number-check.patch
ocfs2-add-ocfs2_try_rw_lock-and-ocfs2_try_inode_lock.patch
ocfs2-add-ocfs2_overwrite_io-function.patch
ocfs2-nowait-aio-support.patch

