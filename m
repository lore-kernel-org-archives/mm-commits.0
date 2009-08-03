From: akpm@linux-foundation.org
Subject: + schedule_work-documentation-improvements.patch added to -mm tree
Date: Mon, 03 Aug 2009 13:48:44 -0700
Message-ID: <200908032048.n73Kmi2S019373@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752843AbZHCUto (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Aug 2009 16:49:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bart.vanassche@gmail.com, gregkh@suse.de, mingo@elte.hu, oleg@redhat.com


The patch titled
     schedule_work() documentation improvements
has been added to the -mm tree.  Its filename is
     schedule_work-documentation-improvements.patch

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
Subject: schedule_work() documentation improvements
From: Bart Van Assche <bart.vanassche@gmail.com>

Two important aspects of the schedule_work() function are not yet documented:
- that it is allowed to pass a struct work_struct * to this function that
  is already on the kernel-global workqueue;
- the meaning of its return value.
The patch below documents both aspects.

Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN kernel/workqueue.c~schedule_work-documentation-improvements kernel/workqueue.c
--- a/kernel/workqueue.c~schedule_work-documentation-improvements
+++ a/kernel/workqueue.c
@@ -600,7 +600,11 @@ static struct workqueue_struct *keventd_
  * schedule_work - put work task in global workqueue
  * @work: job to be done
  *
- * This puts a job in the kernel-global workqueue.
+ * Returns zero if @work was already on the kernel-global workqueue and
+ * non-zero otherwise.
+ *
+ * This puts a job in the kernel-global workqueue if it was not already queued
+ * and leaves it in the same position on the kernel-global workqueue otherwise.
  */
 int schedule_work(struct work_struct *work)
 {
_

Patches currently in -mm which might be from bart.vanassche@gmail.com are

readahead-add-blk_run_backing_dev.patch
schedule_work-documentation-improvements.patch

