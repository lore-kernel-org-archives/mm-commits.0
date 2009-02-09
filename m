From: akpm@linux-foundation.org
Subject: [merged] vfs-dont-call-attach_nobh_buffers-with-an-empty-list.patch removed from -mm tree
Date: Mon, 09 Feb 2009 12:05:19 -0800
Message-ID: <200902092005.n19K5Jwe024361@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751860AbZBIULE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 15:11:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaggy@linux.vnet.ibm.com, dmonakhov@openvz.org, nickpiggin@yahoo.com.au, wfp5p@virginia.edu, mm-commits@vger.kernel.org


The patch titled
     vfs: don't call attach_nobh_buffers() with an empty list
has been removed from the -mm tree.  Its filename was
     vfs-dont-call-attach_nobh_buffers-with-an-empty-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: don't call attach_nobh_buffers() with an empty list
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

This is a modification of a patch by Bill Pemberton.

nobh_write_end() could call attach_nobh_buffers() with head == NULL.  This
would result in a trap when attach_nobh_buffers() attempted to access
bh->b_this_page.

This can be illustrated by running the writev01 testcase from LTP on jfs.

This error was introduced by commit 5b41e74a "vfs: fix data leak in
nobh_write_end()".  That patch did not take into account that if
PageMappedToDisk() is true upon entry to nobh_write_begin(), then no
buffers will be allocated for the page.  In that case, we won't have to
worry about a failed write leaving unitialized data in the page.

Of course, head != NULL implies !page_has_buffers(page), so no need to
test both.

Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Bill Pemberton <wfp5p@virginia.edu>
Cc: Dmitri Monakhov <dmonakhov@openvz.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/buffer.c~vfs-dont-call-attach_nobh_buffers-with-an-empty-list fs/buffer.c
--- a/fs/buffer.c~vfs-dont-call-attach_nobh_buffers-with-an-empty-list
+++ a/fs/buffer.c
@@ -2688,7 +2688,7 @@ int nobh_write_end(struct file *file, st
 	struct buffer_head *bh;
 	BUG_ON(fsdata != NULL && page_has_buffers(page));
 
-	if (unlikely(copied < len) && !page_has_buffers(page))
+	if (unlikely(copied < len) && head)
 		attach_nobh_buffers(page, head);
 	if (page_has_buffers(page))
 		return generic_write_end(file, mapping, pos, len,
_

Patches currently in -mm which might be from shaggy@linux.vnet.ibm.com are

linux-next.patch

