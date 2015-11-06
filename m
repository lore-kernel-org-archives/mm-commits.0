From: akpm@linux-foundation.org
Subject: + fs-fix-writebackc-kernel-doc-warnings.patch added to -mm tree
Date: Fri, 06 Nov 2015 14:48:30 -0800
Message-ID: <563d2e3e.kbdEdZo8h1aMmC0o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51299 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757635AbbKFWsb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 17:48:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/writeback.c: fix kernel-doc warnings
has been added to the -mm tree.  Its filename is
     fs-fix-writebackc-kernel-doc-warnings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-fix-writebackc-kernel-doc-warnings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-fix-writebackc-kernel-doc-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: fs/writeback.c: fix kernel-doc warnings

Fix kernel-doc warnings in fs/fs-writeback.c by moving a #define macro to
after the function's opening brace.  Also #undef this macro at the end of
the function.

..//fs/fs-writeback.c:1984: warning: Excess function parameter 'inode' description in 'I_DIRTY_INODE'
..//fs/fs-writeback.c:1984: warning: Excess function parameter 'flags' description in 'I_DIRTY_INODE'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/fs-writeback.c~fs-fix-writebackc-kernel-doc-warnings fs/fs-writeback.c
--- a/fs/fs-writeback.c~fs-fix-writebackc-kernel-doc-warnings
+++ a/fs/fs-writeback.c
@@ -1981,9 +1981,9 @@ static noinline void block_dump___mark_i
  * page->mapping->host, so the page-dirtying time is recorded in the internal
  * blockdev inode.
  */
-#define I_DIRTY_INODE (I_DIRTY_SYNC | I_DIRTY_DATASYNC)
 void __mark_inode_dirty(struct inode *inode, int flags)
 {
+#define I_DIRTY_INODE (I_DIRTY_SYNC | I_DIRTY_DATASYNC)
 	struct super_block *sb = inode->i_sb;
 	int dirtytime;
 
@@ -2093,6 +2093,7 @@ void __mark_inode_dirty(struct inode *in
 out_unlock_inode:
 	spin_unlock(&inode->i_lock);
 
+#undef I_DIRTY_INODE
 }
 EXPORT_SYMBOL(__mark_inode_dirty);
 
_

Patches currently in -mm which might be from rdunlap@infradead.org are

fs-fix-inodec-kernel-doc-warning.patch
fs-fix-writebackc-kernel-doc-warnings.patch

