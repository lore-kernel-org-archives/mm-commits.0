From: akpm@linux-foundation.org
Subject: - lockdep-shrink-held_lock-structure-fix-2.patch removed from -mm tree
Date: Tue, 12 Aug 2008 13:33:28 -0700
Message-ID: <200808122033.m7CKXSXH011790@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46841 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751985AbYHLUpg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 16:45:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, davej@redhat.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     lockdep-shrink-held_lock-structure fix 2
has been removed from the -mm tree.  Its filename was
     lockdep-shrink-held_lock-structure-fix-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lockdep-shrink-held_lock-structure fix 2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

A build fix, probably run-away search-'n-replace damage..

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/lockdep.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/lockdep.c~lockdep-shrink-held_lock-structure-fix-2 kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-shrink-held_lock-structure-fix-2
+++ a/kernel/lockdep.c
@@ -2819,7 +2819,7 @@ static int lock_release_nested(struct ta
 
 #ifdef CONFIG_DEBUG_LOCKDEP
 	hlock->prev_chain_key = 0;
-	hlock_class(hlock) = NULL;
+	hlock->class_idx = 0;
 	hlock->acquire_ip = 0;
 	hlock->irq_context = 0;
 #endif
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
linux-next.patch
irq-warn-about-irqf_disabledirqf_shared.patch

