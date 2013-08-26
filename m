From: akpm@linux-foundation.org
Subject: [merged] efs-iget_locked-doesnt-return-an-err_ptr.patch removed
 from -mm tree
Date: Mon, 26 Aug 2013 13:08:06 -0700
Message-ID: <521bb5a6.k7sHvy98D7AhLcc4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57347 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab3HZUIH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Aug 2013 16:08:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, serge.hallyn@canonical.com, ebiederm@xmission.com, dan.carpenter@oracle.com

Subject: [merged] efs-iget_locked-doesnt-return-an-err_ptr.patch removed from -mm tree
To: dan.carpenter@oracle.com,ebiederm@xmission.com,serge.hallyn@canonical.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 26 Aug 2013 13:08:06 -0700


The patch titled
     Subject: efs: iget_locked() doesn't return an ERR_PTR()
has been removed from the -mm tree.  Its filename was
     efs-iget_locked-doesnt-return-an-err_ptr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: efs: iget_locked() doesn't return an ERR_PTR()

The iget_locked() function returns NULL on error and never an ERR_PTR.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/efs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/efs/inode.c~efs-iget_locked-doesnt-return-an-err_ptr fs/efs/inode.c
--- a/fs/efs/inode.c~efs-iget_locked-doesnt-return-an-err_ptr
+++ a/fs/efs/inode.c
@@ -57,7 +57,7 @@ struct inode *efs_iget(struct super_bloc
 	struct inode *inode;
 
 	inode = iget_locked(super, ino);
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

