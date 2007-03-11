From: akpm@linux-foundation.org
Subject: + xfs-stop-using-kmalloc-in-xfs_buf_get_noaddr-fix.patch added to -mm tree
Date: Sun, 11 Mar 2007 00:54:46 -0800
Message-ID: <200703110854.l2B8sjq8008189@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40462 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809AbXCKIzA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 04:55:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de


The patch titled
     xfs: stop using kmalloc in xfs_buf_get_noaddr (fix)
has been added to the -mm tree.  Its filename is
     xfs-stop-using-kmalloc-in-xfs_buf_get_noaddr-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: xfs: stop using kmalloc in xfs_buf_get_noaddr (fix)
From: Christoph Hellwig <hch@lst.de>

Ed Cashin found a bug in the error handling code for the case where
a page allocation fails.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/linux-2.6/xfs_buf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/xfs/linux-2.6/xfs_buf.c~xfs-stop-using-kmalloc-in-xfs_buf_get_noaddr-fix fs/xfs/linux-2.6/xfs_buf.c
--- a/fs/xfs/linux-2.6/xfs_buf.c~xfs-stop-using-kmalloc-in-xfs_buf_get_noaddr-fix
+++ a/fs/xfs/linux-2.6/xfs_buf.c
@@ -790,7 +790,7 @@ xfs_buf_get_noaddr(
 	return bp;
 
  fail_free_mem:
- 	for ( ; i >= 0; i++)
+ 	for ( ; i >= 0; i--)
 		__free_page(bp->b_pages[i]);
  fail_free_buf:
 	xfs_buf_free(bp);
_

Patches currently in -mm which might be from hch@lst.de are

ufs2-tindirect-truncate-fix.patch
xfs-use-xfs_get_buf_noaddr-for-iclogs.patch
xfs-stop-using-kmalloc-in-xfs_buf_get_noaddr.patch
xfs-stop-using-kmalloc-in-xfs_buf_get_noaddr-fix.patch
simplify-the-stacktrace-code.patch
allow-access-to-proc-pid-fd-after-setuid.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
freevxfs-possible-null-pointer-dereference-fix.patch
vfs-remove-superflous-sb-==-null-checks.patch
nameic-remove-utterly-outdated-comment.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
change-libfs-sb-creation-routines-to-avoid-collisions-with-their-root-inodes.patch
aio-is-unlikely.patch
ps3fb-thread-updates.patch
ps3av-thread-updates.patch
ps3fb-kill-superfluous-zero-initializations.patch
ps3av-misc-updates.patch
