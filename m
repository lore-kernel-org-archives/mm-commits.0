From: akpm@linux-foundation.org
Subject: [merged] ufs-make-solaris-fsck-happy.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:57:40 -0400
Message-ID: <201003150658.o2F6wDr4016431@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51700 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935693Ab0COG6V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:58:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dushistov@mail.ru, viskovatoff@imap.cc, mm-commits@vger.kernel.org


The patch titled
     ufs: make solaris fsck happy
has been removed from the -mm tree.  Its filename was
     ufs-make-solaris-fsck-happy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ufs: make solaris fsck happy
From: Evgeniy Dushistov <dushistov@mail.ru>

Alex Viskovatoff let me know that after copying data to solaris's ufs from
linux, solaris's fsck sees some errors in cylinder summary information. 
This is because of solaris expects find some data on another places, then
curernt implementation save it.  This patch fixes this issue.  It is
tested by me, and also Alex reported that it works for him.

Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>
Reported-by: Alex Viskovatoff <viskovatoff@imap.cc>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/ufs_fs.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN fs/ufs/ufs_fs.h~ufs-make-solaris-fsck-happy fs/ufs/ufs_fs.h
--- a/fs/ufs/ufs_fs.h~ufs-make-solaris-fsck-happy
+++ a/fs/ufs/ufs_fs.h
@@ -233,11 +233,16 @@ typedef __u16 __bitwise __fs16;
  */
 #define ufs_cbtocylno(bno) \
 	((bno) * uspi->s_nspf / uspi->s_spc)
-#define ufs_cbtorpos(bno) \
+#define ufs_cbtorpos(bno)				      \
+	((UFS_SB(sb)->s_flags & UFS_CG_SUN) ?		      \
+	 (((((bno) * uspi->s_nspf % uspi->s_spc) %	      \
+	    uspi->s_nsect) *				      \
+	   uspi->s_nrpos) / uspi->s_nsect)		      \
+	 :						      \
 	((((bno) * uspi->s_nspf % uspi->s_spc / uspi->s_nsect \
 	* uspi->s_trackskew + (bno) * uspi->s_nspf % uspi->s_spc \
 	% uspi->s_nsect * uspi->s_interleave) % uspi->s_nsect \
-	* uspi->s_nrpos) / uspi->s_npsect)
+	  * uspi->s_nrpos) / uspi->s_npsect))
 
 /*
  * The following macros optimize certain frequently calculated
_

Patches currently in -mm which might be from dushistov@mail.ru are

origin.patch

