From: akpm@linux-foundation.org
Subject: - mm-hugetlb-get-rid-of-redundant-if-operation.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:15:01 -0800
Message-ID: <200901072215.n07MF18t014875@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757776AbZAGWPH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:15:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, gorcunov@openvz.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     mm: hugetlb: remove redundant `if' operation
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-get-rid-of-redundant-if-operation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: hugetlb: remove redundant `if' operation
From: Cyrill Gorcunov <gorcunov@gmail.com>

At this point we already know that 'addr' is not NULL so get rid of
redundant 'if'.  Probably gcc eliminate it by optimization pass.

[akpm@linux-foundation.org: use __weak, too]
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-get-rid-of-redundant-if-operation mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-get-rid-of-redundant-if-operation
+++ a/mm/hugetlb.c
@@ -1005,7 +1005,7 @@ static struct page *alloc_huge_page(stru
 	return page;
 }
 
-__attribute__((weak)) int alloc_bootmem_huge_page(struct hstate *h)
+int __weak alloc_bootmem_huge_page(struct hstate *h)
 {
 	struct huge_bootmem_page *m;
 	int nr_nodes = nodes_weight(node_online_map);
@@ -1024,8 +1024,7 @@ __attribute__((weak)) int alloc_bootmem_
 			 * puts them into the mem_map).
 			 */
 			m = addr;
-			if (m)
-				goto found;
+			goto found;
 		}
 		hstate_next_node(h);
 		nr_nodes--;
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
linux-next.patch
memcg-add-inactive_anon_is_low.patch

