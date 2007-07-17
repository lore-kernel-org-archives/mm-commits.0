From: akpm@linux-foundation.org
Subject: - make-timespec_equal-take-const-arguments.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:02:28 -0700
Message-ID: <200707172302.l6HN2SXc011575@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47493 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933784AbXGQXRc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:17:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@computergmbh.de, jengelh@gmx.de, johnstul@us.ibm.com, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     make timespec_equal() take const arguments
has been removed from the -mm tree.  Its filename was
     make-timespec_equal-take-const-arguments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: make timespec_equal() take const arguments
From: Jan Engelhardt <jengelh@computergmbh.de>

Make arguments of timespec_equal() const struct timespec.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/time.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/time.h~make-timespec_equal-take-const-arguments include/linux/time.h
--- a/include/linux/time.h~make-timespec_equal-take-const-arguments
+++ a/include/linux/time.h
@@ -36,7 +36,8 @@ struct timezone {
 #define NSEC_PER_SEC	1000000000L
 #define FSEC_PER_SEC	1000000000000000L
 
-static inline int timespec_equal(struct timespec *a, struct timespec *b)
+static inline int timespec_equal(const struct timespec *a,
+                                 const struct timespec *b)
 {
 	return (a->tv_sec == b->tv_sec) && (a->tv_nsec == b->tv_nsec);
 }
_

Patches currently in -mm which might be from jengelh@computergmbh.de are

origin.patch
intel-iommu-iommu-gfx-workaround-kconfig-fix.patch
intel-iommu-iommu-floppy-workaround-kconfig-fix.patch
