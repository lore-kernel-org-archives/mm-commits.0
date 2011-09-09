From: akpm@linux-foundation.org
Subject: + x86-rtc-dont-recursively-acquire-rtc_lock.patch added to -mm tree
Date: Fri, 09 Sep 2011 15:08:32 -0700
Message-ID: <201109092208.p89M8WRF009655@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759180Ab1IIWI6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2011 18:08:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matt.fleming@intel.com, avi@redhat.com, hpa@zytor.com, jbeulich@novell.com, jwboyer@gmail.com, mingo@elte.hu, rui.zhang@intel.com, tglx@linutronix.de


The patch titled
     x86 rtc: don't recursively acquire rtc_lock
has been added to the -mm tree.  Its filename is
     x86-rtc-dont-recursively-acquire-rtc_lock.patch

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
Subject: x86 rtc: don't recursively acquire rtc_lock
From: Matt Fleming <matt.fleming@intel.com>

A deadlock was introduced on x86 in commit ef68c8f87ed1 ("x86: Serialize
EFI time accesses on rtc_lock") because efi_get_time() and friends can be
called with rtc_lock already held by read_persistent_time(), e.g.

timekeeping_init()
    read_persistent_clock()     <-- acquire rtc_lock
        efi_get_time()
            phys_efi_get_time() <-- acquire rtc_lock <DEADLOCK>

To fix this let's push the locking down into the get_wallclock() and
set_wallclock() implementations.  Only the clock implementations that
access the x86 RTC directly need to acquire rtc_lock, so it makes sense to
push the locking down into the rtc, vrtc and efi code.

The virtualization implementations don't require rtc_lock to be held
because they provide their own serialization.

Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Acked-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Avi Kivity <avi@redhat.com> [for the virtualization aspect]
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Josh Boyer <jwboyer@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/rtc.c         |   23 ++++++++++++-----------
 arch/x86/platform/mrst/vrtc.c |    9 +++++++++
 2 files changed, 21 insertions(+), 11 deletions(-)

diff -puN arch/x86/kernel/rtc.c~x86-rtc-dont-recursively-acquire-rtc_lock arch/x86/kernel/rtc.c
--- a/arch/x86/kernel/rtc.c~x86-rtc-dont-recursively-acquire-rtc_lock
+++ a/arch/x86/kernel/rtc.c
@@ -43,8 +43,11 @@ int mach_set_rtc_mmss(unsigned long nowt
 {
 	int real_seconds, real_minutes, cmos_minutes;
 	unsigned char save_control, save_freq_select;
+	unsigned long flags;
 	int retval = 0;
 
+	spin_lock_irqsave(&rtc_lock, flags);
+
 	 /* tell the clock it's being set */
 	save_control = CMOS_READ(RTC_CONTROL);
 	CMOS_WRITE((save_control|RTC_SET), RTC_CONTROL);
@@ -94,12 +97,17 @@ int mach_set_rtc_mmss(unsigned long nowt
 	CMOS_WRITE(save_control, RTC_CONTROL);
 	CMOS_WRITE(save_freq_select, RTC_FREQ_SELECT);
 
+	spin_unlock_irqrestore(&rtc_lock, flags);
+
 	return retval;
 }
 
 unsigned long mach_get_cmos_time(void)
 {
 	unsigned int status, year, mon, day, hour, min, sec, century = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rtc_lock, flags);
 
 	/*
 	 * If UIP is clear, then we have >= 244 microseconds before
@@ -126,6 +134,8 @@ unsigned long mach_get_cmos_time(void)
 	status = CMOS_READ(RTC_CONTROL);
 	WARN_ON_ONCE(RTC_ALWAYS_BCD && (status & RTC_DM_BINARY));
 
+	spin_unlock_irqrestore(&rtc_lock, flags);
+
 	if (RTC_ALWAYS_BCD || !(status & RTC_DM_BINARY)) {
 		sec = bcd2bin(sec);
 		min = bcd2bin(min);
@@ -170,24 +180,15 @@ EXPORT_SYMBOL(rtc_cmos_write);
 
 int update_persistent_clock(struct timespec now)
 {
-	unsigned long flags;
-	int retval;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-	retval = x86_platform.set_wallclock(now.tv_sec);
-	spin_unlock_irqrestore(&rtc_lock, flags);
-
-	return retval;
+	return x86_platform.set_wallclock(now.tv_sec);
 }
 
 /* not static: needed by APM */
 void read_persistent_clock(struct timespec *ts)
 {
-	unsigned long retval, flags;
+	unsigned long retval;
 
-	spin_lock_irqsave(&rtc_lock, flags);
 	retval = x86_platform.get_wallclock();
-	spin_unlock_irqrestore(&rtc_lock, flags);
 
 	ts->tv_sec = retval;
 	ts->tv_nsec = 0;
diff -puN arch/x86/platform/mrst/vrtc.c~x86-rtc-dont-recursively-acquire-rtc_lock arch/x86/platform/mrst/vrtc.c
--- a/arch/x86/platform/mrst/vrtc.c~x86-rtc-dont-recursively-acquire-rtc_lock
+++ a/arch/x86/platform/mrst/vrtc.c
@@ -59,8 +59,11 @@ EXPORT_SYMBOL_GPL(vrtc_cmos_write);
 unsigned long vrtc_get_time(void)
 {
 	u8 sec, min, hour, mday, mon;
+	unsigned long flags;
 	u32 year;
 
+	spin_lock_irqsave(&rtc_lock, flags);
+
 	while ((vrtc_cmos_read(RTC_FREQ_SELECT) & RTC_UIP))
 		cpu_relax();
 
@@ -71,6 +74,8 @@ unsigned long vrtc_get_time(void)
 	mon = vrtc_cmos_read(RTC_MONTH);
 	year = vrtc_cmos_read(RTC_YEAR);
 
+	spin_unlock_irqrestore(&rtc_lock, flags);
+
 	/* vRTC YEAR reg contains the offset to 1960 */
 	year += 1960;
 
@@ -84,8 +89,10 @@ unsigned long vrtc_get_time(void)
 int vrtc_set_mmss(unsigned long nowtime)
 {
 	int real_sec, real_min;
+	unsigned long flags;
 	int vrtc_min;
 
+	spin_lock_irqsave(&rtc_lock, flags);
 	vrtc_min = vrtc_cmos_read(RTC_MINUTES);
 
 	real_sec = nowtime % 60;
@@ -96,6 +103,8 @@ int vrtc_set_mmss(unsigned long nowtime)
 
 	vrtc_cmos_write(real_sec, RTC_SECONDS);
 	vrtc_cmos_write(real_min, RTC_MINUTES);
+	spin_unlock_irqrestore(&rtc_lock, flags);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from matt.fleming@intel.com are

linux-next.patch
x86-rtc-dont-recursively-acquire-rtc_lock.patch

