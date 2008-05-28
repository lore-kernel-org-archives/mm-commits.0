From: akpm@linux-foundation.org
Subject: + tridentfb-documentation-update.patch added to -mm tree
Date: Tue, 27 May 2008 20:46:43 -0700
Message-ID: <200805280346.m4S3khdU027472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752104AbYE1Dqs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 23:46:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     tridentfb: documentation update
has been added to the -mm tree.  Its filename is
     tridentfb-documentation-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tridentfb: documentation update
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Make the tridentfb documentation closer to current state of the tridentfb
driver.  Fix also some formatting.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fb/tridentfb.txt |   46 ++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 15 deletions(-)

diff -puN Documentation/fb/tridentfb.txt~tridentfb-documentation-update Documentation/fb/tridentfb.txt
--- a/Documentation/fb/tridentfb.txt~tridentfb-documentation-update
+++ a/Documentation/fb/tridentfb.txt
@@ -3,11 +3,25 @@ Tridentfb is a framebuffer driver for so
 The following list of chips is thought to be supported although not all are
 tested:
 
-those from the Image series with Cyber in their names - accelerated
-those with Blade in their names (Blade3D,CyberBlade...) - accelerated
-the newer CyberBladeXP family  - nonaccelerated
-
-Only PCI/AGP based cards are supported, none of the older Tridents.
+those from the TGUI series 9440/96XX and with Cyber in their names
+those from the Image series and with Cyber in their names
+those with Blade in their names (Blade3D,CyberBlade...)
+the newer CyberBladeXP family
+
+All families are accelerated. Only PCI/AGP based cards are supported,
+none of the older Tridents.
+The driver supports 8, 16 and 32 bits per pixel depths.
+The TGUI family requires a line length to be power of 2 if acceleration
+is enabled. This means that range of possible resolutions and bpp is
+limited comparing to the range if acceleration is disabled (see list
+of parameters below).
+
+Known bugs:
+1. The driver randomly locks up on 3DImage975 chip with acceleration
+   enabled. The same happens in X11 (Xorg).
+2. The ramdac speeds require some more fine tuning. It is possible to
+   switch resolution which the chip does not support at some depths for
+   older chips.
 
 How to use it?
 ==============
@@ -17,12 +31,11 @@ video=tridentfb
 
 The parameters for tridentfb are concatenated with a ':' as in this example.
 
-video=tridentfb:800x600,bpp=16,noaccel
+video=tridentfb:800x600-16@75,noaccel
 
 The second level parameters that tridentfb understands are:
 
 noaccel - turns off acceleration (when it doesn't work for your card)
-accel - force text acceleration (for boards which by default are noacceled)
 
 fp	- use flat panel related stuff
 crt 	- assume monitor is present instead of fp
@@ -31,21 +44,24 @@ center 	- for flat panels and resolution
 	  image, otherwise use
 stretch
 
-memsize - integer value in Kb, use if your card's memory size is misdetected.
+memsize - integer value in KB, use if your card's memory size is misdetected.
 	  look at the driver output to see what it says when initializing.
-memdiff - integer value in Kb,should be nonzero if your card reports
-	  more memory than it actually has.For instance mine is 192K less than
+
+memdiff - integer value in KB, should be nonzero if your card reports
+	  more memory than it actually has. For instance mine is 192K less than
 	  detection says in all three BIOS selectable situations 2M, 4M, 8M.
 	  Only use if your video memory is taken from main memory hence of
-	  configurable size.Otherwise use memsize.
-	  If in some modes which barely fit the memory you see garbage at the bottom
-	  this might help by not letting change to that mode anymore.
+	  configurable size. Otherwise use memsize.
+	  If in some modes which barely fit the memory you see garbage
+	  at the bottom this might help by not letting change to that mode
+	  anymore.
 
 nativex - the width in pixels of the flat panel.If you know it (usually 1024
 	  800 or 1280) and it is not what the driver seems to detect use it.
 
-bpp  - bits per pixel (8,16 or 32)
-mode - a mode name like 800x600 (as described in Documentation/fb/modedb.txt)
+bpp	- bits per pixel (8,16 or 32)
+mode	- a mode name like 800x600-8@75 as described in
+	  Documentation/fb/modedb.txt
 
 Using insane values for the above parameters will probably result in driver
 misbehaviour so take care(for instance memsize=12345678 or memdiff=23784 or
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

tridentfb-replace-macros-with-functions.patch
tridentfb-convert-fb_info-into-allocated-one.patch
tridentfb-move-global-pseudo-palette-into-structure.patch
tridentfb-move-global-chip_id-into-structure.patch
tridentfb-move-global-flat-panel-variable-into-structure.patch
tridentfb-convert-is_blade-and-is_xp-macros-into-functions.patch
tridentfb-move-global-acceleration-hooks-into-structure.patch
tridentfb-make-use-of-functions-and-constants-from-the-vgah.patch
tridentfb-fix-timing-calculations.patch
tridentfb-use-mmio-access-for-clock-setting.patch
tridentfb-fix-clock-settings-for-older-trident-96xx-chips.patch
tridentfb-improve-probe-function.patch
tridentfb-improved-register-values-on-tgui-9680.patch
tridentfb-add-tgui-9440-support.patch
tridentfb-fix-unitialized-pseudo_palette.patch
tridentfb-improve-check_var-function.patch
tridentfb-preserve-memory-type-settings.patch
tridentfb-fix-hi-color-modes-for-tgui-9440.patch
tridentfb-add-acceleration-for-tgui-families.patch
tridentfb-acceleration-code-improvements.patch
tridentfb-acceleration-bug-fixes.patch
tridentfb-various-pixclock-and-timing-improvements.patch
tridentfb-acceleration-constants-change.patch
tridentfb-source-code-improvements.patch
tridentfb-fix-console-freeze-when-switching-from-x11.patch
tridentfb-fix-224-color-logo-at-8-bpp.patch
amifb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
atafb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
fbcon-make-logo_height-a-local-variable.patch
uvesafb-change-mode-parameter-to-mode_option.patch
tridentfb-documentation-update.patch
fbcon-fix-wrong-vmode-bits-copied-on-console-switch.patch
tdfxfb-add-mode_option-module-parameter.patch
vga16fb-source-code-improvement.patch

