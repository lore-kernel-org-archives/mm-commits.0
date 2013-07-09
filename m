From: akpm@linux-foundation.org
Subject: [merged]
 page-migration-fix-wrong-comment-in-address_space_operationsmigratepage.patch removed from -mm tree
Date: Tue, 09 Jul 2013 16:20:21 -0700
Message-ID: <51dc9ab5.x3yIEH01Gb+ywrJr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38907 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab3GIXUV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:20:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tangchen@cn.fujitsu.com

Subject: [merged] page-migration-fix-wrong-comment-in-address_space_operationsmigratepage.patch removed from -mm tree
To: tangchen@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:20:21 -0700


The patch titled
     Subject: page migration: fix wrong comment in address_space_operations.migratepage()
has been removed from the -mm tree.  Its filename was
     page-migration-fix-wrong-comment-in-address_space_operationsmigratepage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: page migration: fix wrong comment in address_space_operations.migratepage()

There is no parameter "sync" in address_space_operations->migratepage(). 
It should be mograte_mode.  And the comment is for MIGRATE_ASYNC.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/fs.h~page-migration-fix-wrong-comment-in-address_space_operationsmigratepage include/linux/fs.h
--- a/include/linux/fs.h~page-migration-fix-wrong-comment-in-address_space_operationsmigratepage
+++ a/include/linux/fs.h
@@ -372,8 +372,8 @@ struct address_space_operations {
 	int (*get_xip_mem)(struct address_space *, pgoff_t, int,
 						void **, unsigned long *);
 	/*
-	 * migrate the contents of a page to the specified target. If sync
-	 * is false, it must not block.
+	 * migrate the contents of a page to the specified target. If
+	 * migrate_mode is MIGRATE_ASYNC, it must not block.
 	 */
 	int (*migratepage) (struct address_space *,
 			struct page *, struct page *, enum migrate_mode);
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

origin.patch

