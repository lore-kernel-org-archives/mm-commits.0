From: akpm@linux-foundation.org
Subject: + linux-timexh-cleanup-for-userspace.patch added to -mm tree
Date: Tue, 19 Aug 2008 20:49:35 -0700
Message-ID: <200808200349.m7K3nZdp022728@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750864AbYHTDuM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Aug 2008 23:50:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, bunk@stusta.de, johnstul@us.ibm.com, tglx@linutronix.de, zippel@linux-m68k.org


The patch titled
     linux/timex.h: cleanup for userspace
has been added to the -mm tree.  Its filename is
     linux-timexh-cleanup-for-userspace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux/timex.h: cleanup for userspace
From: Mike Frysinger <vapier@gentoo.org>

MAXFREQ_SCALED was tweaked recently to contain a (s64) cast.  Assuming this
is meant for userspace, change it to (__s64) and pull in linux/types.h.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Adrian Bunk <bunk@stusta.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/timex.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/timex.h~linux-timexh-cleanup-for-userspace include/linux/timex.h
--- a/include/linux/timex.h~linux-timexh-cleanup-for-userspace
+++ a/include/linux/timex.h
@@ -55,6 +55,7 @@
 
 #include <linux/compiler.h>
 #include <linux/time.h>
+#include <linux/types.h>
 
 #include <asm/param.h>
 
@@ -85,7 +86,7 @@
 
 #define MAXPHASE 500000000l	/* max phase error (ns) */
 #define MAXFREQ 500000		/* max frequency error (ns/s) */
-#define MAXFREQ_SCALED ((s64)MAXFREQ << NTP_SCALE_SHIFT)
+#define MAXFREQ_SCALED ((__s64)MAXFREQ << NTP_SCALE_SHIFT)
 #define MINSEC 256		/* min interval between updates (s) */
 #define MAXSEC 2048		/* max interval between updates (s) */
 #define NTP_PHASE_LIMIT ((MAXPHASE / NSEC_PER_USEC) << 5) /* beyond max. dispersion */
_

Patches currently in -mm which might be from vapier@gentoo.org are

linux-timexh-cleanup-for-userspace.patch

