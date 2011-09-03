From: akpm@linux-foundation.org
Subject: + x86-rtc-dont-register-a-platform-rtc-device-for-intel-mid-platforms.patch added to -mm tree
Date: Fri, 02 Sep 2011 17:29:46 -0700
Message-ID: <201109030029.p830Tkta019308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48268 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751633Ab1ICAaH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2011 20:30:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathias.nyman@linux.intel.com, alan@linux.intel.com, feng.tang@intel.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: rtc: don't register a platform RTC device for Intel MID platforms
has been added to the -mm tree.  Its filename is
     x86-rtc-dont-register-a-platform-rtc-device-for-intel-mid-platforms.patch

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
Subject: x86: rtc: don't register a platform RTC device for Intel MID platforms
From: Mathias Nyman <mathias.nyman@linux.intel.com>

Intel MID x86 platforms have a memory mapped virtual RTC instead.  No MID
platform have the default ports (and accessing them may do weird stuff)

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/mrst.h |    9 +++++++++
 arch/x86/kernel/rtc.c       |    5 +++++
 2 files changed, 14 insertions(+)

diff -puN arch/x86/include/asm/mrst.h~x86-rtc-dont-register-a-platform-rtc-device-for-intel-mid-platforms arch/x86/include/asm/mrst.h
--- a/arch/x86/include/asm/mrst.h~x86-rtc-dont-register-a-platform-rtc-device-for-intel-mid-platforms
+++ a/arch/x86/include/asm/mrst.h
@@ -31,11 +31,20 @@ enum mrst_cpu_type {
 };
 
 extern enum mrst_cpu_type __mrst_cpu_chip;
+
+#ifdef CONFIG_X86_INTEL_MID
+
 static inline enum mrst_cpu_type mrst_identify_cpu(void)
 {
 	return __mrst_cpu_chip;
 }
 
+#else /* !CONFIG_X86_INTEL_MID */
+
+#define mrst_identify_cpu()    (0)
+
+#endif /* !CONFIG_X86_INTEL_MID */
+
 enum mrst_timer_options {
 	MRST_TIMER_DEFAULT,
 	MRST_TIMER_APBT_ONLY,
diff -puN arch/x86/kernel/rtc.c~x86-rtc-dont-register-a-platform-rtc-device-for-intel-mid-platforms arch/x86/kernel/rtc.c
--- a/arch/x86/kernel/rtc.c~x86-rtc-dont-register-a-platform-rtc-device-for-intel-mid-platforms
+++ a/arch/x86/kernel/rtc.c
@@ -12,6 +12,7 @@
 #include <asm/vsyscall.h>
 #include <asm/x86_init.h>
 #include <asm/time.h>
+#include <asm/mrst.h>
 
 #ifdef CONFIG_X86_32
 /*
@@ -241,6 +242,10 @@ static __init int add_rtc_cmos(void)
 	if (of_have_populated_dt())
 		return 0;
 
+	/* Intel MID platforms don't have ioport rtc */
+	if (mrst_identify_cpu())
+		return -ENODEV;
+
 	platform_device_register(&rtc_device);
 	dev_info(&rtc_device.dev,
 		 "registered platform RTC device (no PNP device found)\n");
_

Patches currently in -mm which might be from mathias.nyman@linux.intel.com are

vrtc-change-its-year-offset-from-1960-to-1972.patch
x86-rtc-dont-register-a-platform-rtc-device-for-intel-mid-platforms.patch
x86-mrst-some-drivers-need-to-known-when-an-scu-is-available.patch
mrst-battery-fixes.patch

