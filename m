From: akpm@linux-foundation.org
Subject: - clocksource-keep-track-of-original-clocksource-frequency-fix.patch removed from -mm tree
Date: Thu, 03 Apr 2008 14:10:19 -0700
Message-ID: <200804032110.m33LAJcI022658@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35864 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757392AbYDCVKg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2008 17:10:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zippel@linux-m68k.org, johnstul@us.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     clocksource-keep-track-of-original-clocksource-frequency fix
has been removed from the -mm tree.  Its filename was
     clocksource-keep-track-of-original-clocksource-frequency-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: clocksource-keep-track-of-original-clocksource-frequency fix
From: Roman Zippel <zippel@linux-m68k.org>

> @@ -63,6 +64,7 @@ struct clocksource {
>  	cycle_t (*read)(void);
>  	cycle_t mask;
>  	u32 mult;
> +	s32 mult_orig;
>  	u32 shift;
>  	unsigned long flags;
>  	cycle_t (*vread)(void);

This is wrong, with HZ=100 the jiffies clock multiplier suddenly becomes
negative and later the raw interval underflows.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Acked-by: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/clocksource.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/clocksource.h~clocksource-keep-track-of-original-clocksource-frequency-fix include/linux/clocksource.h
--- a/include/linux/clocksource.h~clocksource-keep-track-of-original-clocksource-frequency-fix
+++ a/include/linux/clocksource.h
@@ -64,7 +64,7 @@ struct clocksource {
 	cycle_t (*read)(void);
 	cycle_t mask;
 	u32 mult;
-	s32 mult_orig;
+	u32 mult_orig;
 	u32 shift;
 	unsigned long flags;
 	cycle_t (*vread)(void);
_

Patches currently in -mm which might be from zippel@linux-m68k.org are

git-x86.patch
provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc.patch
git-watchdog.patch
m68k-replace-remaining-__function__-occurences.patch
fs-hfsplus-proper-externs.patch
affs-handle-match_strdup-failure.patch
hfs-handle-match_strdup-failure.patch
hfsplus-handle-match_strdup-failure.patch
fs-affs-filec-use-bug_on.patch
affs-be_add_cpu-conversion.patch
hfs-hfsplus-be_add_cpu-conversion.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
introduce-explicit-signed-unsigned-64bit-divide.patch
convert-a-few-do_div-user.patch
rename-div64_64-to-div64_u64.patch
rename-div64_64-to-div64_u64-mm.patch
remove-div_long_long_rem.patch
ntp-cleanup-ntpc.patch
ntp-ntp4-user-space-bits-update.patch
ntp-increase-time_freq-resolution.patch
ntp-increase-time_offset-resolution.patch
ntp-support-for-tai.patch
ntp-rename-tick_length_shift-to-ntp_scale_shift.patch
ntp-remove-current_tick_length.patch
ntp-handle-leap-second-via-timer.patch
clocksource-keep-track-of-original-clocksource-frequency-fix.patch
clocksource-introduce-clock_monotonic_raw.patch
clocksource-introduce-clock_monotonic_raw-fix.patch
clocksource-introduce-clock_monotonic_raw-fix-checkpatch-fixes.patch
clocksource-introduce-clocksource_forward_now.patch

