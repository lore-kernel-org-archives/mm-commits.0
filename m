From: akpm@linux-foundation.org
Subject: + kasan-remove-the-unnecessary-warn_once-from-quarantinec.patch
 added to -mm tree
Date: Thu, 11 Aug 2016 13:16:20 -0700
Message-ID: <57acdd14.TJZRAgBtu6Ba2Mdz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51858 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176AbcHKUQV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2016 16:16:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glider@google.com, adech.fo@gmail.com, aryabinin@virtuozzo.com, cl@linux.com, dvyukov@google.com, iamjoonsoo.kim@lge.com, kuthonuzo.luruo@hpe.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: remove the unnecessary WARN_ONCE from quarantine.c
has been added to the -mm tree.  Its filename is
     kasan-remove-the-unnecessary-warn_once-from-quarantinec.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-remove-the-unnecessary-warn_once-from-quarantinec.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-remove-the-unnecessary-warn_once-from-quarantinec.patch

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
Subject: kasan: remove the unnecessary WARN_ONCE from quarantine.c

It's quite unlikely that the user will so little memory that the
per-CPU quarantines won't fit into the given fraction of the available
memory. Even in that case he won't be able to do anything with the
information given in the warning.

Link: http://lkml.kernel.org/r/1470929182-101413-1-git-send-email-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Konovalov <adech.fo@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kuthonuzo Luruo <kuthonuzo.luruo@hpe.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/quarantine.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN mm/kasan/quarantine.c~kasan-remove-the-unnecessary-warn_once-from-quarantinec mm/kasan/quarantine.c
--- a/mm/kasan/quarantine.c~kasan-remove-the-unnecessary-warn_once-from-quarantinec
+++ a/mm/kasan/quarantine.c
@@ -217,11 +217,8 @@ void quarantine_reduce(void)
 	new_quarantine_size = (READ_ONCE(totalram_pages) << PAGE_SHIFT) /
 		QUARANTINE_FRACTION;
 	percpu_quarantines = QUARANTINE_PERCPU_SIZE * num_online_cpus();
-	if (WARN_ONCE(new_quarantine_size < percpu_quarantines,
-		"Too little memory, disabling global KASAN quarantine.\n"))
-		new_quarantine_size = 0;
-	else
-		new_quarantine_size -= percpu_quarantines;
+	new_quarantine_size = (new_quarantine_size < percpu_quarantines) ?
+		0 : new_quarantine_size - percpu_quarantines;
 	WRITE_ONCE(quarantine_size, new_quarantine_size);
 
 	last = global_quarantine.head;
_

Patches currently in -mm which might be from glider@google.com are

kasan-remove-the-unnecessary-warn_once-from-quarantinec.patch

