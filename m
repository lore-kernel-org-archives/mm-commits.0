From: akpm@linux-foundation.org
Subject: + workqueues-kill-cpu_singlethread_map-use-get_cpu_mask-instead-fix.patch added to -mm tree
Date: Sun, 04 Jan 2009 23:17:26 -0800
Message-ID: <200901050717.n057HQCG001964@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44393 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751356AbZAEHTC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 02:19:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: valdis.kletnieks@vt.edu, oleg@redhat.com, rusty@rustcorp.com.au


The patch titled
     workqueues-kill-cpu_singlethread_map-use-get_cpu_mask-instead-fix
has been added to the -mm tree.  Its filename is
     workqueues-kill-cpu_singlethread_map-use-get_cpu_mask-instead-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: workqueues-kill-cpu_singlethread_map-use-get_cpu_mask-instead-fix
From: Valdis.Kletnieks@vt.edu

In mmotm1230, there was an apparent mismerge that left a spare '&' on
a variable, causing this compiler warning:

kernel/workqueue.c: In function 'wq_cpu_map':
kernel/workqueue.c:94: warning: pointer type mismatch in conditional expression

so let's fix that up.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/workqueue.c~workqueues-kill-cpu_singlethread_map-use-get_cpu_mask-instead-fix kernel/workqueue.c
--- a/kernel/workqueue.c~workqueues-kill-cpu_singlethread_map-use-get_cpu_mask-instead-fix
+++ a/kernel/workqueue.c
@@ -91,7 +91,7 @@ static inline int is_wq_single_threaded(
 static const struct cpumask *wq_cpu_map(struct workqueue_struct *wq)
 {
 	return is_wq_single_threaded(wq)
-		 ? get_cpu_mask(singlethread_cpu) : &cpu_populated_map;
+		 ? get_cpu_mask(singlethread_cpu) : cpu_populated_map;
 }
 
 static
_

Patches currently in -mm which might be from valdis.kletnieks@vt.edu are

workqueues-kill-cpu_singlethread_map-use-get_cpu_mask-instead-fix.patch

