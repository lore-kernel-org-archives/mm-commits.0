From: akpm@linux-foundation.org
Subject: + slub-drop-lockdep_assert_held-from-put_map.patch added to
 -mm tree
Date: Sat, 20 Jun 2020 18:13:18 -0700
Message-ID: <20200621011318.qfCQS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728952AbgFUBNU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 20 Jun 2020 21:13:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yuzhao@google.com, tglx@linutronix.de, rientjes@google.com, penberg@kernel.org, iamjoonsoo.kim@lge.com, cl@linux.com, bigeasy@linutronix.de


The patch titled
     Subject: mm/slub.c: drop lockdep_assert_held() from put_map()
has been added to the -mm tree.  Its filename is
     slub-drop-lockdep_assert_held-from-put_map.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-drop-lockdep_assert_held-from-put_map.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-drop-lockdep_assert_held-from-put_map.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm/slub.c: drop lockdep_assert_held() from put_map()

There is no point in using lockdep_assert_held() unlock that is about to
be unlocked.  It works only with lockdep and lockdep will complain if
spin_unlock() is used on a lock that has not been locked.

Remove superfluous lockdep_assert_held().

Link: http://lkml.kernel.org/r/20200618201234.795692-2-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Christopher Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/slub.c~slub-drop-lockdep_assert_held-from-put_map
+++ a/mm/slub.c
@@ -473,8 +473,6 @@ static unsigned long *get_map(struct kme
 static void put_map(unsigned long *map) __releases(&object_map_lock)
 {
 	VM_BUG_ON(map != object_map);
-	lockdep_assert_held(&object_map_lock);
