From: akpm@linux-foundation.org
Subject: [merged] mmc-some-microsd-cards-are-not-recognized-by-pcixx12-sda-controller.patch removed from -mm tree
Date: Mon, 04 May 2009 13:13:55 -0700
Message-ID: <200905042013.n44KDtOV022840@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56055 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753860AbZEDUQI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 16:16:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josemariafg@gmail.com, drzeus@drzeus.cx, mm-commits@vger.kernel.org


The patch titled
     mmc: some microSD cards are not recognized by PCIxx12 SDA controll=
er
has been removed from the -mm tree.  Its filename was
     mmc-some-microsd-cards-are-not-recognized-by-pcixx12-sda-controlle=
r.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: mmc: some microSD cards are not recognized by PCIxx12 SDA cont=
roller
=46rom: Jos=E9 M. Fern=E1ndez <josemariafg@gmail.com>

My working laptop is a Toshiba Tecra M5 with Core2 Duo T7400 and 2GB of
memory.  Since I'm using it I have found that some microSD cards (using
their size adapter) are not recognized when they are inserted in the Te=
cra
M5 SD slot.  Now I own one of those cards (a Transcend 2GB
MM8GR02GUACU-PA), which works well with Windows XP and Toshiba drivers.=
=20
Looking for a fix I have done some web research about similar laptop
models, and following the clues I found next HTML page:

http://list.drzeus.cx/pipermail/sdhci-devel/2007-December/002089.html

about a kernel patch related to the SD controller in my laptop, which
involves a change on a mmc_delay call on controller startup. The
lspci -vv description for the SD controller is:

06:0b.3 SD Host controller: Texas Instruments PCIxx12 SDA Standard Comp=
liant SD Host Controller (prog-if 01)
        Subsystem: Toshiba America Info Systems Device 0001
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- Par=
Err- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbo=
rt- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (1750ns min, 1000ns max), Cache Line Size: 32 bytes
        Interrupt: pin D routed to IRQ 23
        Region 0: Memory at ff9ff700 (32-bit, non-prefetchable) [size=3D=
256]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1=
+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Kernel driver in use: sdhci-pci
        Kernel modules: sdhci-pci

When I applied the proposed change from that patch on mmc_delay after
MMC_POWER_ON, kernel started recognizing the microSD card, but with err=
ors
I have seen with other SD cards:

=46eb 21 18:39:25 olympo mmc0: card claims to support voltages below th=
e defined range. These will be ignored.
=46eb 21 18:39:25 olympo mmc0: SDIO card claims to support the incomple=
tely defined 'low voltage range'. This will be ignored.
=46eb 21 18:39:25 olympo mmc0: error -110 whilst initialising SDIO card

So, I extrapolated the change and, by chance, I found the fix, which
consist on raising the mmc_delay from 2 to 10 both on MMC_POWER_UP and
MMC_POWER_ON.  I have been using the kernel with this fix for some week=
s,
with no problem.

I don't know whether this patch can break something in the behavior of
other SD controllers, but at least it works for my laptop.

Signed-off-by: Jos=E9 M. Fern=E1ndez <josemariafg@gmail.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/mmc/core/core.c~mmc-some-microsd-cards-are-not-recogn=
ized-by-pcixx12-sda-controller drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~mmc-some-microsd-cards-are-not-recognized=
-by-pcixx12-sda-controller
+++ a/drivers/mmc/core/core.c
@@ -712,7 +712,7 @@ static void mmc_power_up(struct mmc_host
 	 * This delay should be sufficient to allow the power supply
 	 * to reach the minimum voltage.
 	 */
-	mmc_delay(2);
+	mmc_delay(10);
=20
 	host->ios.clock =3D host->f_min;
 	host->ios.power_mode =3D MMC_POWER_ON;
@@ -722,7 +722,7 @@ static void mmc_power_up(struct mmc_host
 	 * This delay must be at least 74 clock sizes, or 1 ms, or the
 	 * time required to reach a stable voltage.
 	 */
-	mmc_delay(2);
+	mmc_delay(10);
 }
=20
 static void mmc_power_off(struct mmc_host *host)
_

Patches currently in -mm which might be from josemariafg@gmail.com are

linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
