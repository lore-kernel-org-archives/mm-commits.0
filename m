From: akpm@linux-foundation.org
Subject: [merged] nilfs2-fix-using-of-pagelocked-in-nilfs_clear_dirty_page.patch removed from -mm tree
Date: Tue, 07 May 2013 10:48:36 -0700
Message-ID: <20130507174836.75B8C31C1EC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:63048 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856Ab3EGRsi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:48:38 -0400
Received: by mail-gg0-f201.google.com with SMTP id k25so85187ggl.4
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:48:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: slava@dubeyko.com, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix using of PageLocked() in nilfs_clear_dirty_page()
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-using-of-pagelocked-in-nilfs_clear_dirty_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: nilfs2: fix using of PageLocked() in nilfs_clear_dirty_page()

Change test_bit(PG_locked, &page->flags) to PageLocked().

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/page.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nilfs2/page.c~nilfs2-fix-using-of-pagelocked-in-nilfs_clear_dirty_page fs/nilfs2/page.c
--- a/fs/nilfs2/page.c~nilfs2-fix-using-of-pagelocked-in-nilfs_clear_dirty_page
+++ a/fs/nilfs2/page.c
@@ -407,7 +407,7 @@ void nilfs_clear_dirty_page(struct page
 	struct inode *inode = page->mapping->host;
 	struct super_block *sb = inode->i_sb;
 
-	BUG_ON(!test_bit(PG_locked, &page->flags));
+	BUG_ON(!PageLocked(page));
 
 	if (!silent) {
 		nilfs_warning(sb, __func__,
_

Patches currently in -mm which might be from slava@dubeyko.com are

origin.patch

