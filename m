From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_ref-use-page_ref-helper-instead-of-direct-modification-of-_count.patch removed from -mm tree
Date: Fri, 20 May 2016 14:03:49 -0700
Message-ID: <573f7bb5.tzjURwBcBmeCHELC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46879 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbcETVDu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:03:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cmetcalf@mellanox.com, davem@davemloft.net, hughd@google.com, johannes@sipsolutions.net, sgoutham@cavium.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_ref: use page_ref helper instead of direct modification of _count
has been removed from the -mm tree.  Its filename was
     mm-page_ref-use-page_ref-helper-instead-of-direct-modification-of-_count.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/page_ref: use page_ref helper instead of direct modification of _count

page_reference manipulation functions are introduced to track down
reference count change of the page.  Use it instead of direct modification
of _count.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Sunil Goutham <sgoutham@cavium.com>
Cc: Chris Metcalf <cmetcalf@mellanox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/cavium/thunder/nicvf_queues.c |    2 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c       |    2 +-
 mm/filemap.c                                       |    2 +-
 net/wireless/util.c                                |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/net/ethernet/cavium/thunder/nicvf_queues.c~mm-page_ref-use-page_ref-helper-instead-of-direct-modification-of-_count drivers/net/ethernet/cavium/thunder/nicvf_queues.c
--- a/drivers/net/ethernet/cavium/thunder/nicvf_queues.c~mm-page_ref-use-page_ref-helper-instead-of-direct-modification-of-_count
+++ a/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
@@ -23,7 +23,7 @@ static void nicvf_get_page(struct nicvf
 	if (!nic->rb_pageref || !nic->rb_page)
 		return;
 
-	atomic_add(nic->rb_pageref, &nic->rb_page->_count);
+	page_ref_add(nic->rb_page, nic->rb_pageref);
 	nic->rb_pageref = 0;
 }
 
diff -puN drivers/net/ethernet/qlogic/qede/qede_main.c~mm-page_ref-use-page_ref-helper-instead-of-direct-modification-of-_count drivers/net/ethernet/qlogic/qede/qede_main.c
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c~mm-page_ref-use-page_ref-helper-instead-of-direct-modification-of-_count
+++ a/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -920,7 +920,7 @@ static inline int qede_realloc_rx_buffer
 		 * network stack to take the ownership of the page
 		 * which can be recycled multiple times by the driver.
 		 */
-		atomic_inc(&curr_cons->data->_count);
+		page_ref_inc(curr_cons->data);
 		qede_reuse_page(edev, rxq, curr_cons);
 	}
 
diff -puN mm/filemap.c~mm-page_ref-use-page_ref-helper-instead-of-direct-modification-of-_count mm/filemap.c
--- a/mm/filemap.c~mm-page_ref-use-page_ref-helper-instead-of-direct-modification-of-_count
+++ a/mm/filemap.c
@@ -213,7 +213,7 @@ void __delete_from_page_cache(struct pag
 			 * some other bad page check should catch it later.
 			 */
 			page_mapcount_reset(page);
-			atomic_sub(mapcount, &page->_count);
+			page_ref_sub(page, mapcount);
 		}
 	}
 
diff -puN net/wireless/util.c~mm-page_ref-use-page_ref-helper-instead-of-direct-modification-of-_count net/wireless/util.c
--- a/net/wireless/util.c~mm-page_ref-use-page_ref-helper-instead-of-direct-modification-of-_count
+++ a/net/wireless/util.c
@@ -651,7 +651,7 @@ __frame_add_frag(struct sk_buff *skb, st
 	struct skb_shared_info *sh = skb_shinfo(skb);
 	int page_offset;
 
-	atomic_inc(&page->_count);
+	page_ref_inc(page);
 	page_offset = ptr - page_address(page);
 	skb_add_rx_frag(skb, sh->nr_frags, page, page_offset, len, size);
 }
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are


