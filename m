From: akpm@linux-foundation.org
Subject: [merged] slow-work-delete-timers-properly.patch removed from -mm tree
Date: Fri, 24 Apr 2009 12:27:57 -0700
Message-ID: <200904241927.n3OJRvsU015993@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752723AbZDXTaA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Apr 2009 15:30:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     slow-work: delete timers properly
has been removed from the -mm tree.  Its filename was
     slow-work-delete-timers-properly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
