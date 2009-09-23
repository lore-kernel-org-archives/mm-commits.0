From: akpm@linux-foundation.org
Subject: [merged] ext2-fix-format-string-compile-warning-ino_t.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:03:34 -0700
Message-ID: <200909232003.n8NK3YJH019500@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753902AbZIWUEG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:04:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ext2: fix format string compile warning (ino_t)
has been removed from the -mm tree.  Its filename was
     ext2-fix-format-string-compile-warning-ino_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

