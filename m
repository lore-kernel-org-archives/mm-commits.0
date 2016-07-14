From: akpm@linux-foundation.org
Subject: [patch 14/20] gcov: add support for gcc version >= 6
Date: Thu, 14 Jul 2016 12:07:26 -0700
Message-ID: <5787e2ee.l2Ba7PvT3arcjn6f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41007 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbcGNTH1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jul 2016 15:07:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, Florian.Meier@informatik.uni-erlangen.de, oberpar@linux.vnet.ibm.com

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
