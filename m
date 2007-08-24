From: akpm@linux-foundation.org
Subject: + mips-replace-config_usb_ohci-with-config_usb_ohci_hcd-in-a-few-overlooked-files.patch added to -mm tree
Date: Fri, 24 Aug 2007 16:28:04 -0700
Message-ID: <200708242328.l7ONS4sY020222@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41098 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755181AbXHXX2v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 19:28:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: blaisorblade@yahoo.it, giuseppe.patane@tvblob.com, ralf@linux-mips.org


The patch titled
     mips: replace CONFIG_USB_OHCI with CONFIG_USB_OHCI_HCD in a few ov=
erlooked files
has been added to the -mm tree.  Its filename is
     mips-replace-config_usb_ohci-with-config_usb_ohci_hcd-in-a-few-ove=
rlooked-files.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: mips: replace CONFIG_USB_OHCI with CONFIG_USB_OHCI_HCD in a fe=
w overlooked files
=46rom: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>

=46inish the rename of CONFIG_USB_OHCI to CONFIG_USB_OHCI_HCD, which st=
arted
in 2005 (before 2.6.12-rc2).  The patch in this message has not been
applied yet; moreover, it is not something to fix afterwards.  I've
verified that no more instances of 'CONFIG_USB_[UOE]HCI\>' exist in the
source tree.

http://www.linux-mips.org/archives/linux-mips/2005-06/msg00060.html

I'm also sending a script to detect undefined Kconfig variables in next=
 patch.

Thanks to my colleague Giuseppe Patan=C3=A8 for the original report: he=
 discovered
the original mail (above) and for verified that the fix had not yet bee=
n
applied.

Cc: Giuseppe Patan=C3=A8 <giuseppe.patane@tvblob.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/au1000/mtx-1/board_setup.c  |    4 ++--
 arch/mips/au1000/pb1000/board_setup.c |    6 +++---
 arch/mips/au1000/pb1100/board_setup.c |    4 ++--
 arch/mips/au1000/pb1500/board_setup.c |    6 +++---
 4 files changed, 10 insertions(+), 10 deletions(-)

diff -puN arch/mips/au1000/mtx-1/board_setup.c~mips-replace-config_usb_=
ohci-with-config_usb_ohci_hcd-in-a-few-overlooked-files arch/mips/au100=
0/mtx-1/board_setup.c
--- a/arch/mips/au1000/mtx-1/board_setup.c~mips-replace-config_usb_ohci=
-with-config_usb_ohci_hcd-in-a-few-overlooked-files
+++ a/arch/mips/au1000/mtx-1/board_setup.c
@@ -54,11 +54,11 @@ void board_reset (void)
=20
 void __init board_setup(void)
 {
-#ifdef CONFIG_USB_OHCI
+#ifdef CONFIG_USB_OHCI_HCD
 	// enable USB power switch
 	au_writel( au_readl(GPIO2_DIR) | 0x10, GPIO2_DIR );
 	au_writel( 0x100000, GPIO2_OUTPUT );
-#endif // defined (CONFIG_USB_OHCI)
+#endif // defined (CONFIG_USB_OHCI_HCD)
=20
 #ifdef CONFIG_PCI
 #if defined(__MIPSEB__)
diff -puN arch/mips/au1000/pb1000/board_setup.c~mips-replace-config_usb=
_ohci-with-config_usb_ohci_hcd-in-a-few-overlooked-files arch/mips/au10=
00/pb1000/board_setup.c
--- a/arch/mips/au1000/pb1000/board_setup.c~mips-replace-config_usb_ohc=
i-with-config_usb_ohci_hcd-in-a-few-overlooked-files
+++ a/arch/mips/au1000/pb1000/board_setup.c
@@ -54,7 +54,7 @@ void __init board_setup(void)
 	au_writel(0, SYS_PINSTATERD);
 	udelay(100);
=20
-#ifdef CONFIG_USB_OHCI
+#ifdef CONFIG_USB_OHCI_HCD
 	/* zero and disable FREQ2 */
 	sys_freqctrl =3D au_readl(SYS_FREQCTRL0);
 	sys_freqctrl &=3D ~0xFFF00000;
@@ -102,7 +102,7 @@ void __init board_setup(void)
 	/*
 	 * Route 48MHz FREQ2 into USB Host and/or Device
 	 */
-#ifdef CONFIG_USB_OHCI
+#ifdef CONFIG_USB_OHCI_HCD
 	sys_clksrc |=3D ((4<<12) | (0<<11) | (0<<10));
 #endif
 	au_writel(sys_clksrc, SYS_CLKSRC);
@@ -116,7 +116,7 @@ void __init board_setup(void)
 	au_writel(pin_func, SYS_PINFUNC);
 	au_writel(0x2800, SYS_TRIOUTCLR);
 	au_writel(0x0030, SYS_OUTPUTCLR);
-#endif // defined (CONFIG_USB_OHCI)
+#endif // defined (CONFIG_USB_OHCI_HCD)
=20
 	// make gpio 15 an input (for interrupt line)
 	pin_func =3D au_readl(SYS_PINFUNC) & (u32)(~0x100);
diff -puN arch/mips/au1000/pb1100/board_setup.c~mips-replace-config_usb=
_ohci-with-config_usb_ohci_hcd-in-a-few-overlooked-files arch/mips/au10=
00/pb1100/board_setup.c
--- a/arch/mips/au1000/pb1100/board_setup.c~mips-replace-config_usb_ohc=
i-with-config_usb_ohci_hcd-in-a-few-overlooked-files
+++ a/arch/mips/au1000/pb1100/board_setup.c
@@ -54,7 +54,7 @@ void __init board_setup(void)
 	au_writel(0, SYS_PININPUTEN);
 	udelay(100);
=20
-#ifdef CONFIG_USB_OHCI
+#ifdef CONFIG_USB_OHCI_HCD
 	{
 		u32 pin_func, sys_freqctrl, sys_clksrc;
=20
@@ -98,7 +98,7 @@ void __init board_setup(void)
 		pin_func |=3D 0x8000;
 		au_writel(pin_func, SYS_PINFUNC);
 	}
-#endif // defined (CONFIG_USB_OHCI)
+#endif // defined (CONFIG_USB_OHCI_HCD)
=20
 	/* Enable sys bus clock divider when IDLE state or no bus activity. *=
/
 	au_writel(au_readl(SYS_POWERCTRL) | (0x3 << 5), SYS_POWERCTRL);
diff -puN arch/mips/au1000/pb1500/board_setup.c~mips-replace-config_usb=
_ohci-with-config_usb_ohci_hcd-in-a-few-overlooked-files arch/mips/au10=
00/pb1500/board_setup.c
--- a/arch/mips/au1000/pb1500/board_setup.c~mips-replace-config_usb_ohc=
i-with-config_usb_ohci_hcd-in-a-few-overlooked-files
+++ a/arch/mips/au1000/pb1500/board_setup.c
@@ -56,7 +56,7 @@ void __init board_setup(void)
 	au_writel(0, SYS_PINSTATERD);
 	udelay(100);
=20
-#ifdef CONFIG_USB_OHCI
+#ifdef CONFIG_USB_OHCI_HCD
=20
 	/* GPIO201 is input for PCMCIA card detect */
 	/* GPIO203 is input for PCMCIA interrupt request */
@@ -85,7 +85,7 @@ void __init board_setup(void)
 	/*
 	 * Route 48MHz FREQ2 into USB Host and/or Device
 	 */
-#ifdef CONFIG_USB_OHCI
+#ifdef CONFIG_USB_OHCI_HCD
 	sys_clksrc |=3D ((4<<12) | (0<<11) | (0<<10));
 #endif
 	au_writel(sys_clksrc, SYS_CLKSRC);
@@ -95,7 +95,7 @@ void __init board_setup(void)
 	// 2nd USB port is USB host
 	pin_func |=3D 0x8000;
 	au_writel(pin_func, SYS_PINFUNC);
-#endif // defined (CONFIG_USB_OHCI)
+#endif // defined (CONFIG_USB_OHCI_HCD)
=20
=20
=20
_

Patches currently in -mm which might be from blaisorblade@yahoo.it are

mips-replace-config_usb_ohci-with-config_usb_ohci_hcd-in-a-few-overlook=
ed-files.patch
usbmon-doc-update-mention-new-wildcard-0-bus.patch
uml-move-userspace-code-to-userspace-file.patch
uml-tidy-recently-moved-code.patch
uml-fix-error-cleanup-ordering.patch
uml-console-subsystem-tidying.patch
