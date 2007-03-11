From: akpm@linux-foundation.org
Subject: + i386-fix-gdts-number-of-quadwords-in.patch added to -mm tree
Date: Sun, 11 Mar 2007 02:02:15 -0800
Message-ID: <200703111002.l2BA2Flj009376@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42092 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093AbXCKKCW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 06:02:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darwish.07@gmail.com, randy.dunlap@oracle.com


The patch titled
     i386: fix GDT's number of quadwords in comment
has been added to the -mm tree.  Its filename is
     i386-fix-gdts-number-of-quadwords-in.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: fix GDT's number of quadwords in comment
From: Ahmed S. Darwish <darwish.07@gmail.com>

Fix comments to represent the true number of quadwords in GDT.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/head.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/i386/kernel/head.S~i386-fix-gdts-number-of-quadwords-in arch/i386/kernel/head.S
--- a/arch/i386/kernel/head.S~i386-fix-gdts-number-of-quadwords-in
+++ a/arch/i386/kernel/head.S
@@ -612,7 +612,7 @@ ENTRY(boot_gdt_table)
 	.quad 0x00cf92000000ffff	/* kernel 4GB data at 0x00000000 */
 
 /*
- * The Global Descriptor Table contains 28 quadwords, per-CPU.
+ * The Global Descriptor Table contains 32 quadwords, per-CPU.
  */
 	.align L1_CACHE_BYTES
 ENTRY(cpu_gdt_table)
@@ -639,7 +639,7 @@ ENTRY(cpu_gdt_table)
 
 	/*
 	 * Segments used for calling PnP BIOS have byte granularity.
-	 * They code segments and data segments have fixed 64k limits,
+	 * The code segments and data segments have fixed 64k limits,
 	 * the transfer segment sizes are set at run time.
 	 */
 	.quad 0x00409a000000ffff	/* 0x90 32-bit code */
_

Patches currently in -mm which might be from darwish.07@gmail.com are

git-avr32.patch
git-drm.patch
git-kvm.patch
s390-kmalloc-kzalloc-casting-cleanups.patch
i386-fix-gdts-number-of-quadwords-in.patch
rcutorture-use-array_size-macro-when-appropriate.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
