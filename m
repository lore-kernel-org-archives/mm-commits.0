From: akpm@linux-foundation.org
Subject: + i386-make-bootsector-stub-16-bit-only.patch added to -mm tree
Date: Mon, 07 May 2007 15:01:13 -0700
Message-ID: <200705072201.l47M1El3006469@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966517AbXEGWBS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 18:01:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heukelum@mailshack.com, hpa@zytor.com


The patch titled
     i386: make bootsector stub 16-bit-only
has been added to the -mm tree.  Its filename is
     i386-make-bootsector-stub-16-bit-only.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
