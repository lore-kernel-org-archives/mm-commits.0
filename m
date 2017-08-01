From: akpm@linux-foundation.org
Subject: [merged]
 mm-remove-optimizations-based-on-i_size-in-mapping-writeback-waits.patch
 removed from -mm tree
Date: Tue, 01 Aug 2017 12:38:14 -0700
Message-ID: <20170801193814.Lr2-XPxXx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48320 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752044AbdHATiP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Aug 2017 15:38:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, jlayton@redhat.com, marcelo.tosatti@cyclades.com, mm-commits@vger.kernel.org, mtosatti@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: mm: remove optimizations based on i_size in mapping writeback waits
has been removed from the -mm tree.  Its filename was
     mm-remove-optimizations-based-on-i_size-in-mapping-writeback-waits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jeff Layton <jlayton@redhat.com>
Subject: mm: remove optimizations based on i_size in mapping writeback waits

Marcelo added this i_size based optimization with a patch in 2004 (commit
765dad09b4ac in the linux-history tree):

    commit 765dad09b4ac101a32d87af2bb793c3060497d3c
    Author: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
    Date:   Tue Sep 7 17:51:17 2004 -0700

	small wait_on_page_writeback_range() optimization

	filemap_fdatawait() calls wait_on_page_writeback_range() with -1
	as "end" parameter.  This is not needed since we know the EOF
	from the inode.  Use that instead.

There may be races here, particularly with clustered or network
filesystems.  Block devices always have an i_size of 0 as well, which
makes using this with a blockdev inode sort of pointless.

It also seems like a bit of a layering violation since we're operating on
an address_space here, not an inode.

Finally, it's also questionable whether this optimization really helps on
workloads that we care about.  Should we be optimizing for writeback vs. 
truncate races in a codepath where we expect to wait anyway?  It doesn't
seem worth the risk.

Remove this optimization from the filemap_fdatawait codepaths.  This means
that filemap_fdatawait becomes a trivial wrapper around
filemap_fdatawait_range.

Link: http://lkml.kernel.org/r/20170731152946.13976-1-jlayton@kernel.org
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    9 +++++++--
 mm/filemap.c       |   30 +-----------------------------
 2 files changed, 8 insertions(+), 31 deletions(-)

diff -puN include/linux/fs.h~mm-remove-optimizations-based-on-i_size-in-mapping-writeback-waits include/linux/fs.h
--- a/include/linux/fs.h~mm-remove-optimizations-based-on-i_size-in-mapping-writeback-waits
+++ a/include/linux/fs.h
@@ -2542,10 +2542,15 @@ extern int invalidate_inode_pages2_range
 extern int write_inode_now(struct inode *, int);
 extern int filemap_fdatawrite(struct address_space *);
 extern int filemap_flush(struct address_space *);
-extern int filemap_fdatawait(struct address_space *);
-extern int filemap_fdatawait_keep_errors(struct address_space *mapping);
 extern int filemap_fdatawait_range(struct address_space *, loff_t lstart,
 				   loff_t lend);
+extern int filemap_fdatawait_keep_errors(struct address_space *mapping);
+
+static inline int filemap_fdatawait(struct address_space *mapping)
+{
+	return filemap_fdatawait_range(mapping, 0, LLONG_MAX);
+}
+
 extern bool filemap_range_has_page(struct address_space *, loff_t lstart,
 				  loff_t lend);
 extern int __must_check file_fdatawait_range(struct file *file, loff_t lstart,
diff -puN mm/filemap.c~mm-remove-optimizations-based-on-i_size-in-mapping-writeback-waits mm/filemap.c
--- a/mm/filemap.c~mm-remove-optimizations-based-on-i_size-in-mapping-writeback-waits
+++ a/mm/filemap.c
@@ -500,39 +500,11 @@ EXPORT_SYMBOL(file_fdatawait_range);
  */
 int filemap_fdatawait_keep_errors(struct address_space *mapping)
 {
-	loff_t i_size = i_size_read(mapping->host);
-
-	if (i_size == 0)
-		return 0;
-
-	__filemap_fdatawait_range(mapping, 0, i_size - 1);
+	__filemap_fdatawait_range(mapping, 0, LLONG_MAX);
 	return filemap_check_and_keep_errors(mapping);
 }
 EXPORT_SYMBOL(filemap_fdatawait_keep_errors);
 
-/**
- * filemap_fdatawait - wait for all under-writeback pages to complete
- * @mapping: address space structure to wait for
- *
- * Walk the list of under-writeback pages of the given address space
- * and wait for all of them.  Check error status of the address space
- * and return it.
- *
- * Since the error status of the address space is cleared by this function,
- * callers are responsible for checking the return value and handling and/or
- * reporting the error.
- */
-int filemap_fdatawait(struct address_space *mapping)
-{
-	loff_t i_size = i_size_read(mapping->host);
-
-	if (i_size == 0)
-		return 0;
-
-	return filemap_fdatawait_range(mapping, 0, i_size - 1);
-}
-EXPORT_SYMBOL(filemap_fdatawait);
