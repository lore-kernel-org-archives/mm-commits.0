From: akpm@linux-foundation.org
Subject: [folded-merged]
 fs-nilfs2-fix-integer-overflow-in-nilfs_ioctl_wrap_copy-fix.patch removed
 from -mm tree
Date: Thu, 23 Jan 2014 15:27:59 -0800
Message-ID: <52e1a57f.//9f9DIgF0AZQNqu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37247 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbaAWX2A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jan 2014 18:28:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, slava@dubeyko.com, fanwlexca@gmail.com, konishi.ryusuke@lab.ntt.co.jp

Subject: [folded-merged] fs-nilfs2-fix-integer-overflow-in-nilfs_ioctl_wrap_copy-fix.patch removed from -mm tree
To: konishi.ryusuke@lab.ntt.co.jp,fanwlexca@gmail.com,slava@dubeyko.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 23 Jan 2014 15:27:59 -0800


The patch titled
     Subject: fs-nilfs2-fix-integer-overflow-in-nilfs_ioctl_wrap_copy-fix
has been removed from the -mm tree.  Its filename was
     fs-nilfs2-fix-integer-overflow-in-nilfs_ioctl_wrap_copy-fix.patch

This patch was dropped because it was folded into fs-nilfs2-fix-integer-overflow-in-nilfs_ioctl_wrap_copy.patch

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: fs-nilfs2-fix-integer-overflow-in-nilfs_ioctl_wrap_copy-fix

Signed-off-by: Wenliang Fan <fanwlexca@gmail.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/ioctl.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN fs/nilfs2/ioctl.c~fs-nilfs2-fix-integer-overflow-in-nilfs_ioctl_wrap_copy-fix fs/nilfs2/ioctl.c
--- a/fs/nilfs2/ioctl.c~fs-nilfs2-fix-integer-overflow-in-nilfs_ioctl_wrap_copy-fix
+++ a/fs/nilfs2/ioctl.c
@@ -57,7 +57,12 @@ static int nilfs_ioctl_wrap_copy(struct
 	if (argv->v_size > PAGE_SIZE)
 		return -EINVAL;
 
-	if (argv->v_index > (~(__u64)0 - argv->v_nmembs))
+	/*
+	 * Reject pairs of a start item position (argv->v_index) and a
+	 * total count (argv->v_nmembs) which leads position 'pos' to
+	 * overflow by the increment at the end of the loop.
+	 */
+	if (argv->v_index > ~(__u64)0 - argv->v_nmembs)
 		return -EINVAL;
 
 	buf = (void *)__get_free_pages(GFP_NOFS, 0);
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

fs-nilfs2-fix-integer-overflow-in-nilfs_ioctl_wrap_copy.patch
nilfs2-add-comments-for-ioctls.patch

