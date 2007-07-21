From: akpm@linux-foundation.org
Subject: - oprofile-enable-spu-switch-notification-to-detect-currently-active-spu-tasks-update.patch removed from -mm tree
Date: Sat, 21 Jul 2007 03:25:12 -0700
Message-ID: <200707211025.l6LAPC2Q011975@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40468 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933738AbXGUKZ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Jul 2007 06:25:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpjohn@us.ibm.com, arnd.bergmann@de.ibm.com, carll@us.ibm.com, paulus@samba.org, rrnelson@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     OProfile: enable SPU switch notification to detect  currently active SPU tasks (update)
has been removed from the -mm tree.  Its filename was
     oprofile-enable-spu-switch-notification-to-detect-currently-active-spu-tasks-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: OProfile: enable SPU switch notification to detect  currently active SPU tasks (update)
From: Maynard Johnson <mpjohn@us.ibm.com>

Changed "for (node = 0; node < MAX_NUMNODES; node++)" loop to
for_each_online_node(node).
Added comment to memory barrier.
Better info in changelog.

Cc: Carl Love <carll@us.ibm.com>
Cc: Bob Nelson <rrnelson@us.ibm.com>
Cc: Arnd Bergmann <arnd.bergmann@de.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/sched.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/platforms/cell/spufs/sched.c~oprofile-enable-spu-switch-notification-to-detect-currently-active-spu-tasks-update arch/powerpc/platforms/cell/spufs/sched.c
--- a/arch/powerpc/platforms/cell/spufs/sched.c~oprofile-enable-spu-switch-notification-to-detect-currently-active-spu-tasks-update
+++ a/arch/powerpc/platforms/cell/spufs/sched.c
@@ -220,13 +220,14 @@ static void notify_spus_active(void)
 	 * When the awakened processes see their "notify_active" flag is set,
 	 * they will call spu_switch_notify();
 	 */
-	for (node = 0; node < MAX_NUMNODES; node++) {
+	for_each_online_node(node) {
 		struct spu *spu;
 		mutex_lock(&spu_prio->active_mutex[node]);
 		list_for_each_entry(spu, &spu_prio->active_list[node], list) {
 			struct spu_context *ctx = spu->ctx;
 			set_bit(SPU_SCHED_NOTIFY_ACTIVE, &ctx->sched_flags);
-			mb();
+			mb();	/* make sure any tasks woken up below */
+				/* can see the bit(s) set above */
 			wake_up_all(&ctx->stop_wq);
 		}
 		mutex_unlock(&spu_prio->active_mutex[node]);
_

Patches currently in -mm which might be from mpjohn@us.ibm.com are

origin.patch
