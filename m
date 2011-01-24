From: akpm@linux-foundation.org
Subject: + rds-stop-including-asm-generic-bitops-leh-directly.patch added to -mm tree
Date: Mon, 24 Jan 2011 14:05:47 -0800
Message-ID: <201101242205.p0OM5lTa013322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45967 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751107Ab1AXWFx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Jan 2011 17:05:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, andy.grover@oracle.com, davem@davemloft.net


The patch titled
     rds: stop including asm-generic/bitops/le.h directly
has been added to the -mm tree.  Its filename is
     rds-stop-including-asm-generic-bitops-leh-directly.patch

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

smp-move-smp-setup-functions-to-kernel-smpc.patch
kvm-stop-including-asm-generic-bitops-leh-directly.patch
rds-stop-including-asm-generic-bitops-leh-directly.patch
bitops-merge-little-and-big-endian-definisions-in-asm-generic-bitops-leh.patch
asm-generic-rename-generic-little-endian-bitops-functions.patch
asm-generic-change-little-endian-bitops-to-take-any-pointer-types.patch
powerpc-introduce-little-endian-bitops.patch
s390-introduce-little-endian-bitops.patch
arm-introduce-little-endian-bitops.patch
m68k-introduce-little-endian-bitops.patch
bitops-introduce-config_generic_find_bit_le.patch
m68knommu-introduce-little-endian-bitops.patch
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

