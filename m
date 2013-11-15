From: akpm@linux-foundation.org
Subject: [merged] mm-drop-actor-argument-of-do_generic_file_read.patch
 removed from -mm tree
Date: Fri, 15 Nov 2013 12:07:14 -0800
Message-ID: <52867ef2.YMq1dYR+adPqScfH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35411 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab3KOUHP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:07:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, willy@linux.intel.com, liwanp@linux.vnet.ibm.com, hughd@google.com, dave.hansen@linux.intel.com, kirill.shutemov@linux.intel.com

Subject: [merged] mm-drop-actor-argument-of-do_generic_file_read.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,dave.hansen@linux.intel.com,hughd@google.com,liwanp@linux.vnet.ibm.com,willy@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:07:14 -0800


The patch titled
     Subject: mm: drop actor argument of do_generic_file_read()
has been removed from the -mm tree.  Its filename was
     mm-drop-actor-argument-of-do_generic_file_read.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: drop actor argument of do_generic_file_read()

There's only one caller of do_generic_file_read() and the only actor is
file_read_actor().  No reason to have a callback parameter.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/filemap.c~mm-drop-actor-argument-of-do_generic_file_read mm/filemap.c
--- a/mm/filemap.c~mm-drop-actor-argument-of-do_generic_file_read
+++ a/mm/filemap.c
@@ -1090,7 +1090,6 @@ static void shrink_readahead_size_eio(st
  * @filp:	the file to read
  * @ppos:	current file position
  * @desc:	read_descriptor
- * @actor:	read method
  *
  * This is a generic file read routine, and uses the
  * mapping->a_ops->readpage() function for the actual low-level stuff.
@@ -1099,7 +1098,7 @@ static void shrink_readahead_size_eio(st
  * of the logic when it comes to error handling etc.
  */
 static void do_generic_file_read(struct file *filp, loff_t *ppos,
-		read_descriptor_t *desc, read_actor_t actor)
+		read_descriptor_t *desc)
 {
 	struct address_space *mapping = filp->f_mapping;
 	struct inode *inode = mapping->host;
@@ -1200,13 +1199,14 @@ page_ok:
 		 * Ok, we have the page, and it's up-to-date, so
 		 * now we can copy it to user space...
 		 *
-		 * The actor routine returns how many bytes were actually used..
+		 * The file_read_actor routine returns how many bytes were
+		 * actually used..
 		 * NOTE! This may not be the same as how much of a user buffer
 		 * we filled up (we may be padding etc), so we can only update
 		 * "pos" here (the actor routine has to update the user buffer
 		 * pointers and the remaining count).
 		 */
-		ret = actor(desc, page, offset, nr);
+		ret = file_read_actor(desc, page, offset, nr);
 		offset += ret;
 		index += offset >> PAGE_CACHE_SHIFT;
 		offset &= ~PAGE_CACHE_MASK;
@@ -1479,7 +1479,7 @@ generic_file_aio_read(struct kiocb *iocb
 		if (desc.count == 0)
 			continue;
 		desc.error = 0;
-		do_generic_file_read(filp, ppos, &desc, file_read_actor);
+		do_generic_file_read(filp, ppos, &desc);
 		retval += desc.written;
 		if (desc.error) {
 			retval = retval ?: desc.error;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
x86-mm-get-aslr-work-for-hugetlb-mappings.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

