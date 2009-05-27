From: akpm@linux-foundation.org
Subject: + drivers-serial-mpc52xx_uartc-fix-array-overindexing-check.patch added to -mm tree
Date: Wed, 27 May 2009 00:19:22 -0700
Message-ID: <200905270719.n4R7JMEF008436@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759198AbZE0HTt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 May 2009 03:19:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, alan@lxorguk.ukuu.org.uk, benh@kernel.crashing.org, grant.likely@secretlab.ca, w.sang@pengutronix.de


The patch titled
     drivers/serial/mpc52xx_uart.c: fix array overindexing check
has been added to the -mm tree.  Its filename is
     drivers-serial-mpc52xx_uartc-fix-array-overindexing-check.patch

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
Subject: drivers/serial/mpc52xx_uart.c: fix array overindexing check
From: Roel Kluin <roel.kluin@gmail.com>

The check for an overindexing of mpc52xx_uart_{ports,nodes} has an
off-by-one.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/mpc52xx_uart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/mpc52xx_uart.c~drivers-serial-mpc52xx_uartc-fix-array-overindexing-check drivers/serial/mpc52xx_uart.c
--- a/drivers/serial/mpc52xx_uart.c~drivers-serial-mpc52xx_uartc-fix-array-overindexing-check
+++ a/drivers/serial/mpc52xx_uart.c
@@ -988,7 +988,7 @@ mpc52xx_console_setup(struct console *co
 	pr_debug("mpc52xx_console_setup co=%p, co->index=%i, options=%s\n",
 		 co, co->index, options);
 
-	if ((co->index < 0) || (co->index > MPC52xx_PSC_MAXNUM)) {
+	if ((co->index < 0) || (co->index >= MPC52xx_PSC_MAXNUM)) {
 		pr_debug("PSC%x out of range\n", co->index);
 		return -EINVAL;
 	}
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
drm-fix-lock_test_with_return-macro.patch
v4l-dvb-cimax2c-fix-typo.patch
zoran-fix-error.patch
uwb-event_size-should-be-signed.patch
irda-count-reaches-1.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
wis-sony-tunerc-typo.patch
otus-80211core-coidc-fix-array-range-check.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
sh-fix-access-beyond-array_size-of-onchip_ops.patch
alpha-bad-macro-expansion-parameter-is-member.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
uml-bad-macro-expansion-parameter-is-member.patch
serial-z85c30-bcm1480-loops-reach-1.patch
spi_bfin5xx-limit-reaches-1.patch
carminefb-fix-possible-access-beyond-end-of-carmine_modedb.patch
ufs-sector_t-cannot-be-negative.patch
dtlk-off-by-one-in-readwrite_tts.patch
drivers-serial-mpc52xx_uartc-fix-array-overindexing-check.patch

