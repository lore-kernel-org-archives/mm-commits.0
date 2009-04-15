From: akpm@linux-foundation.org
Subject: + slow_work_thread-should-do-the-exclusive-wait.patch added to -mm tree
Date: Wed, 15 Apr 2009 16:27:18 -0700
Message-ID: <200904152327.n3FNRICZ003640@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43088 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752295AbZDOXcD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Apr 2009 19:32:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, Daire.Byrne@framestore.com, Trond.Myklebust@netapp.com, dhowells@redhat.com, serue@us.ibm.com, steved@redhat.com


The patch titled
     slow_work_thread() should do the exclusive wait
has been added to the -mm tree.  Its filename is
     slow_work_thread-should-do-the-exclusive-wait.patch

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
Subject: slow_work_thread() should do the exclusive wait
From: Oleg Nesterov <oleg@redhat.com>

slow_work_thread() sleeps on slow_work_thread_wq without WQ_FLAG_EXCLUSIVE,
this means that slow_work_enqueue()->__wake_up(nr_exclusive => 1) wakes up
all kslowd threads. Afaics this is not what we want, change slow_work_thread()
to use prepare_to_wait_exclusive().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Steve Dickson <steved@redhat.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Daire Byrne <Daire.Byrne@framestore.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/slow-work.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/slow-work.c~slow_work_thread-should-do-the-exclusive-wait kernel/slow-work.c
--- a/kernel/slow-work.c~slow_work_thread-should-do-the-exclusive-wait
+++ a/kernel/slow-work.c
@@ -372,8 +372,8 @@ static int slow_work_thread(void *_data)
 		vsmax *= atomic_read(&slow_work_thread_count);
 		vsmax /= 100;
 
-		prepare_to_wait(&slow_work_thread_wq, &wait,
-				TASK_INTERRUPTIBLE);
+		prepare_to_wait_exclusive(&slow_work_thread_wq, &wait,
+						TASK_INTERRUPTIBLE);
 		if (!freezing(current) &&
 		    !slow_work_threads_should_exit &&
 		    !slow_work_available(vsmax) &&
_

Patches currently in -mm which might be from oleg@redhat.com are

slow_work_thread-should-do-the-exclusive-wait.patch
getrusage-fill-ru_maxrss-value.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch
signals-tracehook_notify_jctl-change.patch

