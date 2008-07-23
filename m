From: akpm@linux-foundation.org
Subject: - page_align-correctly-handle-64-bit-values-on-32-bit-architectures-x86_64-fix.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:12:56 -0700
Message-ID: <200807232325.m6NNPXCZ017531@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56381 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754937AbYGWXZf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:25:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: righi.andrea@gmail.com, linux-arch@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     page_align-correctly-handle-64-bit-values-on-32-bit-architectures x86_64 fix
has been removed from the -mm tree.  Its filename was
     page_align-correctly-handle-64-bit-values-on-32-bit-architectures-x86_64-fix.patch

This patch was dropped because it was folded into page_align-correctly-handle-64-bit-values-on-32-bit-architectures.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page_align-correctly-handle-64-bit-values-on-32-bit-architectures x86_64 fix
From: Andrea Righi <righi.andrea@gmail.com>

x86_64 allmodconfig build failed due to a missing #include <linux/mm.h>
in arch/x86/kernel/module_64.c.

Following patch resolves (on top of the previous one).

Except this, no errors for x86_64.

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/module_64.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/kernel/module_64.c~page_align-correctly-handle-64-bit-values-on-32-bit-architectures-x86_64-fix arch/x86/kernel/module_64.c
--- a/arch/x86/kernel/module_64.c~page_align-correctly-handle-64-bit-values-on-32-bit-architectures-x86_64-fix
+++ a/arch/x86/kernel/module_64.c
@@ -22,6 +22,7 @@
 #include <linux/fs.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
+#include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/bug.h>
 
_

Patches currently in -mm which might be from righi.andrea@gmail.com are

page_align-correctly-handle-64-bit-values-on-32-bit-architectures.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-x86_64-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-powerpc-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-arm-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-mips-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-dvb.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-mtd-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-powerpc-fixes.patch
page_align-arm-fix-implicit-declaration-of-function-page_align.patch
page_align-avr32-fix-implicit-declaration-of-function-page_align.patch
page_align-h8300-fix-implicit-declaration-of-function-page_align.patch
page_align-m68k-fix-implicit-declaration-of-function-page_align.patch
page_align-m68knommu-fix-implicit-declaration-of-function-page_align.patch
page_align-mips-fix-implicit-declarations-of-function-page_align.patch
page_align-xtensa-fix-implicit-declaration-of-function-page_align.patch
page_align-fix-implicit-declarations-of-function-page_align-in-various-drivers.patch

