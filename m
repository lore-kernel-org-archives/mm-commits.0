From: akpm@linux-foundation.org
Subject: + mm-fir-truncate_setsize-comment.patch added to -mm tree
Date: Wed, 19 Jan 2011 15:13:51 -0800
Message-ID: <201101192313.p0JNDp2h009273@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41042 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753106Ab1ASXOj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Jan 2011 18:14:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, hch@infradead.org, viro@ZenIV.linux.org.uk


The patch titled
     mm: fir truncate_setsize() comment
has been added to the -mm tree.  Its filename is
     mm-fir-truncate_setsize-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fir truncate_setsize() comment
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
@@ -559,13 +559,12 @@ EXPORT_SYMBOL(truncate_pagecache);
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

linux-next.patch
mm-fir-truncate_setsize-comment.patch

