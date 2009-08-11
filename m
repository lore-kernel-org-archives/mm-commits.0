From: akpm@linux-foundation.org
Subject: + input-add-a-driver-for-the-winbond-wpcd376i-consumer-ir-hardware.patch added to -mm tree
Date: Tue, 11 Aug 2009 14:07:43 -0700
Message-ID: <200908112107.n7BL7iqp012652@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50519 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753680AbZHKVIW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Aug 2009 17:08:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@hardeman.nu, bjorn.helgaas@hp.com, dtor@mail.ru, jbarnes@virtuousgeek.org


The patch titled
     input: add a driver for the Winbond WPCD376I Consumer IR hardware
has been added to the -mm tree.  Its filename is
     input-add-a-driver-for-the-winbond-wpcd376i-consumer-ir-hardware.p=
atch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: input: add a driver for the Winbond WPCD376I Consumer IR hardw=
are
=46rom: David H=E4rdeman <david@hardeman.nu>

Add a driver for the the Consumer IR (CIR) functionality of the Winbond
WPCD376I chipset (found on e.g. Intel DG45FC motherboards).

Changes since the last version: converted from an ACPI to a PNP driver
using a patch provided by Bjorn Helgaas <bjorn.helgaas@hp.com>.

Signed-off-by: David H=E4rdeman <david@hardeman.nu>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                      |    6=20
 drivers/input/misc/Kconfig       |   16=20
 drivers/input/misc/Makefile      |    1=20
 drivers/input/misc/winbond-cir.c | 1644 +++++++++++++++++++++++++++++
 4 files changed, 1667 insertions(+)

diff -puN MAINTAINERS~input-add-a-driver-for-the-winbond-wpcd376i-consu=
mer-ir-hardware MAINTAINERS
--- a/MAINTAINERS~input-add-a-driver-for-the-winbond-wpcd376i-consumer-=
ir-hardware
+++ a/MAINTAINERS
@@ -5622,6 +5622,12 @@ L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/wd7000.c
=20
+WINBOND CIR DRIVER
+P:	David H=C3=A4rdeman
+M:	david@hardeman.nu
+S:	Maintained
+F:	drivers/input/misc/winbond-cir.c
+
 WIMAX STACK
 M:	Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
 M:	linux-wimax@intel.com
diff -puN drivers/input/misc/Kconfig~input-add-a-driver-for-the-winbond=
-wpcd376i-consumer-ir-hardware drivers/input/misc/Kconfig
--- a/drivers/input/misc/Kconfig~input-add-a-driver-for-the-winbond-wpc=
d376i-consumer-ir-hardware
+++ a/drivers/input/misc/Kconfig
@@ -222,6 +222,22 @@ config INPUT_SGI_BTNS
 	  To compile this driver as a module, choose M here: the
 	  module will be called sgi_btns.
=20
+config INPUT_WINBOND_CIR
+	tristate "Winbond IR remote control"
+	depends on X86 && PNP
+	select LEDS_CLASS
+	select BITREVERSE
+	help
+	  Say Y here if you want to use the IR remote functionality found
+	  in some Winbond SuperI/O chips. Currently only the WPCD376I
+	  chip is supported (included in some Intel Media series motherboards=
).
+
+	  IR Receive and wake-on-IR from suspend and power-off is currently
+	  supported.
+
+	  To compile this driver as a module, choose M here: the module will =
be
+	  called winbond_cir.
+
 config HP_SDC_RTC
 	tristate "HP SDC Real Time Clock"
 	depends on (GSC || HP300) && SERIO
diff -puN drivers/input/misc/Makefile~input-add-a-driver-for-the-winbon=
d-wpcd376i-consumer-ir-hardware drivers/input/misc/Makefile
--- a/drivers/input/misc/Makefile~input-add-a-driver-for-the-winbond-wp=
cd376i-consumer-ir-hardware
+++ a/drivers/input/misc/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_INPUT_PCF50633_PMU)	+=3D pcf5
 obj-$(CONFIG_INPUT_PCSPKR)		+=3D pcspkr.o
 obj-$(CONFIG_INPUT_POWERMATE)		+=3D powermate.o
 obj-$(CONFIG_INPUT_RB532_BUTTON)	+=3D rb532_button.o
+obj-$(CONFIG_INPUT_WINBOND_CIR)		+=3D winbond-cir.o
 obj-$(CONFIG_INPUT_GPIO_ROTARY_ENCODER)	+=3D rotary_encoder.o
 obj-$(CONFIG_INPUT_SGI_BTNS)		+=3D sgi_btns.o
 obj-$(CONFIG_INPUT_SPARCSPKR)		+=3D sparcspkr.o
diff -puN /dev/null drivers/input/misc/winbond-cir.c
--- /dev/null
+++ a/drivers/input/misc/winbond-cir.c
@@ -0,0 +1,1644 @@
+/*
+ *  winbond-cir.c - Driver for the Consumer IR functionality of Winbon=
d
+ *                  SuperI/O chips.
+ *
+ *  Currently supports the Winbond WPCD376i chip (PNP id WEC1022), but
+ *  could probably support others (Winbond WEC102X, NatSemi, etc)
+ *  with minor modifications.
+ *
+ *  Original Author: David H=C3=A4rdeman <david@hardeman.nu>
+ *     Copyright (C) 2009 David H=C3=A4rdeman <david@hardeman.nu>
+ *
+ *  Dedicated to Matilda, my newborn daughter, without whose loving at=
tention
+ *  this driver would have been finished in half the time and with a f=
raction
+ *  of the bugs.
+ *
+ *  Written using:
+ *    o Winbond WPCD376I datasheet helpfully provided by Jesse Barnes =
at Intel
+ *    o NatSemi PC87338/PC97338 datasheet (for the serial port stuff)
+ *    o DSDT dumps
+ *
+ *  Supported features:
+ *    o RC6
+ *    o Wake-On-CIR functionality
+ *
+ *  To do:
+ *    o Test NEC and RC5
+ *
+ *  Left as an exercise for the reader:
+ *    o Learning (I have neither the hardware, nor the need)
+ *    o IR Transmit (ibid)
+ *
+ *  This program is free software; you can redistribute it and/or modi=
fy
+ *  it under the terms of the GNU General Public License as published =
by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/pnp.h>
+#include <linux/interrupt.h>
+#include <linux/timer.h>
+#include <linux/input.h>
+#include <linux/leds.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/pci_ids.h>
+#include <linux/io.h>
+#include <linux/bitrev.h>
+#include <linux/bitops.h>
+
+#define DRVNAME "winbond-cir"
+
+/* CEIR Wake-Up Registers, relative to data->wbase                    =
  */
+#define WBCIR_REG_WCEIR_CTL	0x03 /* CEIR Receiver Control		*/
+#define WBCIR_REG_WCEIR_STS	0x04 /* CEIR Receiver Status		*/
+#define WBCIR_REG_WCEIR_EV_EN	0x05 /* CEIR Receiver Event Enable	*/
+#define WBCIR_REG_WCEIR_CNTL	0x06 /* CEIR Receiver Counter Low	*/
+#define WBCIR_REG_WCEIR_CNTH	0x07 /* CEIR Receiver Counter High	*/
+#define WBCIR_REG_WCEIR_INDEX	0x08 /* CEIR Receiver Index		*/
+#define WBCIR_REG_WCEIR_DATA	0x09 /* CEIR Receiver Data		*/
+#define WBCIR_REG_WCEIR_CSL	0x0A /* CEIR Re. Compare Strlen		*/
+#define WBCIR_REG_WCEIR_CFG1	0x0B /* CEIR Re. Configuration 1	*/
+#define WBCIR_REG_WCEIR_CFG2	0x0C /* CEIR Re. Configuration 2	*/
+
+/* CEIR Enhanced Functionality Registers, relative to data->ebase     =
  */
+#define WBCIR_REG_ECEIR_CTS	0x00 /* Enhanced IR Control Status	*/
+#define WBCIR_REG_ECEIR_CCTL	0x01 /* Infrared Counter Control	*/
+#define WBCIR_REG_ECEIR_CNT_LO	0x02 /* Infrared Counter LSB		*/
+#define WBCIR_REG_ECEIR_CNT_HI	0x03 /* Infrared Counter MSB		*/
+#define WBCIR_REG_ECEIR_IREM	0x04 /* Infrared Emitter Status		*/
+
+/* SP3 Banked Registers, relative to data->sbase                      =
  */
+#define WBCIR_REG_SP3_BSR	0x03 /* Bank Select, all banks		*/
+				      /* Bank 0				*/
+#define WBCIR_REG_SP3_RXDATA	0x00 /* FIFO RX data (r)		*/
+#define WBCIR_REG_SP3_TXDATA	0x00 /* FIFO TX data (w)		*/
+#define WBCIR_REG_SP3_IER	0x01 /* Interrupt Enable		*/
+#define WBCIR_REG_SP3_EIR	0x02 /* Event Identification (r)	*/
+#define WBCIR_REG_SP3_FCR	0x02 /* FIFO Control (w)		*/
+#define WBCIR_REG_SP3_MCR	0x04 /* Mode Control			*/
+#define WBCIR_REG_SP3_LSR	0x05 /* Link Status			*/
+#define WBCIR_REG_SP3_MSR	0x06 /* Modem Status			*/
+#define WBCIR_REG_SP3_ASCR	0x07 /* Aux Status and Control		*/
+				      /* Bank 2				*/
+#define WBCIR_REG_SP3_BGDL	0x00 /* Baud Divisor LSB		*/
+#define WBCIR_REG_SP3_BGDH	0x01 /* Baud Divisor MSB		*/
+#define WBCIR_REG_SP3_EXCR1	0x02 /* Extended Control 1		*/
+#define WBCIR_REG_SP3_EXCR2	0x04 /* Extended Control 2		*/
+#define WBCIR_REG_SP3_TXFLV	0x06 /* TX FIFO Level			*/
+#define WBCIR_REG_SP3_RXFLV	0x07 /* RX FIFO Level			*/
+				      /* Bank 3				*/
+#define WBCIR_REG_SP3_MRID	0x00 /* Module Identification		*/
+#define WBCIR_REG_SP3_SH_LCR	0x01 /* LCR Shadow			*/
+#define WBCIR_REG_SP3_SH_FCR	0x02 /* FCR Shadow			*/
+				      /* Bank 4				*/
+#define WBCIR_REG_SP3_IRCR1	0x02 /* Infrared Control 1		*/
+				      /* Bank 5				*/
+#define WBCIR_REG_SP3_IRCR2	0x04 /* Infrared Control 2		*/
+				      /* Bank 6				*/
+#define WBCIR_REG_SP3_IRCR3	0x00 /* Infrared Control 3		*/
+#define WBCIR_REG_SP3_SIR_PW	0x02 /* SIR Pulse Width		*/
+				      /* Bank 7				*/
+#define WBCIR_REG_SP3_IRRXDC	0x00 /* IR RX Demod Control		*/
+#define WBCIR_REG_SP3_IRTXMC	0x01 /* IR TX Mod Control		*/
+#define WBCIR_REG_SP3_RCCFG	0x02 /* CEIR Config			*/
+#define WBCIR_REG_SP3_IRCFG1	0x04 /* Infrared Config 1		*/
+#define WBCIR_REG_SP3_IRCFG4	0x07 /* Infrared Config 4		*/
+
+/*
+ * Magic values follow
+ */
+
+/* No interrupts for WBCIR_REG_SP3_IER and WBCIR_REG_SP3_EIR */
+#define WBCIR_IRQ_NONE		0x00
+/* RX data bit for WBCIR_REG_SP3_IER and WBCIR_REG_SP3_EIR */
+#define WBCIR_IRQ_RX		0x01
+/* Over/Under-flow bit for WBCIR_REG_SP3_IER and WBCIR_REG_SP3_EIR */
+#define WBCIR_IRQ_ERR		0x04
+/* Led enable/disable bit for WBCIR_REG_ECEIR_CTS */
+#define WBCIR_LED_ENABLE	0x80
+/* RX data available bit for WBCIR_REG_SP3_LSR */
+#define WBCIR_RX_AVAIL		0x01
+/* RX disable bit for WBCIR_REG_SP3_ASCR */
+#define WBCIR_RX_DISABLE	0x20
+/* Extended mode enable bit for WBCIR_REG_SP3_EXCR1 */
+#define WBCIR_EXT_ENABLE	0x01
+/* Select compare register in WBCIR_REG_WCEIR_INDEX (bits 5 & 6) */
+#define WBCIR_REGSEL_COMPARE	0x10
+/* Select mask register in WBCIR_REG_WCEIR_INDEX (bits 5 & 6) */
+#define WBCIR_REGSEL_MASK	0x20
+/* Starting address of selected register in WBCIR_REG_WCEIR_INDEX */
+#define WBCIR_REG_ADDR0		0x00
+
+/* Valid banks for the SP3 UART */
+enum wbcir_bank {
+	WBCIR_BANK_0          =3D 0x00,
+	WBCIR_BANK_1          =3D 0x80,
+	WBCIR_BANK_2          =3D 0xE0,
+	WBCIR_BANK_3          =3D 0xE4,
+	WBCIR_BANK_4          =3D 0xE8,
+	WBCIR_BANK_5          =3D 0xEC,
+	WBCIR_BANK_6          =3D 0xF0,
+	WBCIR_BANK_7          =3D 0xF4,
+};
+
+/* Supported IR Protocols */
+enum wbcir_protocol {
+	IR_PROTOCOL_RC5          =3D 0x0,
+	IR_PROTOCOL_NEC          =3D 0x1,
+	IR_PROTOCOL_RC6          =3D 0x2,
+};
+
+/* Misc */
+#define WBCIR_NAME	"Winbond CIR"
+#define WBCIR_ID_FAMILY          0xF1 /* Family ID for the WPCD376I	*/
+#define	WBCIR_ID_CHIP            0x04 /* Chip ID for the WPCD376I	*/
+#define IR_KEYPRESS_TIMEOUT       250 /* FIXME: should be per-protocol=
? */
+#define INVALID_SCANCODE   0x7FFFFFFF /* Invalid with all protos	*/
+#define WAKEUP_IOMEM_LEN         0x10 /* Wake-Up I/O Reg Len		*/
+#define EHFUNC_IOMEM_LEN         0x10 /* Enhanced Func I/O Reg Len	*/
+#define SP_IOMEM_LEN             0x08 /* Serial Port 3 (IR) Reg Len	*/
+#define WBCIR_MAX_IDLE_BYTES       10
+
+static DEFINE_SPINLOCK(wbcir_lock);
+static DEFINE_RWLOCK(keytable_lock);
+
+struct wbcir_key {
+	u32 scancode;
+	unsigned int keycode;
+};
+
+struct wbcir_keyentry {
+	struct wbcir_key key;
+	struct list_head list;
+};
+
+static struct wbcir_key rc6_def_keymap[] =3D {
+	{ 0x800F0400, KEY_0			},
+	{ 0x800F0401, KEY_1			},
+	{ 0x800F0402, KEY_2			},
+	{ 0x800F0403, KEY_3			},
+	{ 0x800F0404, KEY_4			},
+	{ 0x800F0405, KEY_5			},
+	{ 0x800F0406, KEY_6			},
+	{ 0x800F0407, KEY_7			},
+	{ 0x800F0408, KEY_8			},
+	{ 0x800F0409, KEY_9			},
+	{ 0x800F041D, KEY_NUMERIC_STAR		},
+	{ 0x800F041C, KEY_NUMERIC_POUND		},
+	{ 0x800F0410, KEY_VOLUMEUP		},
+	{ 0x800F0411, KEY_VOLUMEDOWN		},
+	{ 0x800F0412, KEY_CHANNELUP		},
+	{ 0x800F0413, KEY_CHANNELDOWN		},
+	{ 0x800F040E, KEY_MUTE			},
+	{ 0x800F040D, KEY_VENDOR		}, /* Vista Logo Key */
+	{ 0x800F041E, KEY_UP			},
+	{ 0x800F041F, KEY_DOWN			},
+	{ 0x800F0420, KEY_LEFT			},
+	{ 0x800F0421, KEY_RIGHT			},
+	{ 0x800F0422, KEY_OK			},
+	{ 0x800F0423, KEY_ESC			},
+	{ 0x800F040F, KEY_INFO			},
+	{ 0x800F040A, KEY_CLEAR			},
+	{ 0x800F040B, KEY_ENTER			},
+	{ 0x800F045B, KEY_RED			},
+	{ 0x800F045C, KEY_GREEN			},
+	{ 0x800F045D, KEY_YELLOW		},
+	{ 0x800F045E, KEY_BLUE			},
+	{ 0x800F045A, KEY_TEXT			},
+	{ 0x800F0427, KEY_SWITCHVIDEOMODE	},
+	{ 0x800F040C, KEY_POWER			},
+	{ 0x800F0450, KEY_RADIO			},
+	{ 0x800F0448, KEY_PVR			},
+	{ 0x800F0447, KEY_AUDIO			},
+	{ 0x800F0426, KEY_EPG			},
+	{ 0x800F0449, KEY_CAMERA		},
+	{ 0x800F0425, KEY_TV			},
+	{ 0x800F044A, KEY_VIDEO			},
+	{ 0x800F0424, KEY_DVD			},
+	{ 0x800F0416, KEY_PLAY			},
+	{ 0x800F0418, KEY_PAUSE			},
+	{ 0x800F0419, KEY_STOP			},
+	{ 0x800F0414, KEY_FASTFORWARD		},
+	{ 0x800F041A, KEY_NEXT			},
+	{ 0x800F041B, KEY_PREVIOUS		},
+	{ 0x800F0415, KEY_REWIND		},
+	{ 0x800F0417, KEY_RECORD		},
+};
+
+/* Registers and other state is protected by wbcir_lock */
+struct wbcir_data {
+	unsigned long wbase;        /* Wake-Up Baseaddr		*/
+	unsigned long ebase;        /* Enhanced Func. Baseaddr	*/
+	unsigned long sbase;        /* Serial Port Baseaddr	*/
+	unsigned int  irq;          /* Serial Port IRQ		*/
+
+	struct input_dev *input_dev;
+	struct timer_list timer_keyup;
+	struct led_trigger *rxtrigger;
+	struct led_trigger *txtrigger;
+	struct led_classdev led;
+
+	u32 last_scancode;
+	unsigned int last_keycode;
+	u8 last_toggle;
+	u8 keypressed;
+	unsigned long keyup_jiffies;
+	unsigned int idle_count;
+
+	/* RX irdata and parsing state */
+	unsigned long irdata[30];
+	unsigned int irdata_count;
+	unsigned int irdata_idle;
+	unsigned int irdata_off;
+	unsigned int irdata_error;
+
+	/* Protected by keytable_lock */
+	struct list_head keytable;
+};
+
+static enum wbcir_protocol protocol =3D IR_PROTOCOL_RC6;
+module_param(protocol, uint, 0444);
+MODULE_PARM_DESC(protocol, "IR protocol to use "
+		 "(0 =3D RC5, 1 =3D NEC, 2 =3D RC6A, default)");
+
+static int invert; /* default =3D 0 */
+module_param(invert, bool, 0444);
+MODULE_PARM_DESC(invert, "Invert the signal from the IR receiver");
+
+static unsigned int wake_sc =3D 0x800F040C;
+module_param(wake_sc, uint, 0644);
+MODULE_PARM_DESC(wake_sc, "Scancode of the power-on IR command");
+
+static unsigned int wake_rc6mode =3D 6;
+module_param(wake_rc6mode, uint, 0644);
+MODULE_PARM_DESC(wake_rc6mode, "RC6 mode for the power-on command "
+		 "(0 =3D 0, 6 =3D 6A, default)");
+
+
+
+/*********************************************************************=
********
+ *
+ * UTILITY FUNCTIONS
+ *
+ *********************************************************************=
********/
+
+/* Caller needs to hold wbcir_lock */
+static void
+wbcir_set_bits(unsigned long addr, u8 bits, u8 mask)
+{
+	u8 val;
+
+	val =3D inb(addr);
+	val =3D ((val & ~mask) | (bits & mask));
+	outb(val, addr);
+}
+
+/* Selects the register bank for the serial port */
+static inline void
+wbcir_select_bank(struct wbcir_data *data, enum wbcir_bank bank)
+{
+	outb(bank, data->sbase + WBCIR_REG_SP3_BSR);
+}
+
+static enum led_brightness
+wbcir_led_brightness_get(struct led_classdev *led_cdev)
+{
+	struct wbcir_data *data =3D container_of(led_cdev,
+					       struct wbcir_data,
+					       led);
+
+	if (inb(data->ebase + WBCIR_REG_ECEIR_CTS) & WBCIR_LED_ENABLE)
+		return LED_FULL;
+	else
+		return LED_OFF;
+}
+
+static void
+wbcir_led_brightness_set(struct led_classdev *led_cdev,
+			    enum led_brightness brightness)
+{
+	struct wbcir_data *data =3D container_of(led_cdev,
+					       struct wbcir_data,
+					       led);
+
+	wbcir_set_bits(data->ebase + WBCIR_REG_ECEIR_CTS,
+		       brightness =3D=3D LED_OFF ? 0x00 : WBCIR_LED_ENABLE,
+		       WBCIR_LED_ENABLE);
+}
+
+/* Manchester encodes bits to RC6 message cells (see wbcir_parse_rc6) =
*/
+static u8
+wbcir_to_rc6cells(u8 val)
+{
+	u8 coded =3D 0x00;
+	int i;
+
+	val &=3D 0x0F;
+	for (i =3D 0; i < 4; i++) {
+		if (val & 0x01)
+			coded |=3D 0x02 << (i * 2);
+		else
+			coded |=3D 0x01 << (i * 2);
+		val >>=3D 1;
+	}
+
+	return coded;
+}
+
+
+
+/*********************************************************************=
********
+ *
+ * INPUT FUNCTIONS
+ *
+ *********************************************************************=
********/
+
+static unsigned int
+wbcir_do_getkeycode(struct wbcir_data *data, u32 scancode)
+{
+	struct wbcir_keyentry *keyentry;
+	unsigned int keycode =3D KEY_RESERVED;
+	unsigned long flags;
+
+	read_lock_irqsave(&keytable_lock, flags);
+
+	list_for_each_entry(keyentry, &data->keytable, list) {
+		if (keyentry->key.scancode =3D=3D scancode) {
+			keycode =3D keyentry->key.keycode;
+			break;
+		}
+	}
+
+	read_unlock_irqrestore(&keytable_lock, flags);
+	return keycode;
+}
+
+static int
+wbcir_getkeycode(struct input_dev *dev, int scancode, int *keycode)
+{
+	struct wbcir_data *data =3D input_get_drvdata(dev);
+
+	*keycode =3D (int)wbcir_do_getkeycode(data, (u32)scancode);
+	return 0;
+}
+
+static int
+wbcir_setkeycode(struct input_dev *dev, int sscancode, int keycode)
+{
+	struct wbcir_data *data =3D input_get_drvdata(dev);
+	struct wbcir_keyentry *keyentry;
+	struct wbcir_keyentry *new_keyentry;
+	unsigned long flags;
+	unsigned int old_keycode =3D KEY_RESERVED;
+	u32 scancode =3D (u32)sscancode;
+
+	if (keycode < 0 || keycode > KEY_MAX)
+		return -EINVAL;
+
+	new_keyentry =3D kmalloc(sizeof(*new_keyentry), GFP_KERNEL);
+	if (!new_keyentry)
+		return -ENOMEM;
+
+	write_lock_irqsave(&keytable_lock, flags);
+
+	list_for_each_entry(keyentry, &data->keytable, list) {
+		if (keyentry->key.scancode !=3D scancode)
+			continue;
+
+		old_keycode =3D keyentry->key.keycode;
+		keyentry->key.keycode =3D keycode;
+
+		if (keyentry->key.keycode =3D=3D KEY_RESERVED) {
+			list_del(&keyentry->list);
+			kfree(keyentry);
+		}
+
+		break;
+	}
+
+	set_bit(keycode, dev->keybit);
+
+	if (old_keycode =3D=3D KEY_RESERVED) {
+		new_keyentry->key.scancode =3D scancode;
+		new_keyentry->key.keycode =3D keycode;
+		list_add(&new_keyentry->list, &data->keytable);
+	} else {
+		kfree(new_keyentry);
+		clear_bit(old_keycode, dev->keybit);
+		list_for_each_entry(keyentry, &data->keytable, list) {
+			if (keyentry->key.keycode =3D=3D old_keycode) {
+				set_bit(old_keycode, dev->keybit);
+				break;
+			}
+		}
+	}
+
+	write_unlock_irqrestore(&keytable_lock, flags);
+	return 0;
+}
+
+/*
+ * Timer function to report keyup event some time after keydown is
+ * reported by the ISR.
+ */
+static void
+wbcir_keyup(unsigned long cookie)
+{
+	struct wbcir_data *data =3D (struct wbcir_data *)cookie;
+	unsigned long flags;
+
+	/*
+	 * data->keyup_jiffies is used to prevent a race condition if a
+	 * hardware interrupt occurs at this point and the keyup timer
+	 * event is moved further into the future as a result.
+	 *
+	 * The timer will then be reactivated and this function called
+	 * again in the future. We need to exit gracefully in that case
+	 * to allow the input subsystem to do its auto-repeat magic or
+	 * a keyup event might follow immediately after the keydown.
+	 */
+
+	spin_lock_irqsave(&wbcir_lock, flags);
+
+	if (time_is_after_eq_jiffies(data->keyup_jiffies) && data->keypressed=
) {
+		data->keypressed =3D 0;
+		led_trigger_event(data->rxtrigger, LED_OFF);
+		input_report_key(data->input_dev, data->last_keycode, 0);
+		input_sync(data->input_dev);
+	}
+
+	spin_unlock_irqrestore(&wbcir_lock, flags);
+}
+
+static void
+wbcir_keydown(struct wbcir_data *data, u32 scancode, u8 toggle)
+{
+	unsigned int keycode;
+
+	/* Repeat? */
+	if (data->last_scancode =3D=3D scancode &&
+	    data->last_toggle =3D=3D toggle &&
+	    data->keypressed)
+		goto set_timer;
+	data->last_scancode =3D scancode;
+
+	/* Do we need to release an old keypress? */
+	if (data->keypressed) {
+		input_report_key(data->input_dev, data->last_keycode, 0);
+		input_sync(data->input_dev);
+		data->keypressed =3D 0;
+	}
+
+	/* Do we know this scancode? */
+	keycode =3D wbcir_do_getkeycode(data, scancode);
+	if (keycode =3D=3D KEY_RESERVED)
+		goto set_timer;
+
+	/* Register a keypress */
+	input_report_key(data->input_dev, keycode, 1);
+	input_sync(data->input_dev);
+	data->keypressed =3D 1;
+	data->last_keycode =3D keycode;
+	data->last_toggle =3D toggle;
+
+set_timer:
+	led_trigger_event(data->rxtrigger,
+			  data->keypressed ? LED_FULL : LED_OFF);
+	data->keyup_jiffies =3D jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOU=
T);
+	mod_timer(&data->timer_keyup, data->keyup_jiffies);
+}
+
+
+
+/*********************************************************************=
********
+ *
+ * IR PARSING FUNCTIONS
+ *
+ *********************************************************************=
********/
+
+/* Resets all irdata */
+static void
+wbcir_reset_irdata(struct wbcir_data *data)
+{
+	memset(data->irdata, 0, sizeof(data->irdata));
+	data->irdata_count =3D 0;
+	data->irdata_off =3D 0;
+	data->irdata_error =3D 0;
+}
+
+/* Adds one bit of irdata */
+static void
+add_irdata_bit(struct wbcir_data *data, int set)
+{
+	if (data->irdata_count >=3D sizeof(data->irdata) * 8) {
+		data->irdata_error =3D 1;
+		return;
+	}
+
+	if (set)
+		__set_bit(data->irdata_count, data->irdata);
+	data->irdata_count++;
+}
+
+/* Gets count bits of irdata */
+static u16
+get_bits(struct wbcir_data *data, int count)
+{
+	u16 val =3D 0x0;
+
+	if (data->irdata_count - data->irdata_off < count) {
+		data->irdata_error =3D 1;
+		return 0x0;
+	}
+
+	while (count > 0) {
+		val <<=3D 1;
+		if (test_bit(data->irdata_off, data->irdata))
+			val |=3D 0x1;
+		count--;
+		data->irdata_off++;
+	}
+
+	return val;
+}
+
+/* Reads 16 cells and converts them to a byte */
+static u8
+wbcir_rc6cells_to_byte(struct wbcir_data *data)
+{
+	u16 raw =3D get_bits(data, 16);
+	u8 val =3D 0x00;
+	int bit;
+
+	for (bit =3D 0; bit < 8; bit++) {
+		switch (raw & 0x03) {
+		case 0x01:
+			break;
+		case 0x02:
+			val |=3D (0x01 << bit);
+			break;
+		default:
+			data->irdata_error =3D 1;
+			break;
+		}
+		raw >>=3D 2;
+	}
+
+	return val;
+}
+
+/* Decodes a number of bits from raw RC5 data */
+static u8
+wbcir_get_rc5bits(struct wbcir_data *data, unsigned int count)
+{
+	u16 raw =3D get_bits(data, count * 2);
+	u8 val =3D 0x00;
+	int bit;
+
+	for (bit =3D 0; bit < count; bit++) {
+		switch (raw & 0x03) {
+		case 0x01:
+			val |=3D (0x01 << bit);
+			break;
+		case 0x02:
+			break;
+		default:
+			data->irdata_error =3D 1;
+			break;
+		}
+		raw >>=3D 2;
+	}
+
+	return val;
+}
+
+static void
+wbcir_parse_rc6(struct device *dev, struct wbcir_data *data)
+{
+	/*
+	 * Normal bits are manchester coded as follows:
+	 * cell0 + cell1 =3D logic "0"
+	 * cell1 + cell0 =3D logic "1"
+	 *
+	 * The IR pulse has the following components:
+	 *
+	 * Leader		- 6 * cell1 - discarded
+	 * Gap    		- 2 * cell0 - discarded
+	 * Start bit		- Normal Coding - always "1"
+	 * Mode Bit 2 - 0	- Normal Coding
+	 * Toggle bit		- Normal Coding with double bit time,
+	 *			  e.g. cell0 + cell0 + cell1 + cell1
+	 *			  means logic "0".
+	 *
+	 * The rest depends on the mode, the following modes are known:
+	 *
+	 * MODE 0:
+	 *  Address Bit 7 - 0	- Normal Coding
+	 *  Command Bit 7 - 0	- Normal Coding
+	 *
+	 * MODE 6:
+	 *  The above Toggle Bit is used as a submode bit, 0 =3D A, 1 =3D B.
+	 *  Submode B is for pointing devices, only remotes using submode A
+	 *  are supported.
+	 *
+	 *  Customer range bit	- 0 =3D> Customer =3D 7 bits, 0...127
+	 *                        1 =3D> Customer =3D 15 bits, 32768...65535
+	 *  Customer Bits	- Normal Coding
+	 *
+	 *  Customer codes are allocated by Philips. The rest of the bits
+	 *  are customer dependent. The following is commonly used (and the
+	 *  only supported config):
+	 *
+	 *  Toggle Bit		- Normal Coding
+	 *  Address Bit 6 - 0	- Normal Coding
+	 *  Command Bit 7 - 0	- Normal Coding
+	 *
+	 * All modes are followed by at least 6 * cell0.
+	 *
+	 * MODE 0 msglen:
+	 *  1 * 2 (start bit) + 3 * 2 (mode) + 2 * 2 (toggle) +
+	 *  8 * 2 (address) + 8 * 2 (command) =3D
+	 *  44 cells
+	 *
+	 * MODE 6A msglen:
+	 *  1 * 2 (start bit) + 3 * 2 (mode) + 2 * 2 (submode) +
+	 *  1 * 2 (customer range bit) + 7/15 * 2 (customer bits) +
+	 *  1 * 2 (toggle bit) + 7 * 2 (address) + 8 * 2 (command) =3D
+	 *  60 - 76 cells
+	 */
+	u8 mode;
+	u8 toggle;
+	u16 customer =3D 0x0;
+	u8 address;
+	u8 command;
+	u32 scancode;
+
+	/* Leader mark */
+	while (get_bits(data, 1) && !data->irdata_error)
+		/* Do nothing */;
+
+	/* Leader space */
+	if (get_bits(data, 1)) {
+		dev_dbg(dev, "RC6 - Invalid leader space\n");
+		return;
+	}
+
+	/* Start bit */
+	if (get_bits(data, 2) !=3D 0x02) {
+		dev_dbg(dev, "RC6 - Invalid start bit\n");
+		return;
+	}
+
+	/* Mode */
+	mode =3D get_bits(data, 6);
+	switch (mode) {
+	case 0x15: /* 010101 =3D b000 */
+		mode =3D 0;
+		break;
+	case 0x29: /* 101001 =3D b110 */
+		mode =3D 6;
+		break;
+	default:
+		dev_dbg(dev, "RC6 - Invalid mode\n");
+		return;
+	}
+
+	/* Toggle bit / Submode bit */
+	toggle =3D get_bits(data, 4);
+	switch (toggle) {
+	case 0x03:
+		toggle =3D 0;
+		break;
+	case 0x0C:
+		toggle =3D 1;
+		break;
+	default:
+		dev_dbg(dev, "RC6 - Toggle bit error\n");
+		break;
+	}
+
+	/* Customer */
+	if (mode =3D=3D 6) {
+		if (toggle !=3D 0) {
+			dev_dbg(dev, "RC6B - Not Supported\n");
+			return;
+		}
+
+		customer =3D wbcir_rc6cells_to_byte(data);
+
+		if (customer & 0x80) {
+			/* 15 bit customer value */
+			customer <<=3D 8;
+			customer |=3D wbcir_rc6cells_to_byte(data);
+		}
+	}
+
+	/* Address */
+	address =3D wbcir_rc6cells_to_byte(data);
+	if (mode =3D=3D 6) {
+		toggle =3D address >> 7;
+		address &=3D 0x7F;
+	}
+
+	/* Command */
+	command =3D wbcir_rc6cells_to_byte(data);
+
+	/* Create scancode */
+	scancode =3D  command;
+	scancode |=3D address << 8;
+	scancode |=3D customer << 16;
+
+	/* Last sanity check */
+	if (data->irdata_error) {
+		dev_dbg(dev, "RC6 - Cell error(s)\n");
+		return;
+	}
+
+	dev_dbg(dev, "IR-RC6 ad 0x%02X cm 0x%02X cu 0x%04X "
+		"toggle %u mode %u scan 0x%08X\n",
+		address,
+		command,
+		customer,
+		(unsigned int)toggle,
+		(unsigned int)mode,
+		scancode);
+
+	wbcir_keydown(data, scancode, toggle);
+}
+
+static void
+wbcir_parse_rc5(struct device *dev, struct wbcir_data *data)
+{
+	/*
+	 * Bits are manchester coded as follows:
+	 * cell1 + cell0 =3D logic "0"
+	 * cell0 + cell1 =3D logic "1"
+	 * (i.e. the reverse of RC6)
+	 *
+	 * Start bit 1		- "1" - discarded
+	 * Start bit 2		- Must be inverted to get command bit 6
+	 * Toggle bit
+	 * Address Bit 4 - 0
+	 * Command Bit 5 - 0
+	 */
+	u8 toggle;
+	u8 address;
+	u8 command;
+	u32 scancode;
+
+	/* Start bit 1 */
+	if (!get_bits(data, 1)) {
+		dev_dbg(dev, "RC5 - Invalid start bit\n");
+		return;
+	}
+
+	/* Start bit 2 */
+	if (!wbcir_get_rc5bits(data, 1))
+		command =3D 0x40;
+	else
+		command =3D 0x00;
+
+	toggle   =3D wbcir_get_rc5bits(data, 1);
+	address  =3D wbcir_get_rc5bits(data, 5);
+	command |=3D wbcir_get_rc5bits(data, 6);
+	scancode =3D address << 7 | command;
+
+	/* Last sanity check */
+	if (data->irdata_error) {
+		dev_dbg(dev, "RC5 - Invalid message\n");
+		return;
+	}
+
+	dev_dbg(dev, "IR-RC5 ad %u cm %u t %u s %u\n",
+		(unsigned int)address,
+		(unsigned int)command,
+		(unsigned int)toggle,
+		(unsigned int)scancode);
+
+	wbcir_keydown(data, scancode, toggle);
+}
+
+static void
+wbcir_parse_nec(struct device *dev, struct wbcir_data *data)
+{
+	/*
+	 * Each bit represents 560 us.
+	 *
+	 * Leader		- 9 ms burst
+	 * Gap			- 4.5 ms silence
+	 * Address1 bit 0 - 7	- Address 1
+	 * Address2 bit 0 - 7	- Address 2
+	 * Command1 bit 0 - 7	- Command 1
+	 * Command2 bit 0 - 7	- Command 2
+	 *
+	 * Note the bit order!
+	 *
+	 * With the old NEC protocol, Address2 was the inverse of Address1
+	 * and Command2 was the inverse of Command1 and were used as
+	 * an error check.
+	 *
+	 * With NEC extended, Address1 is the LSB of the Address and
+	 * Address2 is the MSB, Command parsing remains unchanged.
+	 *
+	 * A repeat message is coded as:
+	 * Leader		- 9 ms burst
+	 * Gap			- 2.25 ms silence
+	 * Repeat		- 560 us active
+	 */
+	u8 address1;
+	u8 address2;
+	u8 command1;
+	u8 command2;
+	u16 address;
+	u32 scancode;
+
+	/* Leader mark */
+	while (get_bits(data, 1) && !data->irdata_error)
+		/* Do nothing */;
+
+	/* Leader space */
+	if (get_bits(data, 4)) {
+		dev_dbg(dev, "NEC - Invalid leader space\n");
+		return;
+	}
+
+	/* Repeat? */
+	if (get_bits(data, 1)) {
+		if (!data->keypressed) {
+			dev_dbg(dev, "NEC - Stray repeat message\n");
+			return;
+		}
+
+		dev_dbg(dev, "IR-NEC repeat s %u\n",
+			(unsigned int)data->last_scancode);
+
+		wbcir_keydown(data, data->last_scancode, data->last_toggle);
+		return;
+	}
+
+	/* Remaining leader space */
+	if (get_bits(data, 3)) {
+		dev_dbg(dev, "NEC - Invalid leader space\n");
+		return;
+	}
+
+	address1  =3D bitrev8(get_bits(data, 8));
+	address2  =3D bitrev8(get_bits(data, 8));
+	command1  =3D bitrev8(get_bits(data, 8));
+	command2  =3D bitrev8(get_bits(data, 8));
+
+	/* Sanity check */
+	if (data->irdata_error) {
+		dev_dbg(dev, "NEC - Invalid message\n");
+		return;
+	}
+
+	/* Check command validity */
+	if (command1 !=3D ~command2) {
+		dev_dbg(dev, "NEC - Command bytes mismatch\n");
+		return;
+	}
+
+	/* Check for extended NEC protocol */
+	address =3D address1;
+	if (address1 !=3D ~address2)
+		address |=3D address2 << 8;
+
+	scancode =3D address << 8 | command1;
+
+	dev_dbg(dev, "IR-NEC ad %u cm %u s %u\n",
+		(unsigned int)address,
+		(unsigned int)command1,
+		(unsigned int)scancode);
+
+	wbcir_keydown(data, scancode, !data->last_toggle);
+}
+
+
+
+/*********************************************************************=
********
+ *
+ * INTERRUPT FUNCTIONS
+ *
+ *********************************************************************=
********/
+
+static irqreturn_t
+wbcir_irq_handler(int irqno, void *cookie)
+{
+	struct pnp_dev *device =3D cookie;
+	struct wbcir_data *data =3D pnp_get_drvdata(device);
+	struct device *dev =3D &device->dev;
+	u8 status;
+	unsigned long flags;
+	u8 irdata[16];
+	int i;
+	unsigned int hw;
+
+	spin_lock_irqsave(&wbcir_lock, flags);
+
+	wbcir_select_bank(data, WBCIR_BANK_0);
+
+	status =3D inb(data->sbase + WBCIR_REG_SP3_EIR);
+
+	if (!(status & (WBCIR_IRQ_RX | WBCIR_IRQ_ERR))) {
+		spin_unlock_irqrestore(&wbcir_lock, flags);
+		return IRQ_NONE;
+	}
+
+	if (status & WBCIR_IRQ_ERR)
+		data->irdata_error =3D 1;
+
+	if (!(status & WBCIR_IRQ_RX))
+		goto out;
+
+	/* Since RXHDLEV is set, at least 16 bytes are in the FIFO */
+	insb(data->sbase + WBCIR_REG_SP3_RXDATA, &irdata[0], 8);
+	insb(data->sbase + WBCIR_REG_SP3_RXDATA, &irdata[8], 8);
+
+	for (i =3D 0; i < sizeof(data); i++) {
+		hw =3D hweight8(irdata[i]);
+		if (hw > 4)
+			add_irdata_bit(data, 0);
+		else
+			add_irdata_bit(data, 1);
+
+		if (hw =3D=3D 8)
+			data->idle_count++;
+		else
+			data->idle_count =3D 0;
+	}
+
+	if (data->idle_count > WBCIR_MAX_IDLE_BYTES) {
+		/* Drain the FIFO */
+		while (inb(data->sbase + WBCIR_REG_SP3_LSR) & WBCIR_RX_AVAIL)
+			inb(data->sbase + WBCIR_REG_SP3_RXDATA);
+
+		/* And set RXINACTIVE */
+		outb(WBCIR_RX_DISABLE, data->sbase + WBCIR_REG_SP3_ASCR);
+
+		dev_dbg(dev, "IRDATA:\n");
+		for (i =3D 0; i < data->irdata_count; i +=3D BITS_PER_LONG)
+			dev_dbg(dev, "0x%08lX\n", data->irdata[i/BITS_PER_LONG]);
+
+		switch (protocol) {
+		case IR_PROTOCOL_RC5:
+			wbcir_parse_rc5(dev, data);
+			break;
+		case IR_PROTOCOL_RC6:
+			wbcir_parse_rc6(dev, data);
+			break;
+		case IR_PROTOCOL_NEC:
+			wbcir_parse_nec(dev, data);
+			break;
+		}
+
+		wbcir_reset_irdata(data);
+		data->idle_count =3D 0;
+	}
+
+out:
+	spin_unlock_irqrestore(&wbcir_lock, flags);
+	return IRQ_HANDLED;
+}
+
+
+
+/*********************************************************************=
********
+ *
+ * SUSPEND/RESUME FUNCTIONS
+ *
+ *********************************************************************=
********/
+
+static void
+wbcir_shutdown(struct pnp_dev *device)
+{
+	struct device *dev =3D &device->dev;
+	struct wbcir_data *data =3D pnp_get_drvdata(device);
+	int do_wake =3D 1;
+	u8 match[11];
+	u8 mask[11];
+	u8 rc6_csl =3D 0;
+	int i;
+
+	memset(match, 0, sizeof(match));
+	memset(mask, 0, sizeof(mask));
+
+	if (wake_sc =3D=3D INVALID_SCANCODE || !device_may_wakeup(dev)) {
+		do_wake =3D 0;
+		goto finish;
+	}
+
+	switch (protocol) {
+	case IR_PROTOCOL_RC5:
+		if (wake_sc > 0xFFF) {
+			do_wake =3D 0;
+			dev_err(dev, "RC5 - Invalid wake scancode\n");
+			break;
+		}
+
+		/* Mask =3D 13 bits, ex toggle */
+		mask[0] =3D 0xFF;
+		mask[1] =3D 0x17;
+
+		match[0]  =3D (wake_sc & 0x003F);      /* 6 command bits */
+		match[0] |=3D (wake_sc & 0x0180) >> 1; /* 2 address bits */
+		match[1]  =3D (wake_sc & 0x0E00) >> 9; /* 3 address bits */
+		if (!(wake_sc & 0x0040))             /* 2nd start bit  */
+			match[1] |=3D 0x10;
+
+		break;
+
+	case IR_PROTOCOL_NEC:
+		if (wake_sc > 0xFFFFFF) {
+			do_wake =3D 0;
+			dev_err(dev, "NEC - Invalid wake scancode\n");
+			break;
+		}
+
+		mask[0] =3D mask[1] =3D mask[2] =3D mask[3] =3D 0xFF;
+
+		match[1] =3D bitrev8((wake_sc & 0xFF));
+		match[0] =3D ~match[1];
+
+		match[3] =3D bitrev8((wake_sc & 0xFF00) >> 8);
+		if (wake_sc > 0xFFFF)
+			match[2] =3D bitrev8((wake_sc & 0xFF0000) >> 16);
+		else
+			match[2] =3D ~match[3];
+
+		break;
+
+	case IR_PROTOCOL_RC6:
+
+		if (wake_rc6mode =3D=3D 0) {
+			if (wake_sc > 0xFFFF) {
+				do_wake =3D 0;
+				dev_err(dev, "RC6 - Invalid wake scancode\n");
+				break;
+			}
+
+			/* Command */
+			match[0] =3D wbcir_to_rc6cells(wake_sc >>  0);
+			mask[0]  =3D 0xFF;
+			match[1] =3D wbcir_to_rc6cells(wake_sc >>  4);
+			mask[1]  =3D 0xFF;
+
+			/* Address */
+			match[2] =3D wbcir_to_rc6cells(wake_sc >>  8);
+			mask[2]  =3D 0xFF;
+			match[3] =3D wbcir_to_rc6cells(wake_sc >> 12);
+			mask[3]  =3D 0xFF;
+
+			/* Header */
+			match[4] =3D 0x50; /* mode1 =3D mode0 =3D 0, ignore toggle */
+			mask[4]  =3D 0xF0;
+			match[5] =3D 0x09; /* start bit =3D 1, mode2 =3D 0 */
+			mask[5]  =3D 0x0F;
+
+			rc6_csl =3D 44;
+
+		} else if (wake_rc6mode =3D=3D 6) {
+			i =3D 0;
+
+			/* Command */
+			match[i]  =3D wbcir_to_rc6cells(wake_sc >>  0);
+			mask[i++] =3D 0xFF;
+			match[i]  =3D wbcir_to_rc6cells(wake_sc >>  4);
+			mask[i++] =3D 0xFF;
+
+			/* Address + Toggle */
+			match[i]  =3D wbcir_to_rc6cells(wake_sc >>  8);
+			mask[i++] =3D 0xFF;
+			match[i]  =3D wbcir_to_rc6cells(wake_sc >> 12);
+			mask[i++] =3D 0x3F;
+
+			/* Customer bits 7 - 0 */
+			match[i]  =3D wbcir_to_rc6cells(wake_sc >> 16);
+			mask[i++] =3D 0xFF;
+			match[i]  =3D wbcir_to_rc6cells(wake_sc >> 20);
+			mask[i++] =3D 0xFF;
+
+			if (wake_sc & 0x80000000) {
+				/* Customer range bit and bits 15 - 8 */
+				match[i]  =3D wbcir_to_rc6cells(wake_sc >> 24);
+				mask[i++] =3D 0xFF;
+				match[i]  =3D wbcir_to_rc6cells(wake_sc >> 28);
+				mask[i++] =3D 0xFF;
+				rc6_csl =3D 76;
+			} else if (wake_sc <=3D 0x007FFFFF) {
+				rc6_csl =3D 60;
+			} else {
+				do_wake =3D 0;
+				dev_err(dev, "RC6 - Invalid wake scancode\n");
+				break;
+			}
+
+			/* Header */
+			match[i]  =3D 0x93; /* mode1 =3D mode0 =3D 1, submode =3D 0 */
+			mask[i++] =3D 0xFF;
+			match[i]  =3D 0x0A; /* start bit =3D 1, mode2 =3D 1 */
+			mask[i++] =3D 0x0F;
+
+		} else {
+			do_wake =3D 0;
+			dev_err(dev, "RC6 - Invalid wake mode\n");
+		}
+
+		break;
+
+	default:
+		do_wake =3D 0;
+		break;
+	}
+
+finish:
+	if (do_wake) {
+		/* Set compare and compare mask */
+		wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_INDEX,
+			       WBCIR_REGSEL_COMPARE | WBCIR_REG_ADDR0,
+			       0x3F);
+		outsb(data->wbase + WBCIR_REG_WCEIR_DATA, match, 11);
+		wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_INDEX,
+			       WBCIR_REGSEL_MASK | WBCIR_REG_ADDR0,
+			       0x3F);
+		outsb(data->wbase + WBCIR_REG_WCEIR_DATA, mask, 11);
+
+		/* RC6 Compare String Len */
+		outb(rc6_csl, data->wbase + WBCIR_REG_WCEIR_CSL);
+
+		/* Clear status bits NEC_REP, BUFF, MSG_END, MATCH */
+		wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_STS, 0x17, 0x17);
+
+		/* Clear BUFF_EN, Clear END_EN, Set MATCH_EN */
+		wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_EV_EN, 0x01, 0x07);
+
+		/* Set CEIR_EN */
+		wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_CTL, 0x01, 0x01);
+
+	} else {
+		/* Clear BUFF_EN, Clear END_EN, Clear MATCH_EN */
+		wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_EV_EN, 0x00, 0x07);
+
+		/* Clear CEIR_EN */
+		wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_CTL, 0x00, 0x01);
+	}
+
+	/* Disable interrupts */
+	outb(WBCIR_IRQ_NONE, data->sbase + WBCIR_REG_SP3_IER);
+}
+
+static int
+wbcir_suspend(struct pnp_dev *device, pm_message_t state)
+{
+	wbcir_shutdown(device);
+	return 0;
+}
+
+static int
+wbcir_resume(struct pnp_dev *device)
+{
+	struct wbcir_data *data =3D pnp_get_drvdata(device);
+
+	/* Clear BUFF_EN, Clear END_EN, Clear MATCH_EN */
+	wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_EV_EN, 0x00, 0x07);
+
+	/* Clear CEIR_EN */
+	wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_CTL, 0x00, 0x01);
+
+	/* Enable interrupts */
+	wbcir_reset_irdata(data);
+	outb(WBCIR_IRQ_RX | WBCIR_IRQ_ERR, data->sbase + WBCIR_REG_SP3_IER);
+
+	return 0;
+}
+
+
+
+/*********************************************************************=
********
+ *
+ * SETUP/INIT FUNCTIONS
+ *
+ *********************************************************************=
********/
+
+static ssize_t
+wbcir_show_last_scancode(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	struct pnp_dev *device =3D container_of(dev, struct pnp_dev, dev);
+	struct wbcir_data *data =3D pnp_get_drvdata(device);
+	return sprintf(buf, "0x%08X\n", data->last_scancode);
+}
+
+static struct device_attribute dev_attr_last_scancode =3D {
+	.attr =3D {
+		.name =3D "last_scancode",
+		.mode =3D 0444,
+	},
+	.show =3D wbcir_show_last_scancode,
+	.store =3D NULL,
+
+};
+
+static struct attribute *wbcir_attributes[] =3D {
+	&dev_attr_last_scancode.attr,
+	NULL,
+};
+
+static struct attribute_group wbcir_attribute_group =3D {
+	.attrs =3D wbcir_attributes,
+};
+
+static void
+wbcir_cfg_ceir(struct wbcir_data *data)
+{
+	u8 tmp;
+
+	/* Set PROT_SEL, RX_INV, Clear CEIR_EN (needed for the led) */
+	tmp =3D protocol << 4;
+	if (invert)
+		tmp |=3D 0x08;
+	outb(tmp, data->wbase + WBCIR_REG_WCEIR_CTL);
+
+	/* Clear status bits NEC_REP, BUFF, MSG_END, MATCH */
+	wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_STS, 0x17, 0x17);
+
+	/* Clear BUFF_EN, Clear END_EN, Clear MATCH_EN */
+	wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_EV_EN, 0x00, 0x07);
+
+	/* Set RC5 cell time to correspond to 36 kHz */
+	wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_CFG1, 0x4A, 0x7F);
+
+	/* Set IRTX_INV */
+	if (invert)
+		outb(0x04, data->ebase + WBCIR_REG_ECEIR_CCTL);
+	else
+		outb(0x00, data->ebase + WBCIR_REG_ECEIR_CCTL);
+
+	/*
+	 * Clear IR LED, set SP3 clock to 24Mhz
+	 * set SP3_IRRX_SW to binary 01, helpfully not documented
+	 */
+	outb(0x10, data->ebase + WBCIR_REG_ECEIR_CTS);
+}
+
+static int
+wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id=
)
+{
+	struct device *dev =3D &device->dev;
+	struct wbcir_data *data;
+	int err;
+
+	if (!(pnp_port_len(device, 0) =3D=3D EHFUNC_IOMEM_LEN &&
+	      pnp_port_len(device, 1) =3D=3D WAKEUP_IOMEM_LEN &&
+	      pnp_port_len(device, 2) =3D=3D SP_IOMEM_LEN)) {
+		dev_err(dev, "Invalid resources\n");
+		return -ENODEV;
+	}
+
+	data =3D kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data) {
+		err =3D -ENOMEM;
+		goto exit;
+	}
+
+	pnp_set_drvdata(device, data);
+
+	data->ebase =3D pnp_port_start(device, 0);
+	data->wbase =3D pnp_port_start(device, 1);
+	data->sbase =3D pnp_port_start(device, 2);
+	data->irq =3D pnp_irq(device, 0);
+
+	if (data->wbase =3D=3D 0 || data->ebase =3D=3D 0 ||
+	    data->sbase =3D=3D 0 || data->irq =3D=3D 0) {
+		err =3D -ENODEV;
+		dev_err(dev, "Invalid resources\n");
+		goto exit_free_data;
+	}
+
+	dev_info(&device->dev, "Found device "
+		 "(w: 0x%lX, e: 0x%lX, s: 0x%lX, i: %u)\n",
+		 data->wbase, data->ebase, data->sbase, data->irq);
+
+	if (!request_region(data->wbase, WAKEUP_IOMEM_LEN, DRVNAME)) {
+		dev_err(dev, "Region 0x%lx-0x%lx already in use!\n",
+			data->wbase, data->wbase + WAKEUP_IOMEM_LEN - 1);
+		err =3D -EBUSY;
+		goto exit_free_data;
+	}
+
+	if (!request_region(data->ebase, EHFUNC_IOMEM_LEN, DRVNAME)) {
+		dev_err(dev, "Region 0x%lx-0x%lx already in use!\n",
+			data->ebase, data->ebase + EHFUNC_IOMEM_LEN - 1);
+		err =3D -EBUSY;
+		goto exit_release_wbase;
+	}
+
+	if (!request_region(data->sbase, SP_IOMEM_LEN, DRVNAME)) {
+		dev_err(dev, "Region 0x%lx-0x%lx already in use!\n",
+			data->sbase, data->sbase + SP_IOMEM_LEN - 1);
+		err =3D -EBUSY;
+		goto exit_release_ebase;
+	}
+
+	err =3D request_irq(data->irq, wbcir_irq_handler,
+			  IRQF_DISABLED, DRVNAME, device);
+	if (err) {
+		dev_err(dev, "Failed to claim IRQ %u\n", data->irq);
+		err =3D -EBUSY;
+		goto exit_release_sbase;
+	}
+
+	led_trigger_register_simple("cir-tx", &data->txtrigger);
+	if (!data->txtrigger) {
+		err =3D -ENOMEM;
+		goto exit_free_irq;
+	}
+
+	led_trigger_register_simple("cir-rx", &data->rxtrigger);
+	if (!data->rxtrigger) {
+		err =3D -ENOMEM;
+		goto exit_unregister_txtrigger;
+	}
+
+	data->led.name =3D "cir::activity";
+	data->led.default_trigger =3D "cir-rx";
+	data->led.brightness_set =3D wbcir_led_brightness_set;
+	data->led.brightness_get =3D wbcir_led_brightness_get;
+	err =3D led_classdev_register(&device->dev, &data->led);
+	if (err)
+		goto exit_unregister_rxtrigger;
+
+	data->input_dev =3D input_allocate_device();
+	if (!data->input_dev) {
+		err =3D -ENOMEM;
+		goto exit_unregister_led;
+	}
+
+	data->input_dev->evbit[0] =3D BIT(EV_KEY);
+	data->input_dev->name =3D WBCIR_NAME;
+	data->input_dev->phys =3D "wbcir/cir0";
+	data->input_dev->id.bustype =3D BUS_HOST;
+	data->input_dev->id.vendor  =3D PCI_VENDOR_ID_WINBOND;
+	data->input_dev->id.product =3D WBCIR_ID_FAMILY;
+	data->input_dev->id.version =3D WBCIR_ID_CHIP;
+	data->input_dev->getkeycode =3D wbcir_getkeycode;
+	data->input_dev->setkeycode =3D wbcir_setkeycode;
+	input_set_drvdata(data->input_dev, data);
+
+	err =3D input_register_device(data->input_dev);
+	if (err)
+		goto exit_free_input;
+
+	data->last_scancode =3D INVALID_SCANCODE;
+	err =3D sysfs_create_group(&device->dev.kobj, &wbcir_attribute_group)=
;
+	if (err)
+		goto exit_unregister_input;
+
+	INIT_LIST_HEAD(&data->keytable);
+	setup_timer(&data->timer_keyup, wbcir_keyup, (unsigned long)data);
+
+	/* Load default keymaps */
+	if (protocol =3D=3D IR_PROTOCOL_RC6) {
+		int i;
+		for (i =3D 0; i < ARRAY_SIZE(rc6_def_keymap); i++) {
+			err =3D wbcir_setkeycode(data->input_dev,
+					       (int)rc6_def_keymap[i].scancode,
+					       (int)rc6_def_keymap[i].keycode);
+			if (err)
+				goto exit_unregister_keys;
+		}
+	}
+
+	device_init_wakeup(&device->dev, 1);
+
+	wbcir_cfg_ceir(data);
+
+	/* Disable interrupts */
+	wbcir_select_bank(data, WBCIR_BANK_0);
+	outb(WBCIR_IRQ_NONE, data->sbase + WBCIR_REG_SP3_IER);
+
+	/* Enable extended mode */
+	wbcir_select_bank(data, WBCIR_BANK_2);
+	outb(WBCIR_EXT_ENABLE, data->sbase + WBCIR_REG_SP3_EXCR1);
+
+	/*
+	 * Configure baud generator, IR data will be sampled at
+	 * a bitrate of: (24Mhz * prescaler) / (divisor * 16).
+	 *
+	 * The ECIR registers include a flag to change the
+	 * 24Mhz clock freq to 48Mhz.
+	 */
+
+	/* prescaler 1.0, tx/rx fifo lvl 32 */
+	outb(0x35, data->sbase + WBCIR_REG_SP3_EXCR2);
+
+	/* Set baud divisor to generate one byte per bit/cell */
+	switch (protocol) {
+	case IR_PROTOCOL_RC5:
+		outb(0xA7, data->sbase + WBCIR_REG_SP3_BGDL);
+		break;
+	case IR_PROTOCOL_RC6:
+		outb(0x53, data->sbase + WBCIR_REG_SP3_BGDL);
+		break;
+	case IR_PROTOCOL_NEC:
+		outb(0x69, data->sbase + WBCIR_REG_SP3_BGDL);
+		break;
+	}
+	outb(0x00, data->sbase + WBCIR_REG_SP3_BGDH);
+
+	/* Set CEIR mode */
+	wbcir_select_bank(data, WBCIR_BANK_0);
+	outb(0xC0, data->sbase + WBCIR_REG_SP3_MCR);
+	inb(data->sbase + WBCIR_REG_SP3_LSR); /* Clear LSR */
+	inb(data->sbase + WBCIR_REG_SP3_MSR); /* Clear MSR */
+
+	/* Disable RX demod, run-length encoding/decoding, set freq span */
+	wbcir_select_bank(data, WBCIR_BANK_7);
+	outb(0x10, data->sbase + WBCIR_REG_SP3_RCCFG);
+
+	/* Disable timer */
+	wbcir_select_bank(data, WBCIR_BANK_4);
+	outb(0x00, data->sbase + WBCIR_REG_SP3_IRCR1);
+
+	/* Enable MSR interrupt, Clear AUX_IRX */
+	wbcir_select_bank(data, WBCIR_BANK_5);
+	outb(0x00, data->sbase + WBCIR_REG_SP3_IRCR2);
+
+	/* Disable CRC */
+	wbcir_select_bank(data, WBCIR_BANK_6);
+	outb(0x20, data->sbase + WBCIR_REG_SP3_IRCR3);
+
+	/* Set RX/TX (de)modulation freq, not really used */
+	wbcir_select_bank(data, WBCIR_BANK_7);
+	outb(0xF2, data->sbase + WBCIR_REG_SP3_IRRXDC);
+	outb(0x69, data->sbase + WBCIR_REG_SP3_IRTXMC);
+
+	/* Set invert and pin direction */
+	if (invert)
+		outb(0x10, data->sbase + WBCIR_REG_SP3_IRCFG4);
+	else
+		outb(0x00, data->sbase + WBCIR_REG_SP3_IRCFG4);
+
+	/* Set FIFO thresholds (RX =3D 16, TX =3D 7), reset RX/TX */
+	wbcir_select_bank(data, WBCIR_BANK_0);
+	outb(0x97, data->sbase + WBCIR_REG_SP3_FCR);
+
+	/* Clear AUX status bits */
+	outb(0xE0, data->sbase + WBCIR_REG_SP3_ASCR);
+
+	/* Enable interrupts */
+	wbcir_select_bank(data, WBCIR_BANK_0);
+	outb(WBCIR_IRQ_RX | WBCIR_IRQ_ERR, data->sbase + WBCIR_REG_SP3_IER);
+
+	return 0;
+
+exit_unregister_keys:
+	if (!list_empty(&data->keytable)) {
+		struct wbcir_keyentry *key;
+		struct wbcir_keyentry *keytmp;
+
+		list_for_each_entry_safe(key, keytmp, &data->keytable, list) {
+			list_del(&key->list);
+			kfree(key);
+		}
+	}
+exit_unregister_input:
+	input_unregister_device(data->input_dev);
+	/* Can't call input_free_device on an unregistered device */
+	data->input_dev =3D NULL;
+exit_free_input:
+	input_free_device(data->input_dev);
+exit_unregister_led:
+	led_classdev_unregister(&data->led);
+exit_unregister_rxtrigger:
+	led_trigger_unregister_simple(data->rxtrigger);
+exit_unregister_txtrigger:
+	led_trigger_unregister_simple(data->txtrigger);
+exit_free_irq:
+	free_irq(data->irq, device);
+exit_release_sbase:
+	release_region(data->sbase, SP_IOMEM_LEN);
+exit_release_ebase:
+	release_region(data->ebase, EHFUNC_IOMEM_LEN);
+exit_release_wbase:
+	release_region(data->wbase, WAKEUP_IOMEM_LEN);
+exit_free_data:
+	kfree(data);
+	pnp_set_drvdata(device, NULL);
+exit:
+	return err;
+}
+
+static void
+wbcir_remove(struct pnp_dev *device)
+{
+	struct wbcir_data *data =3D pnp_get_drvdata(device);
+	struct wbcir_keyentry *key;
+	struct wbcir_keyentry *keytmp;
+
+	/* Disable interrupts */
+	wbcir_select_bank(data, WBCIR_BANK_0);
+	outb(WBCIR_IRQ_NONE, data->sbase + WBCIR_REG_SP3_IER);
+
+	del_timer_sync(&data->timer_keyup);
+
+	free_irq(data->irq, device);
+
+	/* Clear status bits NEC_REP, BUFF, MSG_END, MATCH */
+	wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_STS, 0x17, 0x17);
+
+	/* Clear CEIR_EN */
+	wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_CTL, 0x00, 0x01);
+
+	/* Clear BUFF_EN, END_EN, MATCH_EN */
+	wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_EV_EN, 0x00, 0x07);
+
+	sysfs_remove_group(&device->dev.kobj, &wbcir_attribute_group);
+
+	/* This will generate a keyup event if necessary */
+	input_unregister_device(data->input_dev);
+
+	led_trigger_unregister_simple(data->rxtrigger);
+	led_trigger_unregister_simple(data->txtrigger);
+	led_classdev_unregister(&data->led);
+
+	/* This is ok since &data->led isn't actually used */
+	wbcir_led_brightness_set(&data->led, LED_OFF);
+
+	release_region(data->wbase, WAKEUP_IOMEM_LEN);
+	release_region(data->ebase, EHFUNC_IOMEM_LEN);
+	release_region(data->sbase, SP_IOMEM_LEN);
+
+	list_for_each_entry_safe(key, keytmp, &data->keytable, list) {
+		list_del(&key->list);
+		kfree(key);
+	}
+
+	kfree(data);
+
+	pnp_set_drvdata(device, NULL);
+}
+
+static const struct pnp_device_id wbcir_ids[] =3D {
+	{ "WEC1022", 0 },
+	{ "", 0 }
+};
+MODULE_DEVICE_TABLE(pnp, wbcir_ids);
+
+static struct pnp_driver wbcir_driver =3D {
+	.name     =3D WBCIR_NAME,
+	.id_table =3D wbcir_ids,
+	.probe    =3D wbcir_probe,
+	.remove   =3D wbcir_remove,
+	.suspend  =3D wbcir_suspend,
+	.resume   =3D wbcir_resume,
+	.shutdown =3D wbcir_shutdown
+};
+
+static int __init
+wbcir_init(void)
+{
+	int ret;
+
+	switch (protocol) {
+	case IR_PROTOCOL_RC5:
+	case IR_PROTOCOL_NEC:
+	case IR_PROTOCOL_RC6:
+		break;
+	default:
+		printk(KERN_ERR DRVNAME ": Invalid protocol argument\n");
+		return -EINVAL;
+	}
+
+	ret =3D pnp_register_driver(&wbcir_driver);
+	if (ret)
+		printk(KERN_ERR DRVNAME ": Unable to register driver\n");
+
+	return ret;
+}
+
+static void __exit
+wbcir_exit(void)
+{
+	pnp_unregister_driver(&wbcir_driver);
+}
+
+MODULE_AUTHOR("David H=C3=A4rdeman <david@hardeman.nu>");
+MODULE_DESCRIPTION("Winbond SuperI/O Consumer IR Driver");
+MODULE_LICENSE("GPL");
+
+module_init(wbcir_init);
+module_exit(wbcir_exit);
+
+
_

Patches currently in -mm which might be from david@hardeman.nu are

acpi-reintroduce-acpi_device_ops-shutdown-method.patch
input-add-a-shutdown-method-to-pnp-drivers.patch
input-add-a-driver-for-the-winbond-wpcd376i-consumer-ir-hardware.patch
add-a-driver-for-the-winbond-wpcd376i-ir-functionality.patch
add-a-driver-for-the-winbond-wpcd376i-ir-functionality-select-bitrevers=
e.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
