From: akpm@linux-foundation.org
Subject: + crc32-use-ktime_get_ns-for-measurement.patch added to -mm tree
Date: Tue, 21 Jun 2016 16:36:27 -0700
Message-ID: <5769cf7b.UUgQg+Xe+vAcYl8Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47556 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbcFVAaw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2016 20:30:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: crc32: use ktime_get_ns() for measurement
has been added to the -mm tree.  Its filename is
     crc32-use-ktime_get_ns-for-measurement.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/crc32-use-ktime_get_ns-for-measurement.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/crc32-use-ktime_get_ns-for-measurement.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: crc32: use ktime_get_ns() for measurement

The crc32 test function measures the elapsed time in nanoseconds, but uses
'struct timespec' for that.  We want to remove timespec from the kernel
for y2038 compatibility, and ktime_get_ns() also helps make the code
simpler here.

It is also slightly better to use monontonic time, as we are only
interested in the time difference.

Link: http://lkml.kernel.org/r/20160617143932.3289626-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: "David S . Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/crc32.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff -puN lib/crc32.c~crc32-use-ktime_get_ns-for-measurement lib/crc32.c
--- a/lib/crc32.c~crc32-use-ktime_get_ns-for-measurement
+++ a/lib/crc32.c
@@ -979,7 +979,6 @@ static int __init crc32c_test(void)
 	int i;
 	int errors = 0;
 	int bytes = 0;
-	struct timespec start, stop;
 	u64 nsec;
 	unsigned long flags;
 
@@ -999,20 +998,17 @@ static int __init crc32c_test(void)
 	local_irq_save(flags);
 	local_irq_disable();
 
-	getnstimeofday(&start);
+	nsec = ktime_get_ns();
 	for (i = 0; i < 100; i++) {
 		if (test[i].crc32c_le != __crc32c_le(test[i].crc, test_buf +
 		    test[i].start, test[i].length))
 			errors++;
 	}
-	getnstimeofday(&stop);
+	nsec = ktime_get_ns() - nsec;
 
 	local_irq_restore(flags);
 	local_irq_enable();
 
-	nsec = stop.tv_nsec - start.tv_nsec +
-		1000000000 * (stop.tv_sec - start.tv_sec);
-
 	pr_info("crc32c: CRC_LE_BITS = %d\n", CRC_LE_BITS);
 
 	if (errors)
@@ -1065,7 +1061,6 @@ static int __init crc32_test(void)
 	int i;
 	int errors = 0;
 	int bytes = 0;
-	struct timespec start, stop;
 	u64 nsec;
 	unsigned long flags;
 
@@ -1088,7 +1083,7 @@ static int __init crc32_test(void)
 	local_irq_save(flags);
 	local_irq_disable();
 
-	getnstimeofday(&start);
+	nsec = ktime_get_ns();
 	for (i = 0; i < 100; i++) {
 		if (test[i].crc_le != crc32_le(test[i].crc, test_buf +
 		    test[i].start, test[i].length))
@@ -1098,14 +1093,11 @@ static int __init crc32_test(void)
 		    test[i].start, test[i].length))
 			errors++;
 	}
-	getnstimeofday(&stop);
+	nsec = ktime_get_ns() - nsec;
 
 	local_irq_restore(flags);
 	local_irq_enable();
 
-	nsec = stop.tv_nsec - start.tv_nsec +
-		1000000000 * (stop.tv_sec - start.tv_sec);
