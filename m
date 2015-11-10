From: akpm@linux-foundation.org
Subject: [merged] fs-ext2-remove-unnecessary-new_valid_dev-check.patch
 removed from -mm tree
Date: Tue, 10 Nov 2015 12:33:28 -0800
Message-ID: <56425498.Smgv+w1VO82RlCpF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34077 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbbKJUd2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Nov 2015 15:33:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, jack@suse.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ext2/namei.c: remove unnecessary new_valid_dev() check
has been removed from the -mm tree.  Its filename was
     fs-ext2-remove-unnecessary-new_valid_dev-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <bywxiaobai@163.com>
Subject: fs/ext2/namei.c: remove unnecessary new_valid_dev() check

new_valid_dev() always returns 1, so the !new_valid_dev() check is not
needed.  Remove it.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jan Kara <jack@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/namei.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/ext2/namei.c~fs-ext2-remove-unnecessary-new_valid_dev-check fs/ext2/namei.c
--- a/fs/ext2/namei.c~fs-ext2-remove-unnecessary-new_valid_dev-check
+++ a/fs/ext2/namei.c
@@ -143,9 +143,6 @@ static int ext2_mknod (struct inode * di
 	struct inode * inode;
 	int err;
 
-	if (!new_valid_dev(rdev))
-		return -EINVAL;
