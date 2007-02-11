From: akpm@linux-foundation.org
Subject: - convert-ramfs-to-use-__set_page_dirty_no_writeback.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:46:54 -0800
Message-ID: <200702112246.l1BMksJR015524@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59973 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932741AbXBKWuN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:50:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kenchen@google.com, a.p.zijlstra@chello.nl, hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     convert ramfs to use __set_page_dirty_no_writeback
has been removed from the -mm tree.  Its filename was
     convert-ramfs-to-use-__set_page_dirty_no_writeback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: convert ramfs to use __set_page_dirty_no_writeback
From: "Ken Chen" <kenchen@google.com>

As pointed out by Hugh, ramfs would also benefit from using the new
set_page_dirty aop method for memory backed file systems.

Signed-off-by: Ken Chen <kenchen@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/file-mmu.c   |    2 +-
 fs/ramfs/file-nommu.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ramfs/file-mmu.c~convert-ramfs-to-use-__set_page_dirty_no_writeback fs/ramfs/file-mmu.c
--- a/fs/ramfs/file-mmu.c~convert-ramfs-to-use-__set_page_dirty_no_writeback
+++ a/fs/ramfs/file-mmu.c
@@ -31,7 +31,7 @@ const struct address_space_operations ra
 	.readpage	= simple_readpage,
 	.prepare_write	= simple_prepare_write,
 	.commit_write	= simple_commit_write,
-	.set_page_dirty = __set_page_dirty_nobuffers,
+	.set_page_dirty = __set_page_dirty_no_writeback,
 };
 
 const struct file_operations ramfs_file_operations = {
diff -puN fs/ramfs/file-nommu.c~convert-ramfs-to-use-__set_page_dirty_no_writeback fs/ramfs/file-nommu.c
--- a/fs/ramfs/file-nommu.c~convert-ramfs-to-use-__set_page_dirty_no_writeback
+++ a/fs/ramfs/file-nommu.c
@@ -32,7 +32,7 @@ const struct address_space_operations ra
 	.readpage		= simple_readpage,
 	.prepare_write		= simple_prepare_write,
 	.commit_write		= simple_commit_write,
-	.set_page_dirty = __set_page_dirty_nobuffers,
+	.set_page_dirty		= __set_page_dirty_no_writeback,
 };
 
 const struct file_operations ramfs_file_operations = {
_

Patches currently in -mm which might be from kenchen@google.com are

origin.patch
