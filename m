From: akpm@linux-foundation.org
Subject: + ipc-sem-explicitly-inline-check_restart.patch added to -mm tree
Date: Tue, 25 Oct 2016 15:58:17 -0700
Message-ID: <580fe389.Mcwp3nopT7ZMNVv7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40294 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752987AbcJYW6S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Oct 2016 18:58:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem: explicitly inline check_restart
has been added to the -mm tree.  Its filename is
     ipc-sem-explicitly-inline-check_restart.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-sem-explicitly-inline-check_restart.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-sem-explicitly-inline-check_restart.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: ipc/sem: explicitly inline check_restart

The compiler already does this, but make it explicit.  This helper is
really small and also used in update_queue's main loop, which is O(N^2)
scanning.  Inline and avoid the function overhead.

Link: http://lkml.kernel.org/r/1474225896-10066-5-git-send-email-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/sem.c~ipc-sem-explicitly-inline-check_restart ipc/sem.c
--- a/ipc/sem.c~ipc-sem-explicitly-inline-check_restart
+++ a/ipc/sem.c
@@ -788,7 +788,7 @@ static void unlink_queue(struct sem_arra
  * modified the array.
  * Note that wait-for-zero operations are handled without restart.
  */
-static int check_restart(struct sem_array *sma, struct sem_queue *q)
+static inline int check_restart(struct sem_array *sma, struct sem_queue *q)
 {
 	/* pending complex alter operations are too difficult to analyse */
 	if (!list_empty(&sma->pending_alter))
_

Patches currently in -mm which might be from dave@stgolabs.net are

ipc-sem-do-not-call-wake_sem_queue_do-prematurely.patch
ipc-sem-rework-task-wakeups.patch
ipc-sem-optimize-perform_atomic_semop.patch
ipc-sem-explicitly-inline-check_restart.patch
ipc-sem-use-proper-list-api-for-pending_list-wakeups.patch

