From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?jiffiesh-declare-jiffies-and-jiffies=5F64-with-=5F=5F?=
 =?US-ASCII?Q?=5F=5Fcacheline=5Faligned=5Fin=5Fsmp.patch?= removed from -mm
 tree
Date: Tue, 09 May 2017 11:00:38 -0700
Message-ID: <20170509180038.AkqxSkFY1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34226 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753459AbdEISAj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:00:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghackmann@google.com, grundler@chromium.org, Jason@zx2c4.com, md@google.com, mka@chromium.org, mm-commits@vger.kernel.org, tglx@linutronix.de


The patch titled
     Subject: jiffies.h: declare jiffies and jiffies_64 with ____cacheline_aligned_in_smp
has been removed from the -mm tree.  Its filename was
     jiffiesh-declare-jiffies-and-jiffies_64-with-____cacheline_aligned_in_smp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthias Kaehlcke <mka@chromium.org>
Subject: jiffies.h: declare jiffies and jiffies_64 with ____cacheline_aligned_in_smp

jiffies_64 is defined in kernel/time/timer.c with
____cacheline_aligned_in_smp, however this macro is not part of the
declaration of jiffies and jiffies_64 in jiffies.h.

As a result clang generates the following warning:

kernel/time/timer.c:57:26: error: section does not match previous declaration [-Werror,-Wsection]
__visible u64 jiffies_64 __cacheline_aligned_in_smp = INITIAL_JIFFIES;
                         ^
include/linux/cache.h:39:36: note: expanded from macro '__cacheline_aligned_in_smp'
                                   ^
include/linux/cache.h:34:4: note: expanded from macro '__cacheline_aligned'
                 __section__(".data..cacheline_aligned")))
                 ^
include/linux/jiffies.h:77:12: note: previous attribute is here
extern u64 __jiffy_data jiffies_64;
           ^
include/linux/jiffies.h:70:38: note: expanded from macro '__jiffy_data'

Link: http://lkml.kernel.org/r/20170403190200.70273-1-mka@chromium.org
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>
Cc: Grant Grundler <grundler@chromium.org>
Cc: Michael Davidson <md@google.com>
Cc: Greg Hackmann <ghackmann@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/jiffies.h |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN include/linux/jiffies.h~jiffiesh-declare-jiffies-and-jiffies_64-with-____cacheline_aligned_in_smp include/linux/jiffies.h
--- a/include/linux/jiffies.h~jiffiesh-declare-jiffies-and-jiffies_64-with-____cacheline_aligned_in_smp
+++ a/include/linux/jiffies.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_JIFFIES_H
 #define _LINUX_JIFFIES_H
 
+#include <linux/cache.h>
 #include <linux/math64.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
@@ -63,19 +64,13 @@ extern int register_refined_jiffies(long
 /* TICK_USEC is the time between ticks in usec assuming fake USER_HZ */
 #define TICK_USEC ((1000000UL + USER_HZ/2) / USER_HZ)
 
-/* some arch's have a small-data section that can be accessed register-relative
- * but that can only take up to, say, 4-byte variables. jiffies being part of
- * an 8-byte variable may not be correctly accessed unless we force the issue
- */
-#define __jiffy_data  __attribute__((section(".data")))
