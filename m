From: akpm@linux-foundation.org
Subject: + ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending.patch
 added to -mm tree
Date: Tue, 23 Sep 2014 15:15:21 -0700
Message-ID: <5421f0f9.mCLxQ3AWVGxniUja%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38409 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038AbaIWWPW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Sep 2014 18:15:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangww631@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: do not fall back to buffer I/O write if appending
has been added to the -mm tree.  Its filename is
     ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: WeiWei Wang <wangww631@huawei.com>
Subject: ocfs2: do not fall back to buffer I/O write if appending

After enabling block allocation in direct-io write, we don't fall back to
buffer I/O write in append write situation any more.  If the O_DIRECT flag
is taken, we use direct-io.

Signed-off-by: Weiwei Wang <wangww631@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |    4 ----
 fs/ocfs2/file.c |   11 -----------
 2 files changed, 15 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending
+++ a/fs/ocfs2/aops.c
@@ -663,10 +663,6 @@ static ssize_t ocfs2_direct_IO(int rw,
 	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
 		return 0;
 
-	/* Fallback to buffered I/O if we are appending. */
-	if (i_size_read(inode) <= offset)
-		return 0;
-
 	if (rw == WRITE) {
 		loff_t final_size = offset + count;
 		/*
diff -puN fs/ocfs2/file.c~ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending
+++ a/fs/ocfs2/file.c
@@ -2189,17 +2189,6 @@ static int ocfs2_prepare_inode_for_write
 		}
 
 		/*
-		 * Allowing concurrent direct writes means
-		 * i_size changes wouldn't be synchronized, so
-		 * one node could wind up truncating another
-		 * nodes writes.
-		 */
-		if (end > i_size_read(inode)) {
-			*direct_io = 0;
-			break;
-		}
