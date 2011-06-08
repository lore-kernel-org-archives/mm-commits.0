From: akpm@linux-foundation.org
Subject: + bdi_min_ratio-never-shrinks-ultimately-preventing-valid-setting-of-min_ratio.patch added to -mm tree
Date: Tue, 07 Jun 2011 17:13:58 -0700
Message-ID: <201106080013.p580DxKF004303@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754303Ab1FHAOF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2011 20:14:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peterz@infradead.org, fengguang.wu@intel.com, lkml@pengaru.com, miklos@szeredi.hu, stable@kernel.org


The patch titled
     mm/backing-dev.c: reset bdi min_ratio in bdi_unregister()
has been added to the -mm tree.  Its filename is
     bdi_min_ratio-never-shrinks-ultimately-preventing-valid-setting-of-min_ratio.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/backing-dev.c: reset bdi min_ratio in bdi_unregister()
From: Peter Zijlstra <peterz@infradead.org>

Vito said:

: The system has many usb disks coming and going day to day, with their
: respective bdi's having min_ratio set to 1 when inserted.  It works for
: some time until eventually min_ratio can no longer be set, even when the
: active set of bdi's seen in /sys/class/bdi/*/min_ratio doesn't add up to
: anywhere near 100.
: 
: This then leads to an unrelated starvation problem caused by write-heavy
: fuse mounts being used atop the usb disks, a problem the min_ratio setting
: at the underlying devices bdi effectively prevents.

Fix this leakage by resetting the bdi min_ratio when unregistering the
BDI.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Reported-by: Vito Caputo <lkml@pengaru.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/backing-dev.c~bdi_min_ratio-never-shrinks-ultimately-preventing-valid-setting-of-min_ratio mm/backing-dev.c
--- a/mm/backing-dev.c~bdi_min_ratio-never-shrinks-ultimately-preventing-valid-setting-of-min_ratio
+++ a/mm/backing-dev.c
@@ -617,6 +617,7 @@ static void bdi_prune_sb(struct backing_
 void bdi_unregister(struct backing_dev_info *bdi)
 {
 	if (bdi->dev) {
+		bdi_set_min_ratio(bdi, 0);
 		trace_writeback_bdi_unregister(bdi);
 		bdi_prune_sb(bdi);
 		del_timer_sync(&bdi->wb.wakeup_timer);
_

Patches currently in -mm which might be from peterz@infradead.org are

init-calibratec-remove-annoying-printk.patch
linux-next.patch
bdi_min_ratio-never-shrinks-ultimately-preventing-valid-setting-of-min_ratio.patch

