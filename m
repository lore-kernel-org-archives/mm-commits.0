From: akpm@linux-foundation.org
Subject: - ppc-use-the-common-ascii-hex-helpers.patch removed from -mm tree
Date: Wed, 20 Aug 2008 20:50:04 -0700
Message-ID: <200808210350.m7L3o4Ql015689@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754929AbYHUDuG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 23:50:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ppc: use the common ascii hex helpers
has been removed from the -mm tree.  Its filename was
     ppc-use-the-common-ascii-hex-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ppc: use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

[akpm@linux-foundation.org: exclude prom_init.c]
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/btext.c |   34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff -puN arch/powerpc/kernel/btext.c~ppc-use-the-common-ascii-hex-helpers arch/powerpc/kernel/btext.c
--- a/arch/powerpc/kernel/btext.c~ppc-use-the-common-ascii-hex-helpers
+++ a/arch/powerpc/kernel/btext.c
@@ -442,28 +442,26 @@ void btext_drawtext(const char *c, unsig
 
 void btext_drawhex(unsigned long v)
 {
-	char *hex_table = "0123456789abcdef";
-
 	if (!boot_text_mapped)
 		return;
 #ifdef CONFIG_PPC64
-	btext_drawchar(hex_table[(v >> 60) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 56) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 52) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 48) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 44) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 40) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 36) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 32) & 0x0000000FUL]);
+	btext_drawchar(hex_asc_hi(v >> 56));
+	btext_drawchar(hex_asc_lo(v >> 56));
+	btext_drawchar(hex_asc_hi(v >> 48));
+	btext_drawchar(hex_asc_lo(v >> 48));
+	btext_drawchar(hex_asc_hi(v >> 40));
+	btext_drawchar(hex_asc_lo(v >> 40));
+	btext_drawchar(hex_asc_hi(v >> 32));
+	btext_drawchar(hex_asc_lo(v >> 32));
 #endif
-	btext_drawchar(hex_table[(v >> 28) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 24) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 20) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 16) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 12) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >>  8) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >>  4) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >>  0) & 0x0000000FUL]);
+	btext_drawchar(hex_asc_hi(v >> 24));
+	btext_drawchar(hex_asc_lo(v >> 24));
+	btext_drawchar(hex_asc_hi(v >> 16));
+	btext_drawchar(hex_asc_lo(v >> 16));
+	btext_drawchar(hex_asc_hi(v >> 8));
+	btext_drawchar(hex_asc_lo(v >> 8));
+	btext_drawchar(hex_asc_hi(v));
+	btext_drawchar(hex_asc_lo(v));
 	btext_drawchar(' ');
 }
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
x86-fix-shadowed-variable-warning.patch
cifs-remove-global_extern-macro.patch
git-powerpc.patch
v4l-drx397xdc-sparse-annotations.patch
input-ads7846c-sparse-lock-annotation.patch
misdn-endian-annotations-for-struct-zt.patch
misdn-annotate-iomem-pointer-and-add-statics.patch
drivers-net-replace-__function__-with-__func__.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
wireless-replace-__function__-with-__func__.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
byteorder-add-new-headers-for-make-headers-install.patch
pvrusb2-use-proper-byteorder-interface.patch

