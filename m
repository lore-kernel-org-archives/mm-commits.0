From: akpm@linux-foundation.org
Subject: + rename-div64_64-to-div64_u64-dvb.patch added to -mm tree
Date: Wed, 30 Apr 2008 05:52:50 -0700
Message-ID: <200804301252.m3UCqo5E014415@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37168 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755023AbYD3MxW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 08:53:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zippel@linux-m68k.org, mchehab@infradead.org


The patch titled
     2.6.25-rc5-mm1 specifc div64_u64 fixes
has been added to the -mm tree.  Its filename is
     rename-div64_64-to-div64_u64-dvb.patch

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
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/frontends/drx397xD.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/media/dvb/frontends/drx397xD.c~rename-div64_64-to-div64_u64-dvb drivers/media/dvb/frontends/drx397xD.c
--- a/drivers/media/dvb/frontends/drx397xD.c~rename-div64_64-to-div64_u64-dvb
+++ a/drivers/media/dvb/frontends/drx397xD.c
@@ -1026,13 +1026,13 @@ static int drx_tune(struct drx397xD_stat
 
 	{
 		/* Configure bandwidth specific factor */
-		ebx = div64_64(((u64) (s->f_osc) << 21) + (ebx >> 1),
+		ebx = div64_u64(((u64) (s->f_osc) << 21) + (ebx >> 1),
 				     (u64)ebx) - 0x800000;
 		EXIT_RC(WR16(s, 0x0c50010, ebx & 0xffff));
 		EXIT_RC(WR16(s, 0x0c50011, ebx >> 16));
 
 		/* drx397xD oscillator calibration */
-		ebx = div64_64(((u64) (s->config.f_if + df_tuner) << 28) +
+		ebx = div64_u64(((u64) (s->config.f_if + df_tuner) << 28) +
 				     (s->f_osc >> 1), (u64)s->f_osc);
 	}
 	ebx &= 0xfffffff;
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
rename-div64_64-to-div64_u64-mm.patch
rename-div64_64-to-div64_u64-kvm.patch
git-watchdog.patch
affs-fix-reservation-discarding.patch
vfs-kill-put_inode.patch

