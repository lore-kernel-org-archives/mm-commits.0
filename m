From: akpm@linux-foundation.org
Subject: + remove-__strict_ansi__-from-linux-typesh.patch added to -mm tree
Date: Sun, 27 Jan 2008 21:29:06 -0800
Message-ID: <200801280530.m0S5U0OG014014@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59097 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750932AbYA1FaF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 00:30:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org


The patch titled
     Remove __STRICT_ANSI__ from linux/types.h
has been added to the -mm tree.  Its filename is
     remove-__strict_ansi__-from-linux-typesh.patch

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

git-kbuild.patch
asm-posix_typesh-scrub-__glibc__.patch
procfs-constify-function-pointer-tables.patch
remove-__strict_ansi__-from-linux-typesh.patch
linux-typesh-always-export-64bit-aligned-defines.patch
