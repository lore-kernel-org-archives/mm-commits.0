From: akpm@linux-foundation.org
Subject: + bfs-iget_locked-doesnt-return-an-err_ptr.patch added to -mm
 tree
Date: Thu, 15 Aug 2013 15:04:53 -0700
Message-ID: <520d5085.GS2bxmDXgNsHiLaK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43298 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3HOWEy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Aug 2013 18:04:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tigran@aivazian.fsnet.co.uk, dan.carpenter@oracle.com

Subject: + bfs-iget_locked-doesnt-return-an-err_ptr.patch added to -mm tree
To: dan.carpenter@oracle.com,tigran@aivazian.fsnet.co.uk
From: akpm@linux-foundation.org
Date: Thu, 15 Aug 2013 15:04:53 -0700


The patch titled
     Subject: bfs: iget_locked() doesn't return an ERR_PTR
has been added to the -mm tree.  Its filename is
     bfs-iget_locked-doesnt-return-an-err_ptr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bfs-iget_locked-doesnt-return-an-err_ptr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bfs-iget_locked-doesnt-return-an-err_ptr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

origin.patch
nilfs2-remove-double-bio_put-in-nilfs_end_bio_write-for-bio_eopnotsupp-error.patch
nilfs2-fix-issue-with-counting-number-of-bio-requests-for-bio_eopnotsupp-error-detection.patch
ocfs2-use-list_for_each_entry-instead-of-list_for_each.patch
ocfs2-use-list_for_each_entry-instead-of-list_for_each-fix.patch
efs-iget_locked-doesnt-return-an-err_ptr.patch
bfs-iget_locked-doesnt-return-an-err_ptr.patch
pktcdvd-convert-printk-to-pr_level.patch
pktcdvd-fix-defective-misuses-of-pkt_level.patch
linux-next.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix.patch

