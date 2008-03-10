From: akpm@linux-foundation.org
Subject: + ufs-remove-unused-fs64_add-and-fs64_sub.patch added to -mm tree
Date: Mon, 10 Mar 2008 13:22:03 -0700
Message-ID: <200803102022.m2AKM3Od003749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752419AbYCJUW4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 16:22:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, dushistov@mail.ru


The patch titled
     ufs: remove unused fs64_add and fs64_sub
has been added to the -mm tree.  Its filename is
     ufs-remove-unused-fs64_add-and-fs64_sub.patch

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
Subject: ufs: remove unused fs64_add and fs64_sub
From: Marcin Slusarz <marcin.slusarz@gmail.com>

remove fs64_add and fs64_sub - they probably weren't ever used because
their prototypes used u32 instead of __fs64

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/swab.h |   18 ------------------
 1 file changed, 18 deletions(-)

diff -puN fs/ufs/swab.h~ufs-remove-unused-fs64_add-and-fs64_sub fs/ufs/swab.h
--- a/fs/ufs/swab.h~ufs-remove-unused-fs64_add-and-fs64_sub
+++ a/fs/ufs/swab.h
@@ -41,24 +41,6 @@ cpu_to_fs64(struct super_block *sbp, u64
 }
 
 static __inline u32
-fs64_add(struct super_block *sbp, u32 *n, int d)
-{
-	if (UFS_SB(sbp)->s_bytesex == BYTESEX_LE)
-		return *n = cpu_to_le64(le64_to_cpu(*n)+d);
-	else
-		return *n = cpu_to_be64(be64_to_cpu(*n)+d);
-}
-
-static __inline u32
-fs64_sub(struct super_block *sbp, u32 *n, int d)
-{
-	if (UFS_SB(sbp)->s_bytesex == BYTESEX_LE)
-		return *n = cpu_to_le64(le64_to_cpu(*n)-d);
-	else
-		return *n = cpu_to_be64(be64_to_cpu(*n)-d);
-}
-
-static __inline u32
 fs32_to_cpu(struct super_block *sbp, __fs32 n)
 {
 	if (UFS_SB(sbp)->s_bytesex == BYTESEX_LE)
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-jfs.patch
git-udf.patch
qla3xxx-convert-byte-order-of-constant-instead-of-variable.patch
ntfs-le_add_cpu-conversion.patch
git-sched.patch
scsi-le_add_cpu-conversion.patch
ipw2200-le_add_cpu-conversion.patch
ext2-le_add_cpu-conversion.patch
ext2-convert-byte-order-of-constant-instead-of-variable.patch
ext3-convert-byte-order-of-constant-instead-of-variable.patch
ufs-e_add_cpu-conversion.patch
ufs-remove-unused-fs64_add-and-fs64_sub.patch
reiserfs-le_add_cpu-conversion.patch
affs-be_add_cpu-conversion.patch
hfs-hfsplus-be_add_cpu-conversion.patch
quota-le_add_cpu-conversion.patch
sysv-e_add_cpu-conversion.patch

