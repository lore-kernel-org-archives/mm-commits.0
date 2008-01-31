From: akpm@linux-foundation.org
Subject: + use-__u32-in-linux-reiserfs_fsh.patch added to -mm tree
Date: Thu, 31 Jan 2008 13:57:21 -0800
Message-ID: <200801312157.m0VLvL27013305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54758 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760631AbYAaV57 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jan 2008 16:57:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org


The patch titled
     use __u32 in linux/reiserfs_fs.h
has been added to the -mm tree.  Its filename is
     use-__u32-in-linux-reiserfs_fsh.patch

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
Subject: use __u32 in linux/reiserfs_fs.h
From: Mike Frysinger <vapier@gentoo.org>

Since this header is exported to userspace and all the other types in the
header have been scrubbed, this brings the last straggler in line.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/reiserfs_fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/reiserfs_fs.h~use-__u32-in-linux-reiserfs_fsh include/linux/reiserfs_fs.h
--- a/include/linux/reiserfs_fs.h~use-__u32-in-linux-reiserfs_fsh
+++ a/include/linux/reiserfs_fs.h
@@ -287,7 +287,7 @@ static inline struct reiserfs_sb_info *R
 
 /* Don't trust REISERFS_SB(sb)->s_bmap_nr, it's a u16
  * which overflows on large file systems. */
-static inline u32 reiserfs_bmap_count(struct super_block *sb)
+static inline __u32 reiserfs_bmap_count(struct super_block *sb)
 {
 	return (SB_BLOCK_COUNT(sb) - 1) / (sb->s_blocksize * 8) + 1;
 }
_

Patches currently in -mm which might be from vapier@gentoo.org are

git-kbuild.patch
asm-posix_typesh-scrub-__glibc__.patch
procfs-constify-function-pointer-tables.patch
remove-__strict_ansi__-from-linux-typesh.patch
linux-typesh-always-export-64bit-aligned-defines.patch
drop-linux-ufs_fsh-from-userspace-export-and-relocate-it-to-fs-ufs-ufs_fsh.patch
use-__u32-in-linux-reiserfs_fsh.patch
