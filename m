From: akpm@linux-foundation.org
Subject: [merged] cris-use-int-for-ssize_t-to-match-size_t.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:37:45 -0800
Message-ID: <20130222203745.B125A5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:35103 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757291Ab3BVUhr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:37:47 -0500
Received: by mail-qe0-f74.google.com with SMTP id a11so103745qen.5
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:37:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, hans-peter.nilsson@axis.com, jesper.nilsson@axis.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cris: use "int" for ssize_t to match size_t
has been removed from the -mm tree.  Its filename was
     cris-use-int-for-ssize_t-to-match-size_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: cris: use "int" for ssize_t to match size_t

On cris-linux-gcc, __SIZE_TYPE__ expands to "unsigned int", as
gcc-4.6.3-nolibc/cris-linux/lib/gcc/cris-linux/4.6.3/plugin/include/config/cris/linux.h
has

    #define SIZE_TYPE "unsigned int"

Hence __kernel_size_t is also "unsigned int".  But __kernel_ssize_t is
"long", which has a different base type, causing compiler warnings like:

    fs/quota/quota_tree.c:372:4: warning: format '%zd' expects argument of type 'signed size_t', but argument 4 has type 'ssize_t' [-Wformat]

To fix this, __kernel_ssize_t should be changed to "int". Hence cris can
just use the generic 32-bit versions from include/asm-generic/posix_types.h
for all size-related types.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mikael Starvik <starvik@axis.com>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Hans-Peter Nilsson <hans-peter.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/include/uapi/asm/posix_types.h |    5 -----
 1 file changed, 5 deletions(-)

diff -puN arch/cris/include/uapi/asm/posix_types.h~cris-use-int-for-ssize_t-to-match-size_t arch/cris/include/uapi/asm/posix_types.h
--- a/arch/cris/include/uapi/asm/posix_types.h~cris-use-int-for-ssize_t-to-match-size_t
+++ a/arch/cris/include/uapi/asm/posix_types.h
@@ -22,11 +22,6 @@ typedef unsigned short	__kernel_uid_t;
 typedef unsigned short	__kernel_gid_t;
 #define __kernel_uid_t __kernel_uid_t
 
-typedef __SIZE_TYPE__	__kernel_size_t;
-typedef long		__kernel_ssize_t;
-typedef int		__kernel_ptrdiff_t;
-#define __kernel_size_t __kernel_size_t
