From: akpm@linux-foundation.org
Subject: + hwpoison-fix-action_result-to-print-out-dirty-clean.patch added to -mm tree
Date: Mon, 05 Nov 2012 13:56:39 -0800
Message-ID: <20121105215639.CD07D1000AD@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:57204 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222Ab2KEV4l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2012 16:56:41 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so425405qcq.1
        for <mm-commits@vger.kernel.org>; Mon, 05 Nov 2012 13:56:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, j-nomura@ce.jp.nec.com, tony.luck@intel.com


The patch titled
     Subject: mm: hwpoison: fix action_result() to print out dirty/clean
has been added to the -mm tree.  Its filename is
     hwpoison-fix-action_result-to-print-out-dirty-clean.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
554940dc8c1e, so this patch does not completely closes the race window,
but just narrows it.

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
