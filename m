From: akpm@linux-foundation.org
Subject: + ocfs2-free-inode-when-i_count-becomes-zero.patch added to -mm
 tree
Date: Wed, 11 Jun 2014 15:23:38 -0700
Message-ID: <5398d6ea./YtboJN0sjoHtItf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52110 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197AbaFKWXj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jun 2014 18:23:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, xuejiufei@huawei.com

Subject: + ocfs2-free-inode-when-i_count-becomes-zero.patch added to -mm tree
To: xuejiufei@huawei.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Wed, 11 Jun 2014 15:23:38 -0700


The patch titled
     Subject: ocfs2: free inode when i_count becomes zero
has been added to the -mm tree.  Its filename is
     ocfs2-free-inode-when-i_count-becomes-zero.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-free-inode-when-i_count-becomes-zero.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-free-inode-when-i_count-becomes-zero.patch

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
Subject: ocfs2: free inode when i_count becomes zero

Disk inode deletion may be heavily delayed when one node unlink a file
after the same dentry is freed on another node(say N1) because of memory
shrink but inode is left in memory.  This inode can only be freed while N1
doing the orphan scan work.

However, N1 may skip orphan scan for several times because other nodes may
do the work earlier.  In our tests, it may take 1 hour on 4 nodes cluster
and this will cause bad user experience.  So we think the inode should be
freed when i_count becomes zero to avoid such circumstances.

Signed-off-by: joyce.xue <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff -puN fs/ocfs2/inode.c~ocfs2-free-inode-when-i_count-becomes-zero fs/ocfs2/inode.c
--- a/fs/ocfs2/inode.c~ocfs2-free-inode-when-i_count-becomes-zero
+++ a/fs/ocfs2/inode.c
@@ -1192,17 +1192,9 @@ void ocfs2_evict_inode(struct inode *ino
 int ocfs2_drop_inode(struct inode *inode)
 {
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
-	int res;
-
 	trace_ocfs2_drop_inode((unsigned long long)oi->ip_blkno,
 				inode->i_nlink, oi->ip_flags);
-
-	if (oi->ip_flags & OCFS2_INODE_MAYBE_ORPHANED)
-		res = 1;
-	else
-		res = generic_drop_inode(inode);
