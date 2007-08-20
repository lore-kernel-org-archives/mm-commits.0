From: akpm@linux-foundation.org
Subject: + define-global-bit-macro.patch added to -mm tree
Date: Mon, 20 Aug 2007 13:42:40 -0700
Message-ID: <200708202042.l7KKgeaU022248@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45407 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753985AbXHTUpC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 16:45:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, James.Bottomley@steeleye.com, adaplas@pol.net, benh@kernel.crashing.org, dtor@mail.ru, galak@gate.crashing.org, jeff@garzik.org, linville@tuxdriver.com, paulus@samba.org, ralf@linux-mips.org, rmk@arm.linux.org.uk


The patch titled
     define global BIT macro
has been added to the -mm tree.  Its filename is
     define-global-bit-macro.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: define global BIT macro
From: Jiri Slaby <jirislaby@gmail.com>

define global BIT macro

move all local BIT defines to the new globally define macro.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ppc/platforms/chestnut.c               |    1 -
 drivers/edac/edac_core.h                    |    2 --
 drivers/firmware/dcdbas.h                   |    2 --
 drivers/input/serio/maceps2.c               |    2 --
 drivers/net/eth16i.c                        |    1 -
 drivers/net/meth.h                          |    3 ---
 drivers/net/wireless/hostap/hostap_common.h |    2 --
 drivers/scsi/FlashPoint.c                   |    1 -
 drivers/scsi/nsp32.h                        |    5 -----
 drivers/scsi/pcmcia/nsp_cs.h                |    1 -
 drivers/video/pnx4008/sdum.h                |    3 ---
 include/asm-arm/arch-ixp4xx/io.h            |    3 ---
 include/asm-mips/ip32/crime.h               |    3 ---
 include/asm-mips/ip32/mace.h                |    3 ---
 include/linux/bitops.h                      |    1 +
 include/video/sstfb.h                       |    1 -
 include/video/tdfx.h                        |    2 --
 net/mac80211/ieee80211_i.h                  |    2 --
 18 files changed, 1 insertion(+), 37 deletions(-)

diff -puN arch/ppc/platforms/chestnut.c~define-global-bit-macro arch/ppc/platforms/chestnut.c
--- a/arch/ppc/platforms/chestnut.c~define-global-bit-macro
+++ a/arch/ppc/platforms/chestnut.c
@@ -49,7 +49,6 @@ extern void gen550_progress(char *, unsi
 extern void gen550_init(int, struct uart_port *);
 extern void mv64360_pcibios_fixup(mv64x60_handle_t *bh);
 
-#define BIT(x) (1<<x)
 #define CHESTNUT_PRESERVE_MASK (BIT(MV64x60_CPU2DEV_0_WIN) | \
 				BIT(MV64x60_CPU2DEV_1_WIN) | \
 				BIT(MV64x60_CPU2DEV_2_WIN) | \
diff -puN drivers/edac/edac_core.h~define-global-bit-macro drivers/edac/edac_core.h
--- a/drivers/edac/edac_core.h~define-global-bit-macro
+++ a/drivers/edac/edac_core.h
@@ -94,8 +94,6 @@ extern int edac_debug_level;
 
 #endif				/* !CONFIG_EDAC_DEBUG */
 
-#define BIT(x) (1 << (x))
-
 #define PCI_VEND_DEV(vend, dev) PCI_VENDOR_ID_ ## vend, \
 	PCI_DEVICE_ID_ ## vend ## _ ## dev
 
diff -puN drivers/firmware/dcdbas.h~define-global-bit-macro drivers/firmware/dcdbas.h
--- a/drivers/firmware/dcdbas.h~define-global-bit-macro
+++ a/drivers/firmware/dcdbas.h
@@ -20,8 +20,6 @@
 #include <linux/sysfs.h>
 #include <linux/types.h>
 
-#define BIT(x)					(1UL << x)
-
 #define MAX_SMI_DATA_BUF_SIZE			(256 * 1024)
 
 #define HC_ACTION_NONE				(0)
diff -puN drivers/input/serio/maceps2.c~define-global-bit-macro drivers/input/serio/maceps2.c
--- a/drivers/input/serio/maceps2.c~define-global-bit-macro
+++ a/drivers/input/serio/maceps2.c
@@ -31,8 +31,6 @@ MODULE_LICENSE("GPL");
 
 #define MACE_PS2_TIMEOUT 10000 /* in 50us unit */
 
-#define BIT(x) (1UL << (x))
-
 #define PS2_STATUS_CLOCK_SIGNAL  BIT(0) /* external clock signal */
 #define PS2_STATUS_CLOCK_INHIBIT BIT(1) /* clken output signal */
 #define PS2_STATUS_TX_INPROGRESS BIT(2) /* transmission in progress */
diff -puN drivers/net/eth16i.c~define-global-bit-macro drivers/net/eth16i.c
--- a/drivers/net/eth16i.c~define-global-bit-macro
+++ a/drivers/net/eth16i.c
@@ -170,7 +170,6 @@ static char *version =
 
 
 /* Few macros */
-#define BIT(a)		       ( (1 << (a)) )
 #define BITSET(ioaddr, bnum)   ((outb(((inb(ioaddr)) | (bnum)), ioaddr)))
 #define BITCLR(ioaddr, bnum)   ((outb(((inb(ioaddr)) & (~(bnum))), ioaddr)))
 
diff -puN drivers/net/meth.h~define-global-bit-macro drivers/net/meth.h
--- a/drivers/net/meth.h~define-global-bit-macro
+++ a/drivers/net/meth.h
@@ -28,9 +28,6 @@
 #define RX_BUFFER_OFFSET (sizeof(rx_status_vector)+2) /* staus vector + 2 bytes of padding */
 #define RX_BUCKET_SIZE 256
 
-#undef BIT
-#define BIT(x)	(1UL << (x))
-
 /* For more detailed explanations of what each field menas,
    see Nick's great comments to #defines below (or docs, if
    you are lucky enough toget hold of them :)*/
diff -puN drivers/net/wireless/hostap/hostap_common.h~define-global-bit-macro drivers/net/wireless/hostap/hostap_common.h
--- a/drivers/net/wireless/hostap/hostap_common.h~define-global-bit-macro
+++ a/drivers/net/wireless/hostap/hostap_common.h
@@ -4,8 +4,6 @@
 #include <linux/types.h>
 #include <linux/if_ether.h>
 
-#define BIT(x) (1 << (x))
-
 #define MAC2STR(a) (a)[0], (a)[1], (a)[2], (a)[3], (a)[4], (a)[5]
 #define MACSTR "%02x:%02x:%02x:%02x:%02x:%02x"
 
diff -puN drivers/scsi/FlashPoint.c~define-global-bit-macro drivers/scsi/FlashPoint.c
--- a/drivers/scsi/FlashPoint.c~define-global-bit-macro
+++ a/drivers/scsi/FlashPoint.c
@@ -25,7 +25,6 @@
 
 #define FAILURE         0xFFFFFFFFL
 
-#define BIT(x)          ((unsigned char)(1<<(x)))	/* single-bit mask in bit position x */
 #define BITW(x)          ((unsigned short)(1<<(x)))	/* single-bit mask in bit position x */
 
 struct sccb;
diff -puN drivers/scsi/nsp32.h~define-global-bit-macro drivers/scsi/nsp32.h
--- a/drivers/scsi/nsp32.h~define-global-bit-macro
+++ a/drivers/scsi/nsp32.h
@@ -69,11 +69,6 @@ typedef u32 u32_le;
 typedef u16 u16_le;
 
 /*
- * MACRO
- */
-#define BIT(x)      (1UL << (x))
-
-/*
  * BASIC Definitions
  */
 #ifndef TRUE
diff -puN drivers/scsi/pcmcia/nsp_cs.h~define-global-bit-macro drivers/scsi/pcmcia/nsp_cs.h
--- a/drivers/scsi/pcmcia/nsp_cs.h~define-global-bit-macro
+++ a/drivers/scsi/pcmcia/nsp_cs.h
@@ -24,7 +24,6 @@
 /************************************
  * Some useful macros...
  */
-#define BIT(x)      (1L << (x))
 
 /* SCSI initiator must be ID 7 */
 #define NSP_INITIATOR_ID  7
diff -puN drivers/video/pnx4008/sdum.h~define-global-bit-macro drivers/video/pnx4008/sdum.h
--- a/drivers/video/pnx4008/sdum.h~define-global-bit-macro
+++ a/drivers/video/pnx4008/sdum.h
@@ -77,9 +77,6 @@
 #define CONF_DIRTYDETECTION_OFF	(0x600)
 #define CONF_DIRTYDETECTION_ON	(0x601)
 
-/* Set the corresponding bit. */
-#define BIT(n) (0x1U << (n))
-
 struct dumchannel_uf {
 	int channelnr;
 	u32 *dirty;
diff -puN include/asm-arm/arch-ixp4xx/io.h~define-global-bit-macro include/asm-arm/arch-ixp4xx/io.h
--- a/include/asm-arm/arch-ixp4xx/io.h~define-global-bit-macro
+++ a/include/asm-arm/arch-ixp4xx/io.h
@@ -17,9 +17,6 @@
 
 #define IO_SPACE_LIMIT 0xffff0000
 
-#define	BIT(x)	((1)<<(x))
-
-
 extern int (*ixp4xx_pci_read)(u32 addr, u32 cmd, u32* data);
 extern int ixp4xx_pci_write(u32 addr, u32 cmd, u32 data);
 
diff -puN include/asm-mips/ip32/crime.h~define-global-bit-macro include/asm-mips/ip32/crime.h
--- a/include/asm-mips/ip32/crime.h~define-global-bit-macro
+++ a/include/asm-mips/ip32/crime.h
@@ -17,9 +17,6 @@
  */
 #define CRIME_BASE	0x14000000	/* physical */
 
-#undef BIT
-#define BIT(x)	(1UL << (x))
-
 struct sgi_crime {
 	volatile unsigned long id;
 #define CRIME_ID_MASK			0xff
diff -puN include/asm-mips/ip32/mace.h~define-global-bit-macro include/asm-mips/ip32/mace.h
--- a/include/asm-mips/ip32/mace.h~define-global-bit-macro
+++ a/include/asm-mips/ip32/mace.h
@@ -17,9 +17,6 @@
  */
 #define MACE_BASE	0x1f000000	/* physical */
 
-#undef BIT
-#define BIT(x) (1UL << (x))
-
 /*
  * PCI interface
  */
diff -puN include/linux/bitops.h~define-global-bit-macro include/linux/bitops.h
--- a/include/linux/bitops.h~define-global-bit-macro
+++ a/include/linux/bitops.h
@@ -3,6 +3,7 @@
 #include <asm/types.h>
 
 #ifdef	__KERNEL__
+#define BIT(nr)			(1UL << (nr))
 #define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
 #define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
 #define BITS_TO_TYPE(nr, t)	(((nr)+(t)-1)/(t))
diff -puN include/video/sstfb.h~define-global-bit-macro include/video/sstfb.h
--- a/include/video/sstfb.h~define-global-bit-macro
+++ a/include/video/sstfb.h
@@ -68,7 +68,6 @@
 #  define print_var(X,Y...)
 #endif
 
-#define BIT(x)		(1ul<<(x))
 #define POW2(x)		(1ul<<(x))
 
 /*
diff -puN include/video/tdfx.h~define-global-bit-macro include/video/tdfx.h
--- a/include/video/tdfx.h~define-global-bit-macro
+++ a/include/video/tdfx.h
@@ -79,8 +79,6 @@
 
 /* register bitfields (not all, only as needed) */
 
-#define BIT(x)	(1UL << (x))
-
 /* COMMAND_2D reg. values */
 #define TDFX_ROP_COPY		0xcc	/* src */
 #define TDFX_ROP_INVERT		0x55	/* NOT dst */
diff -puN net/mac80211/ieee80211_i.h~define-global-bit-macro net/mac80211/ieee80211_i.h
--- a/net/mac80211/ieee80211_i.h~define-global-bit-macro
+++ a/net/mac80211/ieee80211_i.h
@@ -37,8 +37,6 @@
 
 struct ieee80211_local;
 
-#define BIT(x) (1 << (x))
-
 #define IEEE80211_ALIGN32_PAD(a) ((4 - ((a) & 3)) & 3)
 
 /* Maximum number of broadcast/multicast frames to buffer when some of the
_

Patches currently in -mm which might be from jirislaby@gmail.com are

net-add-ath5k-wireless-driver.patch
net-add-ath5k-wireless-driver-fix.patch
epcac-reformat-comments-and-coding-style-improvements.patch
char-mxser_new-upgrade-to-110.patch
char-mxser_new-move-to-pci_vdevice.patch
char-mxser_new-remove-useless-comments-in-mxser_cards.patch
char-moxa-fix-and-optimise-empty-timer.patch
char-cyclades-remove-bottom-half-processing.patch
char-cyclades-make-the-isr-code-readable.patch
char-cyclades-move-spin_lock-to-one-place.patch
char-cyclades-fix-some-w-warnings.patch
fs-select-remove-unused-macros.patch
cyber2000fb-rename-bit-macro.patch
i2c-pxa-rename-bit-macro-to-pxa_bit.patch
s2io-rename-bit-macro.patch
amba-pl011-rename-bit-macro.patch
define-first-set-of-bit-macros.patch
get-rid-of-input-bit-duplicate-defines.patch
define-global-bit-macro.patch
flashpoint-use-bit-instead-of-bitw.patch
shrink_slab-handle-bad-shrinkers.patch
