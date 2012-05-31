From: akpm@linux-foundation.org
Subject: [merged] mm-buddy-dump-pg_compound_lock-page-flag.patch removed from -mm tree
Date: Thu, 31 May 2012 12:15:59 -0700
Message-ID: <20120531191559.5B2BDA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:60314 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932944Ab2EaTQA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:16:00 -0400
Received: by mail-qc0-f202.google.com with SMTP id p5so136095qcs.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:16:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shangw@linux.vnet.ibm.com, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/buddy: dump PG_compound_lock page flag
has been removed from the -mm tree.  Its filename was
     mm-buddy-dump-pg_compound_lock-page-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -5973,6 +5973,9 @@ static struct trace_print_flags pageflag
 #ifdef CONFIG_MEMORY_FAILURE
 	{1UL << PG_hwpoison,		"hwpoison"	},
 #endif
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	{1UL << PG_compound_lock,	"compound_lock"	},
+#endif
 	{-1UL,				NULL		},
 };
 
_

Patches currently in -mm which might be from shangw@linux.vnet.ibm.com are

origin.patch
mm-slab-remove-duplicate-check.patch

