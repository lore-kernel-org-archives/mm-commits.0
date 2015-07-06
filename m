From: akpm@linux-foundation.org
Subject: [merged] gcov-add-support-for-gcc-51.patch removed from -mm tree
Date: Mon, 06 Jul 2015 12:46:50 -0700
Message-ID: <559adb2a.kk4GAAJNZjpToPaj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59524 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492AbbGFTqv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:46:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lstoakes@gmail.com, a.ryabinin@samsung.com, coolypf@qq.com, oberpar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: gcov: add support for GCC 5.1
has been removed from the -mm tree.  Its filename was
     gcov-add-support-for-gcc-51.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: gcov: add support for GCC 5.1

Fix kernel gcov support for GCC 5.1.  Similar to commit a992bf836f9
("gcov: add support for GCC 4.9"), this patch takes into account the
existence of a new gcov counter (see gcc's gcc/gcov-counter.def.)

Firstly, it increments GCOV_COUNTERS (to 10), which makes the data
structure struct gcov_info compatible with GCC 5.1.

Secondly, a corresponding counter function __gcov_merge_icall_topn (Top N
value tracking for indirect calls) is included in base.c with the other
gcov counters unused for kernel profiling.

Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Yuan Pengfei <coolypf@qq.com>
Tested-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/base.c    |    6 ++++++
 kernel/gcov/gcc_4_7.c |    4 +++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff -puN kernel/gcov/base.c~gcov-add-support-for-gcc-51 kernel/gcov/base.c
--- a/kernel/gcov/base.c~gcov-add-support-for-gcc-51
+++ a/kernel/gcov/base.c
@@ -92,6 +92,12 @@ void __gcov_merge_time_profile(gcov_type
 }
 EXPORT_SYMBOL(__gcov_merge_time_profile);
 
+void __gcov_merge_icall_topn(gcov_type *counters, unsigned int n_counters)
+{
+	/* Unused. */
+}
+EXPORT_SYMBOL(__gcov_merge_icall_topn);
+
 /**
  * gcov_enable_events - enable event reporting through gcov_event()
  *
diff -puN kernel/gcov/gcc_4_7.c~gcov-add-support-for-gcc-51 kernel/gcov/gcc_4_7.c
--- a/kernel/gcov/gcc_4_7.c~gcov-add-support-for-gcc-51
+++ a/kernel/gcov/gcc_4_7.c
@@ -18,7 +18,9 @@
 #include <linux/vmalloc.h>
 #include "gcov.h"
 
-#if __GNUC__ == 4 && __GNUC_MINOR__ >= 9
+#if __GNUC__ == 5 && __GNUC_MINOR__ >= 1
+#define GCOV_COUNTERS			10
+#elif __GNUC__ == 4 && __GNUC_MINOR__ >= 9
 #define GCOV_COUNTERS			9
 #else
 #define GCOV_COUNTERS			8
_

Patches currently in -mm which might be from lstoakes@gmail.com are


