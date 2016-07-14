From: akpm@linux-foundation.org
Subject: [patch 13/20] mm, meminit: ensure node is online before checking
 whether pages are uninitialised
Date: Thu, 14 Jul 2016 12:07:23 -0700
Message-ID: <5787e2eb.PV6I2GzMGHqwceff%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41002 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbcGNTHY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jul 2016 15:07:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, rientjes@google.com, stable@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, meminit: ensure node is online before checking whether pages are uninitialised

early_page_uninitialised looks up an arbitrary PFN.  While a machine
without node 0 will boot with "mm, page_alloc: Always return a valid node
from early_pfn_to_nid", it works because it assumes that nodes are always
in PFN order.  This is not guaranteed so this patch adds robustness by
always checking if the node being checked is online.

Link: http://lkml.kernel.org/r/1468008031-3848-4-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>	[4.2+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-meminit-ensure-node-is-online-before-checking-whether-pages-are-uninitialised mm/page_alloc.c
--- a/mm/page_alloc.c~mm-meminit-ensure-node-is-online-before-checking-whether-pages-are-uninitialised
+++ a/mm/page_alloc.c
@@ -286,7 +286,9 @@ static inline void reset_deferred_memini
 /* Returns true if the struct page for the pfn is uninitialised */
 static inline bool __meminit early_page_uninitialised(unsigned long pfn)
 {
-	if (pfn >= NODE_DATA(early_pfn_to_nid(pfn))->first_deferred_pfn)
+	int nid = early_pfn_to_nid(pfn);
+
+	if (node_online(nid) && pfn >= NODE_DATA(nid)->first_deferred_pfn)
 		return true;
 
 	return false;
_
