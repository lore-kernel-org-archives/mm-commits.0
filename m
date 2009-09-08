From: akpm@linux-foundation.org
Subject: [merged] nilfs2-fix-format-string-compile-warning-ino_t.patch removed from -mm tree
Date: Tue, 08 Sep 2009 14:26:38 -0700
Message-ID: <200909082126.n88LQcTd007378@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54045 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752148AbZIHV0j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2009 17:26:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     nilfs2: fix format string compile warning (ino_t)
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-format-string-compile-warning-ino_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2: fix format string compile warning (ino_t)
From: Heiko Carstens <heiko.carstens@de.ibm.com>

Unlike on most other architectures ino_t is an unsigned int on s390.
So add an explicit cast to avoid this compile warning:

fs/nilfs2/recovery.c: In function 'recover_dsync_blocks':
fs/nilfs2/recovery.c:555: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'ino_t'

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/recovery.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/nilfs2/recovery.c~nilfs2-fix-format-string-compile-warning-ino_t fs/nilfs2/recovery.c
--- a/fs/nilfs2/recovery.c~nilfs2-fix-format-string-compile-warning-ino_t
+++ a/fs/nilfs2/recovery.c
@@ -552,7 +552,8 @@ static int recover_dsync_blocks(struct n
 		printk(KERN_WARNING
 		       "NILFS warning: error recovering data block "
 		       "(err=%d, ino=%lu, block-offset=%llu)\n",
-		       err, rb->ino, (unsigned long long)rb->blkoff);
+		       err, (unsigned long)rb->ino,
+		       (unsigned long long)rb->blkoff);
 		if (!err2)
 			err2 = err;
  next:
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

linux-next.patch
poll-select-avoid-arithmetic-overflow-in-__estimate_accuracy.patch
ext2-fix-format-string-compile-warning-ino_t.patch

