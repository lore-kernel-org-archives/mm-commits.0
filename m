From: akpm@linux-foundation.org
Subject: [merged] rds-use-little-endian-bitops.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:24:00 -0700
Message-ID: <201103250723.p2P7NsK1025778@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36560 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754757Ab1CYHX7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:23:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, andy.grover@oracle.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     rds: use little-endian bitops
has been removed from the -mm tree.  Its filename was
     rds-use-little-endian-bitops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rds: use little-endian bitops
From: Akinobu Mita <akinobu.mita@gmail.com>

As a preparation for removing ext2 non-atomic bit operations from
asm/bitops.h.  This converts ext2 non-atomic bit operations to
little-endian bit operations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Andy Grover <andy.grover@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/rds/cong.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN net/rds/cong.c~rds-use-little-endian-bitops net/rds/cong.c
--- a/net/rds/cong.c~rds-use-little-endian-bitops
+++ a/net/rds/cong.c
@@ -284,7 +284,7 @@ void rds_cong_set_bit(struct rds_cong_ma
 	i = be16_to_cpu(port) / RDS_CONG_MAP_PAGE_BITS;
 	off = be16_to_cpu(port) % RDS_CONG_MAP_PAGE_BITS;
 
-	ext2_set_bit(off, (void *)map->m_page_addrs[i]);
+	__set_bit_le(off, (void *)map->m_page_addrs[i]);
 }
 
 void rds_cong_clear_bit(struct rds_cong_map *map, __be16 port)
@@ -298,7 +298,7 @@ void rds_cong_clear_bit(struct rds_cong_
 	i = be16_to_cpu(port) / RDS_CONG_MAP_PAGE_BITS;
 	off = be16_to_cpu(port) % RDS_CONG_MAP_PAGE_BITS;
 
-	ext2_clear_bit(off, (void *)map->m_page_addrs[i]);
+	__clear_bit_le(off, (void *)map->m_page_addrs[i]);
 }
 
 static int rds_cong_test_bit(struct rds_cong_map *map, __be16 port)
@@ -309,7 +309,7 @@ static int rds_cong_test_bit(struct rds_
 	i = be16_to_cpu(port) / RDS_CONG_MAP_PAGE_BITS;
 	off = be16_to_cpu(port) % RDS_CONG_MAP_PAGE_BITS;
 
-	return ext2_test_bit(off, (void *)map->m_page_addrs[i]);
+	return test_bit_le(off, (void *)map->m_page_addrs[i]);
 }
 
 void rds_cong_add_socket(struct rds_sock *rs)
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch

