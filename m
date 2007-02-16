From: akpm@linux-foundation.org
Subject: + x86-dont-probe-for-ddc-on-vbe12.patch added to -mm tree
Date: Thu, 15 Feb 2007 17:01:31 -0800
Message-ID: <200702160101.l1G11V8Z014930@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41568 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791AbXBPBBr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 20:01:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zwane@infradead.org, ak@suse.de, hpa@zytor.com, randy.dunlap@oracle.com, tobias.hain@gmx.de


The patch titled
     x86: don't probe for DDC on VBE1.2
has been added to the -mm tree.  Its filename is
     x86-dont-probe-for-ddc-on-vbe12.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86: don't probe for DDC on VBE1.2
From: Zwane Mwaikambo <zwane@infradead.org>

VBE1.2 doesn't support function 15h (DDC) resulting in a 'hang' whilst
uncompressing kernel with some video cards. Make sure we check VBE version
before fiddling around with DDC.

http://bugzilla.kernel.org/show_bug.cgi?id=1458

Opened: 2003-10-30 09:12 Last update: 2007-02-13 22:03

:(

Signed-off-by: Zwane Mwaikambo <zwane@infradead.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Tobias Hain <tobias.hain@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/boot/video.S   |   14 ++++++++++++++
 arch/x86_64/boot/video.S |   14 ++++++++++++++
 2 files changed, 28 insertions(+)

diff -puN arch/i386/boot/video.S~x86-dont-probe-for-ddc-on-vbe12 arch/i386/boot/video.S
--- a/arch/i386/boot/video.S~x86-dont-probe-for-ddc-on-vbe12
+++ a/arch/i386/boot/video.S
@@ -1945,6 +1945,20 @@ store_edid:
 	rep
 	stosl
 
+	pushw	%es
+	pushw	%ds
+	popw	%es
+	leaw	modelist+1024, %di
+	movw	$0x4f00, %ax
+	int	$0x10
+	popw	%es
+
+	cmpw	$0x004f, %ax
+	jne	no_edid
+
+	cmpw	$0x0102, 4(%di)			# only do EDID on > 1.2
+	jle	no_edid
+
 	pushw   %es				# save ES
 	xorw    %di, %di                        # Report Capability
 	pushw   %di
diff -puN arch/x86_64/boot/video.S~x86-dont-probe-for-ddc-on-vbe12 arch/x86_64/boot/video.S
--- a/arch/x86_64/boot/video.S~x86-dont-probe-for-ddc-on-vbe12
+++ a/arch/x86_64/boot/video.S
@@ -1945,6 +1945,20 @@ store_edid:
 	rep
 	stosl
 
+	pushw	%es
+	pushw	%ds
+	popw	%es
+	leaw	modelist+1024, %di
+	movw	$0x4f00, %ax
+	int	$0x10
+	popw	%es
+
+	cmpw	$0x004f, %ax
+	jne	no_edid
+
+	cmpw	$0x0102, 4(%di)			# only do EDID on > 1.2
+	jle	no_edid
+
 	pushw   %es				# save ES
 	xorw    %di, %di                        # Report Capability
 	pushw   %di
_

Patches currently in -mm which might be from zwane@infradead.org are

git-agpgart.patch
fix-mtrr-compat-ioctl.patch
x86-dont-probe-for-ddc-on-vbe12.patch
