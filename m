From: akpm@linux-foundation.org
Subject: + swap-prefetch-avoid-repeating-entry.patch added to -mm tree
Date: Tue, 06 Mar 2007 23:25:37 -0800
Message-ID: <200703070725.l277Pb7v022644@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52432 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161130AbXCGHZm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 02:25:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kernel@kolivas.org


The patch titled
     swap prefetch: avoid repeating entry
has been added to the -mm tree.  Its filename is
     swap-prefetch-avoid-repeating-entry.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
sched-fix-idle-load-balancing-in-softirqd-context-fix.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
swap-prefetch-avoid-repeating-entry.patch
