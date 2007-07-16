From: akpm@linux-foundation.org
Subject: - kcdrwd-remove-unneeded-flush_signals-call.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:58:07 -0700
Message-ID: <200707162058.l6GKw7Ts002324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46497 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755985AbXGPVN1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:13:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, petero2@telia.com, mm-commits@vger.kernel.org


The patch titled
     kcdrwd: remove unneeded flush_signals() call
has been removed from the -mm tree.  Its filename was
     kcdrwd-remove-unneeded-flush_signals-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kcdrwd: remove unneeded flush_signals() call
From: Oleg Nesterov <oleg@tv-sign.ru>

kcdrwd() is a kernel thread, all signals are ignored.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Peter Osterlund <petero2@telia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/pktcdvd.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/block/pktcdvd.c~kcdrwd-remove-unneeded-flush_signals-call drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~kcdrwd-remove-unneeded-flush_signals-call
+++ a/drivers/block/pktcdvd.c
@@ -1652,9 +1652,6 @@ static int kcdrwd(void *foobar)
 				}
 			}
 
-			if (signal_pending(current)) {
-				flush_signals(current);
-			}
 			if (kthread_should_stop())
 				break;
 		}
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
freezer-make-kernel-threads-nonfreezable-by-default.patch
freezer-run-show_state-when-freezing-times-out.patch
hibernation-prepare-to-enter-the-low-power-state.patch
freezer-avoid-freezing-kernel-threads-prematurely.patch
freezer-use-__set_current_state-in-refrigerator.patch
freezer-return-int-from-freeze_processes.patch
freezer-remove-redundant-check-in-try_to_freeze_tasks.patch
pm-prevent-frozen-user-mode-helpers-from-failing-the-freezing-of-tasks-rev-2.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
destroy_workqueue-can-livelock.patch
