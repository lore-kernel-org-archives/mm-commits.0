From: akpm@linux-foundation.org
Subject: [merged] asm-generic-use-little-endian-bitops.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:23:57 -0700
Message-ID: <201103250723.p2P7NpfD025767@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54421 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933818Ab1CYHX4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:23:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     asm-generic: use little-endian bitops
has been removed from the -mm tree.  Its filename was
     asm-generic-use-little-endian-bitops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
+		ret = __test_and_set_bit_le(nr, addr);	\
 		spin_unlock(lock);			\
 		ret;					\
 	})
@@ -14,7 +14,7 @@
 	({						\
 		int ret;				\
 		spin_lock(lock);			\
-		ret = ext2_clear_bit((nr), (unsigned long *)(addr)); \
+		ret = __test_and_clear_bit_le(nr, addr);	\
 		spin_unlock(lock);			\
 		ret;					\
 	})
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch

