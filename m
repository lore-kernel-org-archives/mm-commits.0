From: akpm@linux-foundation.org
Subject: [merged] fs-inodec-use-atomic_inc_return-in-__iget.patch removed from -mm tree
Date: Wed, 19 May 2010 12:35:15 -0700
Message-ID: <201005191935.o4JJZF6s031669@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750859Ab0ESTgK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 15:36:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@rsk.demon.co.uk, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fs: inode.c use atomic_inc_return in __iget
has been removed from the -mm tree.  Its filename was
     fs-inodec-use-atomic_inc_return-in-__iget.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: inode.c use atomic_inc_return in __iget
From: Richard Kennedy <richard@rsk.demon.co.uk>

Using atomic_inc_return in __iget(struct inode *inode) makes the intent of
this code clearer and generates less code on processors that have this
operation.

On x86_64 this patch reduces the text size of inode.o by 12 bytes.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/inode.c~fs-inodec-use-atomic_inc_return-in-__iget fs/inode.c
--- a/fs/inode.c~fs-inodec-use-atomic_inc_return-in-__iget
+++ a/fs/inode.c
@@ -286,11 +286,9 @@ static void init_once(void *foo)
  */
 void __iget(struct inode *inode)
 {
-	if (atomic_read(&inode->i_count)) {
-		atomic_inc(&inode->i_count);
+	if (atomic_inc_return(&inode->i_count) != 1)
 		return;
-	}
-	atomic_inc(&inode->i_count);
+
 	if (!(inode->i_state & (I_DIRTY|I_SYNC)))
 		list_move(&inode->i_list, &inode_in_use);
 	inodes_stat.nr_unused--;
_

Patches currently in -mm which might be from richard@rsk.demon.co.uk are

linux-next.patch
fs-inodec-use-atomic_inc_return-in-__iget.patch
buffer_head-remove-redundant-test-from-wait_on_buffer.patch
buffer_head-remove-redundant-test-from-wait_on_buffer-fix.patch
wait_on_buffer-remove-the-buffer_locked-test.patch
fs-writeback-check-sync-bit-earlier-in-inode_wait_for_writeback.patch

