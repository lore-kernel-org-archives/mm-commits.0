From: akpm@linux-foundation.org
Subject: +
 ocfs2-flush-inode-data-to-disk-and-free-inode-when-i_count-becomes-zero.patch added to -mm tree
Date: Wed, 11 Mar 2015 15:32:09 -0700
Message-ID: <5500c269.ax6eL9JFm9KaGpX+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51718 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbbCKWcK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Mar 2015 18:32:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: flush inode data to disk and free inode when i_count becomes zero
has been added to the -mm tree.  Its filename is
     ocfs2-flush-inode-data-to-disk-and-free-inode-when-i_count-becomes-zero.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-flush-inode-data-to-disk-and-free-inode-when-i_count-becomes-zero.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-flush-inode-data-to-disk-and-free-inode-when-i_count-becomes-zero.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2: flush inode data to disk and free inode when i_count becomes zero

Disk inode deletion may be heavily delayed when one node unlink a file
after the same dentry is freed on another node(say N1) because of memory
shrink but inode is left in memory.  This inode can only be freed while N1
doing the orphan scan work.

However, N1 may skip orphan scan for several times because other nodes may
do the work earlier.  In our tests, it may take 1 hour on 4 nodes cluster
and it hurts the user experience.  So we think the inode should be freed
after the data flushed to disk when i_count becomes zero to avoid such
circumstances.

Signed-off-by: Joyce.xue <xuejiufei@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/inode.c~ocfs2-flush-inode-data-to-disk-and-free-inode-when-i_count-becomes-zero fs/ocfs2/inode.c
--- a/fs/ocfs2/inode.c~ocfs2-flush-inode-data-to-disk-and-free-inode-when-i_count-becomes-zero
+++ a/fs/ocfs2/inode.c
@@ -1191,17 +1191,19 @@ void ocfs2_evict_inode(struct inode *ino
 int ocfs2_drop_inode(struct inode *inode)
 {
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
-	int res;
 
 	trace_ocfs2_drop_inode((unsigned long long)oi->ip_blkno,
 				inode->i_nlink, oi->ip_flags);
 
-	if (oi->ip_flags & OCFS2_INODE_MAYBE_ORPHANED)
-		res = 1;
-	else
-		res = generic_drop_inode(inode);
+	assert_spin_locked(&inode->i_lock);
+	inode->i_state |= I_WILL_FREE;
+	spin_unlock(&inode->i_lock);
+	write_inode_now(inode, 1);
+	spin_lock(&inode->i_lock);
+	WARN_ON(inode->i_state & I_NEW);
+	inode->i_state &= ~I_WILL_FREE;
 
-	return res;
+	return 1;
 }
 
 /*
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

ocfs2-flush-inode-data-to-disk-and-free-inode-when-i_count-becomes-zero.patch
ocfs2-flush-inode-data-to-disk-and-free-inode-when-i_count-becomes-zero.patch

