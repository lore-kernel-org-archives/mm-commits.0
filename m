From: akpm@linux-foundation.org
Subject: [merged] initramfs-fix-build-break-on-symbol-prefixed-archs.patch removed from -mm tree
Date: Thu, 02 Dec 2010 13:07:00 -0800
Message-ID: <201012022107.oB2L7tlo008675@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59232 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932147Ab0LBVI2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Dec 2010 16:08:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brueckner@linux.vnet.ibm.com, mmarek@suse.cz, sam@ravnborg.org, vapier.adi@gmail.com, mm-commits@vger.kernel.org


The patch titled
     initramfs: fix build break on symbol-prefixed archs
has been removed from the -mm tree.  Its filename was
     initramfs-fix-build-break-on-symbol-prefixed-archs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: initramfs: fix build break on symbol-prefixed archs
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>

Define the __initramfs_size variable using VMLINUX_SYMBOL() to take care
of symbol-prefixed architectures, for example, blackfin.

Depending on the CONFIG_SYMBOL_PREFIX configuration option, define the
SYMBOL_PREFIX symbol which is evaluated by VMLINUX_SYMBOL().

Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>, 
Cc: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 usr/Makefile         |    3 +++
 usr/initramfs_data.S |    5 +++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -puN usr/Makefile~initramfs-fix-build-break-on-symbol-prefixed-archs usr/Makefile
--- a/usr/Makefile~initramfs-fix-build-break-on-symbol-prefixed-archs
+++ a/usr/Makefile
@@ -19,6 +19,9 @@ suffix_$(CONFIG_INITRAMFS_COMPRESSION_LZ
 suffix_$(CONFIG_INITRAMFS_COMPRESSION_LZO)   = .lzo
 
 AFLAGS_initramfs_data.o += -DINITRAMFS_IMAGE="usr/initramfs_data.cpio$(suffix_y)"
+ifdef CONFIG_SYMBOL_PREFIX
+AFLAGS_initramfs_data.o += -DSYMBOL_PREFIX=$(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX))
+endif
 
 # Generate builtin.o based on initramfs_data.o
 obj-$(CONFIG_BLK_DEV_INITRD) := initramfs_data.o
diff -puN usr/initramfs_data.S~initramfs-fix-build-break-on-symbol-prefixed-archs usr/initramfs_data.S
--- a/usr/initramfs_data.S~initramfs-fix-build-break-on-symbol-prefixed-archs
+++ a/usr/initramfs_data.S
@@ -22,14 +22,15 @@
 */
 
 #include <linux/stringify.h>
+#include <asm-generic/vmlinux.lds.h>
 
 .section .init.ramfs,"a"
 __irf_start:
 .incbin __stringify(INITRAMFS_IMAGE)
 __irf_end:
 .section .init.ramfs.info,"a"
-.globl __initramfs_size
-__initramfs_size:
+.globl VMLINUX_SYMBOL(__initramfs_size)
+VMLINUX_SYMBOL(__initramfs_size):
 #ifdef CONFIG_64BIT
 	.quad __irf_end - __irf_start
 #else
_

Patches currently in -mm which might be from brueckner@linux.vnet.ibm.com are

linux-next.patch

