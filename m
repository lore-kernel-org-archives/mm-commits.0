From: akpm@linux-foundation.org
Subject: + mm-fix-invalid-node-in-alloc_migrate_target.patch added to -mm
 tree
Date: Fri, 25 Mar 2016 12:22:59 -0700
Message-ID: <56f59013.ssO+99FpElg7WkgE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbcCYTXA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2016 15:23:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, js1304@gmail.com, lauraa@codeaurora.org, n-horiguchi@ah.jp.nec.com, rientjes@google.com, vbabka@suse.cz, wangxq10@lzu.edu.cn, zhuhui@xiaomi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix invalid node in alloc_migrate_target()
has been added to the -mm tree.  Its filename is
     mm-fix-invalid-node-in-alloc_migrate_target.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-invalid-node-in-alloc_migrate_target.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-invalid-node-in-alloc_migrate_target.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: mm: fix invalid node in alloc_migrate_target()

It is incorrect to use next_node to find a target node, it will
return MAX_NUMNODES or invalid node. This will lead to crash in
buddy system allocation.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Laura Abbott" <lauraa@codeaurora.org>
Cc: Hui Zhu <zhuhui@xiaomi.com>
Cc: Wang Xiaoqiang <wangxq10@lzu.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/page_isolation.c~mm-fix-invalid-node-in-alloc_migrate_target mm/page_isolation.c
--- a/mm/page_isolation.c~mm-fix-invalid-node-in-alloc_migrate_target
+++ a/mm/page_isolation.c
@@ -289,11 +289,11 @@ struct page *alloc_migrate_target(struct
 	 * now as a simple work-around, we use the next node for destination.
 	 */
 	if (PageHuge(page)) {
-		nodemask_t src = nodemask_of_node(page_to_nid(page));
-		nodemask_t dst;
-		nodes_complement(dst, src);
+		int node = next_online_node(page_to_nid(page));
+		if (node == MAX_NUMNODES)
+			node = first_online_node;
 		return alloc_huge_page_node(page_hstate(compound_head(page)),
-					    next_node(page_to_nid(page), dst));
+					    node);
 	}
 
 	if (PageHighMem(page))
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

mm-fix-invalid-node-in-alloc_migrate_target.patch

