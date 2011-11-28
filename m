From: akpm@linux-foundation.org
Subject: + mm-debug-test-for-online-nid-when-allocating-on-single-node.patch added to -mm tree
Date: Mon, 28 Nov 2011 13:37:03 -0800
Message-ID: <201111282137.pASLb36b009986@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:54029 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab1K1VhK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2011 16:37:10 -0500
Received: by eeuu44 with SMTP id u44so48853eeu.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2011 13:37:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, mgorman@suse.de


The patch titled
     Subject: mm, debug: test for online nid when allocating on single node
has been added to the -mm tree.  Its filename is
     mm-debug-test-for-online-nid-when-allocating-on-single-node.patch

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
From: David Rientjes <rientjes@google.com>
Subject: mm, debug: test for online nid when allocating on single node

Calling alloc_pages_exact_node() means the allocation only passes the
zonelist of a single node into the page allocator.  If that node isn't
online, it's zonelist may never have been initialized causing a strange
oops that may not immediately be clear.

I recently debugged an issue where node 0 wasn't online and an allocator
was passing 0 to alloc_pages_exact_node() and it resulted in a NULL
pointer on zonelist->_zoneref.  If CONFIG_DEBUG_VM is enabled, though, it
would be nice to catch this a bit earlier.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/gfp.h~mm-debug-test-for-online-nid-when-allocating-on-single-node include/linux/gfp.h
--- a/include/linux/gfp.h~mm-debug-test-for-online-nid-when-allocating-on-single-node
+++ a/include/linux/gfp.h
@@ -324,7 +324,7 @@ static inline struct page *alloc_pages_n
 static inline struct page *alloc_pages_exact_node(int nid, gfp_t gfp_mask,
 						unsigned int order)
 {
-	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
+	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES || !node_online(nid));
 
 	return __alloc_pages(gfp_mask, order, node_zonelist(nid, gfp_mask));
 }
_
Subject: Subject: mm, debug: test for online nid when allocating on single node

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask.patch
drm-avoid-switching-to-text-console-if-there-is-no-panic-timeout.patch
mm-avoid-livelock-on-__gfp_fs-allocations-v2.patch
kernelh-add-build_bug-macro.patch
hugetlb-replace-bug-with-build_bug-for-dummy-definitions.patch
thp-improve-the-error-code-path.patch
thp-remove-unnecessary-tlb-flush-for-mprotect.patch
thp-add-tlb_remove_pmd_tlb_entry.patch
mm-debug-test-for-online-nid-when-allocating-on-single-node.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch

