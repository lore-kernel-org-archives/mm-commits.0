From: akpm@linux-foundation.org
Subject: - rename-div64_64-to-div64_u64-dvb.patch removed from -mm tree
Date: Fri, 02 May 2008 12:43:44 -0700
Message-ID: <200805021943.m42JhiPS011315@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33070 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932555AbYEBTuL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:50:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zippel@linux-m68k.org, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     2.6.25-rc5-mm1 specifc div64_u64 fixes
has been removed from the -mm tree.  Its filename was
     rename-div64_64-to-div64_u64-dvb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
affs-fix-reservation-discarding.patch
vfs-kill-put_inode.patch
git-dvb.patch
git-watchdog.patch

