From: akpm@linux-foundation.org
Subject: - remove-linux-hardirqh-from-asm-generic-localh-sparc-fix.patch removed from -mm tree
Date: Mon, 29 Dec 2008 11:19:23 -0800
Message-ID: <200812291919.mBTJJN6s031568@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37271 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752217AbYL2TUb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Dec 2008 14:20:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, adobriyan@gmail.com, davem@davemloft.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     sparc: fix hardirq.h removal fallout
has been removed from the -mm tree.  Its filename was
     remove-linux-hardirqh-from-asm-generic-localh-sparc-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sparc: fix hardirq.h removal fallout
From: Sam Ravnborg <sam@ravnborg.org>

When hardirq.h are removed from asm-generic/local.h a few bits fails to
build.  Fix these upfront.  Reported by Alexey.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/mdesc.c |    1 +
 arch/sparc/kernel/sysfs.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN arch/sparc/kernel/mdesc.c~remove-linux-hardirqh-from-asm-generic-localh-sparc-fix arch/sparc/kernel/mdesc.c
--- a/arch/sparc/kernel/mdesc.c~remove-linux-hardirqh-from-asm-generic-localh-sparc-fix
+++ a/arch/sparc/kernel/mdesc.c
@@ -11,6 +11,7 @@
 #include <linux/mm.h>
 #include <linux/miscdevice.h>
 
+#include <asm/cpudata.h>
 #include <asm/hypervisor.h>
 #include <asm/mdesc.h>
 #include <asm/prom.h>
diff -puN arch/sparc/kernel/sysfs.c~remove-linux-hardirqh-from-asm-generic-localh-sparc-fix arch/sparc/kernel/sysfs.c
--- a/arch/sparc/kernel/sysfs.c~remove-linux-hardirqh-from-asm-generic-localh-sparc-fix
+++ a/arch/sparc/kernel/sysfs.c
@@ -8,6 +8,7 @@
 #include <linux/percpu.h>
 #include <linux/init.h>
 
+#include <asm/cpudata.h>
 #include <asm/hypervisor.h>
 #include <asm/spitfire.h>
 
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
linux-next.patch
kconfig-add-module_name-shortcut.patch
sparc64-use-unsigned-long-long-for-u64.patch
sparc64-fix-unsigned-long-long-warnings-in-drivers.patch
uml-get-rid-of-the-last-symlink-in-uml-build.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch

