From: akpm@osdl.org
Subject: + convert-ramfs-to-use-__set_page_dirty_no_writeback.patch added to -mm tree
Date: Wed, 31 Jan 2007 15:49:18 -0800
Message-ID: <200701312349.l0VNnIDd030368@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59350 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161098AbXAaXtb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Jan 2007 18:49:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kenchen@google.com, a.p.zijlstra@chello.nl, hugh@veritas.com


The patch titled
     convert ramfs to use __set_page_dirty_no_writeback
has been added to the -mm tree.  Its filename is
     convert-ramfs-to-use-__set_page_dirty_no_writeback.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: convert ramfs to use __set_page_dirty_no_writeback
From: "Ken Chen" <kenchen@google.com>

As pointed out by Hugh, ramfs would also benefit from using the new
set_page_dirty aop method for memory backed file systems.

Signed-off-by: Ken Chen <kenchen@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
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

simplify-shmem_aopsset_page_dirty-method.patch
convert-ramfs-to-use-__set_page_dirty_no_writeback.patch
