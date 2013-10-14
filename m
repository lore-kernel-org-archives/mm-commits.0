From: akpm@linux-foundation.org
Subject: + writeback-fix-negative-bdi-max-pause.patch added to -mm tree
Date: Mon, 14 Oct 2013 12:14:48 -0700
Message-ID: <525c42a8.Hx9uV5y/aiSdaHUj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42476 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590Ab3JNTOt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Oct 2013 15:14:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, toralf.foerster@gmx.de, stable@vger.kernel.org, richard@nod.at, jack@suse.cz, geert@linux-m68k.org, fengguang.wu@intel.com

Subject: + writeback-fix-negative-bdi-max-pause.patch added to -mm tree
To: fengguang.wu@intel.com,geert@linux-m68k.org,jack@suse.cz,richard@nod.at,stable@vger.kernel.org,toralf.foerster@gmx.de
From: akpm@linux-foundation.org
Date: Mon, 14 Oct 2013 12:14:48 -0700


The patch titled
     Subject: writeback: fix negative bdi max pause
has been added to the -mm tree.  Its filename is
     writeback-fix-negative-bdi-max-pause.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/writeback-fix-negative-bdi-max-pause.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/writeback-fix-negative-bdi-max-pause.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: writeback: fix negative bdi max pause

Toralf runs trinity on UML/i386.  After some time it hangs and the last
message line is

	BUG: soft lockup - CPU#0 stuck for 22s! [trinity-child0:1521]

It's found that pages_dirtied becomes very large.  More than 1000000000
pages in this case:

	period = HZ * pages_dirtied / task_ratelimit;
	BUG_ON(pages_dirtied > 2000000000);
	BUG_ON(pages_dirtied > 1000000000);      <---------

UML debug printf shows that we got negative pause here:

	ick: pause : -984
	ick: pages_dirtied : 0
	ick: task_ratelimit: 0

	 pause:
	+       if (pause < 0)  {
	+               extern int printf(char *, ...);
	+               printf("ick : pause : %li\n", pause);
	+               printf("ick: pages_dirtied : %lu\n", pages_dirtied);
	+               printf("ick: task_ratelimit: %lu\n", task_ratelimit);
	+               BUG_ON(1);
	+       }
	        trace_balance_dirty_pages(bdi,

Since pause is bounded by [min_pause, max_pause] where min_pause is also
bounded by max_pause.  It's suspected and demonstrated that the max_pause
calculation goes wrong:

	ick: pause : -717
	ick: min_pause : -177
	ick: max_pause : -717
	ick: pages_dirtied : 14
	ick: task_ratelimit: 0

The problem lies in the two "long = unsigned long" assignments in
bdi_max_pause() which might go negative if the highest bit is 1, and the
min_t(long, ...) check failed to protect it falling under 0.  Fix all of
them by using "unsigned long" throughout the function.

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Reported-by: Toralf Förster <toralf.foerster@gmx.de>
Tested-by: Toralf Förster <toralf.foerster@gmx.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Richard Weinberger <richard@nod.at>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/page-writeback.c~writeback-fix-negative-bdi-max-pause mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-fix-negative-bdi-max-pause
+++ a/mm/page-writeback.c
@@ -1210,11 +1210,11 @@ static unsigned long dirty_poll_interval
 	return 1;
 }
 
-static long bdi_max_pause(struct backing_dev_info *bdi,
-			  unsigned long bdi_dirty)
+static unsigned long bdi_max_pause(struct backing_dev_info *bdi,
+				   unsigned long bdi_dirty)
 {
-	long bw = bdi->avg_write_bandwidth;
-	long t;
+	unsigned long bw = bdi->avg_write_bandwidth;
+	unsigned long t;
 
 	/*
 	 * Limit pause time for small memory systems. If sleeping for too long
@@ -1226,7 +1226,7 @@ static long bdi_max_pause(struct backing
 	t = bdi_dirty / (1 + bw / roundup_pow_of_two(1 + HZ / 8));
 	t++;
 
-	return min_t(long, t, MAX_PAUSE);
+	return min_t(unsigned long, t, MAX_PAUSE);
 }
 
 static long bdi_min_pause(struct backing_dev_info *bdi,
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

writeback-fix-negative-bdi-max-pause.patch
mm-readaheadc-return-the-value-which-force_page_cache_readahead-returns.patch
smaps-show-vm_softdirty-flag-in-vmflags-line.patch
smaps-show-vm_softdirty-flag-in-vmflags-line-fix.patch
page-typesc-support-kpf_softdirty-bit.patch
writeback-do-not-sync-data-dirtied-after-sync-start.patch
writeback-do-not-sync-data-dirtied-after-sync-start-fix.patch
writeback-do-not-sync-data-dirtied-after-sync-start-fix-2.patch
mm-page-writebackc-fix-bdi-max-pause-calculation.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
debugging-keep-track-of-page-owner-now-depends-on-stacktrace_support.patch

