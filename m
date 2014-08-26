From: akpm@linux-foundation.org
Subject: + watchdog-control-hard-lockup-detection-default-fix-2.patch
 added to -mm tree
Date: Tue, 26 Aug 2014 13:17:47 -0700
Message-ID: <53fceb6b.jn61u9n8suYbl5VM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:45969 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbaHZURs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 16:17:48 -0400
Received: by mail-ie0-f201.google.com with SMTP id tr6so1749207ieb.2
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 13:17:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dzickus@redhat.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog, nmi: Fix compile issues on sparc
has been added to the -mm tree.  Its filename is
     watchdog-control-hard-lockup-detection-default-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-control-hard-lockup-detection-default-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-control-hard-lockup-detection-default-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Don Zickus <dzickus@redhat.com>
Subject: watchdog, nmi: Fix compile issues on sparc

Sparc doesn't use HARDLOCKUP_DETECTOR the same way x86 does.  As a result break
out the new functions

watchdog_hardlockup_detector_is_enabled
watchdog_enable_hardlockup_detector

into their own #if defined area.  This resolves the compile issue where
CONFIG_NMI_WATCHDOG=y and CONFIG_HARDLOCKUP_DETECTOR is not set on sparc.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nmi.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN include/linux/nmi.h~watchdog-control-hard-lockup-detection-default-fix-2 include/linux/nmi.h
--- a/include/linux/nmi.h~watchdog-control-hard-lockup-detection-default-fix-2
+++ a/include/linux/nmi.h
@@ -17,13 +17,17 @@
 #if defined(CONFIG_HAVE_NMI_WATCHDOG) || defined(CONFIG_HARDLOCKUP_DETECTOR)
 #include <asm/nmi.h>
 extern void touch_nmi_watchdog(void);
-extern void watchdog_enable_hardlockup_detector(bool val);
-extern bool watchdog_hardlockup_detector_is_enabled(void);
 #else
 static inline void touch_nmi_watchdog(void)
 {
 	touch_softlockup_watchdog();
 }
+#endif
+
+#if defined(CONFIG_HARDLOCKUP_DETECTOR)
+extern void watchdog_enable_hardlockup_detector(bool val);
+extern bool watchdog_hardlockup_detector_is_enabled(void);
+#else
 static inline void watchdog_enable_hardlockup_detector(bool val)
 {
 }
_

Patches currently in -mm which might be from dzickus@redhat.com are

linux-next.patch
softlockup-make-detector-be-aware-of-task-switch-of-processes-hogging-cpu.patch
watchdog-control-hard-lockup-detection-default.patch
watchdog-control-hard-lockup-detection-default-fix.patch
watchdog-control-hard-lockup-detection-default-fix-2.patch
kvm-ensure-hard-lockup-detection-is-disabled-by-default.patch

