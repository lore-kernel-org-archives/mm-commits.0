From: akpm@linux-foundation.org
Subject: - olpc-add-one-laptop-per-child-architecture-support.patch removed from -mm tree
Date: Wed, 16 Apr 2008 17:46:08 -0700
Message-ID: <200804170056.m3H0uYKE015477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752531AbYDQA5K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Apr 2008 20:57:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, ak@suse.de, dilinger@debian.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: olpc: add One Laptop Per Child architecture support
has been removed from the -mm tree.  Its filename was
     olpc-add-one-laptop-per-child-architecture-support.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: x86: olpc: add One Laptop Per Child architecture support
=46rom: Andres Salomon <dilinger@queued.net>

This adds support for OLPC XO hardware.  Open Firmware on XOs don't con=
tain
the VSA, so it is necessary to emulate the PCI BARs in the kernel.  Thi=
s also
adds functionality for running EC commands, and a CONFIG_OLPC.

A number of OLPC drivers depend upon CONFIG_OLPC.

olpc_ec_timeout is a hack to work around Embedded Controller bugs.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    7=20
 arch/x86/Kconfig                    |   18 +
 arch/x86/kernel/Makefile            |    2=20
 arch/x86/kernel/olpc.c              |  256 +++++++++++++++++++++
 arch/x86/pci/Makefile_32            |    1=20
 arch/x86/pci/init.c                 |    3=20
 arch/x86/pci/olpc.c                 |  313 ++++++++++++++++++++++++++
 arch/x86/pci/pci.h                  |    1=20
 include/asm-x86/olpc.h              |  135 +++++++++++
 9 files changed, 735 insertions(+), 1 deletion(-)

diff -puN Documentation/kernel-parameters.txt~olpc-add-one-laptop-per-c=
hild-architecture-support Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~olpc-add-one-laptop-per-child=
-architecture-support
+++ a/Documentation/kernel-parameters.txt
@@ -1364,6 +1364,13 @@ and is between 256 and 4096 characters.=20
=20
 	nr_uarts=3D	[SERIAL] maximum number of UARTs to be registered.
=20
+	olpc_ec_timeout=3D [OLPC] ms delay when issuing EC commands
+			Rather than timing out after 20 ms if an EC
+			command is not properly ACKed, override the length
+			of the timeout.  We have interrupts disabled while
+			waiting for the ACK, so if this is set too high
+			interrupts *may* be lost!
+
 	opl3=3D		[HW,OSS]
 			Format: <io>
=20
diff -puN arch/x86/Kconfig~olpc-add-one-laptop-per-child-architecture-s=
upport arch/x86/Kconfig
--- a/arch/x86/Kconfig~olpc-add-one-laptop-per-child-architecture-suppo=
rt
+++ a/arch/x86/Kconfig
@@ -1465,6 +1465,10 @@ config PCI_GODIRECT
 config PCI_GOANY
 	bool "Any"
=20
+config PCI_GOOLPC
+	bool "OLPC"
+	depends on OLPC
+
 endchoice
=20
 config PCI_BIOS
@@ -1474,12 +1478,17 @@ config PCI_BIOS
 # x86-64 doesn't support PCI BIOS access from long mode so always go d=
irect.
 config PCI_DIRECT
 	def_bool y
-	depends on PCI && (X86_64 || (PCI_GODIRECT || PCI_GOANY) || X86_VISWS=
)
+	depends on PCI && (X86_64 || (PCI_GODIRECT || PCI_GOANY || PCI_GOOLPC=
) || X86_VISWS)
=20
 config PCI_MMCONFIG
 	def_bool y
 	depends on X86_32 && PCI && ACPI && (PCI_GOMMCONFIG || PCI_GOANY)
=20
+config PCI_OLPC
+	bool
+	depends on PCI && PCI_GOOLPC
+	default y
+
 config PCI_DOMAINS
 	def_bool y
 	depends on PCI
@@ -1599,6 +1608,13 @@ config GEODE_MFGPT_TIMER
 	  MFGPTs have a better resolution and max interval than the
 	  generic PIT, and are suitable for use as high-res timers.
=20
+config OLPC
+	bool "One Laptop Per Child support"
+	default n
+	help
+	  Add support for detecting the unique features of the OLPC
+	  XO hardware.
+
 endif # X86_32
=20
 config K8_NB
diff -puN arch/x86/kernel/Makefile~olpc-add-one-laptop-per-child-archit=
ecture-support arch/x86/kernel/Makefile
--- a/arch/x86/kernel/Makefile~olpc-add-one-laptop-per-child-architectu=
re-support
+++ a/arch/x86/kernel/Makefile
@@ -89,6 +89,8 @@ endif
 obj-$(CONFIG_SCx200)		+=3D scx200.o
 scx200-y			+=3D scx200_32.o
=20
+obj-$(CONFIG_OLPC)		+=3D olpc.o
+
 ###
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
diff -puN /dev/null arch/x86/kernel/olpc.c
--- /dev/null
+++ a/arch/x86/kernel/olpc.c
@@ -0,0 +1,256 @@
+/*
+ * Support for the OLPC DCON and OLPC EC access
+ *
+ * Copyright =C2=A9 2006  Advanced Micro Devices, Inc.
+ * Copyright =C2=A9 2007-2008  Andres Salomon <dilinger@debian.org>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/spinlock.h>
+#include <linux/io.h>
+#include <linux/string.h>
+#include <asm/geode.h>
+#include <asm/olpc.h>
+
+#ifdef CONFIG_OPEN_FIRMWARE
+#include <asm/ofw.h>
+#endif
+
+struct olpc_platform_t olpc_platform_info;
+EXPORT_SYMBOL_GPL(olpc_platform_info);
+
+static DEFINE_SPINLOCK(ec_lock);
+
+/* what the timeout *should* be (in ms) */
+#define EC_BASE_TIMEOUT 20
+
+/* the timeout that bugs in the EC might force us to actually use */
+static int ec_timeout =3D EC_BASE_TIMEOUT;
+
+static int __init olpc_ec_timeout_set(char *str)
+{
+	if (get_option(&str, &ec_timeout) !=3D 1) {
+		ec_timeout =3D EC_BASE_TIMEOUT;
+		printk(KERN_ERR "olpc-ec:  invalid argument to "
+				"'olpc_ec_timeout=3D', ignoring!\n");
+	}
+	printk(KERN_DEBUG "olpc-ec:  using %d ms delay for EC commands.\n",
+			ec_timeout);
+	return 1;
+}
+__setup("olpc_ec_timeout=3D", olpc_ec_timeout_set);
+
+/*
+ * These {i,o}bf_status functions return whether the buffers are full =
or not.
+ */
+
+static inline unsigned int ibf_status(unsigned int port)
+{
+	return !!(inb(port) & 0x02);
+}
+
+static inline unsigned int obf_status(unsigned int port)
+{
+	return inb(port) & 0x01;
+}
+
+#define wait_on_ibf(p, d) __wait_on_ibf(__LINE__, (p), (d))
+static int __wait_on_ibf(unsigned int line, unsigned int port, int des=
ired)
+{
+	unsigned int timeo;
+	int state =3D ibf_status(port);
+
+	for (timeo =3D ec_timeout; state !=3D desired && timeo; timeo--) {
+		mdelay(1);
+		state =3D ibf_status(port);
+	}
+
+	if ((state =3D=3D desired) && (ec_timeout > EC_BASE_TIMEOUT) &&
+			timeo < (ec_timeout - EC_BASE_TIMEOUT)) {
+		printk(KERN_WARNING "olpc-ec:  %d: waited %u ms for IBF!\n",
+				line, ec_timeout - timeo);
+	}
+
+	return !(state =3D=3D desired);
+}
+
+#define wait_on_obf(p, d) __wait_on_obf(__LINE__, (p), (d))
+static int __wait_on_obf(unsigned int line, unsigned int port, int des=
ired)
+{
+	unsigned int timeo;
+	int state =3D obf_status(port);
+
+	for (timeo =3D ec_timeout; state !=3D desired && timeo; timeo--) {
+		mdelay(1);
+		state =3D obf_status(port);
+	}
+
+	if ((state =3D=3D desired) && (ec_timeout > EC_BASE_TIMEOUT) &&
+			timeo < (ec_timeout - EC_BASE_TIMEOUT)) {
+		printk(KERN_WARNING "olpc-ec:  %d: waited %u ms for OBF!\n",
+				line, ec_timeout - timeo);
+	}
+
+	return !(state =3D=3D desired);
+}
+
+/*
+ * This allows the kernel to run Embedded Controller commands.  The EC=
 is
+ * documented at <http://wiki.laptop.org/go/Embedded_controller>, and =
the
+ * available EC commands are here:
+ * <http://wiki.laptop.org/go/Ec_specification>.  Unfortunately, while
+ * OpenFirmware's source is available, the EC's is not.
+ */
+int olpc_ec_cmd(unsigned char cmd, unsigned char *inbuf, size_t inlen,
+		unsigned char *outbuf,  size_t outlen)
+{
+	unsigned long flags;
+	int ret =3D -EIO;
+	int i;
+
+	spin_lock_irqsave(&ec_lock, flags);
+
+	/* Clear OBF */
+	for (i =3D 0; i < 10 && (obf_status(0x6c) =3D=3D 1); i++)
+		inb(0x68);
+	if (i =3D=3D 10) {
+		printk(KERN_ERR "olpc-ec:  timeout while attempting to "
+				"clear OBF flag!\n");
+		goto err;
+	}
+
+	if (wait_on_ibf(0x6c, 0)) {
+		printk(KERN_ERR "olpc-ec:  timeout waiting for EC to "
+				"quiesce!\n");
+		goto err;
+	}
+
+restart:
+	/*
+	 * Note that if we time out during any IBF checks, that's a failure;
+	 * we have to return.  There's no way for the kernel to clear that.
+	 *
+	 * If we time out during an OBF check, we can restart the command;
+	 * reissuing it will clear the OBF flag, and we should be alright.
+	 * The OBF flag will sometimes misbehave due to what we believe
+	 * is a hardware quirk..
+	 */
+	printk(KERN_DEBUG "olpc-ec:  running cmd 0x%x\n", cmd);
+	outb(cmd, 0x6c);
+
+	if (wait_on_ibf(0x6c, 0)) {
+		printk(KERN_ERR "olpc-ec:  timeout waiting for EC to read "
+				"command!\n");
+		goto err;
+	}
+
+	if (inbuf && inlen) {
+		/* write data to EC */
+		for (i =3D 0; i < inlen; i++) {
+			if (wait_on_ibf(0x6c, 0)) {
+				printk(KERN_ERR "olpc-ec:  timeout waiting for"
+						" EC accept data!\n");
+				goto err;
+			}
+			printk(KERN_DEBUG "olpc-ec:  sending cmd arg 0x%x\n",
+					inbuf[i]);
+			outb(inbuf[i], 0x68);
+		}
+	}
+	if (outbuf && outlen) {
+		/* read data from EC */
+		for (i =3D 0; i < outlen; i++) {
+			if (wait_on_obf(0x6c, 1)) {
+				printk(KERN_ERR "olpc-ec:  timeout waiting for"
+						" EC to provide data!\n");
+				goto restart;
+			}
+			outbuf[i] =3D inb(0x68);
+			printk(KERN_DEBUG "olpc-ec:  received 0x%x\n",
+					outbuf[i]);
+		}
+	}
+
+	ret =3D 0;
+err:
+	spin_unlock_irqrestore(&ec_lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(olpc_ec_cmd);
+
+#ifdef CONFIG_OPEN_FIRMWARE
+static void __init platform_detect(void)
+{
+	size_t propsize;
+	u32 rev;
+
+	if (ofw("getprop", 4, 1, NULL, "board-revision-int", &rev, 4,
+			&propsize) || propsize !=3D 4) {
+		printk(KERN_ERR "ofw: getprop call failed!\n");
+		rev =3D 0;
+	}
+	olpc_platform_info.boardrev =3D be32_to_cpu(rev);
+}
+#else
+static void __init platform_detect(void)
+{
+	/* stopgap until OFW support is added to the kernel */
+	olpc_platform_info.boardrev =3D be32_to_cpu(0xc2);
+}
+#endif
+
+static int __init olpc_init(void)
+{
+	unsigned char *romsig;
+
+	spin_lock_init(&ec_lock);
+
+	romsig =3D ioremap(0xffffffc0, 16);
+	if (!romsig)
+		return 0;
+
+	if (strncmp(romsig, "CL1   Q", 7))
+		goto unmap;
+	if (strncmp(romsig+6, romsig+13, 3)) {
+		printk(KERN_INFO "OLPC BIOS signature looks invalid.  "
+				"Assuming not OLPC\n");
+		goto unmap;
+	}
+
+	printk(KERN_INFO "OLPC board with OpenFirmware %.16s\n", romsig);
+	olpc_platform_info.flags |=3D OLPC_F_PRESENT;
+
+	/* get the platform revision */
+	platform_detect();
+
+	/* assume B1 and above models always have a DCON */
+	if (olpc_board_at_least(olpc_board(0xb1)))
+		olpc_platform_info.flags |=3D OLPC_F_DCON;
+
+	/* get the EC revision */
+	olpc_ec_cmd(EC_FIRMWARE_REV, NULL, 0,
+			(unsigned char *) &olpc_platform_info.ecver, 1);
+
+	/* check to see if the VSA exists */
+	if (geode_has_vsa())
+		olpc_platform_info.flags |=3D OLPC_F_VSA;
+
+	printk(KERN_INFO "OLPC board revision %s%X (EC=3D%x)\n",
+			((olpc_platform_info.boardrev & 0xf) < 8) ? "pre" : "",
+			olpc_platform_info.boardrev >> 4,
+			olpc_platform_info.ecver);
+
+unmap:
+	iounmap(romsig);
+	return 0;
+}
+
+postcore_initcall(olpc_init);
diff -puN arch/x86/pci/Makefile_32~olpc-add-one-laptop-per-child-archit=
ecture-support arch/x86/pci/Makefile_32
--- a/arch/x86/pci/Makefile_32~olpc-add-one-laptop-per-child-architectu=
re-support
+++ a/arch/x86/pci/Makefile_32
@@ -3,6 +3,7 @@ obj-y				:=3D i386.o init.o
 obj-$(CONFIG_PCI_BIOS)		+=3D pcbios.o
 obj-$(CONFIG_PCI_MMCONFIG)	+=3D mmconfig_32.o direct.o mmconfig-shared=
=2Eo
 obj-$(CONFIG_PCI_DIRECT)	+=3D direct.o
+obj-$(CONFIG_PCI_OLPC)		+=3D olpc.o
=20
 pci-y				:=3D fixup.o
 pci-$(CONFIG_ACPI)		+=3D acpi.o
diff -puN arch/x86/pci/init.c~olpc-add-one-laptop-per-child-architectur=
e-support arch/x86/pci/init.c
--- a/arch/x86/pci/init.c~olpc-add-one-laptop-per-child-architecture-su=
pport
+++ a/arch/x86/pci/init.c
@@ -14,6 +14,9 @@ static __init int pci_access_init(void)
 #ifdef CONFIG_PCI_MMCONFIG
 	pci_mmcfg_init(type);
 #endif
+#ifdef CONFIG_PCI_OLPC
+	pci_olpc_init();
+#endif
 	if (raw_pci_ops)
 		return 0;
 #ifdef CONFIG_PCI_BIOS
diff -puN /dev/null arch/x86/pci/olpc.c
--- /dev/null
+++ a/arch/x86/pci/olpc.c
@@ -0,0 +1,313 @@
+/*
+ * Low-level PCI config space access for OLPC systems who lack the VSA
+ * PCI virtualization software.
+ *
+ * Copyright =C2=A9 2006  Advanced Micro Devices, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * The AMD Geode chipset (ie: GX2 processor, cs5536 I/O companion devi=
ce)
+ * has some I/O functions (display, southbridge, sound, USB HCIs, etc)
+ * that more or less behave like PCI devices, but the hardware doesn't
+ * directly implement the PCI configuration space headers.  AMD provid=
es
+ * "VSA" (Virtual System Architecture) software that emulates PCI conf=
ig
+ * space for these devices, by trapping I/O accesses to PCI config reg=
ister
+ * (CF8/CFC) and running some code in System Management Mode interrupt=
 state.
+ * On the OLPC platform, we don't want to use that VSA code because
+ * (a) it slows down suspend/resume, and (b) recompiling it requires s=
pecial
+ * compilers that are hard to get.  So instead of letting the complex =
VSA
+ * code simulate the PCI config registers for the on-chip devices, we
+ * just simulate them the easy way, by inserting the code into the
+ * pci_write_config and pci_read_config path.  Most of the config regi=
sters
+ * are read-only anyway, so the bulk of the simulation is just table l=
ookup.
+ */
+
+#include <linux/pci.h>
+#include <linux/init.h>
+#include <asm/olpc.h>
+#include <asm/geode.h>
+#include "pci.h"
+
+/*
+ * In the tables below, the first two line (8 longwords) are the
+ * size masks that are used when the higher level PCI code determines
+ * the size of the region by writing ~0 to a base address register
+ * and reading back the result.
+ *
+ * The following lines are the values that are read during normal
+ * PCI config access cycles, i.e. not after just having written
+ * ~0 to a base address register.
+ */
+
+static const uint32_t lxnb_hdr[] =3D {  /* dev 1 function 0 - devfn =3D=
 8 */
+	0x0,	0x0,	0x0,	0x0,
+	0x0,	0x0,	0x0,	0x0,
+
+	0x281022, 0x2200005, 0x6000021, 0x80f808,	/* AMD Vendor ID */
+	0x0,	0x0,	0x0,	0x0,   /* No virtual registers, hence no BAR */
+	0x0,	0x0,	0x0,	0x28100b,
+	0x0,	0x0,	0x0,	0x0,
+	0x0,	0x0,	0x0,	0x0,
+	0x0,	0x0,	0x0,	0x0,
+	0x0,	0x0,	0x0,	0x0,
+};
+
+static const uint32_t gxnb_hdr[] =3D {  /* dev 1 function 0 - devfn =3D=
 8 */
+	0xfffffffd, 0x0, 0x0,	0x0,
+	0x0,	0x0,	0x0,	0x0,
+
+	0x28100b, 0x2200005, 0x6000021, 0x80f808,	/* NSC Vendor ID */
+	0xac1d,	0x0,	0x0,	0x0,  /* I/O BAR - base of virtual registers */
+	0x0,	0x0,	0x0,	0x28100b,
+	0x0,	0x0,	0x0,	0x0,
+	0x0,	0x0,	0x0,	0x0,
+	0x0,	0x0,	0x0,	0x0,
+	0x0,	0x0,	0x0,	0x0,
+};
+
+static const uint32_t lxfb_hdr[] =3D {  /* dev 1 function 1 - devfn =3D=
 9 */
+	0xff000008, 0xffffc000, 0xffffc000, 0xffffc000,
+	0xffffc000,	0x0,	0x0,	0x0,
+
+	0x20811022, 0x2200003, 0x3000000, 0x0,		/* AMD Vendor ID */
+	0xfd000000, 0xfe000000, 0xfe004000, 0xfe008000, /* FB, GP, VG, DF */
+	0xfe00c000, 0x0, 0x0,	0x30100b,		/* VIP */
+	0x0,	0x0,	0x0,	0x10e,	   /* INTA, IRQ14 for graphics accel */
+	0x0,	0x0,	0x0,	0x0,
+	0x3d0,	0x3c0,	0xa0000, 0x0,	    /* VG IO, VG IO, EGA FB, MONO FB */
+	0x0,	0x0,	0x0,	0x0,
+};
+
+static const uint32_t gxfb_hdr[] =3D {  /* dev 1 function 1 - devfn =3D=
 9 */
+	0xff800008, 0xffffc000, 0xffffc000, 0xffffc000,
+	0x0,	0x0,	0x0,	0x0,
+
+	0x30100b, 0x2200003, 0x3000000, 0x0,		/* NSC Vendor ID */
+	0xfd000000, 0xfe000000, 0xfe004000, 0xfe008000,	/* FB, GP, VG, DF */
+	0x0,	0x0,	0x0,	0x30100b,
+	0x0,	0x0,	0x0,	0x0,
+	0x0,	0x0,	0x0,	0x0,
+	0x3d0,	0x3c0,	0xa0000, 0x0,  	    /* VG IO, VG IO, EGA FB, MONO FB */
+	0x0,	0x0,	0x0,	0x0,
+};
+
+static const uint32_t aes_hdr[] =3D {	/* dev 1 function 2 - devfn =3D =
0xa */
+	0xffffc000, 0x0, 0x0,	0x0,
+	0x0,	0x0,	0x0,	0x0,
+
+	0x20821022, 0x2a00006, 0x10100000, 0x8,		/* NSC Vendor ID */
+	0xfe010000, 0x0, 0x0,	0x0,			/* AES registers */
+	0x0,	0x0,	0x0,	0x20821022,
+	0x0,	0x0,	0x0,	0x0,
+	0x0,	0x0,	0x0,	0x0,
+	0x0,	0x0,	0x0,	0x0,
+	0x0,	0x0,	0x0,	0x0,
+};
+
+
+static const uint32_t isa_hdr[] =3D {  /* dev f function 0 - devfn =3D=
 78 */
+	0xfffffff9, 0xffffff01, 0xffffffc1, 0xffffffe1,
+	0xffffff81, 0xffffffc1, 0x0, 0x0,
+
+	0x20901022, 0x2a00049, 0x6010003, 0x802000,
+	0x18b1,	0x1001,	0x1801,	0x1881,	/* SMB-8   GPIO-256 MFGPT-64  IRQ-32 =
*/
+	0x1401,	0x1841,	0x0,	0x20901022,		/* PMS-128 ACPI-64 */
+	0x0,	0x0,	0x0,	0x0,
+	0x0,	0x0,	0x0,	0x0,
+	0x0,	0x0,	0x0,	0xaa5b,			/* IRQ steering */
+	0x0,	0x0,	0x0,	0x0,
+};
+
+static const uint32_t ac97_hdr[] =3D {  /* dev f function 3 - devfn =3D=
 7b */
+	0xffffff81, 0x0, 0x0,	0x0,
+	0x0,	0x0,	0x0,	0x0,
+
+	0x20931022, 0x2a00041, 0x4010001, 0x0,
+	0x1481,	0x0,	0x0,	0x0,			/* I/O BAR-128 */
+	0x0,	0x0,	0x0,	0x20931022,
+	0x0,	0x0,	0x0,	0x205,			/* IntB, IRQ5 */
+	0x0,	0x0,	0x0,	0x0,
+	0x0,	0x0,	0x0,	0x0,
+	0x0,	0x0,	0x0,	0x0,
+};
+
+static const uint32_t ohci_hdr[] =3D {  /* dev f function 4 - devfn =3D=
 7c */
+	0xfffff000, 0x0, 0x0,	0x0,
+	0x0,	0x0,	0x0,	0x0,
+
+	0x20941022, 0x2300006, 0xc031002, 0x0,
+	0xfe01a000, 0x0, 0x0,	0x0,			/* MEMBAR-1000 */
+	0x0,	0x0,	0x0,	0x20941022,
+	0x0,	0x40,	0x0,	0x40a,			/* CapPtr INT-D, IRQA */
+	0xc8020001, 0x0, 0x0,	0x0,	/* Capabilities - 40 is R/O,
+					   44 is mask 8103 (power control) */
+	0x0,	0x0,	0x0,	0x0,
+	0x0,	0x0,	0x0,	0x0,
+};
+
+static const uint32_t ehci_hdr[] =3D {  /* dev f function 4 - devfn =3D=
 7d */
+	0xfffff000, 0x0, 0x0,	0x0,
+	0x0,	0x0,	0x0,	0x0,
+
+	0x20951022, 0x2300006, 0xc032002, 0x0,
+	0xfe01b000, 0x0, 0x0,	0x0,			/* MEMBAR-1000 */
+	0x0,	0x0,	0x0,	0x20951022,
+	0x0,	0x40,	0x0,	0x40a,			/* CapPtr INT-D, IRQA */
+	0xc8020001, 0x0, 0x0,	0x0,	/* Capabilities - 40 is R/O, 44 is
+					   mask 8103 (power control) */
+#if 0
+	0x1,	0x40080000, 0x0, 0x0,	/* EECP - see EHCI spec section 2.1.7 */
+#endif
+	0x01000001, 0x0, 0x0,	0x0,	/* EECP - see EHCI spec section 2.1.7 */
+	0x2020,	0x0,	0x0,	0x0,	/* (EHCI page 8) 60 SBRN (R/O),
+					   61 FLADJ (R/W), PORTWAKECAP  */
+};
+
+static uint32_t ff_loc =3D ~0;
+static uint32_t zero_loc;
+static int bar_probing;		/* Set after a write of ~0 to a BAR */
+static int is_lx;
+
+#define NB_SLOT 0x1	/* Northbridge - GX chip - Device 1 */
+#define SB_SLOT 0xf	/* Southbridge - CS5536 chip - Device F */
+
+static int is_simulated(unsigned int bus, unsigned int devfn)
+{
+	return (!bus && ((PCI_SLOT(devfn) =3D=3D NB_SLOT) ||
+			(PCI_SLOT(devfn) =3D=3D SB_SLOT)));
+}
+
+static uint32_t *hdr_addr(const uint32_t *hdr, int reg)
+{
+	uint32_t addr;
+
+	/*
+	 * This is a little bit tricky.  The header maps consist of
+	 * 0x20 bytes of size masks, followed by 0x70 bytes of header data.
+	 * In the normal case, when not probing a BAR's size, we want
+	 * to access the header data, so we add 0x20 to the reg offset,
+	 * thus skipping the size mask area.
+	 * In the BAR probing case, we want to access the size mask for
+	 * the BAR, so we subtract 0x10 (the config header offset for
+	 * BAR0), and don't skip the size mask area.
+	 */
+
+	addr =3D (uint32_t)hdr + reg + (bar_probing ? -0x10 : 0x20);
+
+	bar_probing =3D 0;
+	return (uint32_t *)addr;
+}
+
+static int pci_olpc_read(unsigned int seg, unsigned int bus,
+		unsigned int devfn, int reg, int len, uint32_t *value)
+{
+	uint32_t *addr;
+
+	/* Use the hardware mechanism for non-simulated devices */
+	if (!is_simulated(bus, devfn))
+		return pci_direct_conf1.read(seg, bus, devfn, reg, len, value);
+
+	/*
+	 * No device has config registers past 0x70, so we save table space
+	 * by not storing entries for the nonexistent registers
+	 */
+	if (reg >=3D 0x70)
+		addr =3D &zero_loc;
+	else {
+		switch (devfn) {
+		case  0x8:
+			addr =3D hdr_addr(is_lx ? lxnb_hdr : gxnb_hdr, reg);
+			break;
+		case  0x9:
+			addr =3D hdr_addr(is_lx ? lxfb_hdr : gxfb_hdr, reg);
+			break;
+		case  0xa:
+			addr =3D is_lx ? hdr_addr(aes_hdr, reg) : &ff_loc;
+			break;
+		case 0x78:
+			addr =3D hdr_addr(isa_hdr, reg);
+			break;
+		case 0x7b:
+			addr =3D hdr_addr(ac97_hdr, reg);
+			break;
+		case 0x7c:
+			addr =3D hdr_addr(ohci_hdr, reg);
+			break;
+		case 0x7d:
+			addr =3D hdr_addr(ehci_hdr, reg);
+			break;
+		default:
+			addr =3D &ff_loc;
+			break;
+		}
+	}
+	switch (len) {
+	case 1:
+		*value =3D *(uint8_t *)addr;
+		break;
+	case 2:
+		*value =3D *(uint16_t *)addr;
+		break;
+	case 4:
+		*value =3D *addr;
+		break;
+	default:
+		BUG();
+	}
+
+	return 0;
+}
+
+static int pci_olpc_write(unsigned int seg, unsigned int bus,
+		unsigned int devfn, int reg, int len, uint32_t value)
+{
+	/* Use the hardware mechanism for non-simulated devices */
+	if (!is_simulated(bus, devfn))
+		return pci_direct_conf1.write(seg, bus, devfn, reg, len, value);
+
+	/* XXX we may want to extend this to simulate EHCI power management *=
/
+
+	/*
+	 * Mostly we just discard writes, but if the write is a size probe
+	 * (i.e. writing ~0 to a BAR), we remember it and arrange to return
+	 * the appropriate size mask on the next read.  This is cheating
+	 * to some extent, because it depends on the fact that the next
+	 * access after such a write will always be a read to the same BAR.
+	 */
+
+	if ((reg >=3D 0x10) && (reg < 0x2c)) {
+		/* write is to a BAR */
+		if (value =3D=3D ~0)
+			bar_probing =3D 1;
+	} else {
+		/*
+		 * No warning on writes to ROM BAR, CMD, LATENCY_TIMER,
+		 * CACHE_LINE_SIZE, or PM registers.
+		 */
+		if ((reg !=3D PCI_ROM_ADDRESS) && (reg !=3D PCI_COMMAND_MASTER) &&
+				(reg !=3D PCI_LATENCY_TIMER) &&
+				(reg !=3D PCI_CACHE_LINE_SIZE) && (reg !=3D 0x44))
+			printk(KERN_WARNING "OLPC PCI: Config write to devfn"
+				" %x reg %x value %x\n", devfn, reg, value);
+	}
+
+	return 0;
+}
+
+static struct pci_raw_ops pci_olpc_conf =3D {
+	.read =3D	pci_olpc_read,
+	.write =3D pci_olpc_write,
+};
+
+void __init pci_olpc_init(void)
+{
+	if (!machine_is_olpc() || olpc_has_vsa())
+		return;
+
+	printk(KERN_INFO "PCI: Using configuration type OLPC\n");
+	raw_pci_ops =3D &pci_olpc_conf;
+	is_lx =3D is_geode_lx();
+}
diff -puN arch/x86/pci/pci.h~olpc-add-one-laptop-per-child-architecture=
-support arch/x86/pci/pci.h
--- a/arch/x86/pci/pci.h~olpc-add-one-laptop-per-child-architecture-sup=
port
+++ a/arch/x86/pci/pci.h
@@ -101,6 +101,7 @@ extern int pci_direct_probe(void);
 extern void pci_direct_init(int type);
 extern void pci_pcbios_init(void);
 extern void pci_mmcfg_init(int type);
+extern void pci_olpc_init(void);
 extern void pcibios_sort(void);
=20
 /* pci-mmconfig.c */
diff -puN /dev/null include/asm-x86/olpc.h
--- /dev/null
+++ a/include/asm-x86/olpc.h
@@ -0,0 +1,135 @@
+/* OLPC machine specific definitions */
+
+#ifndef ASM_OLPC_H_
+#define ASM_OLPC_H_
+
+#include <asm/geode.h>
+
+struct olpc_platform_t {
+	int flags;
+	uint32_t boardrev;
+	int ecver;
+};
+
+#define OLPC_F_PRESENT		0x01
+#define OLPC_F_DCON		0x02
+#define OLPC_F_VSA		0x04
+
+#ifdef CONFIG_OLPC
+
+extern struct olpc_platform_t olpc_platform_info;
+
+/*
+ * OLPC board IDs contain the major build number within the mask 0x0ff=
0,
+ * and the minor build number withing 0x000f.  Pre-builds have a minor
+ * number less than 8, and normal builds start at 8.  For example, 0x0=
B10
+ * is a PreB1, and 0x0C18 is a C1.
+ */
+
+static inline uint32_t olpc_board(uint8_t id)
+{
+	return (id << 4) | 0x8;
+}
+
+static inline uint32_t olpc_board_pre(uint8_t id)
+{
+	return id << 4;
+}
+
+static inline int machine_is_olpc(void)
+{
+	return (olpc_platform_info.flags & OLPC_F_PRESENT) ? 1 : 0;
+}
+
+/*
+ * The DCON is OLPC's Display Controller.  It has a number of unique
+ * features that we might want to take advantage of..
+ */
+static inline int olpc_has_dcon(void)
+{
+	return (olpc_platform_info.flags & OLPC_F_DCON) ? 1 : 0;
+}
+
+/*
+ * The VSA is software from AMD that typical Geode bioses will include=
=2E
+ * It is used to emulate the PCI bus, VGA, etc.  OLPC's Open Firmware =
does
+ * not include the VSA; instead, PCI is emulated by the kernel.
+ *
+ * The VSA is described further in arch/x86/pci/olpc.c.
+ */
+static inline int olpc_has_vsa(void)
+{
+	return (olpc_platform_info.flags & OLPC_F_VSA) ? 1 : 0;
+}
+
+/*
+ * The "Mass Production" version of OLPC's XO is identified as being m=
odel
+ * C2.  During the prototype phase, the following models (in chronolog=
ical
+ * order) were created: A1, B1, B2, B3, B4, C1.  The A1 through B2 mod=
els
+ * were based on Geode GX CPUs, and models after that were based upon
+ * Geode LX CPUs.  There were also some hand-assembled models floating
+ * around, referred to as PreB1, PreB2, etc.
+ */
+static inline int olpc_board_at_least(uint32_t rev)
+{
+	return olpc_platform_info.boardrev >=3D rev;
+}
+
+#else
+
+static inline int machine_is_olpc(void)
+{
+	return 0;
+}
+
+static inline int olpc_has_dcon(void)
+{
+	return 0;
+}
+
+static inline int olpc_has_vsa(void)
+{
+	return 0;
+}
+
+#endif
+
+/* EC related functions */
+
+extern int olpc_ec_cmd(unsigned char cmd, unsigned char *inbuf, size_t=
 inlen,
+		unsigned char *outbuf, size_t outlen);
+
+extern int olpc_ec_mask_set(uint8_t bits);
+extern int olpc_ec_mask_unset(uint8_t bits);
+
+extern void olpc_register_battery_callback(void (*f)(unsigned long));
+extern void olpc_deregister_battery_callback(void);
+
+/* EC commands */
+
+#define EC_FIRMWARE_REV		0x08
+
+/* SCI source values */
+
+#define EC_SCI_SRC_EMPTY	0x00
+#define EC_SCI_SRC_GAME		0x01
+#define EC_SCI_SRC_BATTERY	0x02
+#define EC_SCI_SRC_BATSOC	0x04
+#define EC_SCI_SRC_BATERR	0x08
+#define EC_SCI_SRC_EBOOK	0x10
+#define EC_SCI_SRC_WLAN		0x20
+#define EC_SCI_SRC_ACPWR	0x40
+#define EC_SCI_SRC_ALL		0x7F
+
+/* GPIO assignments */
+
+#define OLPC_GPIO_MIC_AC	geode_gpio(1)
+#define OLPC_GPIO_DCON_IRQ	geode_gpio(7)
+#define OLPC_GPIO_THRM_ALRM	geode_gpio(10)
+#define OLPC_GPIO_SMB_CLK	geode_gpio(14)
+#define OLPC_GPIO_SMB_DATA	geode_gpio(15)
+#define OLPC_GPIO_WORKAUX	geode_gpio(24)
+#define OLPC_GPIO_LID		geode_gpio(26)
+#define OLPC_GPIO_ECSCI		geode_gpio(27)
+
+#endif
_

Patches currently in -mm which might be from dilinger@queued.net are

x86-geode-msr-cleanup.patch
x86-geode-add-virtual-systems-architecture-detection.patch
gxfb-use-pci_device-for-gxfbs-pci-device-table.patch
gxfb-replace-fbsize-config-option-with-a-module-parameter.patch
gxfb-create-dc-vp-fp-specific-handlers-rather-than-using-readl-writel.p=
atch
gxfb-clean-up-register-definitions.patch
gxfb-move-msr-bit-fields-into-gxfbh.patch
gxfb-stop-sharing-code-with-gx1fb.patch
gxfb-add-power-management-functionality.patch
gxfb-add-power-management-functionality-fix.patch
gxfb-add-power-management-functionality-update.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-v=
t-switch.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-v=
t-switch-fix.patch
lxfb-create-gp-dc-vp-fp-specific-handlers-rather-than-using-readl-write=
l.patch
lxfb-clean-up-register-definitions.patch
lxfb-clean-up-final-bits-of-df_regs.patch
lxfb-rearrange-rename-msr-bitfields.patch
lxfb-add-power-management-functionality.patch
lxfb-add-power-management-functionality-fix.patch
lxfb-add-power-management-functionality-update.patch
lxfb-rename-kernel-arg-fbsize-to-vram.patch
lxfb-disable-suspend-vt-switch-by-default.patch
lxfb-gxfb-when-blanking-with-fb_blank_powerdown-also-turn-off-the-crt.p=
atch
gxfb-lxfb-use-vsa-definitions-when-fetching-framebuffer-size.patch
gxfb-lxfb-detect-framebuffer-size-using-an-msr-if-vsa2-isnt-available.p=
atch
olpc-gxfb-lxfb-add-dcon-panel-modes-to-framebuffer-drivers.patch
x86-olpc-add-one-laptop-per-child-architecture-support.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
