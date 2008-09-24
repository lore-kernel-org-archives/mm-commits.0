From: akpm@linux-foundation.org
Subject: - add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch removed from -mm tree
Date: Wed, 24 Sep 2008 09:40:11 -0700
Message-ID: <200809241640.m8OGeCkJ004956@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54831 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752339AbYIXQkq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Sep 2008 12:40:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, alan@lxorguk.ukuu.org.uk, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Add time_is_after_jiffies and others which compare with jiffies
has been removed from the -mm tree.  Its filename was
     add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add time_is_after_jiffies and others which compare with jiffies
From: Dave Young <hidave.darkstar@gmail.com>

Most of time_after like macros usages just compare jiffies and another number,
so here add some time_is_* macros for convenience.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/jiffies.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN include/linux/jiffies.h~add-time_is_after_jiffies-and-others-which-compare-with-jiffies include/linux/jiffies.h
--- a/include/linux/jiffies.h~add-time_is_after_jiffies-and-others-which-compare-with-jiffies
+++ a/include/linux/jiffies.h
@@ -151,6 +151,22 @@ static inline u64 get_jiffies_64(void)
 #define time_is_after_eq_jiffies(a) time_before_eq(jiffies, a)
 
 /*
+ * These four macros compare jiffies and 'a' for convenience.
+ */
+
+/* time_is_before_jiffies(a) return true if a is before jiffies */
+#define time_is_before_jiffies(a) time_after(jiffies, a)
+
+/* time_is_after_jiffies(a) return true if a is after jiffies */
+#define time_is_after_jiffies(a) time_before(jiffies, a)
+
+/* time_is_before_eq_jiffies(a) return true if a is before or equal to jiffies*/
+#define time_is_before_eq_jiffies(a) time_after_eq(jiffies, a)
+
+/* time_is_after_eq_jiffies(a) return true if a is after or equal to jiffies*/
+#define time_is_after_eq_jiffies(a) time_before_eq(jiffies, a)
+
+/*
  * Have the 32 bit jiffies value wrap 5 minutes after boot
  * so jiffies wrap bugs show up earlier.
  */
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

linux-next.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
hci_usb-replace-mb-with-smp_mb.patch

