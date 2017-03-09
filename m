From: akpm@linux-foundation.org
Subject: + kasan-resched-in-quarantine_remove_cache.patch added to -mm
 tree
Date: Thu, 09 Mar 2017 12:30:01 -0800
Message-ID: <58c1bb49.rqcfMPjhOMj8KSZn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58330 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750789AbdCIUc2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Mar 2017 15:32:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, aryabinin@virtuozzo.com, gthelen@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: resched in quarantine_remove_cache()
has been added to the -mm tree.  Its filename is
     kasan-resched-in-quarantine_remove_cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-resched-in-quarantine_remove_cache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-resched-in-quarantine_remove_cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dmitry Vyukov <dvyukov@google.com>
Subject: kasan: resched in quarantine_remove_cache()

We see reported stalls/lockups in quarantine_remove_cache() on machines
with large amounts of RAM.  quarantine_remove_cache() needs to scan whole
quarantine in order to take out all objects belonging to the cache. 
Quarantine is currently 1/32-th of RAM, e.g.  on a machine with 256GB of
memory that will be 8GB.  Moreover quarantine scanning is a walk over
uncached linked list, which is slow.

Add cond_resched() after scanning of each non-empty batch of objects. 
Batches are specifically kept of reasonable size for quarantine_put().  On
a machine with 256GB of RAM we should have ~512 non-empty batches, each
with 16MB of objects.

Link: http://lkml.kernel.org/r/20170308154239.25440-1-dvyukov@google.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/quarantine.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/kasan/quarantine.c~kasan-resched-in-quarantine_remove_cache mm/kasan/quarantine.c
--- a/mm/kasan/quarantine.c~kasan-resched-in-quarantine_remove_cache
+++ a/mm/kasan/quarantine.c
@@ -283,8 +283,15 @@ void quarantine_remove_cache(struct kmem
 	on_each_cpu(per_cpu_remove_cache, cache, 1);
 
 	spin_lock_irqsave(&quarantine_lock, flags);
-	for (i = 0; i < QUARANTINE_BATCHES; i++)
+	for (i = 0; i < QUARANTINE_BATCHES; i++) {
+		if (qlist_empty(&global_quarantine[i]))
+			continue;
 		qlist_move_cache(&global_quarantine[i], &to_free, cache);
+		/* Scanning whole quarantine can take a while. */
+		spin_unlock_irqrestore(&quarantine_lock, flags);
+		cond_resched();
+		spin_lock_irqsave(&quarantine_lock, flags);
+	}
 	spin_unlock_irqrestore(&quarantine_lock, flags);
 
 	qlist_free_all(&to_free, cache);
_

Patches currently in -mm which might be from dvyukov@google.com are

kasan-resched-in-quarantine_remove_cache.patch
kasan-fix-races-in-quarantine_remove_cache.patch

