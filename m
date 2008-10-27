From: akpm@linux-foundation.org
Subject: + ocfs2-truncate-outstanding-block-after-direct-io-failure.patch added to -mm tree
Date: Sun, 26 Oct 2008 21:54:25 -0700
Message-ID: <200810270454.m9R4sPHH022825@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46073 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750735AbYJ0Eyo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 00:54:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmonakhov@openvz.org, Joel.Becker@oracle.com, jmoyer@redhat.com, mark.fasheh@oracle.com, nickpiggin@yahoo.com.au


The patch titled
     ocfs2: truncate outstanding block after direct io failure
has been added to the -mm tree.  Its filename is
     ocfs2-truncate-outstanding-block-after-direct-io-failure.patch

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

ocfs2-truncate-outstanding-block-after-direct-io-failure.patch
kill-suid-bit-only-for-regular-files.patch
fs-truncate-blocks-outside-i_size-after-generic_file_direct_write-error.patch
fs-truncate-blocks-outside-i_size-after-generic_file_direct_write-error-fix.patch

