From: akpm@linux-foundation.org
Subject: [merged] udf-use-little-endian-bitops.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:24:11 -0700
Message-ID: <201103250724.p2P7O5lx025810@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933822Ab1CYHYL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:24:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     udf: use little-endian bitops
has been removed from the -mm tree.  Its filename was
     udf-use-little-endian-bitops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: udf: use little-endian bitops
From: Akinobu Mita <akinobu.mita@gmail.com>

As a preparation for removing ext2 non-atomic bit operations from
asm/bitops.h.  This converts ext2 non-atomic bit operations to
little-endian bit operations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/balloc.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN fs/udf/balloc.c~udf-use-little-endian-bitops fs/udf/balloc.c
--- a/fs/udf/balloc.c~udf-use-little-endian-bitops
+++ a/fs/udf/balloc.c
@@ -27,11 +27,10 @@
 #include "udf_i.h"
 #include "udf_sb.h"
 
-#define udf_clear_bit(nr, addr) ext2_clear_bit(nr, addr)
-#define udf_set_bit(nr, addr) ext2_set_bit(nr, addr)
-#define udf_test_bit(nr, addr) ext2_test_bit(nr, addr)
-#define udf_find_next_one_bit(addr, size, offset) \
-		ext2_find_next_bit((unsigned long *)(addr), size, offset)
+#define udf_clear_bit	__test_and_clear_bit_le
+#define udf_set_bit	__test_and_set_bit_le
+#define udf_test_bit	test_bit_le
+#define udf_find_next_one_bit	find_next_bit_le
 
 static int read_block_bitmap(struct super_block *sb,
 			     struct udf_bitmap *bitmap, unsigned int block,
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch

