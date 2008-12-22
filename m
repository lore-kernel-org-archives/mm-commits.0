From: akpm@linux-foundation.org
Subject: + remove-linux-hardirqh-from-asm-generic-localh-sparc-fix.patch added to -mm tree
Date: Mon, 22 Dec 2008 15:26:40 -0800
Message-ID: <200812222326.mBMNQeOI026742@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49254 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752806AbYLVX06 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Dec 2008 18:26:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org, adobriyan@gmail.com, davem@davemloft.net, rmk@arm.linux.org.uk


The patch titled
     sparc: fix hardirq.h removal fallout
has been added to the -mm tree.  Its filename is
     remove-linux-hardirqh-from-asm-generic-localh-sparc-fix.patch

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

linux-next.patch
kconfig-add-module_name-shortcut.patch
uml-get-rid-of-the-last-symlink-in-uml-build.patch
remove-linux-hardirqh-from-asm-generic-localh-sparc-fix.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch

