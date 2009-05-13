From: akpm@linux-foundation.org
Subject: + nes-off-by-one-in-reset_adapter_ne020-and-init_serdes.patch added to -mm tree
Date: Wed, 13 May 2009 13:00:17 -0700
Message-ID: <200905132000.n4DK0H8a013299@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755814AbZEMUAu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 May 2009 16:00:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, hal.rosenstock@gmail.com, rolandd@cisco.com, sean.hefty@intel.com


The patch titled
     nes: off by one in reset_adapter_ne020() and init_serdes()
has been added to the -mm tree.  Its filename is
     nes-off-by-one-in-reset_adapter_ne020-and-init_serdes.patch

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
Subject: nes: off by one in reset_adapter_ne020() and init_serdes()
From: Roel Kluin <roel.kluin@gmail.com>

With a postfix increment i is incremented beyond 10/5k so the error
message will be displayed too soon.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/nes/nes_hw.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/infiniband/hw/nes/nes_hw.c~nes-off-by-one-in-reset_adapter_ne020-and-init_serdes drivers/infiniband/hw/nes/nes_hw.c
--- a/drivers/infiniband/hw/nes/nes_hw.c~nes-off-by-one-in-reset_adapter_ne020-and-init_serdes
+++ a/drivers/infiniband/hw/nes/nes_hw.c
@@ -667,7 +667,7 @@ static unsigned int nes_reset_adapter_ne
 		i = 0;
 		while (((nes_read32(nesdev->regs+NES_SOFTWARE_RESET) & 0x00000040) == 0) && i++ < 10000)
 			mdelay(1);
-		if (i >= 10000) {
+		if (i > 10000) {
 			nes_debug(NES_DBG_INIT, "Did not see full soft reset done.\n");
 			return 0;
 		}
@@ -675,7 +675,7 @@ static unsigned int nes_reset_adapter_ne
 		i = 0;
 		while ((nes_read_indexed(nesdev, NES_IDX_INT_CPU_STATUS) != 0x80) && i++ < 10000)
 			mdelay(1);
-		if (i >= 10000) {
+		if (i > 10000) {
 			printk(KERN_ERR PFX "Internal CPU not ready, status = %02X\n",
 			       nes_read_indexed(nesdev, NES_IDX_INT_CPU_STATUS));
 			return 0;
@@ -701,7 +701,7 @@ static unsigned int nes_reset_adapter_ne
 	i = 0;
 	while (((nes_read32(nesdev->regs+NES_SOFTWARE_RESET) & 0x00000040) == 0) && i++ < 10000)
 		mdelay(1);
-	if (i >= 10000) {
+	if (i > 10000) {
 		nes_debug(NES_DBG_INIT, "Did not see port soft reset done.\n");
 		return 0;
 	}
@@ -711,7 +711,7 @@ static unsigned int nes_reset_adapter_ne
 	while (((u32temp = (nes_read_indexed(nesdev, NES_IDX_ETH_SERDES_COMMON_STATUS0)
 			& 0x0000000f)) != 0x0000000f) && i++ < 5000)
 		mdelay(1);
-	if (i >= 5000) {
+	if (i > 5000) {
 		nes_debug(NES_DBG_INIT, "Serdes 0 not ready, status=%x\n", u32temp);
 		return 0;
 	}
@@ -722,7 +722,7 @@ static unsigned int nes_reset_adapter_ne
 		while (((u32temp = (nes_read_indexed(nesdev, NES_IDX_ETH_SERDES_COMMON_STATUS1)
 				& 0x0000000f)) != 0x0000000f) && i++ < 5000)
 			mdelay(1);
-		if (i >= 5000) {
+		if (i > 5000) {
 			nes_debug(NES_DBG_INIT, "Serdes 1 not ready, status=%x\n", u32temp);
 			return 0;
 		}
@@ -792,7 +792,7 @@ static int nes_init_serdes(struct nes_de
 		while (((u32temp = (nes_read_indexed(nesdev, NES_IDX_ETH_SERDES_COMMON_STATUS0)
 				& 0x0000000f)) != 0x0000000f) && i++ < 5000)
 			mdelay(1);
-		if (i >= 5000) {
+		if (i > 5000) {
 			nes_debug(NES_DBG_PHY, "Init: serdes 0 not ready, status=%x\n", u32temp);
 			return 1;
 		}
@@ -815,7 +815,7 @@ static int nes_init_serdes(struct nes_de
 			while (((u32temp = (nes_read_indexed(nesdev, NES_IDX_ETH_SERDES_COMMON_STATUS1)
 				& 0x0000000f)) != 0x0000000f) && (i++ < 5000))
 				mdelay(1);
-			if (i >= 5000) {
+			if (i > 5000) {
 				printk("%s: Init: serdes 1 not ready, status=%x\n", __func__, u32temp);
 				/* return 1; */
 			}
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
asm-generic-fix-local_add_unless-macro.patch
linux-next.patch
drm-fix-lock_test_with_return-macro.patch
v4l-dvb-cimax2c-fix-typo.patch
zoran-fix-error.patch
uwb-event_size-should-be-signed.patch
irda-count-reaches-1.patch
isdn-get_free_devid-failure-ignored.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
wis-sony-tunerc-typo.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-bad-macro-expansion-parameter-is-member.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
uml-bad-macro-expansion-parameter-is-member.patch
serial-z85c30-bcm1480-loops-reach-1.patch
spi_bfin5xx-limit-reaches-1.patch
ufs-sector_t-cannot-be-negative.patch
dtlk-off-by-one-in-readwrite_tts.patch
nes-off-by-one-in-reset_adapter_ne020-and-init_serdes.patch
riptide-postfix-increment-and-off-by-one.patch

