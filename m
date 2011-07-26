From: akpm@linux-foundation.org
Subject: [merged] um-reinstate-kernel-version-in-generated-config.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:54:29 -0700
Message-ID: <201107260753.p6Q7rWB4003241@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45688 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753126Ab1GZHy2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:54:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     um: reinstate kernel version in generated .config
has been removed from the -mm tree.  Its filename was
     um-reinstate-kernel-version-in-generated-config.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: reinstate kernel version in generated .config
From: Geert Uytterhoeven <geert@linux-m68k.org>

commit 0954828fcbf3bd13d593499b16b901a4e801b0b9 ("kconfig: replace
KERNELVERSION usage by the mainmenu's prompt") made the kernel version
disappear from the generated .config file when configuring for UML.  As
UML's Kconfig doesn't have a mainmenu, kconfig falls back to the default
string "Linux Kernel Configuration".

Add a suitable mainmenu to the main UML Kconfig file to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig.x86 |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/um/Kconfig.x86~um-reinstate-kernel-version-in-generated-config arch/um/Kconfig.x86
--- a/arch/um/Kconfig.x86~um-reinstate-kernel-version-in-generated-config
+++ a/arch/um/Kconfig.x86
@@ -1,3 +1,5 @@
+mainmenu "User Mode Linux/$SUBARCH $KERNELVERSION Kernel Configuration"
+
 source "arch/um/Kconfig.common"
 
 menu "UML-specific options"
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch
cris-fix-a-build-error-in-kernel-forkc.patch
cris-fix-a-build-error-in-sync_serial_open.patch
cris-fix-the-prototype-of-sync_serial_ioctl.patch
cris-add-missing-declaration-of-kgdb_init-and-breakpoint.patch
fb-fix-potential-deadlock-between-lock_fb_info-and-console_lock.patch
h8300-m68k-xtensa-__fd_isset-should-return-0-1.patch

