From: akpm@linux-foundation.org
Subject: [folded-merged]
 watchdog-control-hard-lockup-detection-default-fix-2.patch removed from -mm tree
Date: Mon, 13 Oct 2014 15:43:42 -0700
Message-ID: <543c559e.ReVrE1O2by8S8z3k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34727 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbaJMWnm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 18:43:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dzickus@redhat.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog, nmi: Fix compile issues on sparc
has been removed from the -mm tree.  Its filename was
     watchdog-control-hard-lockup-detection-default-fix-2.patch

This patch was dropped because it was folded into watchdog-control-hard-lockup-detection-default.patch

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

origin.patch
watchdog-control-hard-lockup-detection-default.patch
kvm-ensure-hard-lockup-detection-is-disabled-by-default.patch

