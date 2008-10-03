From: akpm@linux-foundation.org
Subject: - fix-error-path-null-deref-in-alloc_posix_timer.patch removed from -mm tree
Date: Fri, 03 Oct 2008 14:28:49 -0700
Message-ID: <200810032128.m93LSn78016641@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753045AbYJCV26 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Oct 2008 17:28:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     fix error-path NULL deref in alloc_posix_timer()
has been removed from the -mm tree.  Its filename was
     fix-error-path-null-deref-in-alloc_posix_timer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix error-path NULL deref in alloc_posix_timer()
From: "Dan Carpenter" <error27@gmail.com>

Found by static checker (http://repo.or.cz/w/smatch.git).

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/posix-timers.c~fix-error-path-null-deref-in-alloc_posix_timer kernel/posix-timers.c
--- a/kernel/posix-timers.c~fix-error-path-null-deref-in-alloc_posix_timer
+++ a/kernel/posix-timers.c
@@ -441,7 +441,7 @@ static struct k_itimer * alloc_posix_tim
 		return tmr;
 	if (unlikely(!(tmr->sigq = sigqueue_alloc()))) {
 		kmem_cache_free(posix_timers_cache, tmr);
-		tmr = NULL;
+		return NULL;
 	}
 	memset(&tmr->sigq->info, 0, sizeof(siginfo_t));
 	return tmr;
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch

