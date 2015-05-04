From: akpm@linux-foundation.org
Subject: + mm-meminit-inline-some-helper-functions-fix2.patch added to -mm tree
Date: Mon, 04 May 2015 14:01:12 -0700
Message-ID: <5547de18.sWQaRzXjMaSE0sh5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41165 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbbEDVBN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2015 17:01:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-meminit-inline-some-helper-functions-fix2
has been added to the -mm tree.  Its filename is
     mm-meminit-inline-some-helper-functions-fix2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-meminit-inline-some-helper-functions-fix2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-meminit-inline-some-helper-functions-fix2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm-meminit-inline-some-helper-functions-fix2

mm/page_alloc.c: In function `deferred_init_memmap':
mm/page_alloc.c:1135:4: error: implicit declaration of function `meminit_pfn_in_nid' [-Werror=implicit-function-declaration]
    if (!meminit_pfn_in_nid(pfn, nid, &nid_init_state)) {
    ^

because randconfig decided to disable CONFIG_NODES_SPAN_OTHER_NODES.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/page_alloc.c~mm-meminit-inline-some-helper-functions-fix2 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-meminit-inline-some-helper-functions-fix2
+++ a/mm/page_alloc.c
@@ -957,6 +957,11 @@ static inline bool __meminit early_pfn_i
 {
 	return true;
 }
+static inline bool __meminit meminit_pfn_in_nid(unsigned long pfn, int node,
+					struct mminit_pfnnid_cache *state)
+{
+	return true;
+}
 #endif
 
 
_

Patches currently in -mm which might be from mhocko@suse.cz are

jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
mm-meminit-inline-some-helper-functions-fix2.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-reclaimable-pages.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
exitstats-obey-this-comment.patch

