From: akpm@linux-foundation.org
Subject: + decompress-fix-new-decompressor-for-pic.patch added to -mm tree
Date: Tue, 02 Mar 2010 14:42:04 -0800
Message-ID: <201003022242.o22Mg4Al001562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751020Ab0CBWmV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Mar 2010 17:42:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rmk@arm.linux.org.uk, alain@knaff.lu, rmk+kernel@arm.linux.org.uk, stable@kernel.org


The patch titled
     decompress: fix new decompressor for PIC
has been added to the -mm tree.  Its filename is
     decompress-fix-new-decompressor-for-pic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
linux-next.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-arm.patch
bitops-rename-for_each_bit-to-for_each_set_bit-net.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
arm-convert-proc-cpu-aligment-to-seq_file.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
broadsheetfb-add-multiple-panel-type-support.patch
nuc900-lcd-controller-driver.patch
nuc900-lcd-controller-driver-updates.patch
mx3fb-introduce-waveform-configuration-for-pixel-clock-signal.patch
arm-use-generic-ptrace_resume-code.patch
decompress-fix-new-decompressor-for-pic.patch

