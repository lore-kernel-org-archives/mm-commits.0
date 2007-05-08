From: akpm@linux-foundation.org
Subject: + timer-parenthesis-fix-in-tbase_get_deferrable-etc.patch added to -mm tree
Date: Tue, 08 May 2007 16:33:25 -0700
Message-ID: <200705082333.l48NXPS0004841@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34884 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967977AbXEHXeI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 19:34:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jarkao2@o2.pl, mingo@elte.hu, tglx@linutronix.de


The patch titled
     timer: parenthesis fix in tbase_get_deferrable() etc
has been added to the -mm tree.  Its filename is
     timer-parenthesis-fix-in-tbase_get_deferrable-etc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: timer: parenthesis fix in tbase_get_deferrable() etc
From: Jarek Poplawski <jarkao2@o2.pl>

Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timer.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff -puN kernel/timer.c~timer-parenthesis-fix-in-tbase_get_deferrable-etc kernel/timer.c
--- a/kernel/timer.c~timer-parenthesis-fix-in-tbase_get_deferrable-etc
+++ a/kernel/timer.c
@@ -92,24 +92,24 @@ static DEFINE_PER_CPU(tvec_base_t *, tve
 /* Functions below help us manage 'deferrable' flag */
 static inline unsigned int tbase_get_deferrable(tvec_base_t *base)
 {
-	return ((unsigned int)(unsigned long)base & TBASE_DEFERRABLE_FLAG);
+	return (unsigned int)((unsigned long)base & TBASE_DEFERRABLE_FLAG);
 }
 
 static inline tvec_base_t *tbase_get_base(tvec_base_t *base)
 {
-	return ((tvec_base_t *)((unsigned long)base & ~TBASE_DEFERRABLE_FLAG));
+	return (tvec_base_t *)((unsigned long)base & ~TBASE_DEFERRABLE_FLAG);
 }
 
 static inline void timer_set_deferrable(struct timer_list *timer)
 {
-	timer->base = ((tvec_base_t *)((unsigned long)(timer->base) |
-	                               TBASE_DEFERRABLE_FLAG));
+	timer->base = (tvec_base_t *)((unsigned long)timer->base |
+	                               TBASE_DEFERRABLE_FLAG);
 }
 
 static inline void
 timer_set_base(struct timer_list *timer, tvec_base_t *new_base)
 {
-	timer->base = (tvec_base_t *)((unsigned long)(new_base) |
+	timer->base = (tvec_base_t *)((unsigned long)new_base |
 	                              tbase_get_deferrable(timer->base));
 }
 
_

Patches currently in -mm which might be from jarkao2@o2.pl are

lockdep-lookup_chain_cache-comment-errata.patch
lockdep-removed-unused-ip-argument-in-mark_lock-mark_held_locks.patch
ppp_generic-fix-lockdep-warning.patch
make-cancel_rearming_delayed_work-reliable.patch
make-cancel_rearming_delayed_work-reliable-spelling.patch
timer-parenthesis-fix-in-tbase_get_deferrable-etc.patch
