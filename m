From: akpm@linux-foundation.org
Subject: [merged] fs-stat-remove-unnecessary-new_valid_dev-check.patch
 removed from -mm tree
Date: Tue, 10 Nov 2015 12:33:43 -0800
Message-ID: <564254a7.gXTb3ua95zkABNxk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34106 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbbKJUdn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Nov 2015 15:33:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/stat.c: remove unnecessary new_valid_dev() check
has been removed from the -mm tree.  Its filename was
     fs-stat-remove-unnecessary-new_valid_dev-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <bywxiaobai@163.com>
Subject: fs/stat.c: remove unnecessary new_valid_dev() check

new_valid_dev() always returns 1, so the !new_valid_dev() check is not
needed.  Remove it.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/stat.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/stat.c~fs-stat-remove-unnecessary-new_valid_dev-check fs/stat.c
--- a/fs/stat.c~fs-stat-remove-unnecessary-new_valid_dev-check
+++ a/fs/stat.c
@@ -367,8 +367,6 @@ static long cp_new_stat64(struct kstat *
 	INIT_STRUCT_STAT64_PADDING(tmp);
 #ifdef CONFIG_MIPS
 	/* mips has weird padding, so we don't get 64 bits there */
-	if (!new_valid_dev(stat->dev) || !new_valid_dev(stat->rdev))
-		return -EOVERFLOW;
 	tmp.st_dev = new_encode_dev(stat->dev);
 	tmp.st_rdev = new_encode_dev(stat->rdev);
 #else
_

Patches currently in -mm which might be from bywxiaobai@163.com are


