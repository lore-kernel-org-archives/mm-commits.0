From: akpm@linux-foundation.org
Subject: + x86-dont-probe-for-ddc-on-vbe12-fix.patch added to -mm tree
Date: Thu, 15 Feb 2007 19:37:54 -0800
Message-ID: <200702160337.l1G3btXV018313@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48374 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423108AbXBPDiW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 22:38:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zwane@infradead.org, ak@suse.de, hpa@zytor.com, randy.dunlap@oracle.com, tobias.hain@gmx.de


The patch titled
     x86-dont-probe-for-ddc-on-vbe12 fix
has been added to the -mm tree.  Its filename is
     x86-dont-probe-for-ddc-on-vbe12-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86-dont-probe-for-ddc-on-vbe12 fix
From: Zwane Mwaikambo <zwane@infradead.org>

Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Tobias Hain <tobias.hain@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/boot/video.S   |    4 ++--
 arch/x86_64/boot/video.S |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/i386/boot/video.S~x86-dont-probe-for-ddc-on-vbe12-fix arch/i386/boot/video.S
--- a/arch/i386/boot/video.S~x86-dont-probe-for-ddc-on-vbe12-fix
+++ a/arch/i386/boot/video.S
@@ -1956,8 +1956,8 @@ store_edid:
 	cmpw	$0x004f, %ax
 	jne	no_edid
 
-	cmpw	$0x0102, 4(%di)			# only do EDID on > 1.2
-	jle	no_edid
+	cmpw	$0x0200, 4(%di)			# only do EDID on >= VBE2.0
+	jl	no_edid
 
 	pushw   %es				# save ES
 	xorw    %di, %di                        # Report Capability
diff -puN arch/x86_64/boot/video.S~x86-dont-probe-for-ddc-on-vbe12-fix arch/x86_64/boot/video.S
--- a/arch/x86_64/boot/video.S~x86-dont-probe-for-ddc-on-vbe12-fix
+++ a/arch/x86_64/boot/video.S
@@ -1956,8 +1956,8 @@ store_edid:
 	cmpw	$0x004f, %ax
 	jne	no_edid
 
-	cmpw	$0x0102, 4(%di)			# only do EDID on > 1.2
-	jle	no_edid
+	cmpw	$0x0200, 4(%di)			# only do EDID on >= VBE2.0
+	jl	no_edid
 
 	pushw   %es				# save ES
 	xorw    %di, %di                        # Report Capability
_

Patches currently in -mm which might be from zwane@infradead.org are

git-agpgart.patch
fix-mtrr-compat-ioctl.patch
x86-dont-probe-for-ddc-on-vbe12.patch
x86-dont-probe-for-ddc-on-vbe12-fix.patch
