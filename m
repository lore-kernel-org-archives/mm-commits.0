From: akpm@linux-foundation.org
Subject: +
 mm-kasan-slub-dont-disable-interrupts-when-object-leaves-quarantine.patch
 added to -mm tree
Date: Mon, 01 Aug 2016 13:16:12 -0700
Message-ID: <579fae0c.sheC3UhyIlAofYik%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41289 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864AbcHAUlt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2016 16:41:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kasan, slub: don't disable interrupts when object leaves quarantine
has been added to the -mm tree.  Its filename is
     mm-kasan-slub-dont-disable-interrupts-when-object-leaves-quarantine.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kasan-slub-dont-disable-interrupts-when-object-leaves-quarantine.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kasan-slub-dont-disable-interrupts-when-object-leaves-quarantine.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: mm/kasan, slub: don't disable interrupts when object leaves quarantine

SLUB doesn't require disabled interrupts to call ___cache_free().

Link: http://lkml.kernel.org/r/1470062715-14077-3-git-send-email-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Acked-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/quarantine.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN mm/kasan/quarantine.c~mm-kasan-slub-dont-disable-interrupts-when-object-leaves-quarantine mm/kasan/quarantine.c
--- a/mm/kasan/quarantine.c~mm-kasan-slub-dont-disable-interrupts-when-object-leaves-quarantine
+++ a/mm/kasan/quarantine.c
@@ -147,10 +147,14 @@ static void qlink_free(struct qlist_node
 	struct kasan_alloc_meta *alloc_info = get_alloc_info(cache, object);
 	unsigned long flags;
 
-	local_irq_save(flags);
+	if (IS_ENABLED(CONFIG_SLAB))
+		local_irq_save(flags);
+
 	alloc_info->state = KASAN_STATE_FREE;
 	___cache_free(cache, object, _THIS_IP_);
-	local_irq_restore(flags);
+
+	if (IS_ENABLED(CONFIG_SLAB))
+		local_irq_restore(flags);
 }
 
 static void qlist_free_all(struct qlist_head *q, struct kmem_cache *cache)
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

mm-kasan-fix-corruptions-and-false-positive-reports.patch
mm-kasan-dont-reduce-quarantine-in-atomic-contexts.patch
mm-kasan-slub-dont-disable-interrupts-when-object-leaves-quarantine.patch
mm-kasan-get-rid-of-alloc_size-in-struct-kasan_alloc_meta.patch
mm-kasan-get-rid-of-state-in-struct-kasan_alloc_meta.patch
kasan-improve-double-free-reports.patch

