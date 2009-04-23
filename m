From: akpm@linux-foundation.org
Subject: + slow-work-delete-timers-properly.patch added to -mm tree
Date: Thu, 23 Apr 2009 14:19:04 -0700
Message-ID: <200904232119.n3NLJ4BA018693@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57159 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753611AbZDWVVI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Apr 2009 17:21:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: corbet@lwn.net, dhowells@redhat.com


The patch titled
     slow-work: delete timers properly
has been added to the -mm tree.  Its filename is
     slow-work-delete-timers-properly.patch

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
Subject: slow-work: delete timers properly
From: Jonathan Corbet <corbet@lwn.net>

Slow-work deletes its timer as soon as the first user unregisters, even
though other users could be active.  At the same time, it never seems to
delete slow_work_oom_timer.  Arrange for both to happen in the shutdown
path.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/slow-work.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/slow-work.c~slow-work-delete-timers-properly kernel/slow-work.c
--- a/kernel/slow-work.c~slow-work-delete-timers-properly
+++ a/kernel/slow-work.c
@@ -609,14 +609,14 @@ void slow_work_unregister_user(void)
 	if (slow_work_user_count == 0) {
 		printk(KERN_NOTICE "Slow work thread pool: Shutting down\n");
 		slow_work_threads_should_exit = true;
+		del_timer_sync(&slow_work_cull_timer);
+		del_timer_sync(&slow_work_oom_timer);
 		wake_up_all(&slow_work_thread_wq);
 		wait_for_completion(&slow_work_last_thread_exited);
 		printk(KERN_NOTICE "Slow work thread pool:"
 		       " Shut down complete\n");
 	}
 
-	del_timer_sync(&slow_work_cull_timer);
