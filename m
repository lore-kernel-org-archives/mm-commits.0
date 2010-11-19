From: akpm@linux-foundation.org
Subject: [obsolete] lib-add-generic-exponentially-weighted-moving-average-ewma-function.patch removed from -mm tree
Date: Fri, 19 Nov 2010 11:34:29 -0800
Message-ID: <201011191938.oAJJc6J5030693@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35911 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751197Ab0KSTij (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Nov 2010 14:38:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: br1@einfach.org, a.p.zijlstra@chello.nl, kosaki.motohiro@jp.fujitsu.com, linville@tuxdriver.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     lib: add generic exponentially weighted moving average (EWMA) function
has been removed from the -mm tree.  Its filename was
     lib-add-generic-exponentially-weighted-moving-average-ewma-function.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib: add generic exponentially weighted moving average (EWMA) function
From: Bruno Randolf <br1@einfach.org>

This adds generic functions for calculating Exponentially Weighted Moving
Averages (EWMA).  This implementation makes use of a structure which keeps
the EWMA parameters and a scaled up internal representation to reduce
rounding errors.

The original idea for this implementation came from the rt2x00 driver
(rt2x00link.c).  I would like to use it in several places in the mac80211
and ath5k code and I hope it can be useful in many other places in the
kernel code.

Signed-off-by: Bruno Randolf <br1@einfach.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/average.h |   32 ++++++++++++++++++++
 lib/Makefile            |    2 -
 lib/average.c           |   58 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 91 insertions(+), 1 deletion(-)

diff -puN /dev/null include/linux/average.h
--- /dev/null
+++ a/include/linux/average.h
@@ -0,0 +1,32 @@
+#ifndef _LINUX_AVERAGE_H
+#define _LINUX_AVERAGE_H
+
+#include <linux/kernel.h>
+
+/* Exponentially weighted moving average (EWMA) */
+
+/* For more documentation see lib/average.c */
+
+struct ewma {
+	unsigned long internal;
+	unsigned long factor;
+	unsigned long weight;
+};
+
+extern struct ewma *ewma_init(struct ewma *avg, unsigned long factor,
+			      unsigned long weight);
+
+extern struct ewma *ewma_add(struct ewma *avg, unsigned long val);
+
+/**
+ * ewma_get() - Get average value
+ * @avg: Average structure
+ *
+ * Returns the average value held in @avg.
+ */
+static inline unsigned long ewma_get(const struct ewma *avg)
+{
+	return DIV_ROUND_CLOSEST(avg->internal, avg->factor);
+}
+
+#endif /* _LINUX_AVERAGE_H */
diff -puN lib/Makefile~lib-add-generic-exponentially-weighted-moving-average-ewma-function lib/Makefile
--- a/lib/Makefile~lib-add-generic-exponentially-weighted-moving-average-ewma-function
+++ a/lib/Makefile
@@ -21,7 +21,7 @@ lib-y	+= kobject.o kref.o klist.o
 
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
-	 string_helpers.o gcd.o lcm.o list_sort.o uuid.o
+	 string_helpers.o gcd.o lcm.o list_sort.o uuid.o average.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
diff -puN /dev/null lib/average.c
--- /dev/null
+++ a/lib/average.c
@@ -0,0 +1,58 @@
+/*
+ * lib/average.c
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2.  See the file COPYING for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/average.h>
+
+/**
+ * DOC: Exponentially Weighted Moving Average (EWMA)
+ *
+ * These are generic functions for calculating Exponentially Weighted Moving
+ * Averages (EWMA). We keep a structure with the EWMA parameters and a scaled
+ * up internal representation of the average value to prevent rounding errors.
+ * The factor for scaling up and the exponential weight (or decay rate) have to
+ * be specified thru the init fuction. The structure should not be accessed
+ * directly but only thru the helper functions.
+ */
+
+/**
+ * ewma_init() - Initialize EWMA parameters
+ * @avg: Average structure
+ * @factor: Factor to use for the scaled up internal value. The maximum value
+ *	of averages can be ULONG_MAX/(factor*weight).
+ * @weight: Exponential weight, or decay rate. This defines how fast the
+ *	influence of older values decreases. Has to be bigger than 1.
+ *
+ * Initialize the EWMA parameters for a given struct ewma @avg.
+ */
+struct ewma *ewma_init(struct ewma *avg, unsigned long factor,
+		       unsigned long weight)
+{
+	WARN_ON(weight <= 1 || factor == 0);
+	avg->internal = 0;
+	avg->weight = weight;
+	avg->factor = factor;
+	return avg;
+}
+EXPORT_SYMBOL(ewma_init);
+
+/**
+ * ewma_add() - Exponentially weighted moving average (EWMA)
+ * @avg: Average structure
+ * @val: Current value
+ *
+ * Add a sample to the average.
+ */
+struct ewma *ewma_add(struct ewma *avg, unsigned long val)
+{
+	avg->internal = avg->internal  ?
+		(((avg->internal * (avg->weight - 1)) +
+			(val * avg->factor)) / avg->weight) :
+		(val * avg->factor);
+	return avg;
+}
+EXPORT_SYMBOL(ewma_add);
_

Patches currently in -mm which might be from br1@einfach.org are

linux-next.patch
lib-add-generic-exponentially-weighted-moving-average-ewma-function-fix.patch

