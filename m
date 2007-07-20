From: akpm@linux-foundation.org
Subject: + console-fix-section-mismatch-warning-in-vgaconc.patch added to -mm tree
Date: Fri, 20 Jul 2007 14:50:37 -0700
Message-ID: <200707202150.l6KLobbf018281@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54280 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751896AbXGTVu4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 17:50:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org, adaplas@pol.net


The patch titled
     console: fix section mismatch warning in vgacon.c
has been added to the -mm tree.  Its filename is
     console-fix-section-mismatch-warning-in-vgaconc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: console: fix section mismatch warning in vgacon.c
From: Sam Ravnborg <sam@ravnborg.org>

Fix following section mismatch warning:
WARNING: vmlinux.o(.text+0x121e62): Section mismatch: reference to .init.text:__alloc_bootmem (between 'vgacon_startup' and 'vgacon_scrolldelta')

Browsing the code it seems that vgacon_scrollback_startup() is only called
during the init phase so the reference to the .init.text section is OK.

Teach modpost not to warn using ___init_refok.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/vgacon.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/video/console/vgacon.c~console-fix-section-mismatch-warning-in-vgaconc drivers/video/console/vgacon.c
--- a/drivers/video/console/vgacon.c~console-fix-section-mismatch-warning-in-vgaconc
+++ a/drivers/video/console/vgacon.c
@@ -187,7 +187,11 @@ static void vgacon_scrollback_init(int p
 	}
 }
 
-static void vgacon_scrollback_startup(void)
+/*
+ * Called only duing init so call of alloc_bootmen is ok.
+ * Marked __init_refok to silence modpost.
+ */
+static void __init_refok vgacon_scrollback_startup(void)
 {
 	vgacon_scrollback = alloc_bootmem(CONFIG_VGACON_SOFT_SCROLLBACK_SIZE
 					  * 1024);
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
powerpc-vdso-install-unstripped-copies-on-disk.patch
pass-g-to-assembler-under-config_debug_info.patch
mkmakefile-include-arch-on-o=-builds.patch
i386-vdso-install-unstripped-copies-on-disk.patch
i386-vdso-install-unstripped-copies-on-disk-fix.patch
x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
whitelist-references-from-__dbe_table-to-init.patch
broken-lilo-check-on-make-install.patch
console-fix-section-mismatch-warning-in-vgaconc.patch
