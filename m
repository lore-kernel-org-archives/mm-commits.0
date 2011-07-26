From: akpm@linux-foundation.org
Subject: [merged] bdi_min_ratio-never-shrinks-ultimately-preventing-valid-setting-of-min_ratio.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:52:15 -0700
Message-ID: <201107260751.p6Q7pIPW002938@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386Ab1GZHv4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:51:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peterz@infradead.org, fengguang.wu@intel.com, lkml@pengaru.com, miklos@szeredi.hu, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm/backing-dev.c: reset bdi min_ratio in bdi_unregister()
has been removed from the -mm tree.  Its filename was
     bdi_min_ratio-never-shrinks-ultimately-preventing-valid-setting-of-min_ratio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -606,6 +606,7 @@ static void bdi_prune_sb(struct backing_
 void bdi_unregister(struct backing_dev_info *bdi)
 {
 	if (bdi->dev) {
+		bdi_set_min_ratio(bdi, 0);
 		trace_writeback_bdi_unregister(bdi);
 		bdi_prune_sb(bdi);
 		del_timer_sync(&bdi->wb.wakeup_timer);
_

Patches currently in -mm which might be from peterz@infradead.org are

origin.patch

