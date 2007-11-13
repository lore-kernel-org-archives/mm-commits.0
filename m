From: akpm@linux-foundation.org
Subject: + log2h-define-order_base_2-macro-for-convenience.patch added to -mm tree
Date: Mon, 12 Nov 2007 17:41:52 -0800
Message-ID: <200711130141.lAD1fqK6020338@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34434 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757653AbXKMBm2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 20:42:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca


The patch titled
     log2.h: Define order_base_2() macro for convenience.
has been added to the -mm tree.  Its filename is
     log2h-define-order_base_2-macro-for-convenience.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: log2.h: Define order_base_2() macro for convenience.
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Given a number of places in the tree that need to calculate this value
explicitly, might as well just create a macro for it.

(akpm: must be implemented as a macro for callee typeof() usage)

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/log2.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN include/linux/log2.h~log2h-define-order_base_2-macro-for-convenience include/linux/log2.h
--- a/include/linux/log2.h~log2h-define-order_base_2-macro-for-convenience
+++ a/include/linux/log2.h
@@ -190,4 +190,20 @@ unsigned long __rounddown_pow_of_two(uns
 	__rounddown_pow_of_two(n)		\
  )
 
+/**
+ * order_base_2 - calculate the (rounded up) base 2 order of the argument
+ * @n: parameter
+ *
+ * The first few values calculated by this routine:
+ *  ob2(0) = 0
+ *  ob2(1) = 0
+ *  ob2(2) = 1
+ *  ob2(3) = 2
+ *  ob2(4) = 2
+ *  ob2(5) = 3
+ *  ... and so on.
+ */
+
+#define order_base_2(n) ilog2(roundup_pow_of_two(n))
+
 #endif /* _LINUX_LOG2_H */
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

arm-remove-reference-to-non-existent-mtd_obsolete_chips.patch
hwmon-replace-power-of-two-test-in-drivers-hwmon-adt7470c.patch
git-mips.patch
pcmcia-net-use-roundup_pow_of_two-macro-instead-of-grotesque-loop.patch
blackfin-typo-config_rtc_bfin_module.patch
git-sparc64.patch
frv-move-dma-macros-to-scatterlisth-for-consistency.patch
m68knommu-remove-vestiges-of-non-existent-disktel.patch
uml-delete-some-unused-headers.patch
rd-use-is_power_of_2-in-drivers-block-rdc.patch
log2h-define-order_base_2-macro-for-convenience.patch
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
