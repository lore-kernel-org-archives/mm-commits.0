From: akpm@linux-foundation.org
Subject: + crc32-fix-mixing-of-endian-specific-types.patch added to -mm tree
Date: Wed, 18 Jan 2012 15:01:43 -0800
Message-ID: <20120118230144.757291E0058@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:44960 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab2ARXBp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2012 18:01:45 -0500
Received: by mail-gy0-f202.google.com with SMTP id g20so491708ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2012 15:01:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpearson@systemfabricworks.com, djwong@us.ibm.com


The patch titled
     Subject: crc32: fix mixing of endian-specific types
has been added to the -mm tree.  Its filename is
     crc32-fix-mixing-of-endian-specific-types.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: crc32: fix mixing of endian-specific types

Patches currently in -mm which might be from rpearson@systemfabricworks.com are

origin.patch
crc32-removed-two-instances-of-trailing-whitespaces.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation.patch
crc32-simplify-unit-test-code.patch
crc32-miscellaneous-cleanups.patch
crc32-fix-mixing-of-endian-specific-types.patch
crc32-make-crc__bits-definition-correspond-to-actual-bit-counts.patch
crc32-add-slice-by-8-algorithm-to-existing-code.patch
crc32-optimize-loop-counter-for-x86.patch
crc32-add-note-about-this-patchset-to-crc32c.patch
crc32-bolt-on-crc32c.patch
crypto-crc32c-should-use-library-implementation.patch
crc32-add-self-test-code-for-crc32c.patch
crc32-select-an-algorithm-via-kconfig.patch

