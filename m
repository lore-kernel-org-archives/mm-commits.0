From: akpm@linux-foundation.org
Subject: - create-a-div_round_closest-macro-to-do-division-with-rounding.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:15:31 -0800
Message-ID: <200901072215.n07MFV73015336@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761943AbZAGWPe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:15:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djwong@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Create a DIV_ROUND_CLOSEST macro to do division with rounding
has been removed from the -mm tree.  Its filename was
     create-a-div_round_closest-macro-to-do-division-with-rounding.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Create a DIV_ROUND_CLOSEST macro to do division with rounding
From: "Darrick J. Wong" <djwong@us.ibm.com>

Create a helper macro to divide two numbers and round the result to the
nearest whole number.  This is a helper macro for hwmon drivers that want
to convert incoming sysfs values per standard hwmon practice, though the
macro itself can be used by anyone.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/linux/kernel.h~create-a-div_round_closest-macro-to-do-division-with-rounding include/linux/kernel.h
--- a/include/linux/kernel.h~create-a-div_round_closest-macro-to-do-division-with-rounding
+++ a/include/linux/kernel.h
@@ -48,6 +48,12 @@ extern const char linux_proc_banner[];
 #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
 #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
 #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
+#define DIV_ROUND_CLOSEST(x, divisor)(			\
+{							\
+	typeof(divisor) __divisor = divisor;		\
+	(((x) + ((__divisor) / 2)) / (__divisor));	\
+}							\
+)
 
 #define _RET_IP_		(unsigned long)__builtin_return_address(0)
 #define _THIS_IP_  ({ __label__ __here; __here: (unsigned long)&&__here; })
_

Patches currently in -mm which might be from djwong@us.ibm.com are

origin.patch
linux-next.patch
fakephp-allocate-pci-resources-before-adding-the-device.patch

