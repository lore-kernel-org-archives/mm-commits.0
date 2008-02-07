From: akpm@linux-foundation.org
Subject: - log2h-define-order_base_2-macro-for-convenience.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:22:30 -0800
Message-ID: <200802070022.m170MBo3006402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43187 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933911AbYBGAoN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, mm-commits@vger.kernel.org


The patch titled
     log2.h: Define order_base_2() macro for convenience.
has been removed from the -mm tree.  Its filename was
     log2h-define-order_base_2-macro-for-convenience.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

origin.patch
git-hwmon.patch
git-xfs.patch
