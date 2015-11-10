From: akpm@linux-foundation.org
Subject: [merged] fs-exofs-remove-unnecessary-new_valid_dev-check.patch
 removed from -mm tree
Date: Tue, 10 Nov 2015 12:33:26 -0800
Message-ID: <56425496.JTApLyEzDXJj5o0X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34071 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbbKJUd0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Nov 2015 15:33:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, bhalevy@primarydata.com, ooo@electrozaur.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/exofs/namei.c: remove unnecessary new_valid_dev() check
has been removed from the -mm tree.  Its filename was
     fs-exofs-remove-unnecessary-new_valid_dev-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <bywxiaobai@163.com>
Subject: fs/exofs/namei.c: remove unnecessary new_valid_dev() check

new_valid_dev() always returns 1, so the !new_valid_dev() check is not
needed.  Remove it.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Acked-by: Boaz Harrosh <ooo@electrozaur.com>
Cc: Benny Halevy <bhalevy@primarydata.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exofs/namei.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/exofs/namei.c~fs-exofs-remove-unnecessary-new_valid_dev-check fs/exofs/namei.c
--- a/fs/exofs/namei.c~fs-exofs-remove-unnecessary-new_valid_dev-check
+++ a/fs/exofs/namei.c
@@ -80,9 +80,6 @@ static int exofs_mknod(struct inode *dir
 	struct inode *inode;
 	int err;
 
-	if (!new_valid_dev(rdev))
-		return -EINVAL;
