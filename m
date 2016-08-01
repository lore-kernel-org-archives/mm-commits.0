From: akpm@linux-foundation.org
Subject: +
 kasan-avoid-overflowing-quarantine-size-on-low-memory-systems.patch added
 to -mm tree
Date: Mon, 01 Aug 2016 13:30:49 -0700
Message-ID: <579fb179.aausjFoaiu6hOtuS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41291 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbcHAUlt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2016 16:41:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glider@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: avoid overflowing quarantine size on low memory systems
has been added to the -mm tree.  Its filename is
     kasan-avoid-overflowing-quarantine-size-on-low-memory-systems.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-avoid-overflowing-quarantine-size-on-low-memory-systems.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-avoid-overflowing-quarantine-size-on-low-memory-systems.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: kasan: avoid overflowing quarantine size on low memory systems

If the total amount of memory assigned to quarantine is less than the
amount of memory assigned to per-cpu quarantines, |new_quarantine_size|
may overflow.  Instead, set it to zero.

Link: http://lkml.kernel.org/r/1470063563-96266-1-git-send-email-glider@google.com
Fixes: 55834c59098d ("mm: kasan: initial memory quarantine implementation")
Signed-off-by: Alexander Potapenko <glider@google.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/quarantine.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN mm/kasan/quarantine.c~kasan-avoid-overflowing-quarantine-size-on-low-memory-systems mm/kasan/quarantine.c
--- a/mm/kasan/quarantine.c~kasan-avoid-overflowing-quarantine-size-on-low-memory-systems
+++ a/mm/kasan/quarantine.c
@@ -198,7 +198,7 @@ void quarantine_put(struct kasan_free_me
 
 void quarantine_reduce(void)
 {
-	size_t new_quarantine_size;
+	size_t new_quarantine_size, percpu_quarantines;
 	unsigned long flags;
 	struct qlist_head to_free = QLIST_INIT;
 	size_t size_to_free = 0;
@@ -216,7 +216,15 @@ void quarantine_reduce(void)
 	 */
 	new_quarantine_size = (READ_ONCE(totalram_pages) << PAGE_SHIFT) /
 		QUARANTINE_FRACTION;
-	new_quarantine_size -= QUARANTINE_PERCPU_SIZE * num_online_cpus();
+	percpu_quarantines = QUARANTINE_PERCPU_SIZE * num_online_cpus();
+	if (new_quarantine_size < percpu_quarantines) {
+		WARN_ONCE(1,
+			"Too little memory, disabling global KASAN quarantine.\n",
+		);
+		new_quarantine_size = 0;
+	} else {
+		new_quarantine_size -= percpu_quarantines;
+	}
 	WRITE_ONCE(quarantine_size, new_quarantine_size);
 
 	last = global_quarantine.head;
_

Patches currently in -mm which might be from glider@google.com are

kasan-avoid-overflowing-quarantine-size-on-low-memory-systems.patch

