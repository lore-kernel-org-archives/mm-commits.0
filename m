From: akpm@linux-foundation.org
Subject: + affs-use-loff_t-in-affs_truncate.patch added to -mm tree
Date: Thu, 15 Aug 2013 15:11:37 -0700
Message-ID: <520d5219.EgECZ0QG380RAu73%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43315 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3HOWLk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Aug 2013 18:11:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, marco.stornelli@gmail.com, dan.carpenter@oracle.com

Subject: + affs-use-loff_t-in-affs_truncate.patch added to -mm tree
To: dan.carpenter@oracle.com,marco.stornelli@gmail.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Thu, 15 Aug 2013 15:11:37 -0700


The patch titled
     Subject: affs: use loff_t in affs_truncate()
has been added to the -mm tree.  Its filename is
     affs-use-loff_t-in-affs_truncate.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/affs-use-loff_t-in-affs_truncate.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/affs-use-loff_t-in-affs_truncate.patch

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
Subject: affs: use loff_t in affs_truncate()

It seems pretty unlikely that AFFS supports files over 4GB but we may as
well leave use loff_t just for cleanness sake instead of truncating it to
32 bits.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/affs/file.c~affs-use-loff_t-in-affs_truncate fs/affs/file.c
--- a/fs/affs/file.c~affs-use-loff_t-in-affs_truncate
+++ a/fs/affs/file.c
@@ -836,7 +836,7 @@ affs_truncate(struct inode *inode)
 		struct address_space *mapping = inode->i_mapping;
 		struct page *page;
 		void *fsdata;
-		u32 size = inode->i_size;
+		loff_t size = inode->i_size;
 		int res;
 
 		res = mapping->a_ops->write_begin(NULL, mapping, size, 0, 0, &page, &fsdata);
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
nilfs2-remove-double-bio_put-in-nilfs_end_bio_write-for-bio_eopnotsupp-error.patch
nilfs2-fix-issue-with-counting-number-of-bio-requests-for-bio_eopnotsupp-error-detection.patch
ocfs2-use-list_for_each_entry-instead-of-list_for_each.patch
ocfs2-use-list_for_each_entry-instead-of-list_for_each-fix.patch
efs-iget_locked-doesnt-return-an-err_ptr.patch
affs-use-loff_t-in-affs_truncate.patch
bfs-iget_locked-doesnt-return-an-err_ptr.patch
pktcdvd-convert-printk-to-pr_level.patch
pktcdvd-fix-defective-misuses-of-pkt_level.patch
linux-next.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix.patch

