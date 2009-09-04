From: akpm@linux-foundation.org
Subject: + nilfs2-fix-format-string-compile-warning-ino_t.patch added to -mm tree
Date: Fri, 04 Sep 2009 12:32:57 -0700
Message-ID: <200909041932.n84JWvgZ020636@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58193 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751353AbZIDTdB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2009 15:33:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com


The patch titled
     nilfs2: fix format string compile warning (ino_t)
has been added to the -mm tree.  Its filename is
     nilfs2-fix-format-string-compile-warning-ino_t.patch

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
nilfs2-fix-format-string-compile-warning-ino_t.patch

