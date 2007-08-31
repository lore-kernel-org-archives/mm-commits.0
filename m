From: akpm@linux-foundation.org
Subject: - improve-scripts-gcc-versionsh-output-a-bit-when-called-without-args.patch removed from -mm tree
Date: Thu, 30 Aug 2007 23:34:46 -0700
Message-ID: <200708310634.l7V6Yk4w027726@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34227 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757444AbXHaGet (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 02:34:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, mm-commits@vger.kernel.org


The patch titled
     improve scripts/gcc-version.sh output a bit when called without args
has been removed from the -mm tree.  Its filename was
     improve-scripts-gcc-versionsh-output-a-bit-when-called-without-args.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: improve scripts/gcc-version.sh output a bit when called without args
From: Jesper Juhl <jesper.juhl@gmail.com>

Currently, if you call scripts/gcc-version.sh without arguments it will
generate this output :

$ sh scripts/gcc-version.sh
scripts/gcc-version.sh: line 12: [: =: unary operator expected
scripts/gcc-version.sh: line 16: -E: command not found
scripts/gcc-version.sh: line 17: -E: command not found
0000

Not too pretty. I believe this is an improvement :

$ sh scripts/gcc-version.sh
Error: No compiler specified.
Usage:
        scripts/gcc-version.sh <gcc-command>

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gcc-version.sh |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletion(-)

diff -puN scripts/gcc-version.sh~improve-scripts-gcc-versionsh-output-a-bit-when-called-without-args scripts/gcc-version.sh
--- a/scripts/gcc-version.sh~improve-scripts-gcc-versionsh-output-a-bit-when-called-without-args
+++ a/scripts/gcc-version.sh
@@ -9,10 +9,16 @@
 # gcc-2.95.3, `030301' for gcc-3.3.1, etc.
 #
 
-if [ $1 = "-p" ] ; then with_patchlevel=1; shift; fi
+if [[ $1 = "-p" ]] ; then with_patchlevel=1; shift; fi
 
 compiler="$*"
 
+if [ ${#compiler} -eq 0 ]; then
+	echo "Error: No compiler specified."
+	echo -e "Usage:\n\t$0 <gcc-command>"
+	exit 1
+fi
+
 MAJOR=$(echo __GNUC__ | $compiler -E -xc - | tail -n 1)
 MINOR=$(echo __GNUC_MINOR__ | $compiler -E -xc - | tail -n 1)
 if [ "x$with_patchlevel" != "x" ] ; then
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
