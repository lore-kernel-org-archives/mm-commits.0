From: akpm@linux-foundation.org
Subject: + mm-page-writebackc-fix-bdi-max-pause-calculation.patch added to -mm tree
Date: Fri, 11 Oct 2013 11:53:10 -0700
Message-ID: <52584916.HqtGdzJq89jlfUHb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab3JKSxL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Oct 2013 14:53:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, toralf.foerster@gmx.de, stable@vger.kernel.org, fengguang.wu@intel.com

Subject: + mm-page-writebackc-fix-bdi-max-pause-calculation.patch added to -mm tree
To: fengguang.wu@intel.com,stable@vger.kernel.org,toralf.foerster@gmx.de
From: akpm@linux-foundation.org
Date: Fri, 11 Oct 2013 11:53:10 -0700


The patch titled
     Subject: mm/page-writeback.c: fix bdi max pause calculation
has been added to the -mm tree.  Its filename is
     mm-page-writebackc-fix-bdi-max-pause-calculation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page-writebackc-fix-bdi-max-pause-calculation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page-writebackc-fix-bdi-max-pause-calculation.patch

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
Subject: mm/page-writeback.c: fix bdi max pause calculation

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Reported-by: Toralf Förster <toralf.foerster@gmx.de>
Tested-by: Toralf Förster <toralf.foerster@gmx.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/page-writeback.c~mm-page-writebackc-fix-bdi-max-pause-calculation mm/page-writeback.c
--- a/mm/page-writeback.c~mm-page-writebackc-fix-bdi-max-pause-calculation
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

origin.patch
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

