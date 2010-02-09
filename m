From: akpm@linux-foundation.org
Subject: + fs-ufs-recognize-solaris-specific-file-system-state.patch added to -mm tree
Date: Tue, 09 Feb 2010 15:52:43 -0800
Message-ID: <201002092352.o19NqhE6009089@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51756 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751672Ab0BIXww (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Feb 2010 18:52:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viskovatoff@imap.cc, dushistov@mail.ru


The patch titled
     fs/ufs: recognize Solaris-specific file system state
has been added to the -mm tree.  Its filename is
     fs-ufs-recognize-solaris-specific-file-system-state.patch

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
Subject: fs/ufs: recognize Solaris-specific file system state
From: Alex Viskovatoff <viskovatoff@imap.cc>

Recent releases of Solaris set the fs_clean state of an unmounted UFS file
system as FSLOG ("logging fs").  However, the Linux kernel currently does
not recognize the value which represents this state.  Thus, attempting to
mount such a file system rw produces the message

kernel: ufs_read_super: can't grok fs_clean 0xfffffffd

and the file system is mounted read-only.  This patch makes the kernel
recognize that value.

Signed-off-by: Alex Viskovatoff <viskovatoff@imap.cc>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c  |    3 +++
 fs/ufs/ufs_fs.h |    6 ++++++
 2 files changed, 9 insertions(+)

diff -puN fs/ufs/super.c~fs-ufs-recognize-solaris-specific-file-system-state fs/ufs/super.c
--- a/fs/ufs/super.c~fs-ufs-recognize-solaris-specific-file-system-state
+++ a/fs/ufs/super.c
@@ -1016,6 +1016,9 @@ magic_found:
 		case UFS_FSSTABLE:
 			UFSD("fs is stable\n");
 			break;
+		case UFS_FSLOG:
+			UFSD("fs is logging fs\n");
+			break;
 		case UFS_FSOSF1:
 			UFSD("fs is DEC OSF/1\n");
 			break;
diff -puN fs/ufs/ufs_fs.h~fs-ufs-recognize-solaris-specific-file-system-state fs/ufs/ufs_fs.h
--- a/fs/ufs/ufs_fs.h~fs-ufs-recognize-solaris-specific-file-system-state
+++ a/fs/ufs/ufs_fs.h
@@ -138,6 +138,7 @@ typedef __u16 __bitwise __fs16;
 
 #define UFS_USEEFT  ((__u16)65535)
 
+/* fs_clean values */
 #define UFS_FSOK      0x7c269d38
 #define UFS_FSACTIVE  ((__s8)0x00)
 #define UFS_FSCLEAN   ((__s8)0x01)
@@ -145,6 +146,11 @@ typedef __u16 __bitwise __fs16;
 #define UFS_FSOSF1    ((__s8)0x03)	/* is this correct for DEC OSF/1? */
 #define UFS_FSBAD     ((__s8)0xff)
 
+/* Solaris-specific fs_clean values */
+#define UFS_FSSUSPEND ((__s8)0xfe)	/* temporarily suspended */
+#define UFS_FSLOG     ((__s8)0xfd)	/* logging fs */
+#define UFS_FSFIX     ((__s8)0xfc)	/* being repaired while mounted */
+
 /* From here to next blank line, s_flags for ufs_sb_info */
 /* directory entry encoding */
 #define UFS_DE_MASK		0x00000010	/* mask for the following */
_

Patches currently in -mm which might be from viskovatoff@imap.cc are

fs-ufs-recognize-solaris-specific-file-system-state.patch

