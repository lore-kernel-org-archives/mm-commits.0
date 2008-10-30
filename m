From: akpm@linux-foundation.org
Subject: - ocfs2-truncate-outstanding-block-after-direct-io-failure.patch removed from -mm tree
Date: Thu, 30 Oct 2008 12:04:56 -0700
Message-ID: <200810301904.m9UJ4urn024991@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756450AbYJ3TFQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 15:05:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmonakhov@openvz.org, Joel.Becker@oracle.com, jmoyer@redhat.com, mark.fasheh@oracle.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     ocfs2: truncate outstanding block after direct io failure
has been removed from the -mm tree.  Its filename was
     ocfs2-truncate-outstanding-block-after-direct-io-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ocfs2: truncate outstanding block after direct io failure
From: Dmitri Monakhov <dmonakhov@openvz.org>

Signed-off-by: Dmitri Monakhov <dmonakhov@openvz.org>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Joel Becker <Joel.Becker@oracle.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN fs/ocfs2/file.c~ocfs2-truncate-outstanding-block-after-direct-io-failure fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-truncate-outstanding-block-after-direct-io-failure
+++ a/fs/ocfs2/file.c
@@ -1866,6 +1866,13 @@ relock:
 		written = generic_file_direct_write(iocb, iov, &nr_segs, *ppos,
 						    ppos, count, ocount);
 		if (written < 0) {
+			/*
+			 * direct write may have instantiated a few
+			 * blocks outside i_size. Trim these off again.
+			 * Don't need i_size_read because we hold i_mutex.
+			 */
+			if (*ppos + count > inode->i_size)
+				vmtruncate(inode, inode->i_size);
 			ret = written;
 			goto out_dio;
 		}
_

Patches currently in -mm which might be from dmonakhov@openvz.org are

linux-next.patch
kill-suid-bit-only-for-regular-files.patch
fs-truncate-blocks-outside-i_size-after-generic_file_direct_write-error.patch
fs-truncate-blocks-outside-i_size-after-generic_file_direct_write-error-fix.patch

