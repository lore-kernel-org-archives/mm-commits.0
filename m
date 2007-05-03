From: akpm@linux-foundation.org
Subject: + m68k-export-csum_partial_copy_from_user.patch added to -mm tree
Date: Wed, 02 May 2007 22:18:59 -0700
Message-ID: <200705030518.l435IxrR005410@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55325 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767394AbXECFTP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 01:19:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, dhowells@redhat.com, zippel@linux-m68k.org


The patch titled
     m68k: export csum_partial_copy_from_user
has been added to the -mm tree.  Its filename is
     m68k-export-csum_partial_copy_from_user.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: m68k: export csum_partial_copy_from_user
From: Geert Uytterhoeven <geert@linux-m68k.org>

net/rxrpc/af-rxrpc.ko needs csum_partial_copy_from_user

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/lib/checksum.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/m68k/lib/checksum.c~m68k-export-csum_partial_copy_from_user arch/m68k/lib/checksum.c
--- a/arch/m68k/lib/checksum.c~m68k-export-csum_partial_copy_from_user
+++ a/arch/m68k/lib/checksum.c
@@ -320,6 +320,9 @@ csum_partial_copy_from_user(const void _
 	return(sum);
 }
 
+EXPORT_SYMBOL(csum_partial_copy_from_user);
+
+
 /*
  * copy from kernel space while checksumming, otherwise like csum_partial
  */
_

Patches currently in -mm which might be from geert@linux-m68k.org are

introduce-config_has_dma.patch
remove-unused-header-file-arch-m68k-atari-atasoundh.patch
spin_lock_unlocked-cleanup-in-arch-m68k.patch
m68k-export-csum_partial_copy_from_user.patch
allow-arch-to-initialize-arch-field-of-the-module-structure.patch
