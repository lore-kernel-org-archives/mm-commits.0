From: akpm@linux-foundation.org
Subject: [merged] mm-debug-pagealloc-fix-kconfig-dependency-warning.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:36:14 -0700
Message-ID: <201103232039.p2NKdo7P028442@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933329Ab1CWUkX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:40:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     mm: debug-pagealloc: fix kconfig dependency warning
has been removed from the -mm tree.  Its filename was
     mm-debug-pagealloc-fix-kconfig-dependency-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: debug-pagealloc: fix kconfig dependency warning
From: Akinobu Mita <akinobu.mita@gmail.com>

Fix kconfig dependency warning to satisfy dependencies:

warning: (PAGE_POISONING) selects DEBUG_PAGEALLOC which has unmet
direct dependencies (DEBUG_KERNEL && ARCH_SUPPORTS_DEBUG_PAGEALLOC &&
(!HIBERNATION || !PPC && !SPARC) && !KMEMCHECK)

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig.debug |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff -puN mm/Kconfig.debug~mm-debug-pagealloc-fix-kconfig-dependency-warning mm/Kconfig.debug
--- a/mm/Kconfig.debug~mm-debug-pagealloc-fix-kconfig-dependency-warning
+++ a/mm/Kconfig.debug
@@ -1,27 +1,24 @@
 config DEBUG_PAGEALLOC
 	bool "Debug page memory allocations"
-	depends on DEBUG_KERNEL && ARCH_SUPPORTS_DEBUG_PAGEALLOC
-	depends on !HIBERNATION || !PPC && !SPARC
+	depends on DEBUG_KERNEL
+	depends on !HIBERNATION || ARCH_SUPPORTS_DEBUG_PAGEALLOC && !PPC && !SPARC
 	depends on !KMEMCHECK
+	select PAGE_POISONING if !ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	---help---
 	  Unmap pages from the kernel linear mapping after free_pages().
 	  This results in a large slowdown, but helps to find certain types
 	  of memory corruption.
 
+	  For architectures which don't enable ARCH_SUPPORTS_DEBUG_PAGEALLOC,
+	  fill the pages with poison patterns after free_pages() and verify
+	  the patterns before alloc_pages().  Additionally,
+	  this option cannot be enabled in combination with hibernation as
+	  that would result in incorrect warnings of memory corruption after
+	  a resume because free pages are not saved to the suspend image.
+
 config WANT_PAGE_DEBUG_FLAGS
 	bool
 
 config PAGE_POISONING
-	bool "Debug page memory allocations"
-	depends on DEBUG_KERNEL && !ARCH_SUPPORTS_DEBUG_PAGEALLOC
-	depends on !HIBERNATION
-	select DEBUG_PAGEALLOC
+	bool
 	select WANT_PAGE_DEBUG_FLAGS
-	---help---
-	   Fill the pages with poison patterns after free_pages() and verify
-	   the patterns before alloc_pages(). This results in a large slowdown,
-	   but helps to find certain types of memory corruption.
-
-	   This option cannot be enabled in combination with hibernation as
-	   that would result in incorrect warnings of memory corruption after
-	   a resume because free pages are not saved to the suspend image.
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
kvm-stop-including-asm-generic-bitops-leh-directly.patch
rds-stop-including-asm-generic-bitops-leh-directly.patch
bitops-merge-little-and-big-endian-definisions-in-asm-generic-bitops-leh.patch
asm-generic-rename-generic-little-endian-bitops-functions.patch
asm-generic-change-little-endian-bitops-to-take-any-pointer-types.patch
asm-generic-change-little-endian-bitops-to-take-any-pointer-types-convert-little-endian-bitops-macros-to-static-inline-functions.patch
powerpc-introduce-little-endian-bitops.patch
powerpc-introduce-little-endian-bitops-convert-little-endian-bitops-macros-to-static-inline-functions.patch
s390-introduce-little-endian-bitops.patch
s390-introduce-little-endian-bitops-convert-little-endian-bitops-macros-to-static-inline-functions.patch
arm-introduce-little-endian-bitops.patch
arm-introduce-little-endian-bitops-convert-little-endian-bitops-macros-to-static-inline-functions.patch
m68k-introduce-little-endian-bitops.patch
m68k-introduce-little-endian-bitops-convert-little-endian-bitops-macros-to-static-inline-functions.patch
bitops-introduce-config_generic_find_bit_le.patch
m68knommu-introduce-little-endian-bitops.patch
m68knommu-introduce-little-endian-bitops-convert-little-endian-bitops-macros-to-static-inline-functions.patch
bitops-introduce-little-endian-bitops-for-most-architectures.patch
asm-generic-use-little-endian-bitops.patch
kvm-use-little-endian-bitops.patch
rds-use-little-endian-bitops.patch
ext3-use-little-endian-bitops.patch
ext4-use-little-endian-bitops.patch
ocfs2-use-little-endian-bitops.patch
nilfs2-use-little-endian-bitops.patch
reiserfs-use-little-endian-bitops.patch
udf-use-little-endian-bitops.patch
ufs-use-little-endian-bitops.patch
md-use-little-endian-bitops.patch
dm-use-little-endian-bitops.patch
bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh.patch
m68k-remove-inline-asm-from-minix_find_first_zero_bit.patch
bitops-remove-minix-bitops-from-asm-bitopsh.patch

