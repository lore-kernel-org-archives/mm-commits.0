From: akpm@linux-foundation.org
Subject: [merged] drivers-serial-mpc52xx_uartc-fix-array-overindexing-check.patch removed from -mm tree
Date: Fri, 29 May 2009 11:42:59 -0700
Message-ID: <200905291842.n4TIgxvb011286@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758258AbZE2Sow (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 May 2009 14:44:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, alan@lxorguk.ukuu.org.uk, benh@kernel.crashing.org, grant.likely@secretlab.ca, stable@kernel.org, w.sang@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     drivers/serial/mpc52xx_uart.c: fix array overindexing check
has been removed from the -mm tree.  Its filename was
     drivers-serial-mpc52xx_uartc-fix-array-overindexing-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/serial/mpc52xx_uart.c: fix array overindexing check
From: Roel Kluin <roel.kluin@gmail.com>

The check for an overindexing of mpc52xx_uart_{ports,nodes} has an
off-by-one.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: <stable@kernel.org>
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

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
drm-fix-lock_test_with_return-macro.patch
uwb-event_size-should-be-signed.patch
irda-count-reaches-1.patch
drivers-isdn-i4l-isdn_ttyc-fix-check-for-array-overindexing.patch
atl1c-wake_mcast-tested-twice-not-wake_ucast.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
wis-sony-tunerc-typo.patch
otus-80211core-coidc-fix-array-range-check.patch
wmm_paramac_aci_acm_aifsn-tested-twice.patch
lguest-fix-array-indexing-check.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-bad-macro-expansion-parameter-is-member.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
uml-bad-macro-expansion-parameter-is-member.patch
serial-z85c30-bcm1480-loops-reach-1.patch
spi_bfin5xx-limit-reaches-1.patch
carminefb-fix-possible-access-beyond-end-of-carmine_modedb.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb-fix.patch
platinumfb-misplaced-parenthesis.patch
ufs-sector_t-cannot-be-negative.patch
dtlk-off-by-one-in-readwrite_tts.patch

