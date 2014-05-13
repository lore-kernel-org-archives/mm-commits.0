From: akpm@linux-foundation.org
Subject: + gcov-add-support-for-gcc-49.patch added to -mm tree
Date: Tue, 13 May 2014 13:22:16 -0700
Message-ID: <53727ef8.oU4w/V/UFRbRYr+C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53675 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902AbaEMUWR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 May 2014 16:22:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, oberpar@linux.vnet.ibm.com, coolypf@qq.com

Subject: + gcov-add-support-for-gcc-49.patch added to -mm tree
To: coolypf@qq.com,oberpar@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Tue, 13 May 2014 13:22:16 -0700


The patch titled
     Subject: gcov: add support for GCC 4.9
has been added to the -mm tree.  Its filename is
     gcov-add-support-for-gcc-49.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/gcov-add-support-for-gcc-49.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/gcov-add-support-for-gcc-49.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yuan Pengfei <coolypf@qq.com>
Subject: gcov: add support for GCC 4.9

Handle the gcov-related changes in GCC 4.9:

  A new counter (time profile) is added.

See http://gcc.gnu.org/gcc-4.9/changes.html

Signed-off-by: Yuan Pengfei <coolypf@qq.com>
Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
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

gcov-add-support-for-gcc-49.patch

