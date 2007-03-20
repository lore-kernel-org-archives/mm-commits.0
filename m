From: akpm@linux-foundation.org
Subject: + x86_64-i386-add-command-line-length-to-boot-protocol.patch added to -mm tree
Date: Mon, 19 Mar 2007 22:42:53 -0800
Message-ID: <200703200642.l2K6grDf027815@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49626 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932102AbXCTGm7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Mar 2007 02:42:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de, ak@suse.de, alon.barlev@gmail.com, hpa@zytor.com


The patch titled
     x86_64, i386: add command line length to boot protocol
has been added to the -mm tree.  Its filename is
     x86_64-i386-add-command-line-length-to-boot-protocol.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64, i386: add command line length to boot protocol
From: Bernhard Walle <bwalle@suse.de>

Because the command line is increased to 2048 characters after 2.6.21, it's
not possible for boot loaders and userspace tools to determine the length
of the command line the kernel can understand.  The benefit of knowing the
length is that users can be warned if the command line size is too long
which prevents surprise if things don't work after bootup.

This patch updates the boot protocol to contain a field called
"cmdline_size" that contain the length of the command line (excluding the
terminating zero).

The patch also adds missing fields (of protocol version 2.05) to the x86_64
setup code.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: Alon Bar-Lev <alon.barlev@gmail.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/i386/boot.txt |   23 +++++++++++++++++------
 arch/i386/boot/setup.S      |    7 ++++++-
 arch/x86_64/boot/setup.S    |   15 ++++++++++++++-
 3 files changed, 37 insertions(+), 8 deletions(-)

diff -puN arch/i386/boot/setup.S~x86_64-i386-add-command-line-length-to-boot-protocol arch/i386/boot/setup.S
--- a/arch/i386/boot/setup.S~x86_64-i386-add-command-line-length-to-boot-protocol
+++ a/arch/i386/boot/setup.S
@@ -52,6 +52,7 @@
 #include <asm/boot.h>
 #include <asm/e820.h>
 #include <asm/page.h>
+#include <asm/setup.h>
 	
 /* Signature words to ensure LILO loaded us right */
 #define SIG1	0xAA55
@@ -81,7 +82,7 @@ start:
 # This is the setup header, and it must start at %cs:2 (old 0x9020:2)
 
 		.ascii	"HdrS"		# header signature
-		.word	0x0205		# header version number (>= 0x0105)
+		.word	0x0206		# header version number (>= 0x0105)
 					# or else old loadlin-1.5 will fail)
 realmode_swtch:	.word	0, 0		# default_switch, SETUPSEG
 start_sys_seg:	.word	SYSSEG
@@ -171,6 +172,10 @@ relocatable_kernel:    .byte 0
 pad2:			.byte 0
 pad3:			.word 0
 
+cmdline_size:   .long   COMMAND_LINE_SIZE-1     #length of the command line,
+                                                #added with boot protocol
+                                                #version 2.06
+
 trampoline:	call	start_of_setup
 		.align 16
 					# The offset at this point is 0x240
diff -puN arch/x86_64/boot/setup.S~x86_64-i386-add-command-line-length-to-boot-protocol arch/x86_64/boot/setup.S
--- a/arch/x86_64/boot/setup.S~x86_64-i386-add-command-line-length-to-boot-protocol
+++ a/arch/x86_64/boot/setup.S
@@ -51,6 +51,7 @@
 #include <asm/boot.h>
 #include <asm/e820.h>
 #include <asm/page.h>
+#include <asm/setup.h>
 
 /* Signature words to ensure LILO loaded us right */
 #define SIG1	0xAA55
@@ -80,7 +81,7 @@ start:
 # This is the setup header, and it must start at %cs:2 (old 0x9020:2)
 
 		.ascii	"HdrS"		# header signature
-		.word	0x0204		# header version number (>= 0x0105)
+		.word	0x0206		# header version number (>= 0x0105)
 					# or else old loadlin-1.5 will fail)
 realmode_swtch:	.word	0, 0		# default_switch, SETUPSEG
 start_sys_seg:	.word	SYSSEG
@@ -155,6 +156,18 @@ cmd_line_ptr:	.long 0			# (Header versio
 					# low memory 0x10000 or higher.
 
 ramdisk_max:	.long 0xffffffff
+
+kernel_alignment:  .long CONFIG_PHYSICAL_START 	#physical addr alignment
+						#(not relocatable =>
+						#fixed start == alignment)
+
+relocatable_kernel:     .byte 0                 #x86_64 is currently not
+pad2:			.byte 0                 #relocatable
+pad3:			.word 0
+
+cmdline_size:   .long   COMMAND_LINE_SIZE-1     #length of the command line,
+                                                #added with boot protocol
+                                                #version 2.06
 	
 trampoline:	call	start_of_setup
 		.align 16
diff -puN Documentation/i386/boot.txt~x86_64-i386-add-command-line-length-to-boot-protocol Documentation/i386/boot.txt
--- a/Documentation/i386/boot.txt~x86_64-i386-add-command-line-length-to-boot-protocol
+++ a/Documentation/i386/boot.txt
@@ -2,7 +2,7 @@
 		     ----------------------------
 
 		    H. Peter Anvin <hpa@zytor.com>
-			Last update 2007-01-26
+			Last update 2007-03-06
 
 On the i386 platform, the Linux kernel uses a rather complicated boot
 convention.  This has evolved partially due to historical aspects, as
@@ -35,9 +35,13 @@ Protocol 2.03:	(Kernel 2.4.18-pre1) Expl
 		initrd address available to the bootloader.
 
 Protocol 2.04:	(Kernel 2.6.14) Extend the syssize field to four bytes.
+
 Protocol 2.05:	(Kernel 2.6.20) Make protected mode kernel relocatable.
 		Introduce relocatable_kernel and kernel_alignment fields.
 
+Protocol 2.06:	(Kernel 2.6.22) Added a field that contains the size of
+		the boot command line
+
 
 **** MEMORY LAYOUT
 
@@ -133,6 +137,8 @@ Offset	Proto	Name		Meaning
 022C/4	2.03+	initrd_addr_max	Highest legal initrd address
 0230/4	2.05+	kernel_alignment Physical addr alignment required for kernel
 0234/1	2.05+	relocatable_kernel Whether kernel is relocatable or not
+0235/3	N/A	pad2		Unused
+0238/4	2.06+	cmdline_size	Maximum size of the kernel command line
 
 (1) For backwards compatibility, if the setup_sects field contains 0, the
     real value is 4.
@@ -233,6 +239,12 @@ filled out, however:
 	if your ramdisk is exactly 131072 bytes long and this field is
 	0x37FFFFFF, you can start your ramdisk at 0x37FE0000.)
 
+  cmdline_size:
+	The maximum size of the command line without the terminating
+	zero. This means that the command line can contain at most
+	cmdline_size characters. With protocol version 2.05 and
+	earlier, the maximum size was 255.
+
 
 **** THE KERNEL COMMAND LINE
 
@@ -241,11 +253,10 @@ loader to communicate with the kernel.  
 relevant to the boot loader itself, see "special command line options"
 below.
 
-The kernel command line is a null-terminated string currently up to
-255 characters long, plus the final null.  A string that is too long
-will be automatically truncated by the kernel, a boot loader may allow
-a longer command line to be passed to permit future kernels to extend
-this limit.
+The kernel command line is a null-terminated string. The maximum
+length can be retrieved from the field cmdline_size.  Before protocol
+version 2.06, the maximum was 255 characters.  A string that is too
+long will be automatically truncated by the kernel.
 
 If the boot protocol version is 2.02 or later, the address of the
 kernel command line is given by the header field cmd_line_ptr (see
_

Patches currently in -mm which might be from bwalle@suse.de are

origin.patch
x86_64-i386-add-command-line-length-to-boot-protocol.patch
