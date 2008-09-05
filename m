From: akpm@linux-foundation.org
Subject: + sched-fix-compilation-with-gcc-346.patch added to -mm tree
Date: Fri, 05 Sep 2008 14:45:20 -0700
Message-ID: <200809052145.m85LjLHG021898@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48514 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751607AbYIEVqI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Sep 2008 17:46:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@poczta.fm, krzysztof.h1@wp.pl, mingo@elte.hu


The patch titled
     sched: fix compilation with gcc 3.4.6
has been added to the -mm tree.  Its filename is
     sched-fix-compilation-with-gcc-346.patch

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
Subject: sched: fix compilation with gcc 3.4.6
From: Krzysztof Helt <krzysztof.h1@poczta.fm>

kernel/sched.c: In function `start_rt_bandwidth':
kernel/sched.c:208: sorry, unimplemented: inlining failed in call to 'rt_bandwidth_enabled': function body not available
kernel/sched.c:214: sorry, unimplemented: called from here

It seems that the gcc 3.4.6 requires full inline definition before first usage.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN kernel/sched.c~sched-fix-compilation-with-gcc-346 kernel/sched.c
--- a/kernel/sched.c~sched-fix-compilation-with-gcc-346
+++ a/kernel/sched.c
@@ -205,7 +205,10 @@ void init_rt_bandwidth(struct rt_bandwid
 	rt_b->rt_period_timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_SOFTIRQ;
 }
 
-static inline int rt_bandwidth_enabled(void);
+static inline int rt_bandwidth_enabled(void)
+{
+	return sysctl_sched_rt_runtime >= 0;
+}
 
 static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
 {
@@ -844,11 +847,6 @@ static inline u64 global_rt_runtime(void
 	return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
 }
 
-static inline int rt_bandwidth_enabled(void)
-{
-	return sysctl_sched_rt_runtime >= 0;
-}
-
 #ifndef prepare_arch_switch
 # define prepare_arch_switch(next)	do { } while (0)
 #endif
_

Patches currently in -mm which might be from krzysztof.h1@poczta.fm are

origin.patch
linux-next.patch
sched-fix-compilation-with-gcc-346.patch
fb-push-down-the-bkl-in-the-ioctl-handler.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
viafb-viafbmodes-viafbtxt.patch
viafb-viafbmodes-viafbtxt-fix.patch
viafb-viafbmodes-viafbtxt-fix-fix.patch
viafb-makefile-kconfig.patch
viafb-accelc-accelh.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-chiph-debugh.patch
viafb-dvic-dvih-globalc-and-globalh.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-ifacec-ifaceh-ioctlc-ioctlh.patch
viafb-lcdc-lcdh-lcdtblh.patch
viafb-makefile-shareh.patch
viafb-tbl1636c-tbl1636h-tbldpasettingc-tbldpasettingh.patch
viafb-viafbdevc-viafbdevh.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
viafb-via_i2cc-via_i2ch-viamodec-viamodeh.patch
viafb-via_utilityc-via_utilityh-vt1636c-vt1636h.patch
efifb-imacfb-consolidation-hardware-support.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch

