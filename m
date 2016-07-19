From: akpm@linux-foundation.org
Subject: [merged] added-support-for-gcc-version-=-6.patch removed from -mm tree
Date: Tue, 19 Jul 2016 11:10:28 -0700
Message-ID: <578e6d14.tF4bGwBq1fs4vcbb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44074 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846AbcGSSK3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jul 2016 14:10:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Florian.Meier@informatik.uni-erlangen.de, oberpar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: gcov: add support for gcc version >= 6
has been removed from the -mm tree.  Its filename was
     added-support-for-gcc-version-=-6.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Florian Meier <Florian.Meier@informatik.uni-erlangen.de>
Subject: gcov: add support for gcc version >= 6

Link: http://lkml.kernel.org/r/20160701130914.GA23225@styxhp
Signed-off-by: Florian Meier <Florian.Meier@informatik.uni-erlangen.de>
Reviewed-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Tested-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/gcc_4_7.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/gcov/gcc_4_7.c~added-support-for-gcc-version-=-6 kernel/gcov/gcc_4_7.c
--- a/kernel/gcov/gcc_4_7.c~added-support-for-gcc-version-=-6
+++ a/kernel/gcov/gcc_4_7.c
@@ -18,7 +18,7 @@
 #include <linux/vmalloc.h>
 #include "gcov.h"
 
-#if __GNUC__ == 5 && __GNUC_MINOR__ >= 1
+#if (__GNUC__ > 5) || (__GNUC__ == 5 && __GNUC_MINOR__ >= 1)
 #define GCOV_COUNTERS			10
 #elif __GNUC__ == 4 && __GNUC_MINOR__ >= 9
 #define GCOV_COUNTERS			9
_

Patches currently in -mm which might be from Florian.Meier@informatik.uni-erlangen.de are


