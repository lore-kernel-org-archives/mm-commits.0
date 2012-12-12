From: akpm@linux-foundation.org
Subject: [merged] hwpoison-fix-action_result-to-print-out-dirty-clean.patch removed from -mm tree
Date: Wed, 12 Dec 2012 11:58:52 -0800
Message-ID: <20121212195852.CA37D82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:61479 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149Ab2LLUEE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 15:04:04 -0500
Received: by mail-qa0-f73.google.com with SMTP id a19so120511qad.2
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 12:04:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, j-nomura@ce.jp.nec.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hwpoison: fix action_result() to print out dirty/clean
has been removed from the -mm tree.  Its filename was
     hwpoison-fix-action_result-to-print-out-dirty-clean.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: hwpoison: fix action_result() to print out dirty/clean

action_result() fails to print out "dirty" even if an error occurred on a
dirty pagecache, because when we check PageDirty in action_result() it was
cleared after page isolation even if it's dirty before error handling. 
This can break some applications that monitor this message, so should be
fixed.

There are several callers of action_result() except page_action(), but
either of them are not for LRU pages but for free pages or kernel pages,
so we don't have to consider dirty or not for them.

Note that PG_dirty can be set outside page locks as described in commit
6746aff74da29 ("HWPOISON: shmem: call set_page_dirty() with locked page"),
so this patch does not completely closes the race window, but just narrows
it.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN mm/memory-failure.c~hwpoison-fix-action_result-to-print-out-dirty-clean mm/memory-failure.c
--- a/mm/memory-failure.c~hwpoison-fix-action_result-to-print-out-dirty-clean
+++ a/mm/memory-failure.c
@@ -781,16 +781,16 @@ static struct page_state {
 	{ compound,	compound,	"huge",		me_huge_page },
 #endif
 
-	{ sc|dirty,	sc|dirty,	"swapcache",	me_swapcache_dirty },
-	{ sc|dirty,	sc,		"swapcache",	me_swapcache_clean },
+	{ sc|dirty,	sc|dirty,	"dirty swapcache",	me_swapcache_dirty },
+	{ sc|dirty,	sc,		"clean swapcache",	me_swapcache_clean },
 
-	{ unevict|dirty, unevict|dirty,	"unevictable LRU", me_pagecache_dirty},
-	{ unevict,	unevict,	"unevictable LRU", me_pagecache_clean},
+	{ unevict|dirty, unevict|dirty,	"dirty unevictable LRU", me_pagecache_dirty },
+	{ unevict,	unevict,	"clean unevictable LRU", me_pagecache_clean },
 
-	{ mlock|dirty,	mlock|dirty,	"mlocked LRU",	me_pagecache_dirty },
-	{ mlock,	mlock,		"mlocked LRU",	me_pagecache_clean },
+	{ mlock|dirty,	mlock|dirty,	"dirty mlocked LRU",	me_pagecache_dirty },
+	{ mlock,	mlock,		"clean mlocked LRU",	me_pagecache_clean },
 
-	{ lru|dirty,	lru|dirty,	"LRU",		me_pagecache_dirty },
+	{ lru|dirty,	lru|dirty,	"dirty LRU",	me_pagecache_dirty },
 	{ lru|dirty,	lru,		"clean LRU",	me_pagecache_clean },
 
 	/*
@@ -812,14 +812,14 @@ static struct page_state {
 #undef slab
 #undef reserved
 
+/*
+ * "Dirty/Clean" indication is not 100% accurate due to the possibility of
+ * setting PG_dirty outside page lock. See also comment above set_page_dirty().
+ */
 static void action_result(unsigned long pfn, char *msg, int result)
 {
-	struct page *page = pfn_to_page(pfn);
