From: akpm@linux-foundation.org
Subject: + linux-typesh-always-export-64bit-aligned-defines.patch added to -mm tree
Date: Sun, 27 Jan 2008 21:29:10 -0800
Message-ID: <200801280530.m0S5U5HW014026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34431 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750889AbYA1FaX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 00:30:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, dwmw2@infradead.org, sam@ravnborg.org


The patch titled
     linux/types.h: always export 64bit aligned defines
has been added to the -mm tree.  Its filename is
     linux-typesh-always-export-64bit-aligned-defines.patch

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
Subject: linux/types.h: always export 64bit aligned defines
From: Mike Frysinger <vapier@gentoo.org>

Some kernel headers exported to userspace rely on these 64bit aligned
defines.  However, they are hidden behind __KERNEL_STRICT_NAMES at the
moment which means most of the time, they're never actually available. 
These these defines dont actually conflict with normal userspace / C
library types, there's no reason to hide them behind the
__KERNEL_STRICT_NAMES define.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/types.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/types.h~linux-typesh-always-export-64bit-aligned-defines include/linux/types.h
--- a/include/linux/types.h~linux-typesh-always-export-64bit-aligned-defines
+++ a/include/linux/types.h
@@ -125,11 +125,6 @@ typedef		__u64		u_int64_t;
 typedef		__s64		int64_t;
 #endif
 
-/* this is a special 64bit data type that is 8-byte aligned */
-#define aligned_u64 unsigned long long __attribute__((aligned(8)))
-#define aligned_be64 __be64 __attribute__((aligned(8)))
-#define aligned_le64 __le64 __attribute__((aligned(8)))
-
 /**
  * The type used for indexing onto a disc or disc partition.
  *
@@ -161,6 +156,11 @@ typedef unsigned long blkcnt_t;
 
 #endif /* __KERNEL_STRICT_NAMES */
 
+/* this is a special 64bit data type that is 8-byte aligned */
+#define aligned_u64 unsigned long long __attribute__((aligned(8)))
+#define aligned_be64 __be64 __attribute__((aligned(8)))
+#define aligned_le64 __le64 __attribute__((aligned(8)))
+
 /*
  * Below are truly Linux-specific types that should never collide with
  * any application/library that wants linux/types.h.
_

Patches currently in -mm which might be from vapier@gentoo.org are

git-kbuild.patch
asm-posix_typesh-scrub-__glibc__.patch
procfs-constify-function-pointer-tables.patch
remove-__strict_ansi__-from-linux-typesh.patch
linux-typesh-always-export-64bit-aligned-defines.patch
