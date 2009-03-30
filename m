From: akpm@linux-foundation.org
Subject: [merged] nommu-make-it-possible-for-romfs-to-use-mtd-devices-directly-fix.patch removed from -mm tree
Date: Mon, 30 Mar 2009 12:06:54 -0700
Message-ID: <200903301906.n2UJ6s1Q019212@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43959 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757794AbZC3TMb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 15:12:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, bernd.schmidt@analog.com, dwmw2@infradead.org, gerg@snapgear.com, mm-commits@vger.kernel.org


The patch titled
     NOMMU: Make it possible for RomFS to use MTD devices directly
has been removed from the -mm tree.  Its filename was
     nommu-make-it-possible-for-romfs-to-use-mtd-devices-directly-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: NOMMU: Make it possible for RomFS to use MTD devices directly
From: David Howells <dhowells@redhat.com>

Fix the configuration of the RomFS to make sure that at least one backing
store method is always selected.  This is done by rendering it down to a
choice item that selects between Block, MTD and both.

This also works correctly in the case that CONFIG_MTD=m: MTD cannot be
selected as a backing store unless CONFIG_ROMFS_FS is also 'm'.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Bernd Schmidt <bernd.schmidt@analog.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/romfs/Kconfig |   34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff -puN fs/romfs/Kconfig~nommu-make-it-possible-for-romfs-to-use-mtd-devices-directly-fix fs/romfs/Kconfig
--- a/fs/romfs/Kconfig~nommu-make-it-possible-for-romfs-to-use-mtd-devices-directly-fix
+++ a/fs/romfs/Kconfig
@@ -1,6 +1,6 @@
 config ROMFS_FS
 	tristate "ROM file system support"
-	depends on BLOCK
+	depends on BLOCK || MTD
 	---help---
 	  This is a very small read-only file system mainly intended for
 	  initial ram disks of installation disks, but it could be used for
@@ -15,9 +15,19 @@ config ROMFS_FS
 	  If you don't know whether you need it, then you don't need it:
 	  answer N.
 
-config ROMFS_ON_BLOCK
-	bool "Block device-backed ROM file system support" if (ROMFS_ON_MTD && EMBEDDED)
-	depends on ROMFS_FS && BLOCK
+#
+# Select the backing stores to be supported
+#
+choice
+	prompt "RomFS backing stores"
+	depends on ROMFS_FS
+	default ROMFS_BACKED_BY_BLOCK
+	help
+	  Select the backing stores to be supported.
+
+config ROMFS_BACKED_BY_BLOCK
+	bool "Block device-backed ROM file system support"
+	depends on BLOCK
 	help
 	  This permits ROMFS to use block devices buffered through the page
 	  cache as the medium from which to retrieve data.  It does not allow
@@ -25,9 +35,8 @@ config ROMFS_ON_BLOCK
 
 	  If unsure, answer Y.
 
-config ROMFS_ON_MTD
+config ROMFS_BACKED_BY_MTD
 	bool "MTD-backed ROM file system support"
-	depends on ROMFS_FS
 	depends on MTD=y || (ROMFS_FS=m && MTD)
 	help
 	  This permits ROMFS to use MTD based devices directly, without the
@@ -38,3 +47,16 @@ config ROMFS_ON_MTD
 
 	  If unsure, answer Y.
 
+config ROMFS_BACKED_BY_BOTH
+	bool "Both the above"
+	depends on BLOCK && (MTD=y || (ROMFS_FS=m && MTD))
+endchoice
+
+
+config ROMFS_ON_BLOCK
+	bool
+	default y if ROMFS_BACKED_BY_BLOCK || ROMFS_BACKED_BY_BOTH
+
+config ROMFS_ON_MTD
+	bool
+	default y if ROMFS_BACKED_BY_MTD || ROMFS_BACKED_BY_BOTH
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
kbuild-make-it-possible-for-the-linker-to-discard-local-symbols-from-vmlinux.patch
nommu-there-is-no-mlock-for-nommu-so-dont-provide-the-bits.patch
nommu-make-config_unevictable_lru-available-when-config_mmu=n.patch
frv-duplicate-output_buffer-of-e03.patch
flat-fix-data-sections-alignment.patch
flat-fix-data-sections-alignment-update.patch
bin_elf_fdpic-check-the-return-value-of-clear_user.patch
mutex-subsystem-synchro-test-module.patch

