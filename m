From: akpm@linux-foundation.org
Subject: [folded-merged] gcov-support-gcc-71-v2.patch removed from -mm
 tree
Date: Fri, 12 May 2017 15:40:58 -0700
Message-ID: <591639fa.Ka1DzllJUOWHuIDE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38354 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752997AbdELWk7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2017 18:40:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mliska@suse.cz, oberpar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: gcov-support-gcc-71-v2
has been removed from the -mm tree.  Its filename was
     gcov-support-gcc-71-v2.patch

This patch was dropped because it was folded into gcov-support-gcc-71.patch

------------------------------------------------------
From: Martin Liska <mliska@suse.cz>
Subject: gcov-support-gcc-71-v2

Starting from GCC 7.1, __gcov_exit is a new symbol expected
to be implemented in a profiling runtime. Update number of profile
counters.

Link: http://lkml.kernel.org/r/e63a3c59-0149-c97e-4084-20ca8f146b26@suse.cz
Signed-off-by: Martin Liska <mliska@suse.cz>
Acked-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/gcc_4_7.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/gcov/gcc_4_7.c~gcov-support-gcc-71-v2 kernel/gcov/gcc_4_7.c
--- a/kernel/gcov/gcc_4_7.c~gcov-support-gcc-71-v2
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

gcov-support-gcc-71.patch

