From: akpm@linux-foundation.org
Subject: + mm-do-not-overwrite-reserved-pages-counter-at-show_mem.patch
 added to -mm tree
Date: Mon, 17 Nov 2014 15:49:34 -0800
Message-ID: <546a898e./68I6DuJn06mgBHb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52284 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbaKQXtg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Nov 2014 18:49:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aquini@redhat.com, jweiner@redhat.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: do not overwrite reserved pages counter at show_mem()
has been added to the -mm tree.  Its filename is
     mm-do-not-overwrite-reserved-pages-counter-at-show_mem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-do-not-overwrite-reserved-pages-counter-at-show_mem.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-do-not-overwrite-reserved-pages-counter-at-show_mem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rafael Aquini <aquini@redhat.com>
Subject: mm: do not overwrite reserved pages counter at show_mem()

Minor fixlet to perform the reserved pages counter aggregation for each
node, at show_mem()

Signed-off-by: Rafael Aquini <aquini@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/show_mem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/show_mem.c~mm-do-not-overwrite-reserved-pages-counter-at-show_mem lib/show_mem.c
--- a/lib/show_mem.c~mm-do-not-overwrite-reserved-pages-counter-at-show_mem
+++ a/lib/show_mem.c
@@ -28,7 +28,7 @@ void show_mem(unsigned int filter)
 				continue;
 
 			total += zone->present_pages;
-			reserved = zone->present_pages - zone->managed_pages;
+			reserved += zone->present_pages - zone->managed_pages;
 
 			if (is_highmem_idx(zoneid))
 				highmem += zone->present_pages;
_

Patches currently in -mm which might be from aquini@redhat.com are

mm-do-not-overwrite-reserved-pages-counter-at-show_mem.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-semc-increase-semmsl-semmni-semopm.patch
ipc-msg-increase-msgmni-remove-scaling.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
mm-cma-split-cma-reserved-in-dmesg-log.patch
fs-proc-include-cma-info-in-proc-meminfo.patch

