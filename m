From: akpm@linux-foundation.org
Subject: + cris-build-fixes-fix-mtdramh.patch added to -mm tree
Date: Tue, 30 Oct 2007 15:11:22 -0700
Message-ID: <200710302211.l9UMBMWi030449@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41509 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752233AbXJ3WLb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 18:11:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.nilsson@axis.com, dwmw2@infradead.org, starvik@axis.com


The patch titled
     cris build fixes: fix mtdram.h
has been added to the -mm tree.  Its filename is
     cris-build-fixes-fix-mtdramh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cris build fixes: fix mtdram.h
From: Jesper Nilsson <jesper.nilsson@axis.com>

Add include file with prototype for mtdram_init_device from
drivers/mtd/devices/mtdram.c.
Used by axisflashmap.c to boot from ram.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Acked-by: Mikael Starvik <starvik@axis.com>
Reviewed-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mtd/mtdram.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN /dev/null include/linux/mtd/mtdram.h
--- /dev/null
+++ a/include/linux/mtd/mtdram.h
@@ -0,0 +1,10 @@
+#ifndef __MTD_MTDRAM_H__
+#define __MTD_MTDRAM_H__
+
+#ifdef __KERNEL__
+#include <linux/mtd/mtd.h>
+int mtdram_init_device(struct mtd_info *mtd, void *mapped_address,
+                       unsigned long size, char *name);
+
+#endif /* __KERNEL__ */
+#endif /* __MTD_MTDRAM_H__ */
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

cris-build-fixes-fix-csum_tcpudp_magic-declaration.patch
cris-build-fixes-add-missing-syscalls.patch
cris-build-fixes-hardirqh-include-asm-irqh.patch
cris-build-fixes-atomich-needs-compilerh.patch
cris-build-fixes-atomich-needs-compilerh-fix.patch
cris-build-fixes-irq-fixes.patch
cris-build-fixes-sys_crisc-needs-fsh.patch
cris-build-fixes-add-baud-rate-defines.patch
cris-build-fixes-update-eth_v10c-ethernet-driver.patch
cris-build-fixes-update-eth_v10c-ethernet-driver-fix.patch
cris-build-fixes-fix-mtdramh.patch
cris-build-fixes-corrected-and-improved-nmi-and-irq-handling.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec.patch
cris-build-fixes-setupc-needs-paramh.patch
cris-build-fixes-fix-crisksymsc.patch
cris-build-fixes-defconfig-updates.patch
