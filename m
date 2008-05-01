From: akpm@linux-foundation.org
Subject: - rename-div64_64-to-div64_u64-kvm.patch removed from -mm tree
Date: Thu, 01 May 2008 04:31:16 -0700
Message-ID: <200805011131.m41BVGCr002868@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755054AbYEALcG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 07:32:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zippel@linux-m68k.org, avi@qumranet.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     2.6.25-rc5-mm1 specifc div64_u64 fixes
has been removed from the -mm tree.  Its filename was
     rename-div64_64-to-div64_u64-kvm.patch

This patch was dropped because it was folded into rename-div64_64-to-div64_u64.patch

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
introduce-explicit-signed-unsigned-64bit-divide.patch
convert-a-few-do_div-user.patch
rename-div64_64-to-div64_u64.patch
rename-div64_64-to-div64_u64-kvm.patch
remove-div_long_long_rem.patch
ntp-cleanup-ntpc.patch
ntp-ntp4-user-space-bits-update.patch
ntp-increase-time_freq-resolution.patch
ntp-increase-time_offset-resolution.patch
ntp-support-for-tai.patch
ntp-rename-tick_length_shift-to-ntp_scale_shift.patch
ntp-remove-current_tick_length.patch
ntp-handle-leap-second-via-timer.patch

