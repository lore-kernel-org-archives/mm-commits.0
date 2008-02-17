From: akpm@linux-foundation.org
Subject: + h8300-add-scih.patch added to -mm tree
Date: Sat, 16 Feb 2008 20:56:25 -0800
Message-ID: <200802170456.m1H4uP9I024729@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48604 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754334AbYBQE4n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 16 Feb 2008 23:56:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ysato@users.sourceforge.jp


The patch titled
     h8300: add sci.h
has been added to the -mm tree.  Its filename is
     h8300-add-scih.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: h8300: add sci.h
From: Yoshinori Sato <ysato@users.sourceforge.jp>

This file is required by sh-sci.

Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-h8300/sci.h |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff -puN /dev/null include/asm-h8300/sci.h
--- /dev/null
+++ a/include/asm-h8300/sci.h
@@ -0,0 +1,34 @@
+#ifndef __ASM_SH_SCI_H
+#define __ASM_SH_SCI_H
+
+#include <linux/serial_core.h>
+
+/*
+ * Generic header for SuperH SCI(F)
+ *
+ * Do not place SH-specific parts in here, sh64 and h8300 depend on this too.
+ */
+
+/* Offsets into the sci_port->irqs array */
+enum {
+	SCIx_ERI_IRQ,
+	SCIx_RXI_IRQ,
+	SCIx_TXI_IRQ,
+	SCIx_TEI_IRQ,
+	SCIx_NR_IRQS,
+};
+
+/*
+ * Platform device specific platform_data struct
+ */
+struct plat_sci_port {
+	void __iomem	*membase;		/* io cookie */
+	unsigned long	mapbase;		/* resource base */
+	unsigned int	irqs[SCIx_NR_IRQS];	/* ERI, RXI, TXI, BRI */
+	unsigned int	type;			/* SCI / SCIF / IRDA */
+	upf_t		flags;			/* UPF_* flags */
+};
+
+int early_sci_setup(struct uart_port *port);
+
+#endif /* __ASM_SH_SCI_H */
_

Patches currently in -mm which might be from ysato@users.sourceforge.jp are

h8300-signalc-typo-fix.patch
h8300-uaccessh-update.patch
h8300-irq-handling-update.patch
h8300-defconfig-update.patch
h8300-add-scih.patch
elf-use-elf_core_eflags-for-kcore-elf-header-flags.patch
