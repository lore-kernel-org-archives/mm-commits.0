From: akpm@linux-foundation.org
Subject: + make-timespec_equal-take-const-arguments.patch added to -mm tree
Date: Thu, 12 Jul 2007 16:15:31 -0700
Message-ID: <200707122315.l6CNFVMW010368@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50883 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758479AbXGLXQ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jul 2007 19:16:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@computergmbh.de, jengelh@gmx.de, johnstul@us.ibm.com, tglx@linutronix.de, zippel@linux-m68k.org


The patch titled
     make timespec_equal() take const arguments
has been added to the -mm tree.  Its filename is
     make-timespec_equal-take-const-arguments.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/time.h~make-timespec_equal-take-const-arguments include/linux/time.h
--- a/include/linux/time.h~make-timespec_equal-take-const-arguments
+++ a/include/linux/time.h
@@ -37,7 +37,8 @@ struct timezone {
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

fix-gregkh-usb-usb-use-menuconfig-objects.patch
make-timespec_equal-take-const-arguments.patch
