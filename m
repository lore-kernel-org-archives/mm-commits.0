From: akpm@linux-foundation.org
Subject: [merged] crc32-select-an-algorithm-via-kconfig.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:31:00 -0700
Message-ID: <20120326193100.5E0EDA00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:54481 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903Ab2CZTbB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:31:01 -0400
Received: by mail-vb0-f74.google.com with SMTP id l22so508210vbn.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:31:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djwong@us.ibm.com, rpearson@systemfabricworks.com, mm-commits@vger.kernel.org


The patch titled
     Subject: crc32: select an algorithm via Kconfig
has been removed from the -mm tree.  Its filename was
     crc32-select-an-algorithm-via-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -80,6 +80,49 @@ config CRC32_SELFTEST
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

Patches currently in -mm which might be from djwong@us.ibm.com are

origin.patch
linux-next.patch

