From: akpm@linux-foundation.org
Subject: [merged] nilfs2-remove-unneeded-test-in-nilfs_writepage.patch removed from -mm tree
Date: Tue, 07 May 2013 10:48:39 -0700
Message-ID: <20130507174839.875F95A41B9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:51271 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856Ab3EGRsk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:48:40 -0400
Received: by mail-ve0-f201.google.com with SMTP id m1so85087ves.4
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:48:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: slava@dubeyko.com, dan.carpenter@oracle.com, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: remove unneeded test in nilfs_writepage()
has been removed from the -mm tree.  Its filename was
     nilfs2-remove-unneeded-test-in-nilfs_writepage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: nilfs2: remove unneeded test in nilfs_writepage()

page->mapping->host cannot be NULL in nilfs_writepage(), so remove the
unneeded test.

The fixes the smatch warning: "fs/nilfs2/inode.c:211 nilfs_writepage()
error: we previously assumed 'inode' could be null (see line 195)".

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nilfs2/inode.c~nilfs2-remove-unneeded-test-in-nilfs_writepage fs/nilfs2/inode.c
--- a/fs/nilfs2/inode.c~nilfs2-remove-unneeded-test-in-nilfs_writepage
+++ a/fs/nilfs2/inode.c
@@ -192,7 +192,7 @@ static int nilfs_writepage(struct page *
 	struct inode *inode = page->mapping->host;
 	int err;
 
-	if (inode && (inode->i_sb->s_flags & MS_RDONLY)) {
+	if (inode->i_sb->s_flags & MS_RDONLY) {
 		/*
 		 * It means that filesystem was remounted in read-only
 		 * mode because of error or metadata corruption. But we
_

Patches currently in -mm which might be from slava@dubeyko.com are

origin.patch

