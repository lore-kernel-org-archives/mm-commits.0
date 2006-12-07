From: akpm@osdl.org
Subject: - make-1-bit-bitfields-unsigned.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:05:20 -0800
Message-ID: <200612072305.kB7N5Kqf030143@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52560 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163908AbWLGXFu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:05:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, kkeil@suse.de, mchehab@infradead.org, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     make 1-bit bitfields unsigned
has been removed from the -mm tree.  Its filename was
     make-1-bit-bitfields-unsigned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: make 1-bit bitfields unsigned
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Keeps sparse happy.

Signed-of-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Acked-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/isdn/hisax/isdnhdlc.h        |    8 ++++----
 drivers/media/dvb/frontends/l64781.c |    2 +-
 sound/arm/sa11xx-uda1341.c           |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/isdn/hisax/isdnhdlc.h~make-1-bit-bitfields-unsigned drivers/isdn/hisax/isdnhdlc.h
--- a/drivers/isdn/hisax/isdnhdlc.h~make-1-bit-bitfields-unsigned
+++ a/drivers/isdn/hisax/isdnhdlc.h
@@ -41,10 +41,10 @@ struct isdnhdlc_vars {
 	unsigned char shift_reg;
 	unsigned char ffvalue;
 
-	int data_received:1; 	// set if transferring data
-	int dchannel:1; 	// set if D channel (send idle instead of flags)
-	int do_adapt56:1; 	// set if 56K adaptation
-        int do_closing:1; 	// set if in closing phase (need to send CRC + flag
+	unsigned int data_received:1; 	// set if transferring data
+	unsigned int dchannel:1; 	// set if D channel (send idle instead of flags)
+	unsigned int do_adapt56:1; 	// set if 56K adaptation
+	unsigned int do_closing:1; 	// set if in closing phase (need to send CRC + flag
 };
 
 
diff -puN drivers/media/dvb/frontends/l64781.c~make-1-bit-bitfields-unsigned drivers/media/dvb/frontends/l64781.c
--- a/drivers/media/dvb/frontends/l64781.c~make-1-bit-bitfields-unsigned
+++ a/drivers/media/dvb/frontends/l64781.c
@@ -36,7 +36,7 @@ struct l64781_state {
 	struct dvb_frontend frontend;
 
 	/* private demodulator data */
-	int first:1;
+	unsigned int first:1;
 };
 
 #define dprintk(args...) \
diff -puN sound/arm/sa11xx-uda1341.c~make-1-bit-bitfields-unsigned sound/arm/sa11xx-uda1341.c
--- a/sound/arm/sa11xx-uda1341.c~make-1-bit-bitfields-unsigned
+++ a/sound/arm/sa11xx-uda1341.c
@@ -125,7 +125,7 @@ struct audio_stream {
 #else
 	dma_regs_t *dma_regs;	/* points to our DMA registers */
 #endif
-	int active:1;		/* we are using this stream for transfer now */
+	unsigned int active:1;	/* we are using this stream for transfer now */
 	int period;		/* current transfer period */
 	int periods;		/* current count of periods registerd in the DMA engine */
 	int tx_spin;		/* are we recoding - flag used to do DMA trans. for sync */
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
ppc-cs4218_tdm-remove-extra-brace.patch
mips-dbg_io-stray-brackets-fix.patch
git-mtd.patch
scsi-sic7xxx-stray-bracket-fix.patch
scsi-53c7xx-brackets-fix.patch
sparc64-dma-remove-extra-brackets.patch
video-cyberfb-broken-macro-removal.patch
video-neofb-stray-bracket-fix.patch
video-pm3fb-macros-fix.patch

