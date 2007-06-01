From: akpm@linux-foundation.org
Subject: - serial_coreh-include-linux-sysrqh.patch removed from -mm tree
Date: Fri, 01 Jun 2007 10:48:16 -0700
Message-ID: <200706011748.l51HmFm0015193@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46910 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761586AbXFARs1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 13:48:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     serial_core.h: include <linux/sysrq.h>
has been removed from the -mm tree.  Its filename was
     serial_coreh-include-linux-sysrqh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: serial_core.h: include <linux/sysrq.h>
From: "Maciej W. Rozycki" <macro@linux-mips.org>

The <linux/serial_core.h> header refers to handle_sysrq(), but does not
include <linux/sysrq.h> which provides a declaration of the function.  This
may result in an implicit declaration and a warning if the actual one is
seen later on.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/serial_core.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/serial_core.h~serial_coreh-include-linux-sysrqh include/linux/serial_core.h
--- a/include/linux/serial_core.h~serial_coreh-include-linux-sysrqh
+++ a/include/linux/serial_core.h
@@ -152,6 +152,7 @@
 #include <linux/sched.h>
 #include <linux/tty.h>
 #include <linux/mutex.h>
+#include <linux/sysrq.h>
 
 struct uart_port;
 struct uart_info;
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
zs-move-to-the-serial-subsystem.patch
zs-move-to-the-serial-subsystem-update.patch
