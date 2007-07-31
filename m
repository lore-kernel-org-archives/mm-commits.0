From: akpm@linux-foundation.org
Subject: - various-doc-kernel-parameters-fixes.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:55:09 -0700
Message-ID: <200707312355.l6VNt95Q029209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43505 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764181AbXHAAR0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:17:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, jesper.juhl@gmail.com, mm-commits@vger.kernel.org


The patch titled
     various doc/kernel-parameters fixes
has been removed from the -mm tree.  Its filename was
     various-doc-kernel-parameters-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: various doc/kernel-parameters fixes
From: Randy Dunlap <randy.dunlap@oracle.com>

- tell what APIC (by request), MTD, & PARIDE mean
- correct some source file names
- remove IA64 "llsc*=" (seems to have been removed from source tree)
- removel SCSI "53c7xx=" (driver already removed)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff -puN Documentation/kernel-parameters.txt~various-doc-kernel-parameters-fixes Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~various-doc-kernel-parameters-fixes
+++ a/Documentation/kernel-parameters.txt
@@ -58,14 +58,14 @@ parameter is applicable:
 	MDA	MDA console support is enabled.
 	MOUSE	Appropriate mouse support is enabled.
 	MSI	Message Signaled Interrupts (PCI).
-	MTD	MTD support is enabled.
+	MTD	MTD (Memory Technology Device) support is enabled.
 	NET	Appropriate network support is enabled.
 	NUMA	NUMA support is enabled.
 	GENERIC_TIME The generic timeofday code is enabled.
 	NFS	Appropriate NFS support is enabled.
 	OSS	OSS sound support is enabled.
-	PV_OPS	A paravirtualized kernel
-	PARIDE	The ParIDE subsystem is enabled.
+	PV_OPS	A paravirtualized kernel is enabled.
+	PARIDE	The ParIDE (parallel port IDE) subsystem is enabled.
 	PARISC	The PA-RISC architecture is enabled.
 	PCI	PCI bus support is enabled.
 	PCMCIA	The PCMCIA subsystem is enabled.
@@ -123,10 +123,6 @@ and is between 256 and 4096 characters. 
 ./include/asm/setup.h as COMMAND_LINE_SIZE.
 
 
-	53c7xx=		[HW,SCSI] Amiga SCSI controllers
-			See header of drivers/scsi/53c7xx.c.
-			See also Documentation/scsi/ncr53c7xx.txt.
-
 	acpi=		[HW,ACPI,X86-64,i386]
 			Advanced Configuration and Power Interface
 			Format: { force | off | ht | strict | noirq }
@@ -286,7 +282,8 @@ and is between 256 and 4096 characters. 
 			not play well with APC CPU idle - disable it if you have
 			APC and your system crashes randomly.
 
-	apic=		[APIC,i386] Change the output verbosity whilst booting
+	apic=		[APIC,i386] Advanced Programmable Interrupt Controller
+			Change the output verbosity whilst booting
 			Format: { quiet (default) | verbose | debug }
 			Change the amount of debugging information output
 			when initialising the APIC and IO-APIC components.
@@ -775,7 +772,8 @@ and is between 256 and 4096 characters. 
 			See Documentation/nfsroot.txt.
 
 	ip2=		[HW] Set IO/IRQ pairs for up to 4 IntelliPort boards
-			See comment before ip2_setup() in drivers/char/ip2.c.
+			See comment before ip2_setup() in
+			drivers/char/ip2/ip2base.c.
 
 	ips=		[HW,SCSI] Adaptec / IBM ServeRAID controller
 			See header of drivers/scsi/ips.c.
@@ -871,9 +869,6 @@ and is between 256 and 4096 characters. 
 			if PNPBIOS or ACPI should describe them.  This
 			is for working around firmware defects.
 
-	llsc*=		[IA64] See function print_params() in
-			arch/ia64/sn/kernel/llsc4.c.
-
 	load_ramdisk=	[RAM] List of ramdisks to load from floppy
 			See Documentation/ramdisk.txt.
 
@@ -1046,7 +1041,7 @@ and is between 256 and 4096 characters. 
 			<name>,<region-number>[,<base>,<size>,<buswidth>,<altbuswidth>]
 
 	mtdparts=	[MTD]
-			See drivers/mtd/cmdline.c.
+			See drivers/mtd/cmdlinepart.c.
 
 	mtouchusb.raw_coordinates=
 			[HW] Make the MicroTouch USB driver use raw coordinates
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
fix-auditscc-kernel-doc.patch
git-mtd.patch
aha152x-in-debug-mode.patch
git-unionfs.patch
git-ipwireless_cs.patch
fix-kgdb-kernel-doc.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
profile-likely-unlikely-macros.patch
