From: akpm@linux-foundation.org
Subject: + serial_coreh-include-linux-sysrqh.patch added to -mm tree
Date: Thu, 31 May 2007 14:59:56 -0700
Message-ID: <200705312159.l4VLxuIm029039@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751511AbXEaWA1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2007 18:00:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org, rmk@arm.linux.org.uk


The patch titled
     serial_core.h: Include <linux/sysrq.h>
has been added to the -mm tree.  Its filename is
     serial_coreh-include-linux-sysrqh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: serial_core.h: Include <linux/sysrq.h>
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
 1 files changed, 1 insertion(+)

diff -puN include/linux/serial_core.h~serial_coreh-include-linux-sysrqh include/linux/serial_core.h
--- a/include/linux/serial_core.h~serial_coreh-include-linux-sysrqh
+++ a/include/linux/serial_core.h
@@ -153,6 +153,7 @@
 #include <linux/sched.h>
 #include <linux/tty.h>
 #include <linux/mutex.h>
+#include <linux/sysrq.h>
 
 struct uart_port;
 struct uart_info;
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
serial_coreh-include-linux-sysrqh.patch
zs-move-to-the-serial-subsystem.patch
zs-move-to-the-serial-subsystem-update.patch
