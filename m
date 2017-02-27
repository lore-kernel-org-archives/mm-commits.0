From: akpm@linux-foundation.org
Subject: [patch 41/78] scripts/spelling.txt: add "swith" pattern and fix
 typo instances
Date: Mon, 27 Feb 2017 14:28:41 -0800
Message-ID: <58b4a819.qQH3fgp7o7tbGKXk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45658 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751547AbdB0Wnv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:43:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, yamada.masahiro@socionext.com

From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: scripts/spelling.txt: add "swith" pattern and fix typo instances

Fix typos and add the following to the scripts/spelling.txt:

  swith||switch
  swithable||switchable
  swithed||switched
  swithing||switching

While we are here, fix the "update" to "updates" in the touched hunk
in drivers/net/wireless/marvell/mwifiex/wmm.c.

Link: http://lkml.kernel.org/r/1481573103-11329-2-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/mfd/qcom-rpm.txt     |    2 +-
 Documentation/devicetree/bindings/power/pd-samsung.txt |    2 +-
 arch/arm/boot/compressed/head.S                        |    2 +-
 arch/arm/mm/cache-v7.S                                 |    2 +-
 arch/arm/mm/cache-v7m.S                                |    2 +-
 arch/sh/kernel/irq.c                                   |    2 +-
 arch/sparc/include/asm/switch_to_32.h                  |    2 +-
 drivers/gpu/drm/amd/include/atombios.h                 |    2 +-
 drivers/gpu/drm/radeon/atombios.h                      |    2 +-
 drivers/isdn/mISDN/dsp_core.c                          |    2 +-
 drivers/net/usb/kalmia.c                               |    2 +-
 drivers/net/wireless/marvell/mwifiex/wmm.c             |    4 ++--
 net/mac80211/mesh.c                                    |    2 +-
 scripts/recordmcount.pl                                |    2 +-
 scripts/spelling.txt                                   |    4 ++++
 sound/pci/ac97/ac97_patch.c                            |    2 +-
 16 files changed, 20 insertions(+), 16 deletions(-)

diff -puN Documentation/devicetree/bindings/mfd/qcom-rpm.txt~scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances Documentation/devicetree/bindings/mfd/qcom-rpm.txt
--- a/Documentation/devicetree/bindings/mfd/qcom-rpm.txt~scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances
+++ a/Documentation/devicetree/bindings/mfd/qcom-rpm.txt
@@ -234,7 +234,7 @@ see regulator.txt - with additional cust
 - qcom,switch-mode-frequency:
 	Usage: required
 	Value type: <u32>
-	Definition: Frequency (Hz) of the swith mode power supply;
+	Definition: Frequency (Hz) of the switch mode power supply;
 		    must be one of:
 		    19200000, 9600000, 6400000, 4800000, 3840000, 3200000,
 		    2740000, 2400000, 2130000, 1920000, 1750000, 1600000,
diff -puN Documentation/devicetree/bindings/power/pd-samsung.txt~scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances Documentation/devicetree/bindings/power/pd-samsung.txt
--- a/Documentation/devicetree/bindings/power/pd-samsung.txt~scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances
+++ a/Documentation/devicetree/bindings/power/pd-samsung.txt
@@ -23,7 +23,7 @@ Optional Properties:
 - clock-names: The following clocks can be specified:
 	- oscclk: Oscillator clock.
 	- clkN: Input clocks to the devices in this power domain. These clocks
-		will be reparented to oscclk before swithing power domain off.
+		will be reparented to oscclk before switching power domain off.
 		Their original parent will be brought back after turning on
 		the domain. Maximum of 4 clocks (N = 0 to 3) are supported.
 	- asbN: Clocks required by asynchronous bridges (ASB) present in
diff -puN arch/arm/boot/compressed/head.S~scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances arch/arm/boot/compressed/head.S
--- a/arch/arm/boot/compressed/head.S~scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances
+++ a/arch/arm/boot/compressed/head.S
@@ -1196,7 +1196,7 @@ skip:
 		bgt	loop1
 finished:
 		ldmfd	sp!, {r0-r7, r9-r11}
-		mov	r10, #0			@ swith back to cache level 0
+		mov	r10, #0			@ switch back to cache level 0
 		mcr	p15, 2, r10, c0, c0, 0	@ select current cache level in cssr
 iflush:
 		mcr	p15, 0, r10, c7, c10, 4	@ DSB
diff -puN arch/arm/mm/cache-v7.S~scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances arch/arm/mm/cache-v7.S
--- a/arch/arm/mm/cache-v7.S~scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances
+++ a/arch/arm/mm/cache-v7.S
@@ -164,7 +164,7 @@ skip:
 	cmp	r3, r10
 	bgt	flush_levels
 finished:
-	mov	r10, #0				@ swith back to cache level 0
+	mov	r10, #0				@ switch back to cache level 0
 	mcr	p15, 2, r10, c0, c0, 0		@ select current cache level in cssr
 	dsb	st
 	isb
diff -puN arch/arm/mm/cache-v7m.S~scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances arch/arm/mm/cache-v7m.S
--- a/arch/arm/mm/cache-v7m.S~scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances
+++ a/arch/arm/mm/cache-v7m.S
@@ -217,7 +217,7 @@ skip:
 	cmp	r3, r10
 	bgt	flush_levels
 finished:
-	mov	r10, #0				@ swith back to cache level 0
+	mov	r10, #0				@ switch back to cache level 0
 	write_csselr r10, r3			@ select current cache level in cssr
 	dsb	st
 	isb
diff -puN arch/sh/kernel/irq.c~scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances arch/sh/kernel/irq.c
--- a/arch/sh/kernel/irq.c~scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances
+++ a/arch/sh/kernel/irq.c
@@ -99,7 +99,7 @@ static inline void handle_one_irq(unsign
 			"mov	%0, r4		\n"
 			"mov	r15, r8		\n"
 			"jsr	@%1		\n"
-			/* swith to the irq stack */
+			/* switch to the irq stack */
 			" mov	%2, r15		\n"
 			/* restore the stack (ring zero) */
 			"mov	r8, r15		\n"
diff -puN arch/sparc/include/asm/switch_to_32.h~scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances arch/sparc/include/asm/switch_to_32.h
--- a/arch/sparc/include/asm/switch_to_32.h~scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances
+++ a/arch/sparc/include/asm/switch_to_32.h
@@ -9,7 +9,7 @@ extern struct thread_info *current_set[N
  * Flush windows so that the VM switch which follows
  * would not pull the stack from under us.
  *
- * SWITCH_ENTER and SWITH_DO_LAZY_FPU do not work yet (e.g. SMP does not work)
+ * SWITCH_ENTER and SWITCH_DO_LAZY_FPU do not work yet (e.g. SMP does not work)
  * XXX WTF is the above comment? Found in late teen 2.4.x.
  */
 #ifdef CONFIG_SMP
diff -puN drivers/gpu/drm/amd/include/atombios.h~scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances drivers/gpu/drm/amd/include/atombios.h
--- a/drivers/gpu/drm/amd/include/atombios.h~scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances
+++ a/drivers/gpu/drm/amd/include/atombios.h
@@ -4361,7 +4361,7 @@ typedef struct _ATOM_GPIO_PIN_ASSIGNMENT
 // GPIO use to control PCIE_VDDC in certain SLT board
 #define PCIE_VDDC_CONTROL_GPIO_PINID        56
 
-//from SMU7.x, if ucGPIO_ID=PP_AC_DC_SWITCH_GPIO_PINID in GPIO_LUTTable, AC/DC swithing feature is enable
+//from SMU7.x, if ucGPIO_ID=PP_AC_DC_SWITCH_GPIO_PINID in GPIO_LUTTable, AC/DC switching feature is enable
 #define PP_AC_DC_SWITCH_GPIO_PINID          60
 //from SMU7.x, if ucGPIO_ID=VDDC_REGULATOR_VRHOT_GPIO_PINID in GPIO_LUTable, VRHot feature is enable
 #define VDDC_VRHOT_GPIO_PINID               61
diff -puN drivers/gpu/drm/radeon/atombios.h~scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances drivers/gpu/drm/radeon/atombios.h
--- a/drivers/gpu/drm/radeon/atombios.h~scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances
+++ a/drivers/gpu/drm/radeon/atombios.h
@@ -3883,7 +3883,7 @@ typedef struct _ATOM_GPIO_PIN_ASSIGNMENT
 }ATOM_GPIO_PIN_ASSIGNMENT;
 
 //ucGPIO_ID pre-define id for multiple usage
-//from SMU7.x, if ucGPIO_ID=PP_AC_DC_SWITCH_GPIO_PINID in GPIO_LUTTable, AC/DC swithing feature is enable
+//from SMU7.x, if ucGPIO_ID=PP_AC_DC_SWITCH_GPIO_PINID in GPIO_LUTTable, AC/DC switching feature is enable
 #define PP_AC_DC_SWITCH_GPIO_PINID          60
 //from SMU7.x, if ucGPIO_ID=VDDC_REGULATOR_VRHOT_GPIO_PINID in GPIO_LUTable, VRHot feature is enable
 #define VDDC_VRHOT_GPIO_PINID               61
diff -puN drivers/isdn/mISDN/dsp_core.c~scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances drivers/isdn/mISDN/dsp_core.c
--- a/drivers/isdn/mISDN/dsp_core.c~scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances
+++ a/drivers/isdn/mISDN/dsp_core.c
@@ -115,7 +115,7 @@
  *
  * The CMX has special functions for conferences with one, two and more
  * members. It will allow different types of data flow. Receive and transmit
- * data to/form upper layer may be swithed on/off individually without losing
+ * data to/form upper layer may be switched on/off individually without losing
  * features of CMX, Tones and DTMF.
  *
  * Echo Cancellation: Sometimes we like to cancel echo from the interface.
diff -puN drivers/net/usb/kalmia.c~scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances drivers/net/usb/kalmia.c
--- a/drivers/net/usb/kalmia.c~scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances
+++ a/drivers/net/usb/kalmia.c
@@ -343,7 +343,7 @@ static const struct driver_info kalmia_i
 static const struct usb_device_id products[] = {
 	/* The unswitched USB ID, to get the module auto loaded: */
 	{ USB_DEVICE(0x04e8, 0x689a) },
-	/* The stick swithed into modem (by e.g. usb_modeswitch): */
+	/* The stick switched into modem (by e.g. usb_modeswitch): */
 	{ USB_DEVICE(0x04e8, 0x6889),
 		.driver_info = (unsigned long) &kalmia_info, },
 	{ /* EMPTY == end of list */} };
diff -puN drivers/net/wireless/marvell/mwifiex/wmm.c~scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances drivers/net/wireless/marvell/mwifiex/wmm.c
--- a/drivers/net/wireless/marvell/mwifiex/wmm.c~scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances
+++ a/drivers/net/wireless/marvell/mwifiex/wmm.c
@@ -673,8 +673,8 @@ void mwifiex_update_ralist_tx_pause(stru
 	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
 }
 
-/* This function update non-tdls peer ralist tx_pause while
- * tdls channel swithing
+/* This function updates non-tdls peer ralist tx_pause while
+ * tdls channel switching
  */
 void mwifiex_update_ralist_tx_pause_in_tdls_cs(struct mwifiex_private *priv,
 					       u8 *mac, u8 tx_pause)
diff -puN net/mac80211/mesh.c~scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances net/mac80211/mesh.c
--- a/net/mac80211/mesh.c~scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances
+++ a/net/mac80211/mesh.c
@@ -681,7 +681,7 @@ ieee80211_mesh_build_beacon(struct ieee8
 		   2 + /* NULL SSID */
 		   /* Channel Switch Announcement */
 		   2 + sizeof(struct ieee80211_channel_sw_ie) +
-		   /* Mesh Channel Swith Parameters */
+		   /* Mesh Channel Switch Parameters */
 		   2 + sizeof(struct ieee80211_mesh_chansw_params_ie) +
 		   2 + 8 + /* supported rates */
 		   2 + 3; /* DS params */
diff -puN scripts/recordmcount.pl~scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances scripts/recordmcount.pl
--- a/scripts/recordmcount.pl~scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances
+++ a/scripts/recordmcount.pl
@@ -318,7 +318,7 @@ if ($arch eq "x86_64") {
     # instruction or the addiu one. herein, we record the address of the
     # first one, and then we can replace this instruction by a branch
     # instruction to jump over the profiling function to filter the
-    # indicated functions, or swith back to the lui instruction to trace
+    # indicated functions, or switch back to the lui instruction to trace
     # them, which means dynamic tracing.
     #
     #       c:	3c030000 	lui	v1,0x0
diff -puN scripts/spelling.txt~scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances
+++ a/scripts/spelling.txt
@@ -991,6 +991,10 @@ suspeneded||suspended
 suspicously||suspiciously
 swaping||swapping
 switchs||switches
+swith||switch
+swithable||switchable
+swithed||switched
+swithing||switching
 symetric||symmetric
 synax||syntax
 synchonized||synchronized
diff -puN sound/pci/ac97/ac97_patch.c~scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances sound/pci/ac97/ac97_patch.c
--- a/sound/pci/ac97/ac97_patch.c~scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances
+++ a/sound/pci/ac97/ac97_patch.c
@@ -3093,7 +3093,7 @@ static int patch_cm9739(struct snd_ac97
 	/* set-up multi channel */
 	/* bit 14: 0 = SPDIF, 1 = EAPD */
 	/* bit 13: enable internal vref output for mic */
-	/* bit 12: disable center/lfe (swithable) */
+	/* bit 12: disable center/lfe (switchable) */
 	/* bit 10: disable surround/line (switchable) */
 	/* bit 9: mix 2 surround off */
 	/* bit 4: undocumented; 0 mutes the CM9739A, which defaults to 1 */
_
