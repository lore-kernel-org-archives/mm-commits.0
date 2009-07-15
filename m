From: akpm@linux-foundation.org
Subject: + profile-suppress-warning-about-large-allocations-when-profile=1-is-specified.patch added to -mm tree
Date: Wed, 15 Jul 2009 13:28:23 -0700
Message-ID: <200907152028.n6FKSOa2010459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932257AbZGOU2x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jul 2009 16:28:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie


The patch titled
     profile: suppress warning about large allocations when profile=1 is specified
has been added to the -mm tree.  Its filename is
     profile-suppress-warning-about-large-allocations-when-profile=1-is-specified.patch

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
Subject: profile: suppress warning about large allocations when profile=1 is specified
From: Mel Gorman <mel@csn.ul.ie>

When profile= is used, a large buffer is allocated early at boot.  This
can be larger than what the page allocator can provide so it prints a
warning.  However, the caller is able to handle the situation so this
patch suppresses the warning.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/profile.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/profile.c~profile-suppress-warning-about-large-allocations-when-profile=1-is-specified kernel/profile.c
--- a/kernel/profile.c~profile-suppress-warning-about-large-allocations-when-profile=1-is-specified
+++ a/kernel/profile.c
@@ -117,11 +117,12 @@ int __ref profile_init(void)
 
 	cpumask_copy(prof_cpu_mask, cpu_possible_mask);
 
-	prof_buffer = kzalloc(buffer_bytes, GFP_KERNEL);
+	prof_buffer = kzalloc(buffer_bytes, GFP_KERNEL|__GFP_NOWARN);
 	if (prof_buffer)
 		return 0;
 
-	prof_buffer = alloc_pages_exact(buffer_bytes, GFP_KERNEL|__GFP_ZERO);
+	prof_buffer = alloc_pages_exact(buffer_bytes,
+					GFP_KERNEL|__GFP_ZERO|__GFP_NOWARN);
 	if (prof_buffer)
 		return 0;
 
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

