From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix.patch removed
 from -mm tree
Date: Thu, 19 May 2016 16:57:29 -0700
Message-ID: <573e52e9.RL/Sg9XYWJJE47YJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45779 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904AbcESX5b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 19:57:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mgorman@techsingularity.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix.patch

This patch was dropped because it was folded into mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix

Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix
+++ a/mm/page_alloc.c
@@ -991,7 +991,8 @@ out:
 	return ret;
 }
 
-static bool free_pages_prepare(struct page *page, unsigned int order);
+static bool free_pages_prepare(struct page *page, unsigned int order,
+			       bool check_free);
 
 #ifdef CONFIG_DEBUG_VM
 static inline bool free_pcp_prepare(struct page *page)
@@ -1178,8 +1179,8 @@ void __meminit reserve_bootmem_region(un
 	}
 }
 
-static __always_inline bool free_pages_prepare(struct page *page, unsigned int order,
-						bool check_free)
+static __always_inline bool free_pages_prepare(struct page *page,
+					unsigned int order, bool check_free)
 {
 	int bad = 0;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-nodemaskh-create-next_node_in-helper.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-uninline-page_mapped.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix-fix.patch

