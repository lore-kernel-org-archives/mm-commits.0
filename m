From: akpm@linux-foundation.org
Subject: [folded] m68knommu-introduce-little-endian-bitops-build-fix.patch removed from -mm tree
Date: Wed, 12 Jan 2011 16:32:02 -0800
Message-ID: <201101130032.p0D0W2oj012682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46240 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755961Ab1AMAcL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Jan 2011 19:32:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, arnd@arndb.de, gerg@uclinux.org, mm-commits@vger.kernel.org


The patch titled
     "m68knommu: introduce little-endian bitops" build fix
has been removed from the -mm tree.  Its filename was
     m68knommu-introduce-little-endian-bitops-build-fix.patch

This patch was dropped because it was folded into m68knommu-introduce-little-endian-bitops.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: "m68knommu: introduce little-endian bitops" build fix
From: Akinobu Mita <akinobu.mita@gmail.com>

The little-endian bitops patch series broke the build on m68knommu.

lib/find_next_bit.c:190: error: conflicting types for 'find_next_zero_le_bit'
arch/m68k/include/asm/bitops_no.h:286: error: previous
definition of 'find_next_zero_le_bit' was here

Because m68knommu selects CONFIG_GENERIC_FIND_NEXT_BIT, it redefines
find_next_zero_le_bit() in lib/find_next_bit.c.

Previous patch introduced CONFIG_GENERIC_FIND_LE_BIT to tell whether to
use generic implementation of find_*_le_bit() in lib/find_next_bit.c or not.

Don't select CONFIG_GENERIC_FIND_LE_BIT to fix build failure on m68knommu.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/Kconfig |    4 ----
 1 file changed, 4 deletions(-)

diff -puN arch/m68knommu/Kconfig~m68knommu-introduce-little-endian-bitops-build-fix arch/m68knommu/Kconfig
--- a/arch/m68knommu/Kconfig~m68knommu-introduce-little-endian-bitops-build-fix
+++ a/arch/m68knommu/Kconfig
@@ -40,10 +40,6 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
-config GENERIC_FIND_LE_BIT
-	bool
-	default y
-
 config GENERIC_GPIO
 	bool
 	default n
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
uml-use-simple_write_to_buffer.patch
bitops-merge-little-and-big-endian-definisions-in-asm-generic-bitops-leh.patch
bitops-rename-generic-little-endian-bitops-functions.patch
s390-introduce-little-endian-bitops.patch
arm-introduce-little-endian-bitops.patch
m68k-introduce-little-endian-bitops.patch
bitops-introduce-config_generic_find_le_bit.patch
m68knommu-introduce-little-endian-bitops.patch
bitops-introduce-little-endian-bitops-for-most-architectures.patch
rds-stop-including-asm-generic-bitops-leh.patch
kvm-stop-including-asm-generic-bitops-leh.patch
asm-generic-use-little-endian-bitops.patch
ext3-use-little-endian-bitops.patch
ext4-use-little-endian-bitops.patch
ocfs2-use-little-endian-bitops.patch
nilfs2-use-little-endian-bitops.patch
reiserfs-use-little-endian-bitops.patch
udf-use-little-endian-bitops.patch
ufs-use-little-endian-bitops.patch
md-use-little-endian-bit-operations.patch
dm-use-little-endian-bit-operations.patch
bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh.patch
m68k-remove-inline-asm-from-minix_find_first_zero_bit.patch
bitops-remove-minix-bitops-from-asm-bitopsh.patch
bitops-use-find_first_zero_bit-instead-of-find_next_zero_bitaddr-size-0.patch

