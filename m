From: akpm@linux-foundation.org
Subject: [merged] mm-vmallocc-add-a-schedule-point-to-vmalloc.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:04:59 -0700
Message-ID: <53e3dbeb.Zc6vR8xHPQf4RMtx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:57152 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaHGUFA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:05:00 -0400
Received: by mail-yh0-f73.google.com with SMTP id f73so608463yha.2
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:04:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edumazet@google.com, hughd@google.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: add a schedule point to vmalloc()
has been removed from the -mm tree.  Its filename was
     mm-vmallocc-add-a-schedule-point-to-vmalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Eric Dumazet <edumazet@google.com>
Subject: mm/vmalloc.c: add a schedule point to vmalloc()

It is not uncommon on busy servers to get stuck hundred of ms in vmalloc()
calls (like file descriptor expansions).

Add a cond_resched() to __vmalloc_area_node() to be gentle to
other tasks.

[akpm@linux-foundation.org: only do it for __GFP_WAIT, per David]
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Hugh Dickins <hughd@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/vmalloc.c~mm-vmallocc-add-a-schedule-point-to-vmalloc mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmallocc-add-a-schedule-point-to-vmalloc
+++ a/mm/vmalloc.c
@@ -1602,6 +1602,8 @@ static void *__vmalloc_area_node(struct
 			goto fail;
 		}
 		area->pages[i] = page;
+		if (gfp_mask & __GFP_WAIT)
+			cond_resched();
 	}
 
 	if (map_vm_area(area, prot, &pages))
_

Patches currently in -mm which might be from edumazet@google.com are

origin.patch
linux-next.patch

