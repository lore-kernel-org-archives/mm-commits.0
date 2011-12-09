From: akpm@linux-foundation.org
Subject: [merged] printk-avoid-double-lock-acquire.patch removed from -mm tree
Date: Fri, 09 Dec 2011 12:08:13 -0800
Message-ID: <201112092008.pB9K8DWp020669@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:55076 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab1LIUIR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2011 15:08:17 -0500
Received: by mail-gy0-f202.google.com with SMTP id r18so393517ghr.1
        for <mm-commits@vger.kernel.org>; Fri, 09 Dec 2011 12:08:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peterz@infradead.org, a.p.zijlstra@chello.nl, aarcange@redhat.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: avoid double lock acquire
has been removed from the -mm tree.  Its filename was
     printk-avoid-double-lock-acquire.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Peter Zijlstra <peterz@infradead.org>
Subject: printk: avoid double lock acquire

Commit 4f2a8d3cf5e ("printk: Fix console_sem vs logbuf_lock unlock race")
introduced another silly bug where we would want to acquire an already
held lock.  Avoid this.

Reported-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/printk.c~printk-avoid-double-lock-acquire kernel/printk.c
--- a/kernel/printk.c~printk-avoid-double-lock-acquire
+++ a/kernel/printk.c
@@ -1293,10 +1293,11 @@ again:
 	raw_spin_lock(&logbuf_lock);
 	if (con_start != log_end)
 		retry = 1;
+	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+
 	if (retry && console_trylock())
 		goto again;
 
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 	if (wake_klogd)
 		wake_up_klogd();
 }
_

Patches currently in -mm which might be from peterz@infradead.org are

origin.patch
linux-next.patch
treewide-remove-useless-noret_type-macro-and-uses.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn.patch
mm-memcg-shorten-preempt-disabled-section-around-event-checks.patch

