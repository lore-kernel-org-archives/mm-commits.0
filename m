From: akpm@linux-foundation.org
Subject: + mm-vmallocc-add-a-schedule-point-to-vmalloc.patch added to -mm
 tree
Date: Tue, 24 Jun 2014 15:10:41 -0700
Message-ID: <53a9f761.niOuC8+VUMs0utDe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37296 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbaFXWKl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 18:10:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edumazet@google.com, hughd@google.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: add a schedule point to vmalloc()
has been added to the -mm tree.  Its filename is
     mm-vmallocc-add-a-schedule-point-to-vmalloc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmallocc-add-a-schedule-point-to-vmalloc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmallocc-add-a-schedule-point-to-vmalloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Dumazet <edumazet@google.com>
Subject: mm/vmalloc.c: add a schedule point to vmalloc()

It is not uncommon on busy servers to get stuck hundred of ms in vmalloc()
calls (like file descriptor expansions).

Add a cond_resched() to __vmalloc_area_node() to be gentle to
other tasks.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/vmalloc.c~mm-vmallocc-add-a-schedule-point-to-vmalloc mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmallocc-add-a-schedule-point-to-vmalloc
+++ a/mm/vmalloc.c
@@ -1602,6 +1602,7 @@ static void *__vmalloc_area_node(struct
 			goto fail;
 		}
 		area->pages[i] = page;
+		cond_resched();
 	}
 
 	if (map_vm_area(area, prot, &pages))
_

Patches currently in -mm which might be from edumazet@google.com are

vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc.patch
linux-next.patch

