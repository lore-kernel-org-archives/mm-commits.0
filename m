From: akpm@linux-foundation.org
Subject: + rtc-simplified-rtc-sysfs-attribute-handling-tidy.patch added to -mm tree
Date: Thu, 01 Mar 2007 17:15:53 -0800
Message-ID: <200703020115.l221Fr9P028472@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33563 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161136AbXCBBP5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 20:15:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     RTC: replace some newly-introduced macros with inlines
has been added to the -mm tree.  Its filename is
     rtc-simplified-rtc-sysfs-attribute-handling-tidy.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: RTC: replace some newly-introduced macros with inlines
From: David Brownell <david-b@pacbell.net>

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-core.h |   46 +++++++++++++++++++++++++++++----------
 1 files changed, 35 insertions(+), 11 deletions(-)

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

rtc_cmos-oops-fix.patch
parport-is-an-orphan.patch
add-config_generic_gpio.patch
git-avr32.patch
git-md-accel.patch
8250-make-probing-for-txen-bug-a-config-option.patch
blackfin-on-chip-rtc-controller-driver.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
rtc-remove-sys-class-rtc-dev.patch
rtc-rtc-interfaces-dont-use-class_device.patch
rtc-simplified-rtc-sysfs-attribute-handling.patch
rtc-simplified-proc-driver-rtc-handling.patch
rtc-remove-rest-of-class_device.patch
rtc-suspend-resume-restores-system-clock.patch
rtc-simplified-rtc-sysfs-attribute-handling-tidy.patch
