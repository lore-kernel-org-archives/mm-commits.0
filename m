From: akpm@linux-foundation.org
Subject: + ext2-fix-typo-in-hurd-part-of-include-linux-ext2_fsh.patch added to -mm tree
Date: Sun, 20 Jul 2008 22:31:34 -0700
Message-ID: <200807210531.m6L5VYD9019317@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752774AbYGUFce (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jul 2008 01:32:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samuel.thibault@ens-lyon.org


The patch titled
     ext2: fix typo in Hurd part of include/linux/ext2_fs.h
has been added to the -mm tree.  Its filename is
     ext2-fix-typo-in-hurd-part-of-include-linux-ext2_fsh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext2: fix typo in Hurd part of include/linux/ext2_fs.h
From: Samuel Thibault <samuel.thibault@ens-lyon.org>

Fix typo in Hurd part of include/linux/ext2_fs.h

The ';' here is redundant or can even pose problem.  This is actually not
used by the Linux kernel, but it is exposed in GNU/Hurd.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ext2_fs.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/ext2_fs.h~ext2-fix-typo-in-hurd-part-of-include-linux-ext2_fsh include/linux/ext2_fs.h
--- a/include/linux/ext2_fs.h~ext2-fix-typo-in-hurd-part-of-include-linux-ext2_fsh
+++ a/include/linux/ext2_fs.h
@@ -284,8 +284,8 @@ struct ext2_inode {
 
 #ifdef	__hurd__
 #define i_translator	osd1.hurd1.h_i_translator
-#define i_frag		osd2.hurd2.h_i_frag;
-#define i_fsize		osd2.hurd2.h_i_fsize;
+#define i_frag		osd2.hurd2.h_i_frag
+#define i_fsize		osd2.hurd2.h_i_fsize
 #define i_uid_high	osd2.hurd2.h_i_uid_high
 #define i_gid_high	osd2.hurd2.h_i_gid_high
 #define i_author	osd2.hurd2.h_i_author
_

Patches currently in -mm which might be from samuel.thibault@ens-lyon.org are

ext2-fix-typo-in-hurd-part-of-include-linux-ext2_fsh.patch

