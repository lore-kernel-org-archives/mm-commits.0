From: akpm@linux-foundation.org
Subject: - i386-make-bootsector-stub-16-bit-only.patch removed from -mm tree
Date: Tue, 08 May 2007 03:28:25 -0700
Message-ID: <200705081028.l48ASPux021195@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934870AbXEHK3D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 06:29:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heukelum@mailshack.com, hpa@zytor.com, mm-commits@vger.kernel.org


The patch titled
     i386: make bootsector stub 16-bit-only
has been removed from the -mm tree.  Its filename was
     i386-make-bootsector-stub-16-bit-only.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: i386: make bootsector stub 16-bit-only
From: Alexander van Heukelum <heukelum@mailshack.com>

The x86 bzImage contains a stub to inform people that it is not possible
any more to run a Linux kernel by catting it to a floppy and then booting
from it.  This was meant to be all 16-bit code.  The first instruction,
however, ended up as being coded as a 16:32-bit far jump.  I assume the
intention was a 16:16-bit far jump.

Signed-off-by: Alexander van Heukelum <heukelum@mailshack.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/boot/bootsect.S |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/boot/bootsect.S~i386-make-bootsector-stub-16-bit-only arch/i386/boot/bootsect.S
--- a/arch/i386/boot/bootsect.S~i386-make-bootsector-stub-16-bit-only
+++ a/arch/i386/boot/bootsect.S
@@ -44,7 +44,7 @@ SWAP_DEV	= 0			/* SWAP_DEV is now writte
 _start:
 
 	# Normalize the start address
-	jmpl	$BOOTSEG, $start2
+	jmpw	$BOOTSEG, $start2
 
 start2:
 	movw	%cs, %ax
_

Patches currently in -mm which might be from heukelum@mailshack.com are

i386-make-bootsector-stub-16-bit-only.patch
x86_64-make-bootsector-stub-16-bit-only.patch
