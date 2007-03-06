From: akpm@linux-foundation.org
Subject: - reiser4-vs-streamline-generic_file_-interfaces-and-filemap.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:59:46 -0800
Message-ID: <200703060159.l261xkFx008642@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46571 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965686AbXCFB7w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:59:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laurent.riffard@free.fr, vs@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiser4 vs streamline-generic_file_-interfaces-and-filemap
has been removed from the -mm tree.  Its filename was
     reiser4-vs-streamline-generic_file_-interfaces-and-filemap.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: reiser4 vs streamline-generic_file_-interfaces-and-filemap
From: Laurent Riffard <laurent.riffard@free.fr>

generic_file_read has been dropped from 2.6.18-rc1-mm1.  This patch works
for me.

Signed-off-by: Laurent Riffard <laurent.riffard@free.fr>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/plugin/file/cryptcompress.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/reiser4/plugin/file/cryptcompress.c~reiser4-vs-streamline-generic_file_-interfaces-and-filemap fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~reiser4-vs-streamline-generic_file_-interfaces-and-filemap
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -2883,7 +2883,7 @@ ssize_t read_cryptcompress(struct file *
 	down_read(&info->lock);
 	LOCK_CNT_INC(inode_sem_r);
 
-	result = generic_file_read(file, buf, size, off);
+	result = do_sync_read(file, buf, size, off);
 
 	up_read(&info->lock);
 	LOCK_CNT_DEC(inode_sem_r);
_

Patches currently in -mm which might be from laurent.riffard@free.fr are

reiser4.patch
reiser4-vs-streamline-generic_file_-interfaces-and-filemap.patch
