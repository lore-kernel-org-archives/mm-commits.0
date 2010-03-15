From: akpm@linux-foundation.org
Subject: [merged] decompress-fix-new-decompressor-for-pic.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:04:45 -0400
Message-ID: <201003150705.o2F75ILR017080@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44882 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759729Ab0COHFd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:05:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rmk@arm.linux.org.uk, alain@knaff.lu, rmk+kernel@arm.linux.org.uk, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     decompress: fix new decompressor for PIC
has been removed from the -mm tree.  Its filename was
     decompress-fix-new-decompressor-for-pic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: decompress: fix new decompressor for PIC
From: Russell King <rmk@arm.linux.org.uk>

The ARM kernel decompressor wants to be able to relocate r/w data
independently from the rest of the image, and we do this by ensuring that
r/w data has global visibility.  Define STATIC_RW_DATA to be empty to
achieve this.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Alain Knaff <alain@knaff.lu>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/decompress/mm.h |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN include/linux/decompress/mm.h~decompress-fix-new-decompressor-for-pic include/linux/decompress/mm.h
--- a/include/linux/decompress/mm.h~decompress-fix-new-decompressor-for-pic
+++ a/include/linux/decompress/mm.h
@@ -14,11 +14,21 @@
 
 /* Code active when included from pre-boot environment: */
 
+/*
+ * Some architectures want to ensure there is no local data in their
+ * pre-boot environment, so that data can arbitarily relocated (via
+ * GOT references).  This is achieved by defining STATIC_RW_DATA to
+ * be null.
+ */
+#ifndef STATIC_RW_DATA
+#define STATIC_RW_DATA static
+#endif
+
 /* A trivial malloc implementation, adapted from
  *  malloc by Hannu Savolainen 1993 and Matthias Urlichs 1994
  */
-static unsigned long malloc_ptr;
-static int malloc_count;
+STATIC_RW_DATA unsigned long malloc_ptr;
+STATIC_RW_DATA int malloc_count;
 
 static void *malloc(int size)
 {
_

Patches currently in -mm which might be from rmk@arm.linux.org.uk are

origin.patch
arm-convert-proc-cpu-aligment-to-seq_file.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
arm-convert-arm-to-arch_gettimeoffset.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch

