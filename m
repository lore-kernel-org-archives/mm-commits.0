From: akpm@linux-foundation.org
Subject: - rename-div64_64-to-div64_u64-ia64.patch removed from -mm tree
Date: Thu, 01 May 2008 02:45:06 -0700
Message-ID: <200805010945.m419j6sv031528@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758193AbYEAJp4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:45:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zippel@linux-m68k.org, avi@qumranet.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     2.6.25-rc5-mm1 specifc div64_u64 fixes
has been removed from the -mm tree.  Its filename was
     rename-div64_64-to-div64_u64-ia64.patch

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

 arch/ia64/kvm/kvm-ia64.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/ia64/kvm/kvm-ia64.c~rename-div64_64-to-div64_u64-ia64 arch/ia64/kvm/kvm-ia64.c
--- a/arch/ia64/kvm/kvm-ia64.c~rename-div64_64-to-div64_u64-ia64
+++ a/arch/ia64/kvm/kvm-ia64.c
@@ -1,4 +1,3 @@
-
 /*
  * kvm_ia64.c: Basic KVM suppport On Itanium series processors
  *
@@ -431,7 +430,7 @@ int kvm_emulate_halt(struct kvm_vcpu *vc
 	if (itc_diff < 0)
 		itc_diff = -itc_diff;
 
-	expires = div64_64(itc_diff, cyc_per_usec);
+	expires = div64_u64(itc_diff, cyc_per_usec);
 	kt = ktime_set(0, 1000 * expires);
 	vcpu->arch.ht_active = 1;
 	hrtimer_start(p_ht, kt, HRTIMER_MODE_ABS);
_

Patches currently in -mm which might be from zippel@linux-m68k.org are

origin.patch
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
rename-div64_64-to-div64_u64-kvm.patch
git-watchdog.patch
affs-fix-reservation-discarding.patch
vfs-kill-put_inode.patch

