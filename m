From: akpm@linux-foundation.org
Subject: [patch 038/102] mm: tighten up the fault path a little
Date: Wed, 03 May 2017 14:53:29 -0700
Message-ID: <20170503215329.bmQoFSBvH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48150 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751198AbdECVxe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:53:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mawilcox@microsoft.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: mm: tighten up the fault path a little

The round_up() macro generates a couple of unnecessary instructions
in this usage:

    48cd:       49 8b 47 50             mov    0x50(%r15),%rax
    48d1:       48 83 e8 01             sub    $0x1,%rax
    48d5:       48 0d ff 0f 00 00       or     $0xfff,%rax
    48db:       48 83 c0 01             add    $0x1,%rax
    48df:       48 c1 f8 0c             sar    $0xc,%rax
    48e3:       48 39 c3                cmp    %rax,%rbx
    48e6:       72 2e                   jb     4916 <filemap_fault+0x96>

If we change round_up() to ((x) + __round_mask(x, y)) & ~__round_mask(x, y)
then GCC can see through it and remove the mask (because that would be
dead code given the subsequent shift):

    48cd:       49 8b 47 50             mov    0x50(%r15),%rax
    48d1:       48 05 ff 0f 00 00       add    $0xfff,%rax
    48d7:       48 c1 e8 0c             shr    $0xc,%rax
    48db:       48 39 c3                cmp    %rax,%rbx
    48de:       72 2e                   jb     490e <filemap_fault+0x8e>

But that's problematic because we'd evaluate 'y' twice.  Converting
round_up into an inline function prevents it from being used in other
definitions.  The easiest thing to do is just change these three usages of
round_up to use DIV_ROUND_UP.  Also add an unlikely() because GCC's
heuristic is wrong in this case.

Link: http://lkml.kernel.org/r/20170207192812.5281-1-willy@infradead.org
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/filemap.c~mm-tighten-up-the-fault-path-a-little mm/filemap.c
--- a/mm/filemap.c~mm-tighten-up-the-fault-path-a-little
+++ a/mm/filemap.c
@@ -2204,12 +2204,12 @@ int filemap_fault(struct vm_fault *vmf)
 	struct file_ra_state *ra = &file->f_ra;
 	struct inode *inode = mapping->host;
 	pgoff_t offset = vmf->pgoff;
+	pgoff_t max_off;
 	struct page *page;
-	loff_t size;
 	int ret = 0;
 
-	size = round_up(i_size_read(inode), PAGE_SIZE);
-	if (offset >= size >> PAGE_SHIFT)
+	max_off = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
+	if (unlikely(offset >= max_off))
 		return VM_FAULT_SIGBUS;
 
 	/*
@@ -2258,8 +2258,8 @@ retry_find:
 	 * Found the page and have a reference on it.
 	 * We must recheck i_size under page lock.
 	 */
-	size = round_up(i_size_read(inode), PAGE_SIZE);
-	if (unlikely(offset >= size >> PAGE_SHIFT)) {
+	max_off = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
+	if (unlikely(offset >= max_off)) {
 		unlock_page(page);
 		put_page(page);
 		return VM_FAULT_SIGBUS;
@@ -2325,7 +2325,7 @@ void filemap_map_pages(struct vm_fault *
 	struct file *file = vmf->vma->vm_file;
 	struct address_space *mapping = file->f_mapping;
 	pgoff_t last_pgoff = start_pgoff;
-	loff_t size;
+	unsigned long max_idx;
 	struct page *head, *page;
 
 	rcu_read_lock();
@@ -2371,8 +2371,8 @@ repeat:
 		if (page->mapping != mapping || !PageUptodate(page))
 			goto unlock;
 
-		size = round_up(i_size_read(mapping->host), PAGE_SIZE);
-		if (page->index >= size >> PAGE_SHIFT)
+		max_idx = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE);
+		if (page->index >= max_idx)
 			goto unlock;
 
 		if (file->f_ra.mmap_miss > 0)
_
