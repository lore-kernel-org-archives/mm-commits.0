From: akpm@linux-foundation.org
Subject: + hwpoison-change-order-of-error_statess-elements.patch added to -mm tree
Date: Thu, 07 Feb 2013 14:24:29 -0800
Message-ID: <20130207222430.A0C3B1CA15E@corp2gmr1-1.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:58954 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422664Ab3BGWYd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Feb 2013 17:24:33 -0500
Received: by mail-wi0-f202.google.com with SMTP id hm11so7343wib.5
        for <mm-commits@vger.kernel.org>; Thu, 07 Feb 2013 14:24:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, fengguang.wu@intel.com, gong.chen@linux.intel.com, tony.luck@intel.com


The patch titled
     Subject: HWPOISON: change order of error_states[]'s elements
has been added to the -mm tree.  Its filename is
     hwpoison-change-order-of-error_statess-elements.patch

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
Subject: HWPOISON: change order of error_states[]'s elements

error_states[] has two separate states "unevictable LRU page" and "mlocked
LRU page", and the former one has the higher priority now.  But because of
that the latter one is rarely chosen because pages with PageMlocked highly
likely have PG_unevictable set.  On the other hand, PG_unevictable without
PageMlocked is common for ramfs or SHM_LOCKed shared memory, so reversing
the priority of these two states helps us clearly distinguish them.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Chen Gong <gong.chen@linux.intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/memory-failure.c~hwpoison-change-order-of-error_statess-elements mm/memory-failure.c
--- a/mm/memory-failure.c~hwpoison-change-order-of-error_statess-elements
+++ a/mm/memory-failure.c
@@ -784,12 +784,12 @@ static struct page_state {
 	{ sc|dirty,	sc|dirty,	"dirty swapcache",	me_swapcache_dirty },
 	{ sc|dirty,	sc,		"clean swapcache",	me_swapcache_clean },
 
-	{ unevict|dirty, unevict|dirty,	"dirty unevictable LRU", me_pagecache_dirty },
-	{ unevict,	unevict,	"clean unevictable LRU", me_pagecache_clean },
