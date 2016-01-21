From: akpm@linux-foundation.org
Subject: [merged] lz4-fix-wrong-compress-buffer-size-for-64-bits.patch
 removed from -mm tree
Date: Thu, 21 Jan 2016 15:28:31 -0800
Message-ID: <56a1699f.apfy0+RgoRENso4O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36061 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbcAUX2d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:28:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bongkyu.kim@lge.com, chanho.min@lge.com, kyungsik.lee@lge.com, yann.collet.73@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lz4: fix wrong compress buffer size for 64-bits
has been removed from the -mm tree.  Its filename was
     lz4-fix-wrong-compress-buffer-size-for-64-bits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bongkyu Kim <bongkyu.kim@lge.com>
Subject: lz4: fix wrong compress buffer size for 64-bits

The current lz4 compress buffer is 16kb on 32-bits, 32kb on 64-bits
system.  But, lz4 needs only 16kb on both.  On 64-bits, this causes wasted
cpu cycles for additional memset during every compression.

In case of lz4hc,
the current buffer size is (256kb + 8) on 32-bits, (512kb + 16) on 64-bits.
But, lz4hc needs only (256kb + 2 * pointer) on both.

This patch fixes these wrong compress buffer sizes for 64-bits.

Signed-off-by: Bongkyu Kim <bongkyu.kim@lge.com>
Cc: Chanho Min <chanho.min@lge.com>
Cc: Yann Collet <yann.collet.73@gmail.com>
Cc: Kyungsik Lee <kyungsik.lee@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lz4.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/lz4.h~lz4-fix-wrong-compress-buffer-size-for-64-bits include/linux/lz4.h
--- a/include/linux/lz4.h~lz4-fix-wrong-compress-buffer-size-for-64-bits
+++ a/include/linux/lz4.h
@@ -9,8 +9,8 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-#define LZ4_MEM_COMPRESS	(4096 * sizeof(unsigned char *))
-#define LZ4HC_MEM_COMPRESS	(65538 * sizeof(unsigned char *))
+#define LZ4_MEM_COMPRESS	(16384)
+#define LZ4HC_MEM_COMPRESS	(262144 + (2 * sizeof(unsigned char *)))
 
 /*
  * lz4_compressbound()
_

Patches currently in -mm which might be from bongkyu.kim@lge.com are


