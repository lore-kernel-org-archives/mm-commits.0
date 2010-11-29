From: akpm@linux-foundation.org
Subject: + initramfs-fix-build-break-on-symbol-prefixed-archs.patch added to -mm tree
Date: Mon, 29 Nov 2010 14:38:56 -0800
Message-ID: <201011292238.oATMcuZh015239@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750860Ab0K2Wj3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Nov 2010 17:39:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: brueckner@linux.vnet.ibm.com, mmarek@suse.cz, sam@ravnborg.org, vapier.adi@gmail.com


The patch titled
     initramfs: fix build break on symbol-prefixed archs
has been added to the -mm tree.  Its filename is
     initramfs-fix-build-break-on-symbol-prefixed-archs.patch

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

initramfs-fix-build-break-on-symbol-prefixed-archs.patch

