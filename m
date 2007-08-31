From: akpm@linux-foundation.org
Subject: - scripts-ver_linux-correct-printing-of-binutils-version.patch removed from -mm tree
Date: Thu, 30 Aug 2007 23:34:44 -0700
Message-ID: <200708310634.l7V6Yiue027723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33574 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756354AbXHaGer (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 02:34:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, mm-commits@vger.kernel.org


The patch titled
     scripts/ver_linux: correct printing of binutils version
has been removed from the -mm tree.  Its filename was
     scripts-ver_linux-correct-printing-of-binutils-version.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: scripts/ver_linux: correct printing of binutils version
From: Jesper Juhl <jesper.juhl@gmail.com>

Currently scripts/ver_linux prints "Binutils" or other random information
for the version number in the "binutils" output line on some distributions.
This patch corrects that.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/ver_linux |    4 +---
 1 files changed, 1 insertion(+), 3 deletions(-)

diff -puN scripts/ver_linux~scripts-ver_linux-correct-printing-of-binutils-version scripts/ver_linux
--- a/scripts/ver_linux~scripts-ver_linux-correct-printing-of-binutils-version
+++ a/scripts/ver_linux
@@ -21,9 +21,7 @@ gcc --version 2>&1| grep gcc | awk \
 make --version 2>&1 | awk -F, '{print $1}' | awk \
       '/GNU Make/{print "Gnu make              ",$NF}'
 
-ld -v | awk -F\) '{print $1}' | awk \
-'/BFD/{print "binutils              ",$NF} \
-/^GNU/{print "binutils              ",$4}'
+echo "binutils               $(ld -v | egrep -o '[0-9]+\.[0-9\.]+')"
 
 echo -n "util-linux             "
 fdformat --version | awk '{print $NF}' | sed -e s/^util-linux-// -e s/\)$//
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
