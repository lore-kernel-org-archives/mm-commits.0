From: akpm@linux-foundation.org
Subject: + pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const.patch added to -mm tree
Date: Mon, 20 Jun 2011 15:06:15 -0700
Message-ID: <201106202206.p5KM6FFM024840@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755099Ab1FTWQL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jun 2011 18:16:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, avorontsov@mvista.com, ccross@android.com, cmetcalf@tilera.com, davem@davemloft.net, eric.y.miao@gmail.com, gxt@mprc.pku.edu.cn, hpa@zytor.com, ink@jurassic.park.msu.ru, jbarnes@virtuousgeek.org, kaloz@openwrt.org, kernel@wantstofly.org, khc@pm.waw.pl, konkers@android.com, lethal@linux-sh.org, linux@arm.linux.org.uk, mattst88@gmail.com, mingo@redhat.com, nico@fluxnic.net, olof@lixom.net, rth@twiddle.net, tglx@linutronix.de


The patch titled
     pci: make the struct pci_dev * argument of pci_fixup_irqs const.
has been added to the -mm tree.  Its filename is
     pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const.patch

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
Subject: pci: make the struct pci_dev * argument of pci_fixup_irqs const.
From: Ralf Baechle <ralf@linux-mips.org>

Aside of the usual motivation for constification, this function has a
history of being abused a hook for interrupt and other fixups so I turned
this function const ages ago in the MIPS code but it should be done
treewide.

Due to function pointer passing in varous places a few other functions
had to be constified as well.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Anton Vorontsov <avorontsov@mvista.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Colin Cross <ccross@android.com>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Erik Gilling <konkers@android.com>
Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Imre Kaloz <kaloz@openwrt.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Lennert Buytenhek <kernel@wantstofly.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: Olof Johansson <olof@lixom.net>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/sys_alcor.c                  |    2 +-
 arch/alpha/kernel/sys_cabriolet.c              |    6 +++---
 arch/alpha/kernel/sys_dp264.c                  |    8 ++++----
 arch/alpha/kernel/sys_eb64p.c                  |    2 +-
 arch/alpha/kernel/sys_eiger.c                  |    2 +-
 arch/alpha/kernel/sys_marvel.c                 |    2 +-
 arch/alpha/kernel/sys_miata.c                  |    2 +-
 arch/alpha/kernel/sys_mikasa.c                 |    2 +-
 arch/alpha/kernel/sys_nautilus.c               |    2 +-
 arch/alpha/kernel/sys_noritake.c               |    2 +-
 arch/alpha/kernel/sys_rawhide.c                |    2 +-
 arch/alpha/kernel/sys_ruffian.c                |    2 +-
 arch/alpha/kernel/sys_rx164.c                  |    2 +-
 arch/alpha/kernel/sys_sable.c                  |    4 ++--
 arch/alpha/kernel/sys_sio.c                    |    4 ++--
 arch/alpha/kernel/sys_sx164.c                  |    2 +-
 arch/alpha/kernel/sys_takara.c                 |    4 ++--
 arch/alpha/kernel/sys_titan.c                  |    2 +-
 arch/alpha/kernel/sys_wildfire.c               |    2 +-
 arch/arm/common/it8152.c                       |    2 +-
 arch/arm/include/asm/hardware/it8152.h         |    2 +-
 arch/arm/include/asm/mach/pci.h                |    4 ++--
 arch/arm/kernel/bios32.c                       |    2 +-
 arch/arm/mach-cns3xxx/pcie.c                   |    2 +-
 arch/arm/mach-dove/pcie.c                      |    2 +-
 arch/arm/mach-footbridge/cats-pci.c            |    2 +-
 arch/arm/mach-footbridge/ebsa285-pci.c         |    2 +-
 arch/arm/mach-footbridge/netwinder-pci.c       |    2 +-
 arch/arm/mach-footbridge/personal-pci.c        |    3 ++-
 arch/arm/mach-integrator/pci.c                 |    2 +-
 arch/arm/mach-iop13xx/iq81340mc.c              |    2 +-
 arch/arm/mach-iop13xx/pci.c                    |    2 +-
 arch/arm/mach-iop32x/em7210.c                  |    2 +-
 arch/arm/mach-iop32x/glantank.c                |    2 +-
 arch/arm/mach-iop32x/iq31244.c                 |    4 ++--
 arch/arm/mach-iop32x/iq80321.c                 |    2 +-
 arch/arm/mach-iop32x/n2100.c                   |    2 +-
 arch/arm/mach-iop33x/iq80331.c                 |    2 +-
 arch/arm/mach-iop33x/iq80332.c                 |    2 +-
 arch/arm/mach-ixp2000/enp2611.c                |    3 ++-
 arch/arm/mach-ixp2000/ixdp2400.c               |    3 ++-
 arch/arm/mach-ixp2000/ixdp2800.c               |    3 ++-
 arch/arm/mach-ixp2000/ixdp2x01.c               |    3 ++-
 arch/arm/mach-ixp23xx/ixdp2351.c               |    2 +-
 arch/arm/mach-ixp23xx/roadrunner.c             |    3 ++-
 arch/arm/mach-ixp4xx/avila-pci.c               |    2 +-
 arch/arm/mach-ixp4xx/coyote-pci.c              |    2 +-
 arch/arm/mach-ixp4xx/dsmg600-pci.c             |    2 +-
 arch/arm/mach-ixp4xx/fsg-pci.c                 |    2 +-
 arch/arm/mach-ixp4xx/gateway7001-pci.c         |    3 ++-
 arch/arm/mach-ixp4xx/goramo_mlr.c              |    2 +-
 arch/arm/mach-ixp4xx/gtwx5715-pci.c            |    2 +-
 arch/arm/mach-ixp4xx/ixdp425-pci.c             |    2 +-
 arch/arm/mach-ixp4xx/ixdpg425-pci.c            |    2 +-
 arch/arm/mach-ixp4xx/nas100d-pci.c             |    2 +-
 arch/arm/mach-ixp4xx/nslu2-pci.c               |    2 +-
 arch/arm/mach-ixp4xx/vulcan-pci.c              |    2 +-
 arch/arm/mach-ixp4xx/wg302v2-pci.c             |    2 +-
 arch/arm/mach-kirkwood/pcie.c                  |    3 ++-
 arch/arm/mach-ks8695/board-dsm320.c            |    2 +-
 arch/arm/mach-ks8695/board-micrel.c            |    2 +-
 arch/arm/mach-ks8695/include/mach/devices.h    |    2 +-
 arch/arm/mach-mv78xx0/pcie.c                   |    3 ++-
 arch/arm/mach-orion5x/common.h                 |    2 +-
 arch/arm/mach-orion5x/db88f5281-setup.c        |    3 ++-
 arch/arm/mach-orion5x/dns323-setup.c           |    4 ++--
 arch/arm/mach-orion5x/kurobox_pro-setup.c      |    3 ++-
 arch/arm/mach-orion5x/mss2-setup.c             |    2 +-
 arch/arm/mach-orion5x/pci.c                    |    2 +-
 arch/arm/mach-orion5x/rd88f5181l-fxo-setup.c   |    2 +-
 arch/arm/mach-orion5x/rd88f5181l-ge-setup.c    |    2 +-
 arch/arm/mach-orion5x/rd88f5182-setup.c        |    3 ++-
 arch/arm/mach-orion5x/terastation_pro2-setup.c |    2 +-
 arch/arm/mach-orion5x/ts209-setup.c            |    3 ++-
 arch/arm/mach-orion5x/ts409-setup.c            |    3 ++-
 arch/arm/mach-orion5x/wnr854t-setup.c          |    3 ++-
 arch/arm/mach-orion5x/wrt350n-v2-setup.c       |    3 ++-
 arch/arm/mach-pxa/cm-x2xx-pci.c                |    2 +-
 arch/arm/mach-sa1100/pci-nanoengine.c          |    3 ++-
 arch/arm/mach-shark/pci.c                      |    2 +-
 arch/arm/mach-tegra/pcie.c                     |    2 +-
 arch/arm/mach-versatile/pci.c                  |    2 +-
 arch/sh/drivers/pci/fixups-cayman.c            |    2 +-
 arch/sh/drivers/pci/fixups-dreamcast.c         |    2 +-
 arch/sh/drivers/pci/fixups-landisk.c           |    2 +-
 arch/sh/drivers/pci/fixups-r7780rp.c           |    2 +-
 arch/sh/drivers/pci/fixups-rts7751r2d.c        |    2 +-
 arch/sh/drivers/pci/fixups-sdk7780.c           |    2 +-
 arch/sh/drivers/pci/fixups-se7751.c            |    2 +-
 arch/sh/drivers/pci/fixups-sh03.c              |    2 +-
 arch/sh/drivers/pci/fixups-snapgear.c          |    2 +-
 arch/sh/drivers/pci/fixups-titan.c             |    2 +-
 arch/sh/drivers/pci/pcie-sh7786.c              |    2 +-
 arch/sh/include/asm/pci.h                      |    2 +-
 arch/sparc/include/asm/leon_pci.h              |    2 +-
 arch/sparc/kernel/leon_pci_grpci2.c            |    2 +-
 arch/tile/kernel/pci.c                         |    2 +-
 arch/unicore32/kernel/pci.c                    |    2 +-
 arch/x86/pci/visws.c                           |    2 +-
 drivers/pci/setup-irq.c                        |    4 ++--
 include/linux/pci.h                            |    2 +-
 101 files changed, 130 insertions(+), 113 deletions(-)

diff -puN arch/alpha/kernel/sys_alcor.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/alpha/kernel/sys_alcor.c
--- a/arch/alpha/kernel/sys_alcor.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/alpha/kernel/sys_alcor.c
@@ -183,7 +183,7 @@ alcor_init_irq(void)
  */
 
 static int __init
-alcor_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+alcor_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[7][5] __initdata = {
 		/*INT    INTA   INTB   INTC   INTD */
diff -puN arch/alpha/kernel/sys_cabriolet.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/alpha/kernel/sys_cabriolet.c
--- a/arch/alpha/kernel/sys_cabriolet.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/alpha/kernel/sys_cabriolet.c
@@ -175,7 +175,7 @@ pc164_init_irq(void)
  */
 
 static inline int __init
-eb66p_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+eb66p_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[5][5] __initdata = {
 		/*INT  INTA  INTB  INTC   INTD */
@@ -205,7 +205,7 @@ eb66p_map_irq(struct pci_dev *dev, u8 sl
  */
 
 static inline int __init
-cabriolet_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+cabriolet_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[5][5] __initdata = {
 		/*INT   INTA  INTB  INTC   INTD */
@@ -289,7 +289,7 @@ cia_cab_init_pci(void)
  */
 
 static inline int __init
-alphapc164_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+alphapc164_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[7][5] __initdata = {
 		/*INT   INTA  INTB   INTC   INTD */
diff -puN arch/alpha/kernel/sys_dp264.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/alpha/kernel/sys_dp264.c
--- a/arch/alpha/kernel/sys_dp264.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/alpha/kernel/sys_dp264.c
@@ -382,7 +382,7 @@ isa_irq_fixup(struct pci_dev *dev, int i
 }
 
 static int __init
-dp264_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+dp264_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[6][5] __initdata = {
 		/*INT    INTA   INTB   INTC   INTD */
@@ -404,7 +404,7 @@ dp264_map_irq(struct pci_dev *dev, u8 sl
 }
 
 static int __init
-monet_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+monet_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[13][5] __initdata = {
 		/*INT    INTA   INTB   INTC   INTD */
@@ -466,7 +466,7 @@ monet_swizzle(struct pci_dev *dev, u8 *p
 }
 
 static int __init
-webbrick_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+webbrick_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[13][5] __initdata = {
 		/*INT    INTA   INTB   INTC   INTD */
@@ -488,7 +488,7 @@ webbrick_map_irq(struct pci_dev *dev, u8
 }
 
 static int __init
-clipper_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+clipper_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[7][5] __initdata = {
 		/*INT    INTA   INTB   INTC   INTD */
diff -puN arch/alpha/kernel/sys_eb64p.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/alpha/kernel/sys_eb64p.c
--- a/arch/alpha/kernel/sys_eb64p.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/alpha/kernel/sys_eb64p.c
@@ -169,7 +169,7 @@ eb64p_init_irq(void)
  */
 
 static int __init
-eb64p_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+eb64p_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[5][5] __initdata = {
 		/*INT  INTA  INTB  INTC   INTD */
diff -puN arch/alpha/kernel/sys_eiger.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/alpha/kernel/sys_eiger.c
--- a/arch/alpha/kernel/sys_eiger.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/alpha/kernel/sys_eiger.c
@@ -144,7 +144,7 @@ eiger_init_irq(void)
 }
 
 static int __init
-eiger_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+eiger_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	u8 irq_orig;
 
diff -puN arch/alpha/kernel/sys_marvel.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/alpha/kernel/sys_marvel.c
--- a/arch/alpha/kernel/sys_marvel.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/alpha/kernel/sys_marvel.c
@@ -318,7 +318,7 @@ marvel_init_irq(void)
 }
 
 static int 
-marvel_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+marvel_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	struct pci_controller *hose = dev->sysdata;
 	struct io7_port *io7_port = hose->sysdata;
diff -puN arch/alpha/kernel/sys_miata.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/alpha/kernel/sys_miata.c
--- a/arch/alpha/kernel/sys_miata.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/alpha/kernel/sys_miata.c
@@ -151,7 +151,7 @@ miata_init_irq(void)
  */
 
 static int __init
-miata_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+miata_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
         static char irq_tab[18][5] __initdata = {
 		/*INT    INTA   INTB   INTC   INTD */
diff -puN arch/alpha/kernel/sys_mikasa.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/alpha/kernel/sys_mikasa.c
--- a/arch/alpha/kernel/sys_mikasa.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/alpha/kernel/sys_mikasa.c
@@ -146,7 +146,7 @@ mikasa_init_irq(void)
  */
 
 static int __init
-mikasa_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+mikasa_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[8][5] __initdata = {
 		/*INT    INTA   INTB   INTC   INTD */
diff -puN arch/alpha/kernel/sys_nautilus.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/alpha/kernel/sys_nautilus.c
--- a/arch/alpha/kernel/sys_nautilus.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/alpha/kernel/sys_nautilus.c
@@ -65,7 +65,7 @@ nautilus_init_irq(void)
 }
 
 static int __init
-nautilus_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+nautilus_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	/* Preserve the IRQ set up by the console.  */
 
diff -puN arch/alpha/kernel/sys_noritake.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/alpha/kernel/sys_noritake.c
--- a/arch/alpha/kernel/sys_noritake.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/alpha/kernel/sys_noritake.c
@@ -194,7 +194,7 @@ noritake_init_irq(void)
  */
 
 static int __init
-noritake_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+noritake_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[15][5] __initdata = {
 		/*INT    INTA   INTB   INTC   INTD */
diff -puN arch/alpha/kernel/sys_rawhide.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/alpha/kernel/sys_rawhide.c
--- a/arch/alpha/kernel/sys_rawhide.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/alpha/kernel/sys_rawhide.c
@@ -223,7 +223,7 @@ rawhide_init_irq(void)
  */
 
 static int __init
-rawhide_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+rawhide_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[5][5] __initdata = {
 		/*INT    INTA   INTB   INTC   INTD */
diff -puN arch/alpha/kernel/sys_ruffian.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/alpha/kernel/sys_ruffian.c
--- a/arch/alpha/kernel/sys_ruffian.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/alpha/kernel/sys_ruffian.c
@@ -119,7 +119,7 @@ ruffian_kill_arch (int mode)
  */
 
 static int __init
-ruffian_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+ruffian_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
         static char irq_tab[11][5] __initdata = {
 	      /*INT  INTA INTB INTC INTD */
diff -puN arch/alpha/kernel/sys_rx164.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/alpha/kernel/sys_rx164.c
--- a/arch/alpha/kernel/sys_rx164.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/alpha/kernel/sys_rx164.c
@@ -144,7 +144,7 @@ rx164_init_irq(void)
  */
 
 static int __init
-rx164_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+rx164_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 #if 0
 	static char irq_tab_pass1[6][5] __initdata = {
diff -puN arch/alpha/kernel/sys_sable.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/alpha/kernel/sys_sable.c
--- a/arch/alpha/kernel/sys_sable.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/alpha/kernel/sys_sable.c
@@ -194,7 +194,7 @@ sable_init_irq(void)
  */
 
 static int __init
-sable_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+sable_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[9][5] __initdata = {
 		/*INT    INTA   INTB   INTC   INTD */
@@ -376,7 +376,7 @@ lynx_init_irq(void)
  */
 
 static int __init
-lynx_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+lynx_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[19][5] __initdata = {
 		/*INT    INTA   INTB   INTC   INTD */
diff -puN arch/alpha/kernel/sys_sio.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/alpha/kernel/sys_sio.c
--- a/arch/alpha/kernel/sys_sio.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/alpha/kernel/sys_sio.c
@@ -146,7 +146,7 @@ sio_fixup_irq_levels(unsigned int level_
 }
 
 static inline int __init
-noname_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+noname_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	/*
 	 * The Noname board has 5 PCI slots with each of the 4
@@ -185,7 +185,7 @@ noname_map_irq(struct pci_dev *dev, u8 s
 }
 
 static inline int __init
-p2k_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+p2k_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[][5] __initdata = {
 		/*INT A   B   C   D */
diff -puN arch/alpha/kernel/sys_sx164.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/alpha/kernel/sys_sx164.c
--- a/arch/alpha/kernel/sys_sx164.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/alpha/kernel/sys_sx164.c
@@ -95,7 +95,7 @@ sx164_init_irq(void)
  */
 
 static int __init
-sx164_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+sx164_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[5][5] __initdata = {
 		/*INT    INTA   INTB   INTC   INTD */
diff -puN arch/alpha/kernel/sys_takara.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/alpha/kernel/sys_takara.c
--- a/arch/alpha/kernel/sys_takara.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/alpha/kernel/sys_takara.c
@@ -157,7 +157,7 @@ takara_init_irq(void)
  */
 
 static int __init
-takara_map_irq_srm(struct pci_dev *dev, u8 slot, u8 pin)
+takara_map_irq_srm(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[15][5] __initdata = {
 		{ 16+3, 16+3, 16+3, 16+3, 16+3},   /* slot  6 == device 3 */
@@ -188,7 +188,7 @@ takara_map_irq_srm(struct pci_dev *dev, 
 }
 
 static int __init
-takara_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+takara_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[15][5] __initdata = {
 		{ 16+3, 16+3, 16+3, 16+3, 16+3},   /* slot  6 == device 3 */
diff -puN arch/alpha/kernel/sys_titan.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/alpha/kernel/sys_titan.c
--- a/arch/alpha/kernel/sys_titan.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/alpha/kernel/sys_titan.c
@@ -305,7 +305,7 @@ titan_late_init(void)
 }
 
 static int __devinit
-titan_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+titan_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	u8 intline;
 	int irq;
diff -puN arch/alpha/kernel/sys_wildfire.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/alpha/kernel/sys_wildfire.c
--- a/arch/alpha/kernel/sys_wildfire.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/alpha/kernel/sys_wildfire.c
@@ -290,7 +290,7 @@ wildfire_device_interrupt(unsigned long 
  */
 
 static int __init
-wildfire_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+wildfire_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[8][5] __initdata = {
 		/*INT    INTA   INTB   INTC   INTD */
diff -puN arch/arm/common/it8152.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/common/it8152.c
--- a/arch/arm/common/it8152.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/common/it8152.c
@@ -144,7 +144,7 @@ void it8152_irq_demux(unsigned int irq, 
 }
 
 /* mapping for on-chip devices */
-int __init it8152_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+int __init it8152_pci_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	if ((dev->vendor == PCI_VENDOR_ID_ITE) &&
 	    (dev->device == PCI_DEVICE_ID_ITE_8152)) {
diff -puN arch/arm/include/asm/hardware/it8152.h~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/include/asm/hardware/it8152.h
--- a/arch/arm/include/asm/hardware/it8152.h~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/include/asm/hardware/it8152.h
@@ -105,7 +105,7 @@ struct pci_sys_data;
 
 extern void it8152_irq_demux(unsigned int irq, struct irq_desc *desc);
 extern void it8152_init_irq(void);
-extern int it8152_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin);
+extern int it8152_pci_map_irq(const struct pci_dev *dev, u8 slot, u8 pin);
 extern int it8152_pci_setup(int nr, struct pci_sys_data *sys);
 extern struct pci_bus *it8152_pci_scan_bus(int nr, struct pci_sys_data *sys);
 
diff -puN arch/arm/include/asm/mach/pci.h~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/include/asm/mach/pci.h
--- a/arch/arm/include/asm/mach/pci.h~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/include/asm/mach/pci.h
@@ -25,7 +25,7 @@ struct hw_pci {
 	void		(*preinit)(void);
 	void		(*postinit)(void);
 	u8		(*swizzle)(struct pci_dev *dev, u8 *pin);
-	int		(*map_irq)(struct pci_dev *dev, u8 slot, u8 pin);
+	int		(*map_irq)(const struct pci_dev *dev, u8 slot, u8 pin);
 };
 
 /*
@@ -44,7 +44,7 @@ struct pci_sys_data {
 					/* Bridge swizzling			*/
 	u8		(*swizzle)(struct pci_dev *, u8 *);
 					/* IRQ mapping				*/
-	int		(*map_irq)(struct pci_dev *, u8, u8);
+	int		(*map_irq)(const struct pci_dev *, u8, u8);
 	struct hw_pci	*hw;
 	void		*private_data;	/* platform controller private data	*/
 };
diff -puN arch/arm/kernel/bios32.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/kernel/bios32.c
--- a/arch/arm/kernel/bios32.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/kernel/bios32.c
@@ -476,7 +476,7 @@ static u8 __devinit pcibios_swizzle(stru
 /*
  * Map a slot/pin to an IRQ.
  */
-static int pcibios_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	struct pci_sys_data *sys = dev->sysdata;
 	int irq = -1;
diff -puN arch/arm/mach-cns3xxx/pcie.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-cns3xxx/pcie.c
--- a/arch/arm/mach-cns3xxx/pcie.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-cns3xxx/pcie.c
@@ -172,7 +172,7 @@ static struct pci_bus *cns3xxx_pci_scan_
 	return pci_scan_bus(sys->busnr, &cns3xxx_pcie_ops, sys);
 }
 
-static int cns3xxx_pcie_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int cns3xxx_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	struct cns3xxx_pcie *cnspci = pdev_to_cnspci(dev);
 	int irq = cnspci->irqs[slot];
diff -puN arch/arm/mach-dove/pcie.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-dove/pcie.c
--- a/arch/arm/mach-dove/pcie.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-dove/pcie.c
@@ -192,7 +192,7 @@ dove_pcie_scan_bus(int nr, struct pci_sy
 	return bus;
 }
 
-static int __init dove_pcie_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init dove_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	struct pcie_port *pp = bus_to_port(dev->bus->number);
 
diff -puN arch/arm/mach-footbridge/cats-pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-footbridge/cats-pci.c
--- a/arch/arm/mach-footbridge/cats-pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-footbridge/cats-pci.c
@@ -16,7 +16,7 @@
 /* cats host-specific stuff */
 static int irqmap_cats[] __initdata = { IRQ_PCI, IRQ_IN0, IRQ_IN1, IRQ_IN3 };
 
-static int __init cats_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init cats_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	if (dev->irq >= 255)
 		return -1;	/* not a valid interrupt. */
diff -puN arch/arm/mach-footbridge/ebsa285-pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-footbridge/ebsa285-pci.c
--- a/arch/arm/mach-footbridge/ebsa285-pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-footbridge/ebsa285-pci.c
@@ -15,7 +15,7 @@
 
 static int irqmap_ebsa285[] __initdata = { IRQ_IN3, IRQ_IN1, IRQ_IN0, IRQ_PCI };
 
-static int __init ebsa285_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init ebsa285_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	if (dev->vendor == PCI_VENDOR_ID_CONTAQ &&
 	    dev->device == PCI_DEVICE_ID_CONTAQ_82C693)
diff -puN arch/arm/mach-footbridge/netwinder-pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-footbridge/netwinder-pci.c
--- a/arch/arm/mach-footbridge/netwinder-pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-footbridge/netwinder-pci.c
@@ -17,7 +17,7 @@
  * We now use the slot ID instead of the device identifiers to select
  * which interrupt is routed where.
  */
-static int __init netwinder_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init netwinder_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	switch (slot) {
 	case 0:  /* host bridge */
diff -puN arch/arm/mach-footbridge/personal-pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-footbridge/personal-pci.c
--- a/arch/arm/mach-footbridge/personal-pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-footbridge/personal-pci.c
@@ -18,7 +18,8 @@ static int irqmap_personal_server[] __in
 	IRQ_DOORBELLHOST, IRQ_DMA1, IRQ_DMA2, IRQ_PCI
 };
 
-static int __init personal_server_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init personal_server_map_irq(const struct pci_dev *dev, u8 slot,
+	u8 pin)
 {
 	unsigned char line;
 
diff -puN arch/arm/mach-integrator/pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-integrator/pci.c
--- a/arch/arm/mach-integrator/pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-integrator/pci.c
@@ -95,7 +95,7 @@ static int irq_tab[4] __initdata = {
  * map the specified device/slot/pin to an IRQ.  This works out such
  * that slot 9 pin 1 is INT0, pin 2 is INT1, and slot 10 pin 1 is INT1.
  */
-static int __init integrator_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init integrator_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	int intnr = ((slot - 9) + (pin - 1)) & 3;
 
diff -puN arch/arm/mach-iop13xx/iq81340mc.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-iop13xx/iq81340mc.c
--- a/arch/arm/mach-iop13xx/iq81340mc.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-iop13xx/iq81340mc.c
@@ -30,7 +30,7 @@
 extern int init_atu; /* Flag to select which ATU(s) to initialize / disable */
 
 static int __init
-iq81340mc_pcix_map_irq(struct pci_dev *dev, u8 idsel, u8 pin)
+iq81340mc_pcix_map_irq(const struct pci_dev *dev, u8 idsel, u8 pin)
 {
 	switch (idsel) {
 	case 1:
diff -puN arch/arm/mach-iop13xx/pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-iop13xx/pci.c
--- a/arch/arm/mach-iop13xx/pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-iop13xx/pci.c
@@ -390,7 +390,7 @@ static int iop13xx_atue_pci_status(int c
 }
 
 static int
-iop13xx_pcie_map_irq(struct pci_dev *dev, u8 idsel, u8 pin)
+iop13xx_pcie_map_irq(const struct pci_dev *dev, u8 idsel, u8 pin)
 {
 	WARN_ON(idsel != 0);
 
diff -puN arch/arm/mach-iop32x/em7210.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-iop32x/em7210.c
--- a/arch/arm/mach-iop32x/em7210.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-iop32x/em7210.c
@@ -81,7 +81,7 @@ void __init em7210_map_io(void)
 #define INTD	IRQ_IOP32X_XINT3
 
 static int __init
-em7210_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+em7210_pci_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static int pci_irq_table[][4] = {
 		/*
diff -puN arch/arm/mach-iop32x/glantank.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-iop32x/glantank.c
--- a/arch/arm/mach-iop32x/glantank.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-iop32x/glantank.c
@@ -77,7 +77,7 @@ void __init glantank_map_io(void)
 #define INTD	IRQ_IOP32X_XINT3
 
 static int __init
-glantank_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+glantank_pci_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static int pci_irq_table[][4] = {
 		/*
diff -puN arch/arm/mach-iop32x/iq31244.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-iop32x/iq31244.c
--- a/arch/arm/mach-iop32x/iq31244.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-iop32x/iq31244.c
@@ -103,7 +103,7 @@ void __init iq31244_map_io(void)
  * EP80219/IQ31244 PCI.
  */
 static int __init
-ep80219_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+ep80219_pci_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	int irq;
 
@@ -139,7 +139,7 @@ static struct hw_pci ep80219_pci __initd
 };
 
 static int __init
-iq31244_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+iq31244_pci_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	int irq;
 
diff -puN arch/arm/mach-iop32x/iq80321.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-iop32x/iq80321.c
--- a/arch/arm/mach-iop32x/iq80321.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-iop32x/iq80321.c
@@ -71,7 +71,7 @@ void __init iq80321_map_io(void)
  * IQ80321 PCI.
  */
 static int __init
-iq80321_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+iq80321_pci_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	int irq;
 
diff -puN arch/arm/mach-iop32x/n2100.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-iop32x/n2100.c
--- a/arch/arm/mach-iop32x/n2100.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-iop32x/n2100.c
@@ -78,7 +78,7 @@ void __init n2100_map_io(void)
  * N2100 PCI.
  */
 static int __init
-n2100_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+n2100_pci_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	int irq;
 
diff -puN arch/arm/mach-iop33x/iq80331.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-iop33x/iq80331.c
--- a/arch/arm/mach-iop33x/iq80331.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-iop33x/iq80331.c
@@ -54,7 +54,7 @@ static struct sys_timer iq80331_timer = 
  * IQ80331 PCI.
  */
 static int __init
-iq80331_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+iq80331_pci_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	int irq;
 
diff -puN arch/arm/mach-iop33x/iq80332.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-iop33x/iq80332.c
--- a/arch/arm/mach-iop33x/iq80332.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-iop33x/iq80332.c
@@ -54,7 +54,7 @@ static struct sys_timer iq80332_timer = 
  * IQ80332 PCI.
  */
 static int __init
-iq80332_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+iq80332_pci_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	int irq;
 
diff -puN arch/arm/mach-ixp2000/enp2611.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-ixp2000/enp2611.c
--- a/arch/arm/mach-ixp2000/enp2611.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-ixp2000/enp2611.c
@@ -148,7 +148,8 @@ static struct pci_bus * __init enp2611_p
 	return pci_scan_bus(sys->busnr, &enp2611_pci_ops, sys);
 }
 
-static int __init enp2611_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init enp2611_pci_map_irq(const struct pci_dev *dev, u8 slot,
+	u8 pin)
 {
 	int irq;
 
diff -puN arch/arm/mach-ixp2000/ixdp2400.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-ixp2000/ixdp2400.c
--- a/arch/arm/mach-ixp2000/ixdp2400.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-ixp2000/ixdp2400.c
@@ -78,7 +78,8 @@ int ixdp2400_pci_setup(int nr, struct pc
 	return 1;
 }
 
-static int __init ixdp2400_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init ixdp2400_pci_map_irq(const struct pci_dev *dev, u8 slot,
+	u8 pin)
 {
 	if (ixdp2x00_master_npu()) {
 
diff -puN arch/arm/mach-ixp2000/ixdp2800.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-ixp2000/ixdp2800.c
--- a/arch/arm/mach-ixp2000/ixdp2800.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-ixp2000/ixdp2800.c
@@ -161,7 +161,8 @@ static int __init ixdp2800_pci_setup(int
 	return 1;
 }
 
-static int __init ixdp2800_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init ixdp2800_pci_map_irq(const struct pci_dev *dev, u8 slot,
+	u8 pin)
 {
 	if (ixdp2x00_master_npu()) {
 
diff -puN arch/arm/mach-ixp2000/ixdp2x01.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-ixp2000/ixdp2x01.c
--- a/arch/arm/mach-ixp2000/ixdp2x01.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-ixp2000/ixdp2x01.c
@@ -252,7 +252,8 @@ void __init ixdp2x01_pci_preinit(void)
 
 #define DEVPIN(dev, pin) ((pin) | ((dev) << 3))
 
-static int __init ixdp2x01_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init ixdp2x01_pci_map_irq(const struct pci_dev *dev, u8 slot,
+	u8 pin)
 {
 	u8 bus = dev->bus->number;
 	u32 devpin = DEVPIN(PCI_SLOT(dev->devfn), pin);
diff -puN arch/arm/mach-ixp23xx/ixdp2351.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-ixp23xx/ixdp2351.c
--- a/arch/arm/mach-ixp23xx/ixdp2351.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-ixp23xx/ixdp2351.c
@@ -168,7 +168,7 @@ void __init ixdp2351_init_irq(void)
  */
 #define DEVPIN(dev, pin) ((pin) | ((dev) << 3))
 
-static int __init ixdp2351_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init ixdp2351_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	u8 bus = dev->bus->number;
 	u32 devpin = DEVPIN(PCI_SLOT(dev->devfn), pin);
diff -puN arch/arm/mach-ixp23xx/roadrunner.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-ixp23xx/roadrunner.c
--- a/arch/arm/mach-ixp23xx/roadrunner.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-ixp23xx/roadrunner.c
@@ -56,7 +56,8 @@
 #define INTC_PIN	IXP23XX_GPIO_PIN_11
 #define INTD_PIN	IXP23XX_GPIO_PIN_12
 
-static int __init roadrunner_map_irq(struct pci_dev *dev, u8 idsel, u8 pin)
+static int __init roadrunner_map_irq(const struct pci_dev *dev, u8 idsel,
+	u8 pin)
 {
 	static int pci_card_slot_irq[] = {INTB, INTC, INTD, INTA};
 	static int pmc_card_slot_irq[] = {INTA, INTB, INTC, INTD};
diff -puN arch/arm/mach-ixp4xx/avila-pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-ixp4xx/avila-pci.c
--- a/arch/arm/mach-ixp4xx/avila-pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-ixp4xx/avila-pci.c
@@ -46,7 +46,7 @@ void __init avila_pci_preinit(void)
 	ixp4xx_pci_preinit();
 }
 
-static int __init avila_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init avila_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static int pci_irq_table[IRQ_LINES] = {
 		IXP4XX_GPIO_IRQ(INTA),
diff -puN arch/arm/mach-ixp4xx/coyote-pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-ixp4xx/coyote-pci.c
--- a/arch/arm/mach-ixp4xx/coyote-pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-ixp4xx/coyote-pci.c
@@ -37,7 +37,7 @@ void __init coyote_pci_preinit(void)
 	ixp4xx_pci_preinit();
 }
 
-static int __init coyote_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init coyote_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	if (slot == SLOT0_DEVID)
 		return IXP4XX_GPIO_IRQ(SLOT0_INTA);
diff -puN arch/arm/mach-ixp4xx/dsmg600-pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-ixp4xx/dsmg600-pci.c
--- a/arch/arm/mach-ixp4xx/dsmg600-pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-ixp4xx/dsmg600-pci.c
@@ -44,7 +44,7 @@ void __init dsmg600_pci_preinit(void)
 	ixp4xx_pci_preinit();
 }
 
-static int __init dsmg600_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init dsmg600_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static int pci_irq_table[MAX_DEV][IRQ_LINES] = {
 		{ IXP4XX_GPIO_IRQ(INTE), -1, -1 },
diff -puN arch/arm/mach-ixp4xx/fsg-pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-ixp4xx/fsg-pci.c
--- a/arch/arm/mach-ixp4xx/fsg-pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-ixp4xx/fsg-pci.c
@@ -38,7 +38,7 @@ void __init fsg_pci_preinit(void)
 	ixp4xx_pci_preinit();
 }
 
-static int __init fsg_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init fsg_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static int pci_irq_table[IRQ_LINES] = {
 		IXP4XX_GPIO_IRQ(INTC),
diff -puN arch/arm/mach-ixp4xx/gateway7001-pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-ixp4xx/gateway7001-pci.c
--- a/arch/arm/mach-ixp4xx/gateway7001-pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-ixp4xx/gateway7001-pci.c
@@ -35,7 +35,8 @@ void __init gateway7001_pci_preinit(void
 	ixp4xx_pci_preinit();
 }
 
-static int __init gateway7001_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init gateway7001_map_irq(const struct pci_dev *dev, u8 slot,
+	u8 pin)
 {
 	if (slot == 1)
 		return IRQ_IXP4XX_GPIO11;
diff -puN arch/arm/mach-ixp4xx/goramo_mlr.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-ixp4xx/goramo_mlr.c
--- a/arch/arm/mach-ixp4xx/goramo_mlr.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-ixp4xx/goramo_mlr.c
@@ -462,7 +462,7 @@ static void __init gmlr_pci_postinit(voi
 	}
 }
 
-static int __init gmlr_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init gmlr_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	switch(slot) {
 	case SLOT_ETHA:	return IXP4XX_GPIO_IRQ(GPIO_IRQ_ETHA);
diff -puN arch/arm/mach-ixp4xx/gtwx5715-pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-ixp4xx/gtwx5715-pci.c
--- a/arch/arm/mach-ixp4xx/gtwx5715-pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-ixp4xx/gtwx5715-pci.c
@@ -49,7 +49,7 @@ void __init gtwx5715_pci_preinit(void)
 }
 
 
-static int __init gtwx5715_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init gtwx5715_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	int rc = -1;
 
diff -puN arch/arm/mach-ixp4xx/ixdp425-pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-ixp4xx/ixdp425-pci.c
--- a/arch/arm/mach-ixp4xx/ixdp425-pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-ixp4xx/ixdp425-pci.c
@@ -43,7 +43,7 @@ void __init ixdp425_pci_preinit(void)
 	ixp4xx_pci_preinit();
 }
 
-static int __init ixdp425_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init ixdp425_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static int pci_irq_table[IRQ_LINES] = {
 		IXP4XX_GPIO_IRQ(INTA),
diff -puN arch/arm/mach-ixp4xx/ixdpg425-pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-ixp4xx/ixdpg425-pci.c
--- a/arch/arm/mach-ixp4xx/ixdpg425-pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-ixp4xx/ixdpg425-pci.c
@@ -31,7 +31,7 @@ void __init ixdpg425_pci_preinit(void)
 	ixp4xx_pci_preinit();
 }
 
-static int __init ixdpg425_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init ixdpg425_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	if (slot == 12 || slot == 13)
 		return IRQ_IXP4XX_GPIO7;
diff -puN arch/arm/mach-ixp4xx/nas100d-pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-ixp4xx/nas100d-pci.c
--- a/arch/arm/mach-ixp4xx/nas100d-pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-ixp4xx/nas100d-pci.c
@@ -41,7 +41,7 @@ void __init nas100d_pci_preinit(void)
 	ixp4xx_pci_preinit();
 }
 
-static int __init nas100d_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init nas100d_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static int pci_irq_table[MAX_DEV][IRQ_LINES] = {
 		{ IXP4XX_GPIO_IRQ(INTA), -1, -1 },
diff -puN arch/arm/mach-ixp4xx/nslu2-pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-ixp4xx/nslu2-pci.c
--- a/arch/arm/mach-ixp4xx/nslu2-pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-ixp4xx/nslu2-pci.c
@@ -38,7 +38,7 @@ void __init nslu2_pci_preinit(void)
 	ixp4xx_pci_preinit();
 }
 
-static int __init nslu2_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init nslu2_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static int pci_irq_table[IRQ_LINES] = {
 		IXP4XX_GPIO_IRQ(INTA),
diff -puN arch/arm/mach-ixp4xx/vulcan-pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-ixp4xx/vulcan-pci.c
--- a/arch/arm/mach-ixp4xx/vulcan-pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-ixp4xx/vulcan-pci.c
@@ -43,7 +43,7 @@ void __init vulcan_pci_preinit(void)
 	ixp4xx_pci_preinit();
 }
 
-static int __init vulcan_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init vulcan_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	if (slot == 1)
 		return IXP4XX_GPIO_IRQ(INTA);
diff -puN arch/arm/mach-ixp4xx/wg302v2-pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-ixp4xx/wg302v2-pci.c
--- a/arch/arm/mach-ixp4xx/wg302v2-pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-ixp4xx/wg302v2-pci.c
@@ -35,7 +35,7 @@ void __init wg302v2_pci_preinit(void)
 	ixp4xx_pci_preinit();
 }
 
-static int __init wg302v2_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init wg302v2_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	if (slot == 1)
 		return IRQ_IXP4XX_GPIO8;
diff -puN arch/arm/mach-kirkwood/pcie.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-kirkwood/pcie.c
--- a/arch/arm/mach-kirkwood/pcie.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-kirkwood/pcie.c
@@ -244,7 +244,8 @@ kirkwood_pcie_scan_bus(int nr, struct pc
 	return bus;
 }
 
-static int __init kirkwood_pcie_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init kirkwood_pcie_map_irq(const struct pci_dev *dev, u8 slot,
+	u8 pin)
 {
 	struct pcie_port *pp = bus_to_port(dev->bus);
 
diff -puN arch/arm/mach-ks8695/board-dsm320.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-ks8695/board-dsm320.c
--- a/arch/arm/mach-ks8695/board-dsm320.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-ks8695/board-dsm320.c
@@ -34,7 +34,7 @@
 #include "generic.h"
 
 #ifdef CONFIG_PCI
-static int dsm320_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int dsm320_pci_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	switch (slot) {
 	case 0:
diff -puN arch/arm/mach-ks8695/board-micrel.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-ks8695/board-micrel.c
--- a/arch/arm/mach-ks8695/board-micrel.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-ks8695/board-micrel.c
@@ -24,7 +24,7 @@
 #include "generic.h"
 
 #ifdef CONFIG_PCI
-static int micrel_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int micrel_pci_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	return KS8695_IRQ_EXTERN0;
 }
diff -puN arch/arm/mach-ks8695/include/mach/devices.h~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-ks8695/include/mach/devices.h
--- a/arch/arm/mach-ks8695/include/mach/devices.h~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-ks8695/include/mach/devices.h
@@ -30,7 +30,7 @@ extern void __init ks8695_init_leds(u8 c
 
 struct ks8695_pci_cfg {
 	short mode;
-	int (*map_irq)(struct pci_dev *, u8, u8);
+	int (*map_irq)(const struct pci_dev *, u8, u8);
 };
 extern __init void ks8695_init_pci(struct ks8695_pci_cfg *);
 
diff -puN arch/arm/mach-mv78xx0/pcie.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-mv78xx0/pcie.c
--- a/arch/arm/mach-mv78xx0/pcie.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-mv78xx0/pcie.c
@@ -259,7 +259,8 @@ mv78xx0_pcie_scan_bus(int nr, struct pci
 	return bus;
 }
 
-static int __init mv78xx0_pcie_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init mv78xx0_pcie_map_irq(const struct pci_dev *dev, u8 slot,
+	u8 pin)
 {
 	struct pcie_port *pp = bus_to_port(dev->bus->number);
 
diff -puN arch/arm/mach-orion5x/common.h~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-orion5x/common.h
--- a/arch/arm/mach-orion5x/common.h~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-orion5x/common.h
@@ -51,7 +51,7 @@ void orion5x_pci_disable(void);
 void orion5x_pci_set_cardbus_mode(void);
 int orion5x_pci_sys_setup(int nr, struct pci_sys_data *sys);
 struct pci_bus *orion5x_pci_sys_scan_bus(int nr, struct pci_sys_data *sys);
-int orion5x_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin);
+int orion5x_pci_map_irq(const struct pci_dev *dev, u8 slot, u8 pin);
 
 struct machine_desc;
 struct meminfo;
diff -puN arch/arm/mach-orion5x/db88f5281-setup.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-orion5x/db88f5281-setup.c
--- a/arch/arm/mach-orion5x/db88f5281-setup.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-orion5x/db88f5281-setup.c
@@ -237,7 +237,8 @@ void __init db88f5281_pci_preinit(void)
 	}
 }
 
-static int __init db88f5281_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init db88f5281_pci_map_irq(const struct pci_dev *dev, u8 slot,
+	u8 pin)
 {
 	int irq;
 
diff -puN arch/arm/mach-orion5x/dns323-setup.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-orion5x/dns323-setup.c
--- a/arch/arm/mach-orion5x/dns323-setup.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-orion5x/dns323-setup.c
@@ -70,14 +70,14 @@ enum {
  * PCI setup
  */
 
-static int __init dns323_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init dns323_pci_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	int irq;
 
 	/*
 	 * Check for devices with hard-wired IRQs.
 	 */
-	irq = orion5x_pci_map_irq(dev, slot, pin);
+	irq = orion5x_pci_map_irq(const dev, slot, pin);
 	if (irq != -1)
 		return irq;
 
diff -puN arch/arm/mach-orion5x/kurobox_pro-setup.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-orion5x/kurobox_pro-setup.c
--- a/arch/arm/mach-orion5x/kurobox_pro-setup.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-orion5x/kurobox_pro-setup.c
@@ -119,7 +119,8 @@ static struct platform_device kurobox_pr
  * PCI
  ****************************************************************************/
 
-static int __init kurobox_pro_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init kurobox_pro_pci_map_irq(const struct pci_dev *dev, u8 slot,
+	u8 pin)
 {
 	int irq;
 
diff -puN arch/arm/mach-orion5x/mss2-setup.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-orion5x/mss2-setup.c
--- a/arch/arm/mach-orion5x/mss2-setup.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-orion5x/mss2-setup.c
@@ -73,7 +73,7 @@ static struct platform_device mss2_nor_f
 /****************************************************************************
  * PCI setup
  ****************************************************************************/
-static int __init mss2_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init mss2_pci_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	int irq;
 
diff -puN arch/arm/mach-orion5x/pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-orion5x/pci.c
--- a/arch/arm/mach-orion5x/pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-orion5x/pci.c
@@ -587,7 +587,7 @@ struct pci_bus __init *orion5x_pci_sys_s
 	return bus;
 }
 
-int __init orion5x_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+int __init orion5x_pci_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	int bus = dev->bus->number;
 
diff -puN arch/arm/mach-orion5x/rd88f5181l-fxo-setup.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-orion5x/rd88f5181l-fxo-setup.c
--- a/arch/arm/mach-orion5x/rd88f5181l-fxo-setup.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-orion5x/rd88f5181l-fxo-setup.c
@@ -131,7 +131,7 @@ static void __init rd88f5181l_fxo_init(v
 }
 
 static int __init
-rd88f5181l_fxo_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+rd88f5181l_fxo_pci_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	int irq;
 
diff -puN arch/arm/mach-orion5x/rd88f5181l-ge-setup.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-orion5x/rd88f5181l-ge-setup.c
--- a/arch/arm/mach-orion5x/rd88f5181l-ge-setup.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-orion5x/rd88f5181l-ge-setup.c
@@ -140,7 +140,7 @@ static void __init rd88f5181l_ge_init(vo
 }
 
 static int __init
-rd88f5181l_ge_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+rd88f5181l_ge_pci_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	int irq;
 
diff -puN arch/arm/mach-orion5x/rd88f5182-setup.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-orion5x/rd88f5182-setup.c
--- a/arch/arm/mach-orion5x/rd88f5182-setup.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-orion5x/rd88f5182-setup.c
@@ -172,7 +172,8 @@ void __init rd88f5182_pci_preinit(void)
 	}
 }
 
-static int __init rd88f5182_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init rd88f5182_pci_map_irq(const struct pci_dev *dev, u8 slot,
+	u8 pin)
 {
 	int irq;
 
diff -puN arch/arm/mach-orion5x/terastation_pro2-setup.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-orion5x/terastation_pro2-setup.c
--- a/arch/arm/mach-orion5x/terastation_pro2-setup.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-orion5x/terastation_pro2-setup.c
@@ -100,7 +100,7 @@ void __init tsp2_pci_preinit(void)
 	}
 }
 
-static int __init tsp2_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init tsp2_pci_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	int irq;
 
diff -puN arch/arm/mach-orion5x/ts209-setup.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-orion5x/ts209-setup.c
--- a/arch/arm/mach-orion5x/ts209-setup.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-orion5x/ts209-setup.c
@@ -143,7 +143,8 @@ void __init qnap_ts209_pci_preinit(void)
 	}
 }
 
-static int __init qnap_ts209_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init qnap_ts209_pci_map_irq(const struct pci_dev *dev, u8 slot,
+	u8 pin)
 {
 	int irq;
 
diff -puN arch/arm/mach-orion5x/ts409-setup.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-orion5x/ts409-setup.c
--- a/arch/arm/mach-orion5x/ts409-setup.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-orion5x/ts409-setup.c
@@ -121,7 +121,8 @@ static struct platform_device qnap_ts409
  * PCI
  ****************************************************************************/
 
-static int __init qnap_ts409_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init qnap_ts409_pci_map_irq(const struct pci_dev *dev, u8 slot,
+	u8 pin)
 {
 	int irq;
 
diff -puN arch/arm/mach-orion5x/wnr854t-setup.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-orion5x/wnr854t-setup.c
--- a/arch/arm/mach-orion5x/wnr854t-setup.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-orion5x/wnr854t-setup.c
@@ -133,7 +133,8 @@ static void __init wnr854t_init(void)
 	platform_device_register(&wnr854t_nor_flash);
 }
 
-static int __init wnr854t_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init wnr854t_pci_map_irq(const struct pci_dev *dev, u8 slot,
+	u8 pin)
 {
 	int irq;
 
diff -puN arch/arm/mach-orion5x/wrt350n-v2-setup.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-orion5x/wrt350n-v2-setup.c
--- a/arch/arm/mach-orion5x/wrt350n-v2-setup.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-orion5x/wrt350n-v2-setup.c
@@ -221,7 +221,8 @@ static void __init wrt350n_v2_init(void)
 	platform_device_register(&wrt350n_v2_button_device);
 }
 
-static int __init wrt350n_v2_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init wrt350n_v2_pci_map_irq(const struct pci_dev *dev, u8 slot,
+	u8 pin)
 {
 	int irq;
 
diff -puN arch/arm/mach-pxa/cm-x2xx-pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-pxa/cm-x2xx-pci.c
--- a/arch/arm/mach-pxa/cm-x2xx-pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-pxa/cm-x2xx-pci.c
@@ -77,7 +77,7 @@ void cmx2xx_pci_resume(void) {}
 #endif
 
 /* PCI IRQ mapping*/
-static int __init cmx2xx_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init cmx2xx_pci_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	int irq;
 
diff -puN arch/arm/mach-sa1100/pci-nanoengine.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-sa1100/pci-nanoengine.c
--- a/arch/arm/mach-sa1100/pci-nanoengine.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-sa1100/pci-nanoengine.c
@@ -122,7 +122,8 @@ static struct pci_ops pci_nano_ops = {
 	.write	= nanoengine_write_config,
 };
 
-static int __init pci_nanoengine_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init pci_nanoengine_map_irq(const struct pci_dev *dev, u8 slot,
+	u8 pin)
 {
 	return NANOENGINE_IRQ_GPIO_PCI;
 }
diff -puN arch/arm/mach-shark/pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-shark/pci.c
--- a/arch/arm/mach-shark/pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-shark/pci.c
@@ -13,7 +13,7 @@
 #include <asm/mach/pci.h>
 #include <asm/mach-types.h>
 
-static int __init shark_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init shark_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	if (dev->bus->number == 0)
 		if (dev->devfn == 0)
diff -puN arch/arm/mach-tegra/pcie.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-tegra/pcie.c
--- a/arch/arm/mach-tegra/pcie.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-tegra/pcie.c
@@ -449,7 +449,7 @@ static int tegra_pcie_setup(int nr, stru
 	return 1;
 }
 
-static int tegra_pcie_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int tegra_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	return INT_PCIE_INTR;
 }
diff -puN arch/arm/mach-versatile/pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/arm/mach-versatile/pci.c
--- a/arch/arm/mach-versatile/pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/arm/mach-versatile/pci.c
@@ -325,7 +325,7 @@ void __init pci_versatile_preinit(void)
 /*
  * map the specified device/slot/pin to an IRQ.   Different backplanes may need to modify this.
  */
-static int __init versatile_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init versatile_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	int irq;
 	int devslot = PCI_SLOT(dev->devfn);
diff -puN arch/sh/drivers/pci/fixups-cayman.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/sh/drivers/pci/fixups-cayman.c
--- a/arch/sh/drivers/pci/fixups-cayman.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/sh/drivers/pci/fixups-cayman.c
@@ -5,7 +5,7 @@
 #include <cpu/irq.h>
 #include "pci-sh5.h"
 
-int __init pcibios_map_platform_irq(struct pci_dev *dev, u8 slot, u8 pin)
+int __init pcibios_map_platform_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	int result = -1;
 
diff -puN arch/sh/drivers/pci/fixups-dreamcast.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/sh/drivers/pci/fixups-dreamcast.c
--- a/arch/sh/drivers/pci/fixups-dreamcast.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/sh/drivers/pci/fixups-dreamcast.c
@@ -64,7 +64,7 @@ static void __init gapspci_fixup_resourc
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_ANY_ID, PCI_ANY_ID, gapspci_fixup_resources);
 
-int __init pcibios_map_platform_irq(struct pci_dev *dev, u8 slot, u8 pin)
+int __init pcibios_map_platform_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	/*
 	 * The interrupt routing semantics here are quite trivial.
diff -puN arch/sh/drivers/pci/fixups-landisk.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/sh/drivers/pci/fixups-landisk.c
--- a/arch/sh/drivers/pci/fixups-landisk.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/sh/drivers/pci/fixups-landisk.c
@@ -19,7 +19,7 @@
 #define PCIMCR_MRSET_OFF	0xBFFFFFFF
 #define PCIMCR_RFSH_OFF		0xFFFFFFFB
 
-int pcibios_map_platform_irq(struct pci_dev *pdev, u8 slot, u8 pin)
+int pcibios_map_platform_irq(const struct pci_dev *pdev, u8 slot, u8 pin)
 {
 	/*
 	 * slot0: pin1-4 = irq5,6,7,8
diff -puN arch/sh/drivers/pci/fixups-r7780rp.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/sh/drivers/pci/fixups-r7780rp.c
--- a/arch/sh/drivers/pci/fixups-r7780rp.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/sh/drivers/pci/fixups-r7780rp.c
@@ -18,7 +18,7 @@ static char irq_tab[] __initdata = {
 	65, 66, 67, 68,
 };
 
-int __init pcibios_map_platform_irq(struct pci_dev *pdev, u8 slot, u8 pin)
+int __init pcibios_map_platform_irq(const struct pci_dev *pdev, u8 slot, u8 pin)
 {
 	return irq_tab[slot];
 }
diff -puN arch/sh/drivers/pci/fixups-rts7751r2d.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/sh/drivers/pci/fixups-rts7751r2d.c
--- a/arch/sh/drivers/pci/fixups-rts7751r2d.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/sh/drivers/pci/fixups-rts7751r2d.c
@@ -31,7 +31,7 @@ static char lboxre2_irq_tab[] __initdata
 	IRQ_ETH0, IRQ_ETH1, IRQ_INTA, IRQ_INTD,
 };
 
-int __init pcibios_map_platform_irq(struct pci_dev *pdev, u8 slot, u8 pin)
+int __init pcibios_map_platform_irq(const struct pci_dev *pdev, u8 slot, u8 pin)
 {
 	if (mach_is_lboxre2())
 		return lboxre2_irq_tab[slot];
diff -puN arch/sh/drivers/pci/fixups-sdk7780.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/sh/drivers/pci/fixups-sdk7780.c
--- a/arch/sh/drivers/pci/fixups-sdk7780.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/sh/drivers/pci/fixups-sdk7780.c
@@ -27,7 +27,7 @@ static char sdk7780_irq_tab[4][16] __ini
 	{ 68, 67, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 },
 };
 
-int __init pcibios_map_platform_irq(struct pci_dev *pdev, u8 slot, u8 pin)
+int __init pcibios_map_platform_irq(const struct pci_dev *pdev, u8 slot, u8 pin)
 {
        return sdk7780_irq_tab[pin-1][slot];
 }
diff -puN arch/sh/drivers/pci/fixups-se7751.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/sh/drivers/pci/fixups-se7751.c
--- a/arch/sh/drivers/pci/fixups-se7751.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/sh/drivers/pci/fixups-se7751.c
@@ -6,7 +6,7 @@
 #include <linux/io.h>
 #include "pci-sh4.h"
 
-int __init pcibios_map_platform_irq(struct pci_dev *, u8 slot, u8 pin)
+int __init pcibios_map_platform_irq(const struct pci_dev *, u8 slot, u8 pin)
 {
         switch (slot) {
         case 0: return 13;
diff -puN arch/sh/drivers/pci/fixups-sh03.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/sh/drivers/pci/fixups-sh03.c
--- a/arch/sh/drivers/pci/fixups-sh03.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/sh/drivers/pci/fixups-sh03.c
@@ -3,7 +3,7 @@
 #include <linux/types.h>
 #include <linux/pci.h>
 
-int __init pcibios_map_platform_irq(struct pci_dev *dev, u8 slot, u8 pin)
+int __init pcibios_map_platform_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	int irq;
 
diff -puN arch/sh/drivers/pci/fixups-snapgear.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/sh/drivers/pci/fixups-snapgear.c
--- a/arch/sh/drivers/pci/fixups-snapgear.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/sh/drivers/pci/fixups-snapgear.c
@@ -18,7 +18,7 @@
 #include <linux/pci.h>
 #include "pci-sh4.h"
 
-int __init pcibios_map_platform_irq(struct pci_dev *pdev, u8 slot, u8 pin)
+int __init pcibios_map_platform_irq(const struct pci_dev *pdev, u8 slot, u8 pin)
 {
 	int irq = -1;
 
diff -puN arch/sh/drivers/pci/fixups-titan.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/sh/drivers/pci/fixups-titan.c
--- a/arch/sh/drivers/pci/fixups-titan.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/sh/drivers/pci/fixups-titan.c
@@ -27,7 +27,7 @@ static char titan_irq_tab[] __initdata =
 	TITAN_IRQ_USB,
 };
 
-int __init pcibios_map_platform_irq(struct pci_dev *pdev, u8 slot, u8 pin)
+int __init pcibios_map_platform_irq(const struct pci_dev *pdev, u8 slot, u8 pin)
 {
 	int irq = titan_irq_tab[slot];
 
diff -puN arch/sh/drivers/pci/pcie-sh7786.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/sh/drivers/pci/pcie-sh7786.c
--- a/arch/sh/drivers/pci/pcie-sh7786.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/sh/drivers/pci/pcie-sh7786.c
@@ -466,7 +466,7 @@ static int __init pcie_init(struct sh778
 	return 0;
 }
 
-int __init pcibios_map_platform_irq(struct pci_dev *pdev, u8 slot, u8 pin)
+int __init pcibios_map_platform_irq(const struct pci_dev *pdev, u8 slot, u8 pin)
 {
         return 71;
 }
diff -puN arch/sh/include/asm/pci.h~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/sh/include/asm/pci.h
--- a/arch/sh/include/asm/pci.h~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/sh/include/asm/pci.h
@@ -112,7 +112,7 @@ static inline void pci_dma_burst_advice(
 #endif
 
 /* Board-specific fixup routines. */
-int pcibios_map_platform_irq(struct pci_dev *dev, u8 slot, u8 pin);
+int pcibios_map_platform_irq(const struct pci_dev *dev, u8 slot, u8 pin);
 
 extern void pcibios_resource_to_bus(struct pci_dev *dev,
 	struct pci_bus_region *region, struct resource *res);
diff -puN arch/sparc/include/asm/leon_pci.h~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/sparc/include/asm/leon_pci.h
--- a/arch/sparc/include/asm/leon_pci.h~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/sparc/include/asm/leon_pci.h
@@ -12,7 +12,7 @@ struct leon_pci_info {
 	struct pci_ops *ops;
 	struct resource	io_space;
 	struct resource	mem_space;
-	int (*map_irq)(struct pci_dev *dev, u8 slot, u8 pin);
+	int (*map_irq)(const struct pci_dev *dev, u8 slot, u8 pin);
 };
 
 extern void leon_pci_init(struct platform_device *ofdev,
diff -puN arch/sparc/kernel/leon_pci_grpci2.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/sparc/kernel/leon_pci_grpci2.c
--- a/arch/sparc/kernel/leon_pci_grpci2.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/sparc/kernel/leon_pci_grpci2.c
@@ -215,7 +215,7 @@ struct grpci2_priv {
 DEFINE_SPINLOCK(grpci2_dev_lock);
 struct grpci2_priv *grpci2priv;
 
-int grpci2_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+int grpci2_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	struct grpci2_priv *priv = dev->bus->sysdata;
 	int irq_group;
diff -puN arch/tile/kernel/pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/tile/kernel/pci.c
--- a/arch/tile/kernel/pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/tile/kernel/pci.c
@@ -228,7 +228,7 @@ err_cont:
  * (pin - 1) converts from the PCI standard's [1:4] convention to
  * a normal [0:3] range.
  */
-static int tile_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int tile_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	struct pci_controller *controller =
 		(struct pci_controller *)dev->sysdata;
diff -puN arch/unicore32/kernel/pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/unicore32/kernel/pci.c
--- a/arch/unicore32/kernel/pci.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/unicore32/kernel/pci.c
@@ -102,7 +102,7 @@ void pci_puv3_preinit(void)
 	writel(readl(PCIBRI_CMD) | PCIBRI_CMD_IO | PCIBRI_CMD_MEM, PCIBRI_CMD);
 }
 
-static int __init pci_puv3_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init pci_puv3_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	if (dev->bus->number == 0) {
 #ifdef CONFIG_ARCH_FPGA /* 4 pci slots */
diff -puN arch/x86/pci/visws.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const arch/x86/pci/visws.c
--- a/arch/x86/pci/visws.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/arch/x86/pci/visws.c
@@ -24,7 +24,7 @@ static void pci_visws_disable_irq(struct
 
 unsigned int pci_bus0, pci_bus1;
 
-static int __init visws_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init visws_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	int irq, bus = dev->bus->number;
 
diff -puN drivers/pci/setup-irq.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const drivers/pci/setup-irq.c
--- a/drivers/pci/setup-irq.c~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/drivers/pci/setup-irq.c
@@ -21,7 +21,7 @@
 static void __init
 pdev_fixup_irq(struct pci_dev *dev,
 	       u8 (*swizzle)(struct pci_dev *, u8 *),
-	       int (*map_irq)(struct pci_dev *, u8, u8))
+	       int (*map_irq)(const struct pci_dev *, u8, u8))
 {
 	u8 pin, slot;
 	int irq = 0;
@@ -56,7 +56,7 @@ pdev_fixup_irq(struct pci_dev *dev,
 
 void __init
 pci_fixup_irqs(u8 (*swizzle)(struct pci_dev *, u8 *),
-	       int (*map_irq)(struct pci_dev *, u8, u8))
+	       int (*map_irq)(const struct pci_dev *, u8, u8))
 {
 	struct pci_dev *dev = NULL;
 	for_each_pci_dev(dev)
diff -puN include/linux/pci.h~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const include/linux/pci.h
--- a/include/linux/pci.h~pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const
+++ a/include/linux/pci.h
@@ -879,7 +879,7 @@ void pdev_enable_device(struct pci_dev *
 void pdev_sort_resources(struct pci_dev *, struct resource_list *);
 int pci_enable_resources(struct pci_dev *, int mask);
 void pci_fixup_irqs(u8 (*)(struct pci_dev *, u8 *),
-		    int (*)(struct pci_dev *, u8, u8));
+		    int (*)(const struct pci_dev *, u8, u8));
 #define HAVE_PCI_REQ_REGIONS	2
 int __must_check pci_request_regions(struct pci_dev *, const char *);
 int __must_check pci_request_regions_exclusive(struct pci_dev *, const char *);
_

Patches currently in -mm which might be from ralf@linux-mips.org are

linux-next.patch
mips-exec-remove-redundant-addr_limit-assignment.patch
pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const.patch

