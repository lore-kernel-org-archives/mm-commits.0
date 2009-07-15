From: akpm@linux-foundation.org
Subject: + net-dccp-suppress-warning-about-large-allocations-from-dccp.patch added to -mm tree
Date: Wed, 15 Jul 2009 13:28:26 -0700
Message-ID: <200907152028.n6FKSRbH010536@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932266AbZGOU3J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jul 2009 16:29:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, acme@redhat.com, davem@davemloft.net


The patch titled
     net-dccp: suppress warning about large allocations from DCCP
has been added to the -mm tree.  Its filename is
     net-dccp-suppress-warning-about-large-allocations-from-dccp.patch

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
Subject: net-dccp: suppress warning about large allocations from DCCP
From: Mel Gorman <mel@csn.ul.ie>

The DCCP protocol tries to allocate some large hash tables during
initialisation using the largest size possible.  This can be larger than
what the page allocator can provide so it prints a warning.  However, the
caller is able to handle the situation so this patch suppresses the
warning.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/dccp/proto.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN net/dccp/proto.c~net-dccp-suppress-warning-about-large-allocations-from-dccp net/dccp/proto.c
--- a/net/dccp/proto.c~net-dccp-suppress-warning-about-large-allocations-from-dccp
+++ a/net/dccp/proto.c
@@ -1066,7 +1066,7 @@ static int __init dccp_init(void)
 		       (dccp_hashinfo.ehash_size - 1))
 			dccp_hashinfo.ehash_size--;
 		dccp_hashinfo.ehash = (struct inet_ehash_bucket *)
-			__get_free_pages(GFP_ATOMIC, ehash_order);
+			__get_free_pages(GFP_ATOMIC|__GFP_NOWARN, ehash_order);
 	} while (!dccp_hashinfo.ehash && --ehash_order > 0);
 
 	if (!dccp_hashinfo.ehash) {
@@ -1091,7 +1091,7 @@ static int __init dccp_init(void)
 		    bhash_order > 0)
 			continue;
 		dccp_hashinfo.bhash = (struct inet_bind_hashbucket *)
-			__get_free_pages(GFP_ATOMIC, bhash_order);
+			__get_free_pages(GFP_ATOMIC|__GFP_NOWARN, bhash_order);
 	} while (!dccp_hashinfo.bhash && --bhash_order >= 0);
 
 	if (!dccp_hashinfo.bhash) {
_

Patches currently in -mm which might be from mel@csn.ul.ie are

page-allocator-preserve-pfn-ordering-when-__gfp_cold-is-set.patch
page-allocator-ensure-that-processes-that-have-been-oom-killed-exit-the-page-allocator.patch
memory-hotplug-update-zone-pcp-at-memory-online.patch
memory-hotplug-update-zone-pcp-at-memory-online-fix.patch
memory-hotplug-exclude-isolated-page-from-pco-page-alloc.patch
memory-hotplug-make-pages-from-movable-zone-always-isolatable.patch
memory-hotplug-alloc-page-from-other-node-in-memory-online.patch
memory-hotplug-migrate-swap-cache-page.patch
hugetlb-balance-freeing-of-huge-pages-across-nodes.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages-fix.patch
hugetlb-clean-up-and-update-huge-pages-documentation.patch
mm-clean-up-page_remove_rmap.patch
page-allocator-allow-too-high-order-warning-messages-to-be-suppressed-with-__gfp_nowarn.patch
profile-suppress-warning-about-large-allocations-when-profile=1-is-specified.patch
net-dccp-suppress-warning-about-large-allocations-from-dccp.patch
add-debugging-aid-for-memory-initialisation-problems.patch

