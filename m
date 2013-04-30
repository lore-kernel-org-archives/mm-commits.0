From: akpm@linux-foundation.org
Subject: [merged] hwpoison-check-dirty-flag-to-match-against-clean-page.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:44:21 -0700
Message-ID: <20130430184421.807A731C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:40385 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932735Ab3D3SoX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:44:23 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so84543qcr.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:44:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, fengguang.wu@intel.com, gong.chen@linux.intel.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: HWPOISON: check dirty flag to match against clean page
has been removed from the -mm tree.  Its filename was
     hwpoison-check-dirty-flag-to-match-against-clean-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: HWPOISON: check dirty flag to match against clean page

Currently page_action() does not check dirty flag to determine whether the
error page is "clean mlocked/unevictable LRU" page.  This doesn't cause
any misjudgement because we do matching against "dirty mlocked/unevictable
LRU" just before the check.  But in order to make code consistent and/or
to avoid potential regression, we had better check dirty flag explicitly.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Suggested-by: Chen Gong <gong.chen@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory-failure.c~hwpoison-check-dirty-flag-to-match-against-clean-page mm/memory-failure.c
--- a/mm/memory-failure.c~hwpoison-check-dirty-flag-to-match-against-clean-page
+++ a/mm/memory-failure.c
@@ -785,10 +785,10 @@ static struct page_state {
 	{ sc|dirty,	sc,		"clean swapcache",	me_swapcache_clean },
 
 	{ mlock|dirty,	mlock|dirty,	"dirty mlocked LRU",	me_pagecache_dirty },
-	{ mlock,	mlock,		"clean mlocked LRU",	me_pagecache_clean },
+	{ mlock|dirty,	mlock,		"clean mlocked LRU",	me_pagecache_clean },
 
 	{ unevict|dirty, unevict|dirty,	"dirty unevictable LRU", me_pagecache_dirty },
-	{ unevict,	unevict,	"clean unevictable LRU", me_pagecache_clean },
+	{ unevict|dirty, unevict,	"clean unevictable LRU", me_pagecache_clean },
 
 	{ lru|dirty,	lru|dirty,	"dirty LRU",	me_pagecache_dirty },
 	{ lru|dirty,	lru,		"clean LRU",	me_pagecache_clean },
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch

