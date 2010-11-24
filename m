From: akpm@linux-foundation.org
Subject: + asm-generic-use-little-endian-bitops.patch added to -mm tree
Date: Wed, 24 Nov 2010 14:39:54 -0800
Message-ID: <201011242239.oAOMdsRA008151@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49429 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753305Ab0KXWp5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Nov 2010 17:45:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, arnd@arndb.de


The patch titled
     asm-generic: use little-endian bitops
has been added to the -mm tree.  Its filename is
     asm-generic-use-little-endian-bitops.patch

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
Subject: asm-generic: use little-endian bitops
From: Akinobu Mita <akinobu.mita@gmail.com>

As a preparation for removing ext2 non-atomic bit operations from
asm/bitops.h.  This converts ext2 non-atomic bit operations to
little-endian bit operations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bitops/ext2-atomic.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/asm-generic/bitops/ext2-atomic.h~asm-generic-use-little-endian-bitops include/asm-generic/bitops/ext2-atomic.h
--- a/include/asm-generic/bitops/ext2-atomic.h~asm-generic-use-little-endian-bitops
+++ a/include/asm-generic/bitops/ext2-atomic.h
@@ -5,7 +5,7 @@
 	({						\
 		int ret;				\
 		spin_lock(lock);			\
-		ret = ext2_set_bit((nr), (unsigned long *)(addr)); \
+		ret = __test_and_set_le_bit((nr), (unsigned long *)(addr)); \
 		spin_unlock(lock);			\
 		ret;					\
 	})
@@ -14,7 +14,7 @@
 	({						\
 		int ret;				\
 		spin_lock(lock);			\
-		ret = ext2_clear_bit((nr), (unsigned long *)(addr)); \
+		ret = __test_and_clear_le_bit((nr), (unsigned long *)(addr)); \
 		spin_unlock(lock);			\
 		ret;					\
 	})
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

bitops-merge-little-and-big-endian-definisions-in-asm-generic-bitops-leh.patch
bitops-rename-generic-little-endian-bitops-functions.patch
s390-introduce-little-endian-bitops.patch
arm-introduce-little-endian-bitops.patch
m68k-introduce-little-endian-bitops.patch
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

