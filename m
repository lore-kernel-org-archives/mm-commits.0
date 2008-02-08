From: akpm@linux-foundation.org
Subject: - remove-__strict_ansi__-from-linux-typesh.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:19:12 -0800
Message-ID: <200802082018.m18KIrMw010983@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58545 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752775AbYBHUmI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:42:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     Remove __STRICT_ANSI__ from linux/types.h
has been removed from the -mm tree.  Its filename was
     remove-__strict_ansi__-from-linux-typesh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Remove __STRICT_ANSI__ from linux/types.h
From: Mike Frysinger <vapier@gentoo.org>

All of the asm-*/types.h headers have been updated to no longer check
__STRICT_ANSI__ for the 64bit types, so this brings linux/types.h in line.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/types.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/types.h~remove-__strict_ansi__-from-linux-typesh include/linux/types.h
--- a/include/linux/types.h~remove-__strict_ansi__-from-linux-typesh
+++ a/include/linux/types.h
@@ -53,7 +53,7 @@ typedef __kernel_uid_t		uid_t;
 typedef __kernel_gid_t		gid_t;
 #endif /* __KERNEL__ */
 
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__)
+#if defined(__GNUC__)
 typedef __kernel_loff_t		loff_t;
 #endif
 
@@ -119,7 +119,7 @@ typedef		__u8		uint8_t;
 typedef		__u16		uint16_t;
 typedef		__u32		uint32_t;
 
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__)
+#if defined(__GNUC__)
 typedef		__u64		uint64_t;
 typedef		__u64		u_int64_t;
 typedef		__s64		int64_t;
@@ -181,7 +181,7 @@ typedef __u16 __bitwise __le16;
 typedef __u16 __bitwise __be16;
 typedef __u32 __bitwise __le32;
 typedef __u32 __bitwise __be32;
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__)
+#if defined(__GNUC__)
 typedef __u64 __bitwise __le64;
 typedef __u64 __bitwise __be64;
 #endif
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
