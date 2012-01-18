From: akpm@linux-foundation.org
Subject: + crc32-miscellaneous-cleanups.patch added to -mm tree
Date: Wed, 18 Jan 2012 15:01:39 -0800
Message-ID: <20120118230140.A425420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:39667 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab2ARXBm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2012 18:01:42 -0500
Received: by eaaf1 with SMTP id f1so109399eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2012 15:01:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpearson@systemfabricworks.com, djwong@us.ibm.com


The patch titled
     Subject: crc32: miscellaneous cleanups
has been added to the -mm tree.  Its filename is
     crc32-miscellaneous-cleanups.patch

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
Subject: crc32: miscellaneous cleanups

Misc cleanup of lib/crc32.c and related files.

- remove unnecessary header files.

- straighten out some convoluted ifdef's

- rewrite some references to 2 dimensional arrays as 1 dimensional
  arrays to make them correct.  I.e.  replace tab[i] with tab[0][i].

- a few trivial whitespace changes

- fix a warning in gen_crc32tables.c caused by a mismatch in the type of
  the pointer passed to output table.  Since the table is only used at
  kernel compile time, it is simpler to make the table big enough to hold
  the largest column size used.  One cannot make the column size smaller
  in output_table because it has to be used by both the le and be tables
  and they can have different column sizes.

[djwong@us.ibm.com: Minor changelog tweaks]
Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>
Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/crc32.c          |  104 ++++++++++++++---------------------------
 lib/gen_crc32table.c |    6 +-
 2 files changed, 39 insertions(+), 71 deletions(-)

diff -puN lib/crc32.c~crc32-miscellaneous-cleanups lib/crc32.c
--- a/lib/crc32.c~crc32-miscellaneous-cleanups
+++ a/lib/crc32.c
@@ -23,13 +23,10 @@
 /* see: Documentation/crc32.txt for a description of algorithms */
 
 #include <linux/crc32.h>
-#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/compiler.h>
 #include <linux/types.h>
-#include <linux/init.h>
-#include <linux/atomic.h>
 #include "crc32defs.h"
+
 #if CRC_LE_BITS == 8
 # define tole(x) __constant_cpu_to_le32(x)
 #else
@@ -41,6 +38,7 @@
 #else
 # define tobe(x) (x)
 #endif
+
 #include "crc32table.h"
 
 MODULE_AUTHOR("Matt Domsch <Matt_Domsch@dell.com>");
@@ -96,6 +94,7 @@ crc32_body(u32 crc, unsigned char const 
 #undef DO_CRC4
 }
 #endif
+
 /**
  * crc32_le() - Calculate bitwise little-endian Ethernet AUTODIN II CRC32
  * @crc: seed value for computation.  ~0 for Ethernet, sometimes 0 for
@@ -103,53 +102,39 @@ crc32_body(u32 crc, unsigned char const 
  * @p: pointer to buffer over which CRC is run
  * @len: length of buffer @p
  */
-u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len);
-
-#if CRC_LE_BITS == 1
-/*
- * In fact, the table-based code will work in this case, but it can be
- * simplified by inlining the table in ?: form.
- */
-
 u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
 {
+#if CRC_LE_BITS == 1
 	int i;
 	while (len--) {
 		crc ^= *p++;
 		for (i = 0; i < 8; i++)
 			crc = (crc >> 1) ^ ((crc & 1) ? CRCPOLY_LE : 0);
 	}
-	return crc;
-}
-#else				/* Table-based approach */
-
-u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
-{
-# if CRC_LE_BITS == 8
-	const u32      (*tab)[] = crc32table_le;
-
-	crc = __cpu_to_le32(crc);
-	crc = crc32_body(crc, p, len, tab);
-	return __le32_to_cpu(crc);
-# elif CRC_LE_BITS == 4
+# elif CRC_LE_BITS == 2
 	while (len--) {
 		crc ^= *p++;
-		crc = (crc >> 4) ^ crc32table_le[crc & 15];
-		crc = (crc >> 4) ^ crc32table_le[crc & 15];
+		crc = (crc >> 2) ^ crc32table_le[0][crc & 3];
+		crc = (crc >> 2) ^ crc32table_le[0][crc & 3];
+		crc = (crc >> 2) ^ crc32table_le[0][crc & 3];
+		crc = (crc >> 2) ^ crc32table_le[0][crc & 3];
 	}
-	return crc;
-# elif CRC_LE_BITS == 2
+# elif CRC_LE_BITS == 4
 	while (len--) {
 		crc ^= *p++;
-		crc = (crc >> 2) ^ crc32table_le[crc & 3];
-		crc = (crc >> 2) ^ crc32table_le[crc & 3];
-		crc = (crc >> 2) ^ crc32table_le[crc & 3];
-		crc = (crc >> 2) ^ crc32table_le[crc & 3];
+		crc = (crc >> 4) ^ crc32table_le[0][crc & 15];
+		crc = (crc >> 4) ^ crc32table_le[0][crc & 15];
 	}
+# elif CRC_LE_BITS == 8
+	const u32      (*tab)[] = crc32table_le;
+
+	crc = __cpu_to_le32(crc);
+	crc = crc32_body(crc, p, len, tab);
+	crc = __le32_to_cpu(crc);
+#endif
 	return crc;
-# endif
 }
-#endif
+EXPORT_SYMBOL(crc32_le);
 
 /**
  * crc32_be() - Calculate bitwise big-endian Ethernet AUTODIN II CRC32
@@ -158,16 +143,9 @@ u32 __pure crc32_le(u32 crc, unsigned ch
  * @p: pointer to buffer over which CRC is run
  * @len: length of buffer @p
  */
-u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len);
-
-#if CRC_BE_BITS == 1
-/*
- * In fact, the table-based code will work in this case, but it can be
- * simplified by inlining the table in ?: form.
- */
-
 u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
 {
+#if CRC_BE_BITS == 1
 	int i;
 	while (len--) {
 		crc ^= *p++ << 24;
@@ -176,39 +154,29 @@ u32 __pure crc32_be(u32 crc, unsigned ch
 			    (crc << 1) ^ ((crc & 0x80000000) ? CRCPOLY_BE :
 					  0);
 	}
-	return crc;
-}
-
-#else				/* Table-based approach */
-u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
-{
-# if CRC_BE_BITS == 8
-	const u32      (*tab)[] = crc32table_be;
-
-	crc = __cpu_to_be32(crc);
-	crc = crc32_body(crc, p, len, tab);
-	return __be32_to_cpu(crc);
-# elif CRC_BE_BITS == 4
+# elif CRC_BE_BITS == 2
 	while (len--) {
 		crc ^= *p++ << 24;
-		crc = (crc << 4) ^ crc32table_be[crc >> 28];
-		crc = (crc << 4) ^ crc32table_be[crc >> 28];
+		crc = (crc << 2) ^ crc32table_be[0][crc >> 30];
+		crc = (crc << 2) ^ crc32table_be[0][crc >> 30];
+		crc = (crc << 2) ^ crc32table_be[0][crc >> 30];
+		crc = (crc << 2) ^ crc32table_be[0][crc >> 30];
 	}
-	return crc;
-# elif CRC_BE_BITS == 2
+# elif CRC_BE_BITS == 4
 	while (len--) {
 		crc ^= *p++ << 24;
-		crc = (crc << 2) ^ crc32table_be[crc >> 30];
-		crc = (crc << 2) ^ crc32table_be[crc >> 30];
-		crc = (crc << 2) ^ crc32table_be[crc >> 30];
-		crc = (crc << 2) ^ crc32table_be[crc >> 30];
+		crc = (crc << 4) ^ crc32table_be[0][crc >> 28];
+		crc = (crc << 4) ^ crc32table_be[0][crc >> 28];
 	}
-	return crc;
+# elif CRC_BE_BITS == 8
+	const u32      (*tab)[] = crc32table_be;
+
+	crc = __cpu_to_be32(crc);
+	crc = crc32_body(crc, p, len, tab);
+	crc = __be32_to_cpu(crc);
 # endif
+	return crc;
 }
-#endif
-
-EXPORT_SYMBOL(crc32_le);
 EXPORT_SYMBOL(crc32_be);
 
 #ifdef CONFIG_CRC32_SELFTEST
diff -puN lib/gen_crc32table.c~crc32-miscellaneous-cleanups lib/gen_crc32table.c
--- a/lib/gen_crc32table.c~crc32-miscellaneous-cleanups
+++ a/lib/gen_crc32table.c
@@ -7,8 +7,8 @@
 #define LE_TABLE_SIZE (1 << CRC_LE_BITS)
 #define BE_TABLE_SIZE (1 << CRC_BE_BITS)
 
-static uint32_t crc32table_le[4][LE_TABLE_SIZE];
-static uint32_t crc32table_be[4][BE_TABLE_SIZE];
+static uint32_t crc32table_le[4][256];
+static uint32_t crc32table_be[4][256];
 
 /**
  * crc32init_le() - allocate and initialize LE table data
@@ -62,7 +62,7 @@ static void crc32init_be(void)
 	}
 }
 
-static void output_table(uint32_t table[4][256], int len, char *trans)
+static void output_table(uint32_t (*table)[256], int len, char *trans)
 {
 	int i, j;
 
_
Subject: Subject: crc32: miscellaneous cleanups

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

