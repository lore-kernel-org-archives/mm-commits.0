From: akpm@linux-foundation.org
Subject: + gcov-add-support-for-gcc-51.patch added to -mm tree
Date: Fri, 29 May 2015 16:12:12 -0700
Message-ID: <5568f24c.sxqh3s9L732srm9W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57331 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287AbbE2XMN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 May 2015 19:12:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lstoakes@gmail.com, a.ryabinin@samsung.com, coolypf@qq.com, oberpar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: gcov: add support for GCC 5.1
has been added to the -mm tree.  Its filename is
     gcov-add-support-for-gcc-51.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/gcov-add-support-for-gcc-51.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/gcov-add-support-for-gcc-51.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
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

gcov-add-support-for-gcc-51.patch

