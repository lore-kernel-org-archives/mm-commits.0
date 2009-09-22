From: akpm@linux-foundation.org
Subject: + include-linux-kmemcheckh-fix-a-trillion-warnings.patch added to -mm tree
Date: Tue, 22 Sep 2009 14:53:45 -0700
Message-ID: <200909222216.n8MMG9hj032704@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751043AbZIVWQt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 18:16:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, johannes@sipsolutions.net, vegard.nossum@gmail.com


The patch titled
     include/linux/kmemcheck.h: fix a trillion warnings
has been added to the -mm tree.  Its filename is
     include-linux-kmemcheckh-fix-a-trillion-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/kmemcheck.h: fix a trillion warnings
From: Andrew Morton <akpm@linux-foundation.org>

of the form

include/net/inet_sock.h:208: warning: ISO C90 forbids mixed declarations and code

Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmemcheck.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/kmemcheck.h~include-linux-kmemcheckh-fix-a-trillion-warnings include/linux/kmemcheck.h
--- a/include/linux/kmemcheck.h~include-linux-kmemcheckh-fix-a-trillion-warnings
+++ a/include/linux/kmemcheck.h
@@ -145,10 +145,12 @@ static inline bool kmemcheck_is_obj_init
 
 #define kmemcheck_annotate_bitfield(ptr, name)				\
 	do {								\
+		int _n;							\
+									\
 		if (!ptr)						\
 			break;						\
 									\
-		int _n = (long) &((ptr)->name##_end)			\
+		_n = (long) &((ptr)->name##_end)			\
 			- (long) &((ptr)->name##_begin);		\
 		BUILD_BUG_ON(_n < 0);					\
 									\
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
include-linux-kmemcheckh-fix-a-trillion-warnings.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios.patch
generic-ipi-make-struct-call_function_data-lockless.patch
proc-connector-add-event-for-process-becoming-session-leader.patch
build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it.patch
build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it-fix.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
sdio-add-cd-disable-support.patch
sdio-add-mmc_quirk_lenient_fn0.patch
at91-atmel-mci-platform-configuration-to-the-the-atmel-mci-driver.patch
mmc-core-sdio-suspend-resume-support.patch
procfs-provide-stack-information-for-threads-v08.patch
kcore-register-vmemmap-range.patch
rtc-add-driver-for-mxcs-internal-rtc-module.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4.patch
drivers-video-add-kmalloc-null-tests.patch
drivers-video-tmiofbc-fix-uninitialised-return-value.patch
v3-minixfs-add-missing-directory-type-checking.patch

