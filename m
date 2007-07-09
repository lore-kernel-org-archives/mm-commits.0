From: akpm@linux-foundation.org
Subject: - swap-prefetch-avoid-repeating-entry.patch removed from -mm tree
Date: Mon, 09 Jul 2007 16:52:52 -0700
Message-ID: <200707092352.l69Nqqc8021608@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57038 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759077AbXGIXw7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 19:52:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kernel@kolivas.org, mm-commits@vger.kernel.org


The patch titled
     swap prefetch: avoid repeating entry
has been removed from the -mm tree.  Its filename was
     swap-prefetch-avoid-repeating-entry.patch

This patch was dropped because it was folded into mm-implement-swap-prefetching.patch

------------------------------------------------------
Subject: swap prefetch: avoid repeating entry
From: Con Kolivas <kernel@kolivas.org>

Avoid entering trickle_swap() when first initialising kprefetchd to prevent
endless loops.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_prefetch.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/swap_prefetch.c~swap-prefetch-avoid-repeating-entry mm/swap_prefetch.c
--- a/mm/swap_prefetch.c~swap-prefetch-avoid-repeating-entry
+++ a/mm/swap_prefetch.c
@@ -515,6 +515,10 @@ static int kprefetchd(void *__unused)
 	/* Set ioprio to lowest if supported by i/o scheduler */
 	sys_ioprio_set(IOPRIO_WHO_PROCESS, 0, IOPRIO_CLASS_IDLE);
 
+	/* kprefetchd has nothing to do until it is woken up the first time */
+	set_current_state(TASK_INTERRUPTIBLE);
+	schedule();
+
 	do {
 		try_to_freeze();
 
_

Patches currently in -mm which might be from kernel@kolivas.org are

sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
swap-prefetch-avoid-repeating-entry.patch
mm-swap-prefetch-improvements.patch
mm-swap-prefetch-more-improvements.patch
mm-swap-prefetch-increase-aggressiveness-and-tunability.patch
