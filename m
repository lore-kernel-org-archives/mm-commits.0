From: akpm@linux-foundation.org
Subject: + crc32-select-an-algorithm-via-kconfig.patch added to -mm tree
Date: Wed, 18 Jan 2012 15:02:09 -0800
Message-ID: <20120118230210.8E159200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:52867 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab2ARXCM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2012 18:02:12 -0500
Received: by wibhm11 with SMTP id hm11so192502wib.1
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2012 15:02:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djwong@us.ibm.com, rpearson@systemfabricworks.com


The patch titled
     Subject: crc32: select an algorithm via Kconfig
has been added to the -mm tree.  Its filename is
     crc32-select-an-algorithm-via-kconfig.patch

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
Subject: crc32: select an algorithm via Kconfig

Allow the kernel builder to choose a crc32* algorithm for the kernel.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Cc: Bob Pearson <rpearson@systemfabricworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig     |   43 +++++++++++++++++++++++++++++++++++++++++++
 lib/crc32defs.h |   18 ++++++++++++++++++
 2 files changed, 61 insertions(+)

diff -puN lib/Kconfig~crc32-select-an-algorithm-via-kconfig lib/Kconfig
--- a/lib/Kconfig~crc32-select-an-algorithm-via-kconfig
+++ a/lib/Kconfig
@@ -77,6 +77,49 @@ config CRC32_SELFTEST
 	  and crc32_be over byte strings with random alignment and length
 	  and computes the total elapsed time and number of bytes processed.
 
+choice
+	prompt "CRC32 implementation"
+	depends on CRC32
+	default CRC32_SLICEBY8
+
+config CRC32_SLICEBY8
+	bool "Slice by 8 bytes"
+	help
+	  Calculate checksum 8 bytes at a time with a clever slicing algorithm.
+	  This is the fastest algorithm, but comes with a 8KiB lookup table.
+	  Most modern processors have enough cache to hold this table without
+	  thrashing the cache.
+
+	  This is the default implementation choice.  Choose this one unless
+	  you have a good reason not to.
+
+config CRC32_SLICEBY4
+	bool "Slice by 4 bytes"
+	help
+	  Calculate checksum 4 bytes at a time with a clever slicing algorithm.
+	  This is a bit slower than slice by 8, but has a smaller 4KiB lookup
+	  table.
+
+	  Only choose this option if you know what you are doing.
+
+config CRC32_SARWATE
+	bool "Sarwate's Algorithm (one byte at a time)"
+	help
+	  Calculate checksum a byte at a time using Sarwate's algorithm.  This
+	  is not particularly fast, but has a small 256 byte lookup table.
+
+	  Only choose this option if you know what you are doing.
+
+config CRC32_BIT
+	bool "Classic Algorithm (one bit at a time)"
+	help
+	  Calculate checksum one bit at a time.  This is VERY slow, but has
+	  no lookup table.  This is provided as a debugging option.
+
+	  Only choose this option if you are debugging crc32.
+
+endchoice
+
 config CRC7
 	tristate "CRC7 functions"
 	help
diff -puN lib/crc32defs.h~crc32-select-an-algorithm-via-kconfig lib/crc32defs.h
--- a/lib/crc32defs.h~crc32-select-an-algorithm-via-kconfig
+++ a/lib/crc32defs.h
@@ -13,6 +13,24 @@
  */
 #define CRC32C_POLY_LE 0x82F63B78
 
+/* Try to choose an implementation variant via Kconfig */
+#ifdef CONFIG_CRC32_SLICEBY8
+# define CRC_LE_BITS 64
+# define CRC_BE_BITS 64
+#endif
+#ifdef CONFIG_CRC32_SLICEBY4
+# define CRC_LE_BITS 32
+# define CRC_BE_BITS 32
+#endif
+#ifdef CONFIG_CRC32_SARWATE
+# define CRC_LE_BITS 8
+# define CRC_BE_BITS 8
+#endif
+#ifdef CONFIG_CRC32_BIT
+# define CRC_LE_BITS 1
+# define CRC_BE_BITS 1
+#endif
+
 /*
  * How many bits at a time to use.  Valid values are 1, 2, 4, 8, 32 and 64.
  * For less performance-sensitive, use 4 or 8 to save table size.
_
Subject: Subject: crc32: select an algorithm via Kconfig

Patches currently in -mm which might be from djwong@us.ibm.com are

linux-next.patch
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

