From: akpm@linux-foundation.org
Subject: + vmlinuxldsh-lower-init-ramfs-alignment-to-4.patch added to -mm tree
Date: Thu, 21 Oct 2010 14:46:33 -0700
Message-ID: <201010212146.o9LLkXLY005578@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752881Ab0JUVqi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Oct 2010 17:46:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, linux-arch@vger.kernel.org, sam@ravnborg.org, viro@zeniv.linux.org.uk


The patch titled
     vmlinux.lds.h: lower init ramfs alignment to 4
has been added to the -mm tree.  Its filename is
     vmlinuxldsh-lower-init-ramfs-alignment-to-4.patch

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
Subject: vmlinux.lds.h: lower init ramfs alignment to 4
From: Mike Frysinger <vapier@gentoo.org>

The new init ramfs format (cpio based) requires an alignment of 4 (per the
documentation and per the source files themselves).  As for compressed
sources, the decompressors can all deal with unaligned buffers.

The cpio source is also found in the __init sections of the kernel, so
once they are read and expanded into a tmpfs, the source is freed.  That
means there is no need to force page alignment here either.

This has been used on Blackfin systems for many releases without issue.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/vmlinux.lds.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-generic/vmlinux.lds.h~vmlinuxldsh-lower-init-ramfs-alignment-to-4 include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~vmlinuxldsh-lower-init-ramfs-alignment-to-4
+++ a/include/asm-generic/vmlinux.lds.h
@@ -637,7 +637,7 @@
 
 #ifdef CONFIG_BLK_DEV_INITRD
 #define INIT_RAM_FS							\
-	. = ALIGN(PAGE_SIZE);						\
+	. = ALIGN(4);							\
 	VMLINUX_SYMBOL(__initramfs_start) = .;				\
 	*(.init.ramfs)							\
 	. = ALIGN(8);							\
_

Patches currently in -mm which might be from vapier@gentoo.org are

drivers-misc-ad525x_dpot-fix-typo-in-spi-write16-and-write24-transfer-counts.patch
linux-next.patch
video-backlight-adp8860-fix-ambient-light-zone-overwrite-handling.patch
m68knommu-blackfin-remove-old-assembler-only-flags-bit-definitions.patch
vmlinuxldsh-gather-datashared_aligned-sections-in-data_data.patch
vmlinuxldsh-lower-init-ramfs-alignment-to-4.patch
drivers-misc-ad525x_dpot-fix-part-name-typos-in-defines.patch
drivers-misc-ad525x_dpot-new-features.patch
misc-devices-do-not-enable-by-default.patch
rtc-bfin-shrink-optimize-interrupt-handler-a-bit.patch
rtc-bfin-add-debug-markers-to-suspend-resume-paths.patch
gpio-adp5588-gpio-support-interrupt-controller.patch
gpio-adp5588-gpio-support-interrupt-controller-update.patch
gpio-adp5588-gpio-gpio_start-must-be-signed.patch
ptrace-cleanup-arch_ptrace-and-friends-on-blackfin.patch

