From: akpm@linux-foundation.org
Subject: [merged] schedule_work-documentation-improvements.patch removed from -mm tree
Date: Mon, 10 Aug 2009 12:29:19 -0700
Message-ID: <200908101929.n7AJTJfg029240@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752199AbZHJT3q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Aug 2009 15:29:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bart.vanassche@gmail.com, gregkh@suse.de, mingo@elte.hu, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     schedule_work() documentation improvements
has been removed from the -mm tree.  Its filename was
     schedule_work-documentation-improvements.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
readahead-add-blk_run_backing_dev.patch

