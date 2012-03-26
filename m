From: akpm@linux-foundation.org
Subject: [merged] crc32-fix-mixing-of-endian-specific-types.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:30:44 -0700
Message-ID: <20120326193044.60B1FA00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:51269 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab2CZTaq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:30:46 -0400
Received: by wibhj13 with SMTP id hj13so233258wib.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:30:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpearson@systemfabricworks.com, djwong@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: crc32: fix mixing of endian-specific types
has been removed from the -mm tree.  Its filename was
     crc32-fix-mixing-of-endian-specific-types.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Bob Pearson <rpearson@systemfabricworks.com>
Subject: crc32: fix mixing of endian-specific types

crc32.c in its original version freely mixed u32, __le32 and __be32 types
which caused warnings from sparse with __CHECK_ENDIAN__.  This patch fixes
these by forcing the types to u32.

[djwong@us.ibm.com: Minor changelog tweaks]
Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>
Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/crc32.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN lib/crc32.c~crc32-fix-mixing-of-endian-specific-types lib/crc32.c
--- a/lib/crc32.c~crc32-fix-mixing-of-endian-specific-types
+++ a/lib/crc32.c
@@ -28,13 +28,13 @@
 #include "crc32defs.h"
 
 #if CRC_LE_BITS == 8
-# define tole(x) __constant_cpu_to_le32(x)
+# define tole(x) ((__force u32) __constant_cpu_to_le32(x))
 #else
 # define tole(x) (x)
 #endif
 
 #if CRC_BE_BITS == 8
-# define tobe(x) __constant_cpu_to_be32(x)
+# define tobe(x) ((__force u32) __constant_cpu_to_be32(x))
 #else
 # define tobe(x) (x)
 #endif
@@ -128,9 +128,9 @@ u32 __pure crc32_le(u32 crc, unsigned ch
 # elif CRC_LE_BITS == 8
 	const u32      (*tab)[] = crc32table_le;
 
-	crc = __cpu_to_le32(crc);
+	crc = (__force u32) __cpu_to_le32(crc);
 	crc = crc32_body(crc, p, len, tab);
-	crc = __le32_to_cpu(crc);
+	crc = __le32_to_cpu((__force __le32)crc);
 #endif
 	return crc;
 }
@@ -171,9 +171,9 @@ u32 __pure crc32_be(u32 crc, unsigned ch
 # elif CRC_BE_BITS == 8
 	const u32      (*tab)[] = crc32table_be;
 
-	crc = __cpu_to_be32(crc);
+	crc = (__force u32) __cpu_to_be32(crc);
 	crc = crc32_body(crc, p, len, tab);
-	crc = __be32_to_cpu(crc);
+	crc = __be32_to_cpu((__force __be32)crc);
 # endif
 	return crc;
 }
_

Patches currently in -mm which might be from rpearson@systemfabricworks.com are

origin.patch

