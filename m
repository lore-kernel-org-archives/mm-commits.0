From: akpm@linux-foundation.org
Subject: + ocfs2-bad-kunmap_atomic.patch added to -mm tree
Date: Tue, 24 Jul 2007 01:24:54 -0700
Message-ID: <200707240824.l6O8OsG9003993@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50697 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752427AbXGXIZE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 04:25:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jens.axboe@oracle.com, mark.fasheh@oracle.com


The patch titled
     ocfs2: bad kunmap_atomic()
has been added to the -mm tree.  Its filename is
     ocfs2-bad-kunmap_atomic.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ocfs2: bad kunmap_atomic()
From: Jens Axboe <jens.axboe@oracle.com>

kunmap_atomic() takes the virtual address, not the mapped page as
argument.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/file.c~ocfs2-bad-kunmap_atomic fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-bad-kunmap_atomic
+++ a/fs/ocfs2/file.c
@@ -2153,7 +2153,7 @@ static int ocfs2_splice_write_actor(stru
 	src = buf->ops->map(pipe, buf, 1);
 	dst = kmap_atomic(page, KM_USER1);
 	memcpy(dst + offset, src + buf->offset, count);
-	kunmap_atomic(page, KM_USER1);
+	kunmap_atomic(dst, KM_USER1);
 	buf->ops->unmap(pipe, buf, src);
 
 	copied = ocfs2_write_end(file, file->f_mapping, sd->pos, count, count,
_

Patches currently in -mm which might be from jens.axboe@oracle.com are

looph-build-fix.patch
ocfs2-bad-kunmap_atomic.patch
git-scsi-rc-fixes.patch
clean-up-duplicate-includes-in-drivers-block.patch
readahead-remove-the-limit-max_sectors_kb-imposed-on-max_readahead_kb.patch
revoke-vs-git-block.patch
git-block-vs-reiser4.patch
