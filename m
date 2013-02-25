From: akpm@linux-foundation.org
Subject: [merged] hwpoison-change-order-of-error_statess-elements.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:55:37 -0800
Message-ID: <20130225205537.BC88C31C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:64613 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759805Ab3BYUzj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:55:39 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so348016vch.0
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:55:38 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, fengguang.wu@intel.com, gong.chen@linux.intel.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: HWPOISON: change order of error_states[]'s elements
has been removed from the -mm tree.  Its filename was
     hwpoison-change-order-of-error_statess-elements.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
