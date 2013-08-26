From: akpm@linux-foundation.org
Subject: [merged] bfs-iget_locked-doesnt-return-an-err_ptr.patch removed
 from -mm tree
Date: Mon, 26 Aug 2013 13:08:10 -0700
Message-ID: <521bb5aa.Xmcq7aJ0dMqoucN5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57355 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab3HZUIK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Aug 2013 16:08:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tigran@aivazian.fsnet.co.uk, dan.carpenter@oracle.com

Subject: [merged] bfs-iget_locked-doesnt-return-an-err_ptr.patch removed from -mm tree
To: dan.carpenter@oracle.com,tigran@aivazian.fsnet.co.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 26 Aug 2013 13:08:10 -0700


The patch titled
     Subject: bfs: iget_locked() doesn't return an ERR_PTR
has been removed from the -mm tree.  Its filename was
     bfs-iget_locked-doesnt-return-an-err_ptr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: bfs: iget_locked() doesn't return an ERR_PTR

iget_locked() returns a NULL on error, it doesn't return an ERR_PTR.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/bfs/inode.c~bfs-iget_locked-doesnt-return-an-err_ptr fs/bfs/inode.c
--- a/fs/bfs/inode.c~bfs-iget_locked-doesnt-return-an-err_ptr
+++ a/fs/bfs/inode.c
@@ -40,7 +40,7 @@ struct inode *bfs_iget(struct super_bloc
 	int block, off;
 
 	inode = iget_locked(sb, ino);
-	if (IS_ERR(inode))
+	if (!inode)
 		return ERR_PTR(-ENOMEM);
 	if (!(inode->i_state & I_NEW))
 		return inode;
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

linux-next.patch
ocfs2-use-list_for_each_entry-instead-of-list_for_each.patch
ocfs2-use-list_for_each_entry-instead-of-list_for_each-fix.patch
mbind-add-bug_onvma-in-new_vma_page.patch
affs-use-loff_t-in-affs_truncate.patch
pktcdvd-convert-printk-to-pr_level.patch
pktcdvd-fix-defective-misuses-of-pkt_level.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix.patch

