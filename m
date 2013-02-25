From: akpm@linux-foundation.org
Subject: + hwpoison-check-dirty-flag-to-match-against-clean-page.patch added to -mm tree
Date: Mon, 25 Feb 2013 13:43:52 -0800
Message-ID: <20130225214353.169E75A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:65329 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab3BYVny (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 16:43:54 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so369506qah.2
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 13:43:53 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, fengguang.wu@intel.com, gong.chen@linux.intel.com, tony.luck@intel.com


The patch titled
     Subject: HWPOISON: check dirty flag to match against clean page
has been added to the -mm tree.  Its filename is
     hwpoison-check-dirty-flag-to-match-against-clean-page.patch

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
hwpoison-check-dirty-flag-to-match-against-clean-page.patch

