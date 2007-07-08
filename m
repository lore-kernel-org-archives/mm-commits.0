From: akpm@linux-foundation.org
Subject: + retrieve-vbe-edid-ddc-info-independent-of-used-video.patch added to -mm tree
Date: Sun, 08 Jul 2007 11:13:32 -0700
Message-ID: <200707081813.l68IDW4E014056@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49889 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757144AbXGHSOB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jul 2007 14:14:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, adaplas@pol.net, ak@suse.de, dsd@gentoo.org, hpa@zytor.com


The patch titled
     retrieve VBE EDID/DDC info independent of used video mode
has been added to the -mm tree.  Its filename is
     retrieve-vbe-edid-ddc-info-independent-of-used-video.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: retrieve VBE EDID/DDC info independent of used video mode
From: "Jan Beulich" <jbeulich@novell.com>

The code to retrieve this information was (a) inside a CONFIG_VIDEO_SELECT
section and (b) protected by a check of a variable (vbe_version) that would
get initialized only when a VESA mode was selected on the command line.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Daniel Drake <dsd@gentoo.org>
Cc: Andi Kleen <ak@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/boot/video.S |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff -puN arch/i386/boot/video.S~retrieve-vbe-edid-ddc-info-independent-of-used-video arch/i386/boot/video.S
--- a/arch/i386/boot/video.S~retrieve-vbe-edid-ddc-info-independent-of-used-video
+++ a/arch/i386/boot/video.S
@@ -96,6 +96,7 @@
 #define PARAM_LFB_PAGES		0x32
 #define PARAM_VESA_ATTRIB	0x34
 #define PARAM_CAPABILITIES	0x36
+#define PARAM_EDID_INFO		0x140
 
 /* Define DO_STORE according to CONFIG_VIDEO_RETAIN */
 #ifdef CONFIG_VIDEO_RETAIN
@@ -132,8 +133,8 @@ vid1:
 #ifdef CONFIG_VIDEO_RETAIN
 	call	restore_screen			# Restore screen contents
 #endif /* CONFIG_VIDEO_RETAIN */
-	call	store_edid
 #endif /* CONFIG_VIDEO_SELECT */
+	call	store_edid
 	call	mode_params			# Store mode parameters
 	popw	%ds				# Restore original DS
 	ret
@@ -571,16 +572,12 @@ setr1:	lodsw
 	jmp	_m_s
 
 check_vesa:
-#ifdef CONFIG_FIRMWARE_EDID
 	leaw	modelist+1024, %di
 	movw	$0x4f00, %ax
 	int	$0x10
 	cmpw	$0x004f, %ax
 	jnz	setbad
 
-	movw	4(%di), %ax
-	movw	%ax, vbe_version
-#endif
 	leaw	modelist+1024, %di
 	subb	$VIDEO_FIRST_VESA>>8, %bh
 	movw	%bx, %cx			# Get mode information structure
@@ -1935,6 +1932,7 @@ skip10:	movb	%ah, %al
 	popw	%cx
 	popw	%ax
 	ret
+#endif /* CONFIG_VIDEO_SELECT */
 
 store_edid:
 #ifdef CONFIG_FIRMWARE_EDID
@@ -1945,18 +1943,28 @@ store_edid:
 	pushw	%dx
 	pushw   %di
 
+	pushw	%ds
+	popw    %es
+	leaw	modelist, %di
+	movw	$0x4f00, %ax
+	int	$0x10
+	cmpw	$0x004f, %ax
+	setne	%dl
+	cmpw	$0x0200, 4(%di)			# only do EDID on >= VBE2.0
+	adc	%dl, %dl
+
 	pushw	%fs
 	popw    %es
 
 	movl	$0x13131313, %eax		# memset block with 0x13
 	movw    $32, %cx
-	movw	$0x140, %di
+	movw	$PARAM_EDID_INFO, %di
 	cld
 	rep
 	stosl
 
-	cmpw	$0x0200, vbe_version		# only do EDID on >= VBE2.0
-	jl	no_edid
+	testb	%dl, %dl
+	jnz	no_edid
 
 	pushw   %es				# save ES
 	xorw    %di, %di                        # Report Capability
@@ -1978,7 +1986,7 @@ store_edid:
 	movw	$0x01, %bx
 	movw	$0x00, %cx
 	movw    $0x00, %dx
-	movw	$0x140, %di
+	movw	$PARAM_EDID_INFO, %di
 	int	$0x10
 
 no_edid:
@@ -1991,6 +1999,7 @@ no_edid:
 #endif
 	ret
 
+#ifdef CONFIG_VIDEO_SELECT
 # VIDEO_SELECT-only variables
 mt_end:		.word	0	# End of video mode table if built
 edit_buf:	.space	6	# Line editor buffer
@@ -2000,7 +2009,6 @@ do_restore:	.byte	0	# Screen contents al
 svga_prefix:	.byte	VIDEO_FIRST_BIOS>>8	# Default prefix for BIOS modes
 graphic_mode:	.byte	0	# Graphic mode with a linear frame buffer
 dac_size:	.byte	6	# DAC bit depth
-vbe_version:	.word	0	# VBE bios version
 
 # Status messages
 keymsg:		.ascii	"Press <RETURN> to see video modes available, "
_

Patches currently in -mm which might be from jbeulich@novell.com are

retrieve-vbe-edid-ddc-info-independent-of-used-video.patch
modpost-white-list-pattern-adjustment.patch
remove-pci_dac_dma_-apis.patch
more-fix-x86_64-mm-xen-xen-smp-guest-support.patch
i386-minor-nx-handling-adjustment.patch
i386-minor-nx-handling-adjustment-fix.patch
x86-smp-alt-once-option-is-only-useful-with-hotplug_cpu.patch
x86-64-remove-unused-variable-maxcpus.patch
mm-fix-improper-init-type-section-references.patch
page-table-handling-cleanup.patch
kill-vmalloc_earlyreserve.patch
adjust-nosmp-handling.patch
