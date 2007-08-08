From: akpm@linux-foundation.org
Subject: - ehea-eliminated-some-compiler-warnings.patch removed from -mm tree
Date: Wed, 08 Aug 2007 12:07:58 -0700
Message-ID: <200708081907.l78J7wU5025830@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43445 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933334AbXHHTIi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Aug 2007 15:08:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: osstklei@de.ibm.com, tklein@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ehea: eliminated some compiler warnings
has been removed from the -mm tree.  Its filename was
     ehea-eliminated-some-compiler-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ehea: eliminated some compiler warnings
From: Thomas Klein <osstklei@de.ibm.com>

Fixed wrongly casted pointers

Signed-off-by: Thomas Klein <tklein@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ehea/ehea_main.c |   25 ++++++++++---------------
 1 files changed, 10 insertions(+), 15 deletions(-)

diff -puN drivers/net/ehea/ehea_main.c~ehea-eliminated-some-compiler-warnings drivers/net/ehea/ehea_main.c
--- a/drivers/net/ehea/ehea_main.c~ehea-eliminated-some-compiler-warnings
+++ a/drivers/net/ehea/ehea_main.c
@@ -1326,7 +1326,6 @@ static void write_swqe2_TSO(struct sk_bu
 	u8 *imm_data = &swqe->u.immdata_desc.immediate_data[0];
 	int skb_data_size = skb->len - skb->data_len;
 	int headersize;
-	u64 tmp_addr;
 
 	/* Packet is TCP with TSO enabled */
 	swqe->tx_control |= EHEA_SWQE_TSO;
@@ -1347,9 +1346,8 @@ static void write_swqe2_TSO(struct sk_bu
 			/* set sg1entry data */
 			sg1entry->l_key = lkey;
 			sg1entry->len = skb_data_size - headersize;
-
-			tmp_addr = (u64)(skb->data + headersize);
-			sg1entry->vaddr = ehea_map_vaddr(tmp_addr);
+			sg1entry->vaddr =
+				ehea_map_vaddr(skb->data + headersize);
 			swqe->descriptors++;
 		}
 	} else
@@ -1362,7 +1360,6 @@ static void write_swqe2_nonTSO(struct sk
 	int skb_data_size = skb->len - skb->data_len;
 	u8 *imm_data = &swqe->u.immdata_desc.immediate_data[0];
 	struct ehea_vsgentry *sg1entry = &swqe->u.immdata_desc.sg_entry;
-	u64 tmp_addr;
 
 	/* Packet is any nonTSO type
 	 *
@@ -1379,8 +1376,8 @@ static void write_swqe2_nonTSO(struct sk
 			/* copy sg1entry data */
 			sg1entry->l_key = lkey;
 			sg1entry->len = skb_data_size - SWQE2_MAX_IMM;
-			tmp_addr = (u64)(skb->data + SWQE2_MAX_IMM);
-			sg1entry->vaddr = ehea_map_vaddr(tmp_addr);
+			sg1entry->vaddr =
+				ehea_map_vaddr(skb->data + SWQE2_MAX_IMM);
 			swqe->descriptors++;
 		}
 	} else {
@@ -1395,7 +1392,6 @@ static inline void write_swqe2_data(stru
 	struct ehea_vsgentry *sg_list, *sg1entry, *sgentry;
 	skb_frag_t *frag;
 	int nfrags, sg1entry_contains_frag_data, i;
-	u64 tmp_addr;
 
 	nfrags = skb_shinfo(skb)->nr_frags;
 	sg1entry = &swqe->u.immdata_desc.sg_entry;
@@ -1417,9 +1413,9 @@ static inline void write_swqe2_data(stru
 			/* copy sg1entry data */
 			sg1entry->l_key = lkey;
 			sg1entry->len = frag->size;
-			tmp_addr =  (u64)(page_address(frag->page)
-					  + frag->page_offset);
-			sg1entry->vaddr = ehea_map_vaddr(tmp_addr);
+			sg1entry->vaddr =
+				ehea_map_vaddr(page_address(frag->page)
+					       + frag->page_offset);
 			swqe->descriptors++;
 			sg1entry_contains_frag_data = 1;
 		}
@@ -1431,10 +1427,9 @@ static inline void write_swqe2_data(stru
 
 			sgentry->l_key = lkey;
 			sgentry->len = frag->size;
-
-			tmp_addr = (u64)(page_address(frag->page)
-					 + frag->page_offset);
-			sgentry->vaddr = ehea_map_vaddr(tmp_addr);
+			sgentry->vaddr =
+				ehea_map_vaddr(page_address(frag->page)
+					       + frag->page_offset);
 			swqe->descriptors++;
 		}
 	}
_

Patches currently in -mm which might be from osstklei@de.ibm.com are

git-netdev-all.patch
