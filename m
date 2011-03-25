From: akpm@linux-foundation.org
Subject: [merged] nilfs2-use-little-endian-bitops.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:24:09 -0700
Message-ID: <201103250724.p2P7O3CP025802@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53760 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933822Ab1CYHYI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:24:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     nilfs2: use little-endian bitops
has been removed from the -mm tree.  Its filename was
     nilfs2-use-little-endian-bitops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2: use little-endian bitops
From: Akinobu Mita <akinobu.mita@gmail.com>

As a preparation for removing ext2 non-atomic bit operations from
asm/bitops.h.  This converts ext2 non-atomic bit operations to
little-endian bit operations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/alloc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nilfs2/alloc.h~nilfs2-use-little-endian-bitops fs/nilfs2/alloc.h
--- a/fs/nilfs2/alloc.h~nilfs2-use-little-endian-bitops
+++ a/fs/nilfs2/alloc.h
@@ -74,7 +74,7 @@ int nilfs_palloc_freev(struct inode *, _
 
 #define nilfs_set_bit_atomic		ext2_set_bit_atomic
 #define nilfs_clear_bit_atomic		ext2_clear_bit_atomic
-#define nilfs_find_next_zero_bit	ext2_find_next_zero_bit
+#define nilfs_find_next_zero_bit	find_next_zero_bit_le
 
 /*
  * persistent object allocator cache
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch

