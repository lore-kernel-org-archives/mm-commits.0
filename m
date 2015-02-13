From: akpm@linux-foundation.org
Subject: [merged] kernelh-remove-ancient-__function__-hack.patch removed
 from -mm tree
Date: Fri, 13 Feb 2015 12:21:57 -0800
Message-ID: <54de5ce5.n5Ch2IvqIYdgY2Hn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49078 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbbBMUV6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:21:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, joe@perches.com, mina86@mina86.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel.h: remove ancient __FUNCTION__ hack
has been removed from the -mm tree.  Its filename was
     kernelh-remove-ancient-__function__-hack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: kernel.h: remove ancient __FUNCTION__ hack

__FUNCTION__ hasn't been treated as a string literal since gcc 3.4, so
this only helps people who only test-compile using 3.3 (compiler-gcc3.h
barks at anything older than that).  Besides, there are almost no
occurrences of __FUNCTION__ left in the tree.

[akpm@linux-foundation.org: convert remaining __FUNCTION__ references]
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/hpet.c                       |    2 +-
 arch/x86/kernel/rtc.c                        |    4 ++--
 arch/x86/platform/intel-mid/intel_mid_vrtc.c |    2 +-
 drivers/acpi/acpica/utdebug.c                |    4 ++--
 drivers/block/xen-blkfront.c                 |    2 +-
 include/acpi/acoutput.h                      |    6 +++---
 include/linux/kernel.h                       |    3 ---
 7 files changed, 10 insertions(+), 13 deletions(-)

diff -puN arch/x86/kernel/hpet.c~kernelh-remove-ancient-__function__-hack arch/x86/kernel/hpet.c
--- a/arch/x86/kernel/hpet.c~kernelh-remove-ancient-__function__-hack
+++ a/arch/x86/kernel/hpet.c
@@ -168,7 +168,7 @@ static void _hpet_print_config(const cha
 #define hpet_print_config()					\
 do {								\
 	if (hpet_verbose)					\
-		_hpet_print_config(__FUNCTION__, __LINE__);	\
+		_hpet_print_config(__func__, __LINE__);	\
 } while (0)
 
 /*
diff -puN arch/x86/kernel/rtc.c~kernelh-remove-ancient-__function__-hack arch/x86/kernel/rtc.c
--- a/arch/x86/kernel/rtc.c~kernelh-remove-ancient-__function__-hack
+++ a/arch/x86/kernel/rtc.c
@@ -49,11 +49,11 @@ int mach_set_rtc_mmss(const struct times
 		retval = set_rtc_time(&tm);
 		if (retval)
 			printk(KERN_ERR "%s: RTC write failed with error %d\n",
-			       __FUNCTION__, retval);
+			       __func__, retval);
 	} else {
 		printk(KERN_ERR
 		       "%s: Invalid RTC value: write of %lx to RTC failed\n",
-			__FUNCTION__, nowtime);
+			__func__, nowtime);
 		retval = -EINVAL;
 	}
 	return retval;
diff -puN arch/x86/platform/intel-mid/intel_mid_vrtc.c~kernelh-remove-ancient-__function__-hack arch/x86/platform/intel-mid/intel_mid_vrtc.c
--- a/arch/x86/platform/intel-mid/intel_mid_vrtc.c~kernelh-remove-ancient-__function__-hack
+++ a/arch/x86/platform/intel-mid/intel_mid_vrtc.c
@@ -110,7 +110,7 @@ int vrtc_set_mmss(const struct timespec
 		spin_unlock_irqrestore(&rtc_lock, flags);
 	} else {
 		pr_err("%s: Invalid vRTC value: write of %lx to vRTC failed\n",
-			__FUNCTION__, now->tv_sec);
+			__func__, now->tv_sec);
 		retval = -EINVAL;
 	}
 	return retval;
diff -puN drivers/acpi/acpica/utdebug.c~kernelh-remove-ancient-__function__-hack drivers/acpi/acpica/utdebug.c
--- a/drivers/acpi/acpica/utdebug.c~kernelh-remove-ancient-__function__-hack
+++ a/drivers/acpi/acpica/utdebug.c
@@ -111,8 +111,8 @@ void acpi_ut_track_stack_ptr(void)
  * RETURN:      Updated pointer to the function name
  *
  * DESCRIPTION: Remove the "Acpi" prefix from the function name, if present.
- *              This allows compiler macros such as __FUNCTION__ to be used
- *              with no change to the debug output.
+ *              This allows compiler macros such as __func__ to be used with no
+ *              change to the debug output.
  *
  ******************************************************************************/
 
diff -puN drivers/block/xen-blkfront.c~kernelh-remove-ancient-__function__-hack drivers/block/xen-blkfront.c
--- a/drivers/block/xen-blkfront.c~kernelh-remove-ancient-__function__-hack
+++ a/drivers/block/xen-blkfront.c
@@ -1391,7 +1391,7 @@ static int blkfront_probe(struct xenbus_
 			if (major != XENVBD_MAJOR) {
 				printk(KERN_INFO
 						"%s: HVM does not support vbd %d as xen block device\n",
-						__FUNCTION__, vdevice);
+						__func__, vdevice);
 				return -ENODEV;
 			}
 		}
diff -puN include/acpi/acoutput.h~kernelh-remove-ancient-__function__-hack include/acpi/acoutput.h
--- a/include/acpi/acoutput.h~kernelh-remove-ancient-__function__-hack
+++ a/include/acpi/acoutput.h
@@ -240,7 +240,7 @@
 /*
  * If ACPI_GET_FUNCTION_NAME was not defined in the compiler-dependent header,
  * define it now. This is the case where there the compiler does not support
- * a __FUNCTION__ macro or equivalent.
+ * a __func__ macro or equivalent.
  */
 #ifndef ACPI_GET_FUNCTION_NAME
 #define ACPI_GET_FUNCTION_NAME          _acpi_function_name
@@ -249,12 +249,12 @@
  * The Name parameter should be the procedure name as a quoted string.
  * The function name is also used by the function exit macros below.
  * Note: (const char) is used to be compatible with the debug interfaces
- * and macros such as __FUNCTION__.
+ * and macros such as __func__.
  */
 #define ACPI_FUNCTION_NAME(name)        static const char _acpi_function_name[] = #name;
 
 #else
-/* Compiler supports __FUNCTION__ (or equivalent) -- Ignore this macro */
+/* Compiler supports __func__ (or equivalent) -- Ignore this macro */
 
 #define ACPI_FUNCTION_NAME(name)
 #endif				/* ACPI_GET_FUNCTION_NAME */
diff -puN include/linux/kernel.h~kernelh-remove-ancient-__function__-hack include/linux/kernel.h
--- a/include/linux/kernel.h~kernelh-remove-ancient-__function__-hack
+++ a/include/linux/kernel.h
@@ -800,9 +800,6 @@ static inline void ftrace_dump(enum ftra
 	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
 	(type *)( (char *)__mptr - offsetof(type,member) );})
 
-/* Trap pasters of __FUNCTION__ at compile-time */
-#define __FUNCTION__ (__func__)
