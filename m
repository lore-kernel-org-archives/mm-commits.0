From: akpm@linux-foundation.org
Subject: [merged] mm-fir-truncate_setsize-comment.patch removed from -mm tree
Date: Fri, 21 Jan 2011 12:31:47 -0800
Message-ID: <201101212031.p0LKVlYl031653@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751577Ab1AUUll (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Jan 2011 15:41:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, hch@infradead.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     mm: fix truncate_setsize() comment
has been removed from the -mm tree.  Its filename was
     mm-fir-truncate_setsize-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix truncate_setsize() comment
From: Jan Kara <jack@suse.cz>

Contrary to what the comment says, truncate_setsize() should be called
*before* filesystem truncated blocks.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN mm/truncate.c~mm-fir-truncate_setsize-comment mm/truncate.c
--- a/mm/truncate.c~mm-fir-truncate_setsize-comment
+++ a/mm/truncate.c
@@ -549,13 +549,12 @@ EXPORT_SYMBOL(truncate_pagecache);
  * @inode: inode
  * @newsize: new file size
  *
- * truncate_setsize updastes i_size update and performs pagecache
- * truncation (if necessary) for a file size updates. It will be
- * typically be called from the filesystem's setattr function when
- * ATTR_SIZE is passed in.
+ * truncate_setsize updates i_size and performs pagecache truncation (if
+ * necessary) to @newsize. It will be typically be called from the filesystem's
+ * setattr function when ATTR_SIZE is passed in.
  *
- * Must be called with inode_mutex held and after all filesystem
- * specific block truncation has been performed.
+ * Must be called with inode_mutex held and before all filesystem specific
+ * block truncation has been performed.
  */
 void truncate_setsize(struct inode *inode, loff_t newsize)
 {
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
linux-next.patch

