From: akpm@linux-foundation.org
Subject: + mm-buddy-dump-pg_compound_lock-page-flag.patch added to -mm tree
Date: Tue, 15 May 2012 15:18:46 -0700
Message-ID: <20120515221847.206B8A0162@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:36267 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964932Ab2EOWSt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 May 2012 18:18:49 -0400
Received: by bkty5 with SMTP id y5so3216bkt.1
        for <mm-commits@vger.kernel.org>; Tue, 15 May 2012 15:18:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shangw@linux.vnet.ibm.com, hannes@cmpxchg.org


The patch titled
     Subject: mm/buddy: dump PG_compound_lock page flag
has been added to the -mm tree.  Its filename is
     mm-buddy-dump-pg_compound_lock-page-flag.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: mm/buddy: dump PG_compound_lock page flag

The array pageflag_names[] does conversion from page flags into their
corresponding names so that a meaningful representation of the
corresponding page flag can be printed.  This mechanism is used while
dumping page frames.  However, the array missed PG_compound_lock.  So the
PG_compound_lock page flag would be printed as a digital number instead of
a meaningful string.

The patch fixes that and prints "compound_lock" for the PG_compound_lock
page flag.

Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/page_alloc.c~mm-buddy-dump-pg_compound_lock-page-flag mm/page_alloc.c
--- a/mm/page_alloc.c~mm-buddy-dump-pg_compound_lock-page-flag
+++ a/mm/page_alloc.c
@@ -5969,6 +5969,9 @@ static struct trace_print_flags pageflag
 #ifdef CONFIG_MEMORY_FAILURE
 	{1UL << PG_hwpoison,		"hwpoison"	},
 #endif
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	{1UL << PG_compound_lock,	"compound_lock"	},
+#endif
 	{-1UL,				NULL		},
 };
 
_
Subject: Subject: mm/buddy: dump PG_compound_lock page flag

Patches currently in -mm which might be from shangw@linux.vnet.ibm.com are

mm-slab-remove-duplicate-check.patch
mm-bootmem-fix-checking-the-bitmap-when-finally-freeing-bootmem.patch
mm-bootmem-rename-alloc_bootmem_core-to-alloc_bootmem_bdata.patch
mm-bootmem-split-out-goal-to-node-mapping-from-goal-dropping.patch
mm-bootmem-allocate-in-order-nodegoal-goal-node-anywhere.patch
mm-bootmem-unify-allocation-policy-of-non-panicking-node-allocations.patch
mm-nobootmem-panic-on-node-specific-allocation-failure.patch
mm-nobootmem-unify-allocation-policy-of-non-panicking-node-allocations.patch
mm-bootmem-pass-pgdat-instead-of-pgdat-bdata-down-the-stack.patch
mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator.patch
mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator-fix.patch
mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator-fix-2.patch
mm-buddy-dump-pg_compound_lock-page-flag.patch
mm-page_alloc-catch-out-of-date-list-of-page-flag-names.patch
mm-page_allocc-cleanups.patch

