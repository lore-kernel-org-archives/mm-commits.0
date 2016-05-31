From: akpm@linux-foundation.org
Subject: + befs-remove-unused-endian-functions.patch added to -mm tree
Date: Tue, 31 May 2016 12:01:08 -0700
Message-ID: <574ddf74.BCYUbDCcAulRbuhD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48262 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbcEaTBJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2016 15:01:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luisbg@osg.samsung.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: befs: remove unused endian functions
has been added to the -mm tree.  Its filename is
     befs-remove-unused-endian-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/befs-remove-unused-endian-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/befs-remove-unused-endian-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: befs: remove unused endian functions

Remove endianness conversion functions that are declared but never used.

Link: http://lkml.kernel.org/r/1464701277-29962-1-git-send-email-luisbg@osg.samsung.com
Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/endian.h |   44 --------------------------------------------
 1 file changed, 44 deletions(-)

diff -puN fs/befs/endian.h~befs-remove-unused-endian-functions fs/befs/endian.h
--- a/fs/befs/endian.h~befs-remove-unused-endian-functions
+++ a/fs/befs/endian.h
@@ -20,15 +20,6 @@ fs64_to_cpu(const struct super_block *sb
 		return be64_to_cpu((__force __be64)n);
 }
 
-static inline fs64
-cpu_to_fs64(const struct super_block *sb, u64 n)
-{
-	if (BEFS_SB(sb)->byte_order == BEFS_BYTESEX_LE)
-		return (__force fs64)cpu_to_le64(n);
-	else
-		return (__force fs64)cpu_to_be64(n);
-}
-
 static inline u32
 fs32_to_cpu(const struct super_block *sb, fs32 n)
 {
@@ -38,15 +29,6 @@ fs32_to_cpu(const struct super_block *sb
 		return be32_to_cpu((__force __be32)n);
 }
 
-static inline fs32
-cpu_to_fs32(const struct super_block *sb, u32 n)
-{
-	if (BEFS_SB(sb)->byte_order == BEFS_BYTESEX_LE)
-		return (__force fs32)cpu_to_le32(n);
-	else
-		return (__force fs32)cpu_to_be32(n);
-}
-
 static inline u16
 fs16_to_cpu(const struct super_block *sb, fs16 n)
 {
@@ -56,15 +38,6 @@ fs16_to_cpu(const struct super_block *sb
 		return be16_to_cpu((__force __be16)n);
 }
 
-static inline fs16
-cpu_to_fs16(const struct super_block *sb, u16 n)
-{
-	if (BEFS_SB(sb)->byte_order == BEFS_BYTESEX_LE)
-		return (__force fs16)cpu_to_le16(n);
-	else
-		return (__force fs16)cpu_to_be16(n);
-}
-
 /* Composite types below here */
 
 static inline befs_block_run
@@ -83,23 +56,6 @@ fsrun_to_cpu(const struct super_block *s
 	}
 	return run;
 }
-
-static inline befs_disk_block_run
-cpu_to_fsrun(const struct super_block *sb, befs_block_run n)
-{
-	befs_disk_block_run run;
