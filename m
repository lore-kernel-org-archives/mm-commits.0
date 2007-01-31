From: akpm@osdl.org
Subject: + simplify-shmem_aopsset_page_dirty-method.patch added to -mm tree
Date: Wed, 31 Jan 2007 15:49:05 -0800
Message-ID: <200701312349.l0VNn5ig030362@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59333 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161064AbXAaXtV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Jan 2007 18:49:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kenchen@google.com, a.p.zijlstra@chello.nl, hugh@veritas.com


The patch titled
     simplify shmem_aops.set_page_dirty() method
has been added to the -mm tree.  Its filename is
     simplify-shmem_aopsset_page_dirty-method.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: simplify shmem_aops.set_page_dirty() method
From: "Ken Chen" <kenchen@google.com>

shmem backed file does not have page writeback, nor it participates in
backing device's dirty or writeback accounting.  So using generic
__set_page_dirty_nobuffers() for its .set_page_dirty aops method is a bit
overkill.  It unnecessarily prolongs shm unmap latency.

For example, on a densely populated large shm segment (sevearl GBs), the
unmapping operation becomes painfully long.  Because at unmap, kernel
transfers dirty bit in PTE into page struct and to the radix tree tag.  The
operation of tagging the radix tree is particularly expensive because it
has to traverse the tree from the root to the leaf node on every dirty
page.  What's bothering is that radix tree tag is used for page write back.
 However, shmem is memory backed and there is no page write back for such
file system.  And in the end, we spend all that time tagging radix tree and
none of that fancy tagging will be used.  So let's simplify it by introduce
a new aops __set_page_dirty_no_writeback and this will speed up shm unmap.

Signed-off-by: Ken Chen <kenchen@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/mm.h  |    1 +
 mm/page-writeback.c |   10 ++++++++++
 mm/shmem.c          |    2 +-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff -puN include/linux/mm.h~simplify-shmem_aopsset_page_dirty-method include/linux/mm.h
--- a/include/linux/mm.h~simplify-shmem_aopsset_page_dirty-method
+++ a/include/linux/mm.h
@@ -785,6 +785,7 @@ extern int try_to_release_page(struct pa
 extern void do_invalidatepage(struct page *page, unsigned long offset);
 
 int __set_page_dirty_nobuffers(struct page *page);
+int __set_page_dirty_no_writeback(struct page *page);
 int redirty_page_for_writepage(struct writeback_control *wbc,
 				struct page *page);
 int FASTCALL(set_page_dirty(struct page *page));
diff -puN mm/page-writeback.c~simplify-shmem_aopsset_page_dirty-method mm/page-writeback.c
--- a/mm/page-writeback.c~simplify-shmem_aopsset_page_dirty-method
+++ a/mm/page-writeback.c
@@ -743,6 +743,16 @@ int write_one_page(struct page *page, in
 EXPORT_SYMBOL(write_one_page);
 
 /*
+ * For address_spaces which do not use buffers nor write back.
+ */
+int __set_page_dirty_no_writeback(struct page *page)
+{
+	if (!PageDirty(page))
+		SetPageDirty(page);
+	return 0;
+}
+
+/*
  * For address_spaces which do not use buffers.  Just tag the page as dirty in
  * its radix tree.
  *
diff -puN mm/shmem.c~simplify-shmem_aopsset_page_dirty-method mm/shmem.c
--- a/mm/shmem.c~simplify-shmem_aopsset_page_dirty-method
+++ a/mm/shmem.c
@@ -2315,7 +2315,7 @@ static void destroy_inodecache(void)
 
 static const struct address_space_operations shmem_aops = {
 	.writepage	= shmem_writepage,
-	.set_page_dirty	= __set_page_dirty_nobuffers,
+	.set_page_dirty	= __set_page_dirty_no_writeback,
 #ifdef CONFIG_TMPFS
 	.prepare_write	= shmem_prepare_write,
 	.commit_write	= simple_commit_write,
_

Patches currently in -mm which might be from kenchen@google.com are

simplify-shmem_aopsset_page_dirty-method.patch
convert-ramfs-to-use-__set_page_dirty_no_writeback.patch
