From: akpm@linux-foundation.org
Subject: + ext2-fix-format-string-compile-warning-ino_t.patch added to -mm tree
Date: Fri, 04 Sep 2009 12:33:49 -0700
Message-ID: <200909041933.n84JXn8J022295@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751353AbZIDTdx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2009 15:33:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com


The patch titled
     ext2: fix format string compile warning (ino_t)
has been added to the -mm tree.  Its filename is
     ext2-fix-format-string-compile-warning-ino_t.patch

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
Subject: ext2: fix format string compile warning (ino_t)
From: Heiko Carstens <heiko.carstens@de.ibm.com>

Unlike on most other architectures ino_t is an unsigned int on s390.  So
add an explicit cast to avoid this compile warning:

fs/ext2/namei.c: In function 'ext2_lookup':
fs/ext2/namei.c:73: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext2/namei.c~ext2-fix-format-string-compile-warning-ino_t fs/ext2/namei.c
--- a/fs/ext2/namei.c~ext2-fix-format-string-compile-warning-ino_t
+++ a/fs/ext2/namei.c
@@ -70,7 +70,7 @@ static struct dentry *ext2_lookup(struct
 			if (PTR_ERR(inode) == -ESTALE) {
 				ext2_error(dir->i_sb, __func__,
 						"deleted inode referenced: %lu",
-						ino);
+						(unsigned long) ino);
 				return ERR_PTR(-EIO);
 			} else {
 				return ERR_CAST(inode);
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

linux-next.patch
poll-select-avoid-arithmetic-overflow-in-__estimate_accuracy.patch
ext2-fix-format-string-compile-warning-ino_t.patch
nilfs2-fix-format-string-compile-warning-ino_t.patch

