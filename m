From: akpm@linux-foundation.org
Subject: [merged]
 watchdog-move-nmi-function-header-declarations-from-watchdogh-to-nmih.patch removed from -mm tree
Date: Tue, 08 Sep 2015 11:03:08 -0700
Message-ID: <55ef22dc.lAuQC1JasHRfpCSW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58953 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbbIHSDJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:03:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@roeck-us.net, dzickus@redhat.com, eranian@google.com, mingo@kernel.org, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog: move NMI function header declarations from watchdog.h to nmi.h
has been removed from the -mm tree.  Its filename was
     watchdog-move-nmi-function-header-declarations-from-watchdogh-to-nmih.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Guenter Roeck <linux@roeck-us.net>
Subject: kernel/watchdog: move NMI function header declarations from watchdog.h to nmi.h

The kernel's NMI watchdog has nothing to do with the watchdog subsystem. 
Its header declarations should be in linux/nmi.h, not linux/watchdog.h.

The code provided two sets of dummy functions if HARDLOCKUP_DETECTOR is
not configured, one in the include file and one in kernel/watchdog.c. 
Remove the dummy functions from kernel/watchdog.c and use those from the
include file.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Cc: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Don Zickus <dzickus@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/perf_event_intel.c |    2 +-
 include/linux/nmi.h                    |    8 +++++---
 include/linux/watchdog.h               |    8 --------
 kernel/watchdog.c                      |    2 --
 4 files changed, 6 insertions(+), 14 deletions(-)

diff -puN arch/x86/kernel/cpu/perf_event_intel.c~watchdog-move-nmi-function-header-declarations-from-watchdogh-to-nmih arch/x86/kernel/cpu/perf_event_intel.c
--- a/arch/x86/kernel/cpu/perf_event_intel.c~watchdog-move-nmi-function-header-declarations-from-watchdogh-to-nmih
+++ a/arch/x86/kernel/cpu/perf_event_intel.c
@@ -12,7 +12,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/export.h>
-#include <linux/watchdog.h>
+#include <linux/nmi.h>
 
 #include <asm/cpufeature.h>
 #include <asm/hardirq.h>
diff -puN include/linux/nmi.h~watchdog-move-nmi-function-header-declarations-from-watchdogh-to-nmih include/linux/nmi.h
--- a/include/linux/nmi.h~watchdog-move-nmi-function-header-declarations-from-watchdogh-to-nmih
+++ a/include/linux/nmi.h
@@ -26,10 +26,12 @@ static inline void touch_nmi_watchdog(vo
 
 #if defined(CONFIG_HARDLOCKUP_DETECTOR)
 extern void hardlockup_detector_disable(void);
+void watchdog_nmi_disable_all(void);
+void watchdog_nmi_enable_all(void);
 #else
-static inline void hardlockup_detector_disable(void)
-{
-}
+static inline void hardlockup_detector_disable(void) {}
+static inline void watchdog_nmi_disable_all(void) {}
+static inline void watchdog_nmi_enable_all(void) {}
 #endif
 
 /*
diff -puN include/linux/watchdog.h~watchdog-move-nmi-function-header-declarations-from-watchdogh-to-nmih include/linux/watchdog.h
--- a/include/linux/watchdog.h~watchdog-move-nmi-function-header-declarations-from-watchdogh-to-nmih
+++ a/include/linux/watchdog.h
@@ -140,12 +140,4 @@ extern int watchdog_init_timeout(struct
 extern int watchdog_register_device(struct watchdog_device *);
 extern void watchdog_unregister_device(struct watchdog_device *);
 
-#ifdef CONFIG_HARDLOCKUP_DETECTOR
-void watchdog_nmi_disable_all(void);
-void watchdog_nmi_enable_all(void);
-#else
-static inline void watchdog_nmi_disable_all(void) {}
-static inline void watchdog_nmi_enable_all(void) {}
-#endif
