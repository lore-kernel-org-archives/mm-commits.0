From: akpm@linux-foundation.org
Subject: + rename-div64_64-to-div64_u64-kvm.patch added to -mm tree
Date: Wed, 30 Apr 2008 05:53:22 -0700
Message-ID: <200804301253.m3UCrM9W014428@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40608 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759976AbYD3Mx5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 08:53:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zippel@linux-m68k.org, avi@qumranet.com, tglx@linutronix.de


The patch titled
     2.6.25-rc5-mm1 specifc div64_u64 fixes
has been added to the -mm tree.  Its filename is
     rename-div64_64-to-div64_u64-kvm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: 2.6.25-rc5-mm1 specifc div64_u64 fixes
From: Roman Zippel <zippel@linux-m68k.org>

Rename a few more div64_u64 which are only in -mm.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Cc: Avi Kivity <avi@qumranet.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kvm/i8254.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/x86/kvm/i8254.c~rename-div64_64-to-div64_u64-kvm arch/x86/kvm/i8254.c
--- a/arch/x86/kvm/i8254.c~rename-div64_64-to-div64_u64-kvm
+++ a/arch/x86/kvm/i8254.c
@@ -35,7 +35,7 @@
 #include "i8254.h"
 
 #ifndef CONFIG_X86_64
-#define mod_64(x, y) ((x) - (y) * div64_64(x, y))
+#define mod_64(x, y) ((x) - (y) * div64_u64(x, y))
 #else
 #define mod_64(x, y) ((x) % (y))
 #endif
@@ -60,8 +60,8 @@ static u64 muldiv64(u64 a, u32 b, u32 c)
 	rl = (u64)u.l.low * (u64)b;
 	rh = (u64)u.l.high * (u64)b;
 	rh += (rl >> 32);
-	res.l.high = div64_64(rh, c);
-	res.l.low = div64_64(((mod_64(rh, c) << 32) + (rl & 0xffffffff)), c);
+	res.l.high = div64_u64(rh, c);
+	res.l.low = div64_u64(((mod_64(rh, c) << 32) + (rl & 0xffffffff)), c);
 	return res.ll;
 }
 
_

Patches currently in -mm which might be from zippel@linux-m68k.org are

origin.patch
affs-be_add_cpu-conversion.patch
hfs-hfsplus-be_add_cpu-conversion.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
introduce-explicit-signed-unsigned-64bit-divide.patch
convert-a-few-do_div-user.patch
rename-div64_64-to-div64_u64.patch
rename-div64_64-to-div64_u64-ia64.patch
remove-div_long_long_rem.patch
ntp-cleanup-ntpc.patch
ntp-ntp4-user-space-bits-update.patch
ntp-increase-time_freq-resolution.patch
ntp-increase-time_offset-resolution.patch
ntp-support-for-tai.patch
ntp-rename-tick_length_shift-to-ntp_scale_shift.patch
ntp-remove-current_tick_length.patch
ntp-handle-leap-second-via-timer.patch
rename-div64_64-to-div64_u64-dvb.patch
provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc.patch
provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc-update.patch
rename-div64_64-to-div64_u64-kvm.patch
git-watchdog.patch
affs-fix-reservation-discarding.patch
vfs-kill-put_inode.patch

