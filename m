From: akpm@linux-foundation.org
Subject: + fix-error-path-null-deref-in-alloc_posix_timer.patch added to -mm tree
Date: Mon, 22 Sep 2008 17:36:03 -0700
Message-ID: <200809230036.m8N0a33n006332@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753612AbYIWAgn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Sep 2008 20:36:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, tglx@linutronix.de


The patch titled
     fix error-path NULL deref in alloc_posix_timer()
has been added to the -mm tree.  Its filename is
     fix-error-path-null-deref-in-alloc_posix_timer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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
@@ -448,7 +448,7 @@ static struct k_itimer * alloc_posix_tim
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

fix-error-path-null-deref-in-alloc_posix_timer.patch

