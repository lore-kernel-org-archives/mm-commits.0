From: akpm@linux-foundation.org
Subject: +
 jiffiesh-declare-jiffies-and-jiffies_64-with-____cacheline_aligned_in_smp.patch added to -mm tree
Date: Mon, 03 Apr 2017 15:30:21 -0700
Message-ID: <58e2ccfd.hhskK1KtoRrUtNQa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53776 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751635AbdDCWaW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Apr 2017 18:30:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mka@chromium.org, Jason@zx2c4.com, ghackmann@google.com, grundler@chromium.org, md@google.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: jiffies.h: declare jiffies and jiffies_64 with ____cacheline_aligned_in_smp
has been added to the -mm tree.  Its filename is
     jiffiesh-declare-jiffies-and-jiffies_64-with-____cacheline_aligned_in_smp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/jiffiesh-declare-jiffies-and-jiffies_64-with-____cacheline_aligned_in_smp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/jiffiesh-declare-jiffies-and-jiffies_64-with-____cacheline_aligned_in_smp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
