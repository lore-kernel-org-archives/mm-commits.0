From: akpm@linux-foundation.org
Subject: [merged] ocfs2-use-little-endian-bitops.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:24:07 -0700
Message-ID: <201103250724.p2P7O1k3025797@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933648Ab1CYHYI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:24:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, joel.becker@oracle.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     ocfs2: use little-endian bitops
has been removed from the -mm tree.  Its filename was
     ocfs2-use-little-endian-bitops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ocfs2: use little-endian bitops
From: Akinobu Mita <akinobu.mita@gmail.com>

As a preparation for removing ext2 non-atomic bit operations from
asm/bitops.h.  This converts ext2 non-atomic bit operations to
little-endian bit operations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Joel Becker <joel.becker@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ocfs2.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/ocfs2/ocfs2.h~ocfs2-use-little-endian-bitops fs/ocfs2/ocfs2.h
--- a/fs/ocfs2/ocfs2.h~ocfs2-use-little-endian-bitops
+++ a/fs/ocfs2/ocfs2.h
@@ -831,18 +831,18 @@ static inline unsigned int ocfs2_cluster
 
 static inline void _ocfs2_set_bit(unsigned int bit, unsigned long *bitmap)
 {
-	ext2_set_bit(bit, bitmap);
+	__test_and_set_bit_le(bit, bitmap);
 }
 #define ocfs2_set_bit(bit, addr) _ocfs2_set_bit((bit), (unsigned long *)(addr))
 
 static inline void _ocfs2_clear_bit(unsigned int bit, unsigned long *bitmap)
 {
-	ext2_clear_bit(bit, bitmap);
+	__test_and_clear_bit_le(bit, bitmap);
 }
 #define ocfs2_clear_bit(bit, addr) _ocfs2_clear_bit((bit), (unsigned long *)(addr))
 
-#define ocfs2_test_bit ext2_test_bit
-#define ocfs2_find_next_zero_bit ext2_find_next_zero_bit
-#define ocfs2_find_next_bit ext2_find_next_bit
+#define ocfs2_test_bit test_bit_le
+#define ocfs2_find_next_zero_bit find_next_zero_bit_le
+#define ocfs2_find_next_bit find_next_bit_le
 #endif  /* OCFS2_H */
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch

