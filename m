From: akpm@linux-foundation.org
Subject: +
 mm-meminit-ensure-node-is-online-before-checking-whether-pages-are-uninitialised.patch added to -mm tree
Date: Fri, 08 Jul 2016 13:18:45 -0700
Message-ID: <57800aa5.L7Mh3FuCAxONFvPa%akpm__18070.0563280427$1468009138$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42711 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427AbcGHUSq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2016 16:18:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, meminit: ensure node is online before checking whether pages are uninitialised
has been added to the -mm tree.  Its filename is
     mm-meminit-ensure-node-is-online-before-checking-whether-pages-are-uninitialised.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-meminit-ensure-node-is-online-before-checking-whether-pages-are-uninitialised.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-meminit-ensure-node-is-online-before-checking-whether-pages-are-uninitialised.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, meminit: ensure node is online before checking whether pages are uninitialised

early_page_uninitialised looks up an arbitrary PFN.  While a machine
without node 0 will boot with "mm, page_alloc: Always return a valid node
from early_pfn_to_nid", it works because it assumes that nodes are always
in PFN order.  This is not guaranteed so this patch adds robustness by
always checking if the node being checked is online.

Link: http://lkml.kernel.org/r/1468008031-3848-4-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
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

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-meminit-always-return-a-valid-node-from-early_pfn_to_nid.patch
mm-meminit-ensure-node-is-online-before-checking-whether-pages-are-uninitialised.patch
mm-meminit-remove-early_page_nid_uninitialised.patch

