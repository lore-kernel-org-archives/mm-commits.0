From: akpm@linux-foundation.org
Subject: + crc32-bolt-on-crc32c-dont-reference-unnecessary-crc32-tables-in-single-bit-mode.patch added to -mm tree
Date: Mon, 23 Jan 2012 13:17:36 -0800
Message-ID: <20120123211737.0BE3A20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pz0-f74.google.com ([209.85.210.74]:45603 "EHLO
	mail-pz0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab2AWVRk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2012 16:17:40 -0500
Received: by dado15 with SMTP id o15so140060dad.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Jan 2012 13:17:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djwong@us.ibm.com, herbert@gondor.apana.org.au, rdunlap@xenotime.net, rpearson@systemfabricworks.com


The patch titled
     Subject: crc32: Don't reference unnecessary crc32 tables in single-bit mode
has been added to the -mm tree.  Its filename is
     crc32-bolt-on-crc32c-dont-reference-unnecessary-crc32-tables-in-single-bit-mode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: crc32: Don't reference unnecessary crc32 tables in single-bit mode

When compiling with single bit mode (CRC32_BIT=y) we shouldn't reference
the crc32 tables, since they aren't built in single-bit mode.  Many thanks
to Randy Dunlap for finding this bug:
http://marc.info/?l=linux-kernel&m=132709702422141&w=2

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Bob Pearson <rpearson@systemfabricworks.com>
Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/crc32.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff -puN lib/crc32.c~crc32-bolt-on-crc32c-dont-reference-unnecessary-crc32-tables-in-single-bit-mode lib/crc32.c
--- a/lib/crc32.c~crc32-bolt-on-crc32c-dont-reference-unnecessary-crc32-tables-in-single-bit-mode
+++ a/lib/crc32.c
@@ -174,16 +174,26 @@ static inline u32 __pure crc32_le_generi
 	return crc;
 }
 
+#if CRC_LE_BITS == 1
+u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
+{
+	return crc32_le_generic(crc, p, len, NULL, CRCPOLY_LE);
+}
+u32 __pure __crc32c_le(u32 crc, unsigned char const *p, size_t len)
+{
+	return crc32_le_generic(crc, p, len, NULL, CRC32C_POLY_LE);
+}
+#else
 u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
 {
 	return crc32_le_generic(crc, p, len, crc32table_le, CRCPOLY_LE);
 }
-EXPORT_SYMBOL(crc32_le);
-
 u32 __pure __crc32c_le(u32 crc, unsigned char const *p, size_t len)
 {
 	return crc32_le_generic(crc, p, len, crc32ctable_le, CRC32C_POLY_LE);
 }
+#endif
+EXPORT_SYMBOL(crc32_le);
 EXPORT_SYMBOL(__crc32c_le);
 
 /**
@@ -233,10 +243,17 @@ static inline u32 __pure crc32_be_generi
 	return crc;
 }
 
+#if CRC_LE_BITS == 1
+u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
+{
+	return crc32_be_generic(crc, p, len, NULL, CRCPOLY_BE);
+}
+#else
 u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
 {
 	return crc32_be_generic(crc, p, len, crc32table_be, CRCPOLY_BE);
 }
+#endif
 EXPORT_SYMBOL(crc32_be);
 
 #ifdef CONFIG_CRC32_SELFTEST
_
Subject: Subject: crc32: Don't reference unnecessary crc32 tables in single-bit mode

Patches currently in -mm which might be from djwong@us.ibm.com are

linux-next.patch
crc32-removed-two-instances-of-trailing-whitespaces.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
crc32-simplify-unit-test-code.patch
crc32-miscellaneous-cleanups.patch
crc32-fix-mixing-of-endian-specific-types.patch
crc32-make-crc__bits-definition-correspond-to-actual-bit-counts.patch
crc32-add-slice-by-8-algorithm-to-existing-code.patch
crc32-optimize-loop-counter-for-x86.patch
crc32-add-note-about-this-patchset-to-crc32c.patch
crc32-bolt-on-crc32c.patch
crc32-bolt-on-crc32c-dont-reference-unnecessary-crc32-tables-in-single-bit-mode.patch
crypto-crc32c-should-use-library-implementation.patch
crc32-add-self-test-code-for-crc32c.patch
crc32-select-an-algorithm-via-kconfig.patch

