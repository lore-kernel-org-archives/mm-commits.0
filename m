From: akpm@linux-foundation.org
Subject: + introduce-lower_32_bits-macro.patch added to -mm tree
Date: Tue, 29 Jul 2008 15:32:15 -0700
Message-ID: <200807292232.m6TMWFal025279@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751051AbYG2Wcv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 18:32:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joerg.roedel@amd.com, hpa@zytor.com


The patch titled
     introduce lower_32_bits() macro
has been added to the -mm tree.  Its filename is
     introduce-lower_32_bits-macro.patch

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
Subject: introduce lower_32_bits() macro
From: Joerg Roedel <joerg.roedel@amd.com>

The file kernel.h contains the upper_32_bits macro.  This patch adds the
other part, the lower_32_bits macro.  Its first use will be in the driver
for AMD IOMMU.

Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/linux/kernel.h~introduce-lower_32_bits-macro include/linux/kernel.h
--- a/include/linux/kernel.h~introduce-lower_32_bits-macro
+++ a/include/linux/kernel.h
@@ -75,6 +75,12 @@ extern const char linux_proc_banner[];
  */
 #define upper_32_bits(n) ((u32)(((n) >> 16) >> 16))
 
+/**
+ * lower_32_bits - return bits 0-31 of a number
+ * @n: the number we're accessing
+ */
+#define lower_32_bits(n) ((u32)(n))
+
 #define	KERN_EMERG	"<0>"	/* system is unusable			*/
 #define	KERN_ALERT	"<1>"	/* action must be taken immediately	*/
 #define	KERN_CRIT	"<2>"	/* critical conditions			*/
_

Patches currently in -mm which might be from joerg.roedel@amd.com are

introduce-lower_32_bits-macro.patch
linux-next.patch

