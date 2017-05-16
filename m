From: akpm@linux-foundation.org
Subject: [merged] gcov-support-gcc-71.patch removed from -mm tree
Date: Tue, 16 May 2017 10:49:56 -0700
Message-ID: <20170516174956.bYysP7voa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57396 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752034AbdEPRt5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 May 2017 13:49:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mliska@suse.cz, mm-commits@vger.kernel.org, oberpar@linux.vnet.ibm.com


The patch titled
     Subject: gcov: support GCC 7.1
has been removed from the -mm tree.  Its filename was
     gcov-support-gcc-71.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Martin Liska <mliska@suse.cz>
Subject: gcov: support GCC 7.1

Starting from GCC 7.1, __gcov_exit is a new symbol expected
to be implemented in a profiling runtime.

[akpm@linux-foundation.org: coding-style fixes]
[mliska@suse.cz: v2]
  Link: http://lkml.kernel.org/r/e63a3c59-0149-c97e-4084-20ca8f146b26@suse.cz
Link: http://lkml.kernel.org/r/8c4084fa-3885-29fe-5fc4-0d4ca199c785@suse.cz
Signed-off-by: Martin Liska <mliska@suse.cz>
Acked-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/base.c    |    6 ++++++
 kernel/gcov/gcc_4_7.c |    4 +++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff -puN kernel/gcov/base.c~gcov-support-gcc-71 kernel/gcov/base.c
--- a/kernel/gcov/base.c~gcov-support-gcc-71
+++ a/kernel/gcov/base.c
@@ -98,6 +98,12 @@ void __gcov_merge_icall_topn(gcov_type *
 }
 EXPORT_SYMBOL(__gcov_merge_icall_topn);
 
+void __gcov_exit(void)
+{
+	/* Unused. */
+}
+EXPORT_SYMBOL(__gcov_exit);
+
 /**
  * gcov_enable_events - enable event reporting through gcov_event()
  *
diff -puN kernel/gcov/gcc_4_7.c~gcov-support-gcc-71 kernel/gcov/gcc_4_7.c
--- a/kernel/gcov/gcc_4_7.c~gcov-support-gcc-71
+++ a/kernel/gcov/gcc_4_7.c
@@ -18,7 +18,9 @@
 #include <linux/vmalloc.h>
 #include "gcov.h"
 
-#if (__GNUC__ > 5) || (__GNUC__ == 5 && __GNUC_MINOR__ >= 1)
+#if (__GNUC__ >= 7)
+#define GCOV_COUNTERS			9
+#elif (__GNUC__ > 5) || (__GNUC__ == 5 && __GNUC_MINOR__ >= 1)
 #define GCOV_COUNTERS			10
 #elif __GNUC__ == 4 && __GNUC_MINOR__ >= 9
 #define GCOV_COUNTERS			9
_

Patches currently in -mm which might be from mliska@suse.cz are


