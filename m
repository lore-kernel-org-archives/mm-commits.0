From: akpm@linux-foundation.org
Subject: [merged] gcov-add-support-for-gcc-49.patch removed from -mm tree
Date: Wed, 11 Jun 2014 12:03:59 -0700
Message-ID: <5398a81f.6ovejiLqw1NGwQPo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48739 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaFKTEA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jun 2014 15:04:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, oberpar@linux.vnet.ibm.com, coolypf@qq.com

Subject: [merged] gcov-add-support-for-gcc-49.patch removed from -mm tree
To: coolypf@qq.com,oberpar@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Jun 2014 12:03:59 -0700


The patch titled
     Subject: gcov: add support for GCC 4.9
has been removed from the -mm tree.  Its filename was
     gcov-add-support-for-gcc-49.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yuan Pengfei <coolypf@qq.com>
Subject: gcov: add support for GCC 4.9

This patch handles the gcov-related changes in GCC 4.9:

  A new counter (time profile) is added. The total number is 9 now.

  A new profile merge function __gcov_merge_time_profile is added.

See gcc/gcov-io.h and libgcc/libgcov-merge.c

For the first change, the layout of struct gcov_info is affected.

For the second one, a dummy function is added to kernel/gcov/base.c
similarly.

Signed-off-by: Yuan Pengfei <coolypf@qq.com>
Acked-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/base.c    |    6 ++++++
 kernel/gcov/gcc_4_7.c |    5 +++++
 2 files changed, 11 insertions(+)

diff -puN kernel/gcov/base.c~gcov-add-support-for-gcc-49 kernel/gcov/base.c
--- a/kernel/gcov/base.c~gcov-add-support-for-gcc-49
+++ a/kernel/gcov/base.c
@@ -85,6 +85,12 @@ void __gcov_merge_ior(gcov_type *counter
 }
 EXPORT_SYMBOL(__gcov_merge_ior);
 
+void __gcov_merge_time_profile(gcov_type *counters, unsigned int n_counters)
+{
+	/* Unused. */
+}
+EXPORT_SYMBOL(__gcov_merge_time_profile);
+
 /**
  * gcov_enable_events - enable event reporting through gcov_event()
  *
diff -puN kernel/gcov/gcc_4_7.c~gcov-add-support-for-gcc-49 kernel/gcov/gcc_4_7.c
--- a/kernel/gcov/gcc_4_7.c~gcov-add-support-for-gcc-49
+++ a/kernel/gcov/gcc_4_7.c
@@ -18,7 +18,12 @@
 #include <linux/vmalloc.h>
 #include "gcov.h"
 
+#if __GNUC__ == 4 && __GNUC_MINOR__ >= 9
+#define GCOV_COUNTERS			9
+#else
 #define GCOV_COUNTERS			8
+#endif
+
 #define GCOV_TAG_FUNCTION_LENGTH	3
 
 static struct gcov_info *gcov_info_head;
_

Patches currently in -mm which might be from coolypf@qq.com are

origin.patch

