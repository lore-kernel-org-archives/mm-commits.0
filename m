From: akpm@linux-foundation.org
Subject: + makefile-export-initial-ramdisk-compression-config-option.patch added to -mm tree
Date: Thu, 10 Oct 2013 14:30:03 -0700
Message-ID: <52571c5b.98eFS30UuzmLq62z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38311 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756184Ab3JJVaE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Oct 2013 17:30:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ppandit@redhat.com

Subject: + makefile-export-initial-ramdisk-compression-config-option.patch added to -mm tree
To: ppandit@redhat.com
From: akpm@linux-foundation.org
Date: Thu, 10 Oct 2013 14:30:03 -0700


The patch titled
     Subject: ./Makefile: export initial ramdisk compression config option
has been added to the -mm tree.  Its filename is
     makefile-export-initial-ramdisk-compression-config-option.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/makefile-export-initial-ramdisk-compression-config-option.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/makefile-export-initial-ramdisk-compression-config-option.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: P J P <ppandit@redhat.com>
Subject: ./Makefile: export initial ramdisk compression config option

Make menuconfig allows one to choose compression format of an initial
ramdisk image.  But this choice does not result in duly compressed ramdisk
image.  Because - $ make install - does not pass on the selected
compression choice to the dracut(8) tool, which creates the initramfs
file.  dracut(8) generates the image with the default compression, ie. 
gzip(1).

This patch exports the selected compression option to a sub-shell
environment, so that it could be used by dracut(8) tool to generate
appropriately compressed initramfs images.

There isn't a straightforward way to pass on options to dracut(8) via
positional parameters.  Because it is indirectly invoked at the end of a $
make install sequence.

 # make install
   -> arch/$arch/boot/Makefile
    -> arch/$arch/boot/install.sh
     -> /sbing/installkernel ...
      -> /sbin/new-kernel-pkg ...
       -> /sbin/dracut ...

Signed-off-by: P J P <ppandit@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile            |   16 ++++++++++++++++
 init/do_mounts_rd.c |    5 +++++
 2 files changed, 21 insertions(+)

diff -puN Makefile~makefile-export-initial-ramdisk-compression-config-option Makefile
--- a/Makefile~makefile-export-initial-ramdisk-compression-config-option
+++ a/Makefile
@@ -726,6 +726,22 @@ mod_strip_cmd = true
 endif # INSTALL_MOD_STRIP
 export mod_strip_cmd
 
+# Select initial ramdisk compression format, default is gzip(1).
+# This shall be used by the dracut(8) tool while creating an initramfs image.
+#
+INITRD_COMPRESS=gzip
+ifeq ($(CONFIG_RD_BZIP2), y)
+        INITRD_COMPRESS=bzip2
+else ifeq ($(CONFIG_RD_LZMA), y)
+        INITRD_COMPRESS=lzma
+else ifeq ($(CONFIG_RD_XZ), y)
+        INITRD_COMPRESS=xz
+else ifeq ($(CONFIG_RD_LZO), y)
+        INITRD_COMPRESS=lzo
+else ifeq ($(CONFIG_RD_LZ4), y)
+        INITRD_COMPRESS=lz4
+endif
+export INITRD_COMPRESS
 
 ifdef CONFIG_MODULE_SIG_ALL
 MODSECKEY = ./signing_key.priv
diff -puN init/do_mounts_rd.c~makefile-export-initial-ramdisk-compression-config-option init/do_mounts_rd.c
--- a/init/do_mounts_rd.c~makefile-export-initial-ramdisk-compression-config-option
+++ a/init/do_mounts_rd.c
@@ -57,6 +57,11 @@ static int __init crd_load(int in_fd, in
  *	cramfs
  *	squashfs
  *	gzip
+ *	bzip2
+ *	lzma
+ *	xz
+ *	lzo
+ *	lz4
  */
 static int __init
 identify_ramdisk_image(int fd, int start_block, decompress_fn *decompressor)
_

Patches currently in -mm which might be from ppandit@redhat.com are

makefile-export-initial-ramdisk-compression-config-option.patch

