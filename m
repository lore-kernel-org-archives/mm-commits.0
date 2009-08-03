From: akpm@linux-foundation.org
Subject: + media-zr364xx-fix-build-errors.patch added to -mm tree
Date: Mon, 03 Aug 2009 14:57:13 -0700
Message-ID: <200908032157.n73LvDNd003432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752414AbZHCV5Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Aug 2009 17:57:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, mchehab@infradead.org, royale@zerezo.com


The patch titled
     media/zr364xx: fix build errors
has been added to the -mm tree.  Its filename is
     media-zr364xx-fix-build-errors.patch

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
Subject: media/zr364xx: fix build errors
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build errors in zr364xx by adding selects:

zr364xx.c:(.text+0x195ed7): undefined reference to `videobuf_streamon'
zr364xx.c:(.text+0x196030): undefined reference to `videobuf_dqbuf'
zr364xx.c:(.text+0x1960c4): undefined reference to `videobuf_qbuf'
zr364xx.c:(.text+0x196123): undefined reference to `videobuf_querybuf'
zr364xx.c:(.text+0x196182): undefined reference to `videobuf_reqbufs'
zr364xx.c:(.text+0x196224): undefined reference to `videobuf_queue_is_busy'
zr364xx.c:(.text+0x196390): undefined reference to `videobuf_vmalloc_free'
zr364xx.c:(.text+0x196571): undefined reference to `videobuf_iolock'
zr364xx.c:(.text+0x196678): undefined reference to `videobuf_mmap_mapper'
zr364xx.c:(.text+0x196760): undefined reference to `videobuf_poll_stream'
zr364xx.c:(.text+0x19689a): undefined reference to `videobuf_read_one'
zr364xx.c:(.text+0x1969ec): undefined reference to `videobuf_mmap_free'
zr364xx.c:(.text+0x197862): undefined reference to `videobuf_queue_vmalloc_init'
zr364xx.c:(.text+0x197a28): undefined reference to `videobuf_streamoff'
zr364xx.c:(.text+0x198203): undefined reference to `videobuf_to_vmalloc'
zr364xx.c:(.text+0x198603): undefined reference to `videobuf_streamoff'
drivers/built-in.o: In function `free_buffer':
zr364xx.c:(.text+0x19930c): undefined reference to `videobuf_vmalloc_free'
drivers/built-in.o: In function `zr364xx_open':
zr364xx.c:(.text+0x19a7de): undefined reference to `videobuf_queue_vmalloc_init'
drivers/built-in.o: In function `read_pipe_completion':
zr364xx.c:(.text+0x19b17f): undefined reference to `videobuf_to_vmalloc'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Antoine Jacquet <royale@zerezo.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/media/video/Kconfig~media-zr364xx-fix-build-errors drivers/media/video/Kconfig
--- a/drivers/media/video/Kconfig~media-zr364xx-fix-build-errors
+++ a/drivers/media/video/Kconfig
@@ -1000,6 +1000,8 @@ source "drivers/media/video/pwc/Kconfig"
 config USB_ZR364XX
 	tristate "USB ZR364XX Camera support"
 	depends on VIDEO_V4L2
+	select VIDEOBUF_GEN
+	select VIDEOBUF_VMALLOC
 	---help---
 	  Say Y here if you want to connect this type of camera to your
 	  computer's USB port.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
media-zr364xx-fix-build-errors.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
kernel-hacking-move-strip_asm_syms-from-general.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
page_alloc-fix-kernel-doc-warning.patch
add-a-driver-for-the-winbond-wpcd376i-ir-functionality-select-bitreverse.patch
lis3-add-power-management-functions-fix.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
spih-add-missing-kernel-doc-for-struct-spi_master.patch
gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update-fix.patch
doc-filesystems-remove-smount-program.patch
doc-filesystems-more-mount-cleanups.patch
reiser4-export-remove_from_page_cache-fix.patch

