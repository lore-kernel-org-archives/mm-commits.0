From: akpm@linux-foundation.org
Subject: + sh-fix-access-beyond-array_size-of-onchip_ops.patch added to -mm tree
Date: Tue, 26 May 2009 17:04:27 -0700
Message-ID: <200905270004.n4R04R5E032358@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760938AbZE0AFQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 20:05:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, lethal@linux-sh.org


The patch titled
     sh: fix access beyond ARRAY_SIZE of onchip_ops[]
has been added to the -mm tree.  Its filename is
     sh-fix-access-beyond-array_size-of-onchip_ops.patch

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
Subject: sh: fix access beyond ARRAY_SIZE of onchip_ops[]
From: Roel Kluin <roel.kluin@gmail.com>

Do not go beyond ARRAY_SIZE of onchip_ops

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/cpu/sh4a/clock-sh7722.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/sh/kernel/cpu/sh4a/clock-sh7722.c~sh-fix-access-beyond-array_size-of-onchip_ops arch/sh/kernel/cpu/sh4a/clock-sh7722.c
--- a/arch/sh/kernel/cpu/sh4a/clock-sh7722.c~sh-fix-access-beyond-array_size-of-onchip_ops
+++ a/arch/sh/kernel/cpu/sh4a/clock-sh7722.c
@@ -897,7 +897,7 @@ struct clk_ops *onchip_ops[] = {
 void __init
 arch_init_clk_ops(struct clk_ops **ops, int type)
 {
-	BUG_ON(type < 0 || type > ARRAY_SIZE(onchip_ops));
+	BUG_ON(type < 0 || type >= ARRAY_SIZE(onchip_ops));
 	*ops = onchip_ops[type];
 }
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
drm-fix-lock_test_with_return-macro.patch
v4l-dvb-cimax2c-fix-typo.patch
zoran-fix-error.patch
uwb-event_size-should-be-signed.patch
irda-count-reaches-1.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
wis-sony-tunerc-typo.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
sh-fix-access-beyond-array_size-of-onchip_ops.patch
alpha-bad-macro-expansion-parameter-is-member.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
uml-bad-macro-expansion-parameter-is-member.patch
serial-z85c30-bcm1480-loops-reach-1.patch
spi_bfin5xx-limit-reaches-1.patch
ufs-sector_t-cannot-be-negative.patch
dtlk-off-by-one-in-readwrite_tts.patch

