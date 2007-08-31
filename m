From: akpm@linux-foundation.org
Subject: - fix-ver_linux-glibc-version-printing.patch removed from -mm tree
Date: Thu, 30 Aug 2007 23:34:39 -0700
Message-ID: <200708310634.l7V6YdK7027717@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34339 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757950AbXHaGfa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 02:35:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, adobriyan@sw.ru, viro@ftp.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Fix ver_linux glibc version printing
has been removed from the -mm tree.  Its filename was
     fix-ver_linux-glibc-version-printing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix ver_linux glibc version printing
From: Jesper Juhl <jesper.juhl@gmail.com>

Alexey Dobriyan reported that commit
4a645d5ea65baaa5736bcb566673bf4a351b2ad8 broke ver_linux when glibc has a 3
digit version number, and proposed a patch.  Al Viro then suggested a
simpler way to solve the problem which I've then simply put into patch
form.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Al Viro <viro@ftp.linux.org.uk>
Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/ver_linux |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff -puN scripts/ver_linux~fix-ver_linux-glibc-version-printing scripts/ver_linux
--- a/scripts/ver_linux~fix-ver_linux-glibc-version-printing
+++ a/scripts/ver_linux
@@ -63,9 +63,8 @@ isdnctrl 2>&1 | grep version | awk \
 showmount --version 2>&1 | grep nfs-utils | awk \
 'NR==1{print "nfs-utils             ", $NF}'
 
-ls -l `ldd /bin/sh | awk '/libc/{print $3}'` | sed \
--e 's/\.so$//' | sed -e 's/>//' | \
-awk -F'[.-]' '{print "Linux C Library        "$(NF-1)"."$NF}'
+echo -n "Linux C Library        "
+sed -n -e '/^.*\/libc-\([^/]*\)\.so$/{s//\1/;p;q}' < /proc/self/maps
 
 ldd -v > /dev/null 2>&1 && ldd -v || ldd --version |head -n 1 | awk \
 'NR==1{print "Dynamic linker (ldd)  ", $NF}'
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-alsa.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
git-powerpc.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ia64.patch
git-kbuild.patch
git-mtd.patch
git-ubi.patch
git-netdev-all.patch
eepro100-avoid-potential-null-pointer-deref-in-speedo_init_rx_ring.patch
avoid-possible-null-pointer-deref-in-3c359-driver.patch
git-backlight.patch
clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch
clean-up-duplicate-includes-in-fs-ntfs.patch
git-scsi-misc.patch
mpt-fusion-fix-two-potential-mem-leaks.patch
fix-a-potential-null-pointer-deref-in-the-aic7xxx-ahc_print_register-function.patch
git-xfs.patch
clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
clean-up-duplicate-includes-in-mm.patch
mm-no-need-to-cast-vmalloc-return-value-in-zone_wait_table_init.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
avoid-a-small-unlikely-memory-leak-in-proc_read_escd.patch
clean-up-duplicate-includes-in-drivers-spi.patch
fix-possible-null-deref-on-low-memory-condition-in-capidrvcsend_message.patch
isdn-guard-against-a-potential-null-pointer-dereference-in-old_capi_manufacturer.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
