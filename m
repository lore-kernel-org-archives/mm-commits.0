From: akpm@linux-foundation.org
Subject: [merged] rds-stop-including-asm-generic-bitops-leh-directly.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:23:30 -0700
Message-ID: <201103250723.p2P7NOQV025724@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33825 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751402Ab1CYHX3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:23:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, andy.grover@oracle.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     rds: stop including asm-generic/bitops/le.h directly
has been removed from the -mm tree.  Its filename was
     rds-stop-including-asm-generic-bitops-leh-directly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rds: stop including asm-generic/bitops/le.h directly
From: Akinobu Mita <akinobu.mita@gmail.com>

asm-generic/bitops/le.h is only intended to be included directly from
asm-generic/bitops/ext2-non-atomic.h or asm-generic/bitops/minix-le.h
which implements generic ext2 or minix bit operations.

This stops including asm-generic/bitops/le.h directly and use ext2
non-atomic bit operations instead.

It seems odd to use ext2_*_bit() on rds, but it will replaced with
__{set,clear,test}_bit_le() after introducing little endian bit operations
for all architectures.  This indirect step is necessary to maintain
bisectability for some architectures which have their own little-endian
bit operations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Andy Grover <andy.grover@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/rds/cong.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN net/rds/cong.c~rds-stop-including-asm-generic-bitops-leh-directly net/rds/cong.c
--- a/net/rds/cong.c~rds-stop-including-asm-generic-bitops-leh-directly
+++ a/net/rds/cong.c
@@ -33,8 +33,7 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/rbtree.h>
-
-#include <asm-generic/bitops/le.h>
+#include <linux/bitops.h>
 
 #include "rds.h"
 
@@ -285,7 +284,7 @@ void rds_cong_set_bit(struct rds_cong_ma
 	i = be16_to_cpu(port) / RDS_CONG_MAP_PAGE_BITS;
 	off = be16_to_cpu(port) % RDS_CONG_MAP_PAGE_BITS;
 
-	generic___set_le_bit(off, (void *)map->m_page_addrs[i]);
+	ext2_set_bit(off, (void *)map->m_page_addrs[i]);
 }
 
 void rds_cong_clear_bit(struct rds_cong_map *map, __be16 port)
@@ -299,7 +298,7 @@ void rds_cong_clear_bit(struct rds_cong_
 	i = be16_to_cpu(port) / RDS_CONG_MAP_PAGE_BITS;
 	off = be16_to_cpu(port) % RDS_CONG_MAP_PAGE_BITS;
 
-	generic___clear_le_bit(off, (void *)map->m_page_addrs[i]);
+	ext2_clear_bit(off, (void *)map->m_page_addrs[i]);
 }
 
 static int rds_cong_test_bit(struct rds_cong_map *map, __be16 port)
@@ -310,7 +309,7 @@ static int rds_cong_test_bit(struct rds_
 	i = be16_to_cpu(port) / RDS_CONG_MAP_PAGE_BITS;
 	off = be16_to_cpu(port) % RDS_CONG_MAP_PAGE_BITS;
 
-	return generic_test_le_bit(off, (void *)map->m_page_addrs[i]);
+	return ext2_test_bit(off, (void *)map->m_page_addrs[i]);
 }
 
 void rds_cong_add_socket(struct rds_sock *rs)
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch

