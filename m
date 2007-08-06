From: akpm@linux-foundation.org
Subject: - serial-sh-sci-fix-build-failure-from-kgdb-fallout.patch removed from -mm tree
Date: Mon, 06 Aug 2007 00:53:50 -0700
Message-ID: <200708060753.l767roJ6016383@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51181 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758845AbXHFHzs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 03:55:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, bunk@stusta.de, jason.wessel@windriver.com, mm-commits@vger.kernel.org


The patch titled
     serial: sh-sci: Fix build failure from kgdb fallout
has been removed from the -mm tree.  Its filename was
     serial-sh-sci-fix-build-failure-from-kgdb-fallout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: serial: sh-sci: Fix build failure from kgdb fallout
From: Paul Mundt <lethal@linux-sh.org>

serial: sh-sci: Fix build failure from kgdb fallout.

  CC      drivers/serial/sh-sci.o
drivers/serial/sh-sci.c: In function 'put_string':
drivers/serial/sh-sci.c:188: error: 'hexchars' undeclared (first use in this function)
drivers/serial/sh-sci.c:188: error: (Each undeclared identifier is reported only once
drivers/serial/sh-sci.c:188: error: for each function it appears in.)
make[3]: *** [drivers/serial/sh-sci.o] Error 1

Reported-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/sh-sci.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/serial/sh-sci.c~serial-sh-sci-fix-build-failure-from-kgdb-fallout drivers/serial/sh-sci.c
--- a/drivers/serial/sh-sci.c~serial-sh-sci-fix-build-failure-from-kgdb-fallout
+++ a/drivers/serial/sh-sci.c
@@ -162,6 +162,7 @@ static void put_string(struct sci_port *
 
 #if defined(CONFIG_SH_STANDARD_BIOS) || defined(CONFIG_SH_KGDB)
 	int checksum;
+	const char hexchars[] = "0123456789abcdef";
 	int usegdb=0;
 
 #ifdef CONFIG_SH_STANDARD_BIOS
_

Patches currently in -mm which might be from lethal@linux-sh.org are

pvr2fb-consolidated-cleanup-of-pvr2fbc.patch
cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core.patch
cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default.patch
net-smc91x-build-fixes-for-general-sh-boards.patch
git-sh.patch
sh64-arch-sh64-kernel-signalh-duplicate-include-removal.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
clean-up-duplicate-includes-in-mm.patch
printk-add-interfaces-for-external-access-to-the-log-buffer.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix-2.patch
