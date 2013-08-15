From: akpm@linux-foundation.org
Subject: + efs-iget_locked-doesnt-return-an-err_ptr.patch added to -mm
 tree
Date: Thu, 15 Aug 2013 15:04:11 -0700
Message-ID: <520d505b./Tvx4yo8kTXqBAwL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43293 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3HOWEM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Aug 2013 18:04:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, serge.hallyn@canonical.com, ebiederm@xmission.com, dan.carpenter@oracle.com

Subject: + efs-iget_locked-doesnt-return-an-err_ptr.patch added to -mm tree
To: dan.carpenter@oracle.com,ebiederm@xmission.com,serge.hallyn@canonical.com
From: akpm@linux-foundation.org
Date: Thu, 15 Aug 2013 15:04:11 -0700


The patch titled
     Subject: efs: iget_locked() doesn't return an ERR_PTR()
has been added to the -mm tree.  Its filename is
     efs-iget_locked-doesnt-return-an-err_ptr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/efs-iget_locked-doesnt-return-an-err_ptr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/efs-iget_locked-doesnt-return-an-err_ptr.patch

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

origin.patch
nilfs2-remove-double-bio_put-in-nilfs_end_bio_write-for-bio_eopnotsupp-error.patch
nilfs2-fix-issue-with-counting-number-of-bio-requests-for-bio_eopnotsupp-error-detection.patch
ocfs2-use-list_for_each_entry-instead-of-list_for_each.patch
ocfs2-use-list_for_each_entry-instead-of-list_for_each-fix.patch
efs-iget_locked-doesnt-return-an-err_ptr.patch
pktcdvd-convert-printk-to-pr_level.patch
pktcdvd-fix-defective-misuses-of-pkt_level.patch
linux-next.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix.patch

