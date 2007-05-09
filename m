From: akpm@linux-foundation.org
Subject: - rtc-simplified-rtc-sysfs-attribute-handling-tidy.patch removed from -mm tree
Date: Tue, 08 May 2007 19:54:16 -0700
Message-ID: <200705090254.l492sGuU009785@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032263AbXEICyZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:54:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     RTC: replace some newly-introduced macros with inlines
has been removed from the -mm tree.  Its filename was
     rtc-simplified-rtc-sysfs-attribute-handling-tidy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: RTC: replace some newly-introduced macros with inlines
From: David Brownell <david-b@pacbell.net>

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-core.h |   46 +++++++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 11 deletions(-)

diff -puN drivers/rtc/rtc-core.h~rtc-simplified-rtc-sysfs-attribute-handling-tidy drivers/rtc/rtc-core.h
--- a/drivers/rtc/rtc-core.h~rtc-simplified-rtc-sysfs-attribute-handling-tidy
+++ a/drivers/rtc/rtc-core.h
@@ -7,22 +7,38 @@ extern void rtc_dev_del_device(struct rt
 
 #else
 
-#define rtc_dev_init()		do{}while(0)
-#define rtc_dev_exit()		do{}while(0)
-#define rtc_dev_add_device(r)	do{}while(0)
-#define rtc_dev_del_device(r)	do{}while(0)
+static inline void rtc_dev_init(void)
+{
+}
+
+static inline void rtc_dev_exit(void)
+{
+}
+
+static inline void rtc_dev_add_device(struct rtc_device *rtc)
+{
+}
+
+static inline void rtc_dev_del_device(struct rtc_device *rtc)
+{
+}
 
 #endif
 
 #ifdef CONFIG_RTC_INTF_PROC
 
-void rtc_proc_add_device(struct rtc_device *rtc);
-void rtc_proc_del_device(struct rtc_device *rtc);
+extern void rtc_proc_add_device(struct rtc_device *rtc);
+extern void rtc_proc_del_device(struct rtc_device *rtc);
 
 #else
 
-#define rtc_proc_add_device(r)	do{}while(0)
-#define rtc_proc_del_device(r)	do{}while(0)
+static inline void rtc_proc_add_device(struct rtc_device *rtc)
+{
+}
+
+static inline void rtc_proc_del_device(struct rtc_device *rtc)
+{
+}
 
 #endif
 
@@ -34,8 +50,16 @@ extern void rtc_sysfs_del_device(struct 
 
 #else
 
-#define rtc_sysfs_init(c)	do{}while(0)
-#define rtc_sysfs_add_device(r)	do{}while(0)
-#define rtc_sysfs_del_device(r)	do{}while(0)
+static inline void rtc_sysfs_init(struct class *rtc)
+{
+}
+
+static inline void rtc_sysfs_add_device(struct rtc_device *rtc)
+{
+}
+
+static inline void rtc_sysfs_del_device(struct rtc_device *rtc)
+{
+}
 
 #endif
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
acpi-driver-model-flags-and-platform_enable_wake.patch
update-documentation-driver-model-platformtxt.patch
use-common-cpu_is_xxx-macros-on-at91-and-avr32.patch
atmel_spi-remove-unnecessary-and-wrong-ifdefs.patch
