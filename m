From: akpm@linux-foundation.org
Subject: [merged] mm-bugfix-set-current-reclaim_state-to-null-while-returning-from-kswapd.patch removed from -mm tree
Date: Mon, 12 Nov 2012 13:09:28 -0800
Message-ID: <20121112210928.BAB61100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:45286 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab2KLVJa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Nov 2012 16:09:30 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so782043yhl.1
        for <mm-commits@vger.kernel.org>; Mon, 12 Nov 2012 13:09:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: takamori.yamaguchi@jp.sony.com, aaditya.kumar@ap.sony.com, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: bugfix: set current->reclaim_state to NULL while returning from kswapd()
has been removed from the -mm tree.  Its filename was
     mm-bugfix-set-current-reclaim_state-to-null-while-returning-from-kswapd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Takamori Yamaguchi <takamori.yamaguchi@jp.sony.com>
Subject: mm: bugfix: set current->reclaim_state to NULL while returning from kswapd()

In kswapd(), set current->reclaim_state to NULL before returning, as
current->reclaim_state holds reference to variable on kswapd()'s stack.

In rare cases, while returning from kswapd() during memory offlining,
__free_slab() and freepages() can access the dangling pointer of
current->reclaim_state.

Signed-off-by: Takamori Yamaguchi <takamori.yamaguchi@jp.sony.com>
Signed-off-by: Aaditya Kumar <aaditya.kumar@ap.sony.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/vmscan.c~mm-bugfix-set-current-reclaim_state-to-null-while-returning-from-kswapd mm/vmscan.c
--- a/mm/vmscan.c~mm-bugfix-set-current-reclaim_state-to-null-while-returning-from-kswapd
+++ a/mm/vmscan.c
@@ -3017,6 +3017,8 @@ static int kswapd(void *p)
 						&balanced_classzone_idx);
 		}
 	}
+
+	current->reclaim_state = NULL;
 	return 0;
 }
 
_

Patches currently in -mm which might be from takamori.yamaguchi@jp.sony.com are


