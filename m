From: akpm@linux-foundation.org
Subject: + edac-i5100-fix-missing-bits.patch added to -mm tree
Date: Fri, 27 Jun 2008 16:09:01 -0700
Message-ID: <200806272309.m5RN92Wx010804@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40064 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932188AbYF0XJr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jun 2008 19:09:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ajones@riverbed.com, dougthompson@xmission.com


The patch titled
     edac: i5100 fix missing bits
has been added to the -mm tree.  Its filename is
     edac-i5100-fix-missing-bits.patch

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
Subject: edac: i5100 fix missing bits
From: Arthur Jones <ajones@riverbed.com>

The error mask we use to trigger ECC notifications is missing many bits of
interest.  We add these bits here so that all possible ECC errors can be
reported.

Signed-off-by: Arthur Jones <ajones@riverbed.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i5100_edac.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff -puN drivers/edac/i5100_edac.c~edac-i5100-fix-missing-bits drivers/edac/i5100_edac.c
--- a/drivers/edac/i5100_edac.c~edac-i5100-fix-missing-bits
+++ a/drivers/edac/i5100_edac.c
@@ -52,12 +52,24 @@
 #define		I5100_FERR_NF_MEM_M16ERR_MASK	(1 << 16)
 #define		I5100_FERR_NF_MEM_M15ERR_MASK	(1 << 15)
 #define		I5100_FERR_NF_MEM_M14ERR_MASK	(1 << 14)
-#define		I5100_FERR_NF_MEM_
-#define		I5100_FERR_NF_MEM_
+#define		I5100_FERR_NF_MEM_M12ERR_MASK	(1 << 12)
+#define		I5100_FERR_NF_MEM_M11ERR_MASK	(1 << 11)
+#define		I5100_FERR_NF_MEM_M10ERR_MASK	(1 << 10)
+#define		I5100_FERR_NF_MEM_M6ERR_MASK	(1 << 6)
+#define		I5100_FERR_NF_MEM_M5ERR_MASK	(1 << 5)
+#define		I5100_FERR_NF_MEM_M4ERR_MASK	(1 << 4)
+#define		I5100_FERR_NF_MEM_M1ERR_MASK	1
 #define		I5100_FERR_NF_MEM_ANY_MASK	\
 			(I5100_FERR_NF_MEM_M16ERR_MASK | \
 			I5100_FERR_NF_MEM_M15ERR_MASK | \
-			I5100_FERR_NF_MEM_M14ERR_MASK)
+			I5100_FERR_NF_MEM_M14ERR_MASK | \
+			I5100_FERR_NF_MEM_M12ERR_MASK | \
+			I5100_FERR_NF_MEM_M11ERR_MASK | \
+			I5100_FERR_NF_MEM_M10ERR_MASK | \
+			I5100_FERR_NF_MEM_M6ERR_MASK | \
+			I5100_FERR_NF_MEM_M5ERR_MASK | \
+			I5100_FERR_NF_MEM_M4ERR_MASK | \
+			I5100_FERR_NF_MEM_M1ERR_MASK)
 #define		I5100_FERR_NF_MEM_ANY(a)  ((a) & I5100_FERR_NF_MEM_ANY_MASK)
 #define	I5100_NERR_NF_MEM	0xa4	/* MC Next Non-Fatal Errors */
 #define		I5100_NERR_NF_MEM_ANY(a)  I5100_FERR_NF_MEM_ANY(a)
_

Patches currently in -mm which might be from ajones@riverbed.com are

edac-i5100-new-intel-chipset-driver.patch
edac-i5100-fix-missing-bits.patch
edac-i5100-fix-enable-ecc-hardware.patch
edac-i5100-fix-unmask-ecc-bits.patch
edac-core-fix-to-use-dynamic-kobject.patch
edac-core-fix-workq-timer.patch
edac-core-fix-redundant-sysfs-controls-to-parameters.patch
edac-core-fix-static-to-dynamic-kset.patch
edac-core-fix-added-newline-to-sysfs-dimm-labels.patch

