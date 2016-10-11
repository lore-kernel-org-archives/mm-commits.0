From: akpm@linux-foundation.org
Subject: [folded-merged]
 relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 11 Oct 2016 13:37:54 -0700
Message-ID: <57fd4da2.Rx8DYMWj23E9jYSO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37613 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754907AbcJKUhz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:37:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, akash.goel@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-checkpatch-fixes.patch

This patch was dropped because it was folded into relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-checkpatch-fixes

ERROR: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")' - ie: 'commit 0123456789ab ("commit description")'
#12: 
	commit 7c9cb38302e78d24e37f7d8a2ea7eed4ae5f2fa7

WARNING: line over 80 characters
#87: FILE: kernel/relay.c:337:
+	struct rchan_buf *buf = container_of(work, struct rchan_buf, wakeup_work);

WARNING: waitqueue_active without comment
#119: FILE: kernel/relay.c:772:
+		if (waitqueue_active(&buf->read_wait)) {

total: 1 errors, 2 warnings, 70 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Akash Goel <akash.goel@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/relay.c~relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-checkpatch-fixes kernel/relay.c
--- a/kernel/relay.c~relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-checkpatch-fixes
+++ a/kernel/relay.c
@@ -334,7 +334,9 @@ static struct rchan_callbacks default_ch
  */
 static void wakeup_readers(struct irq_work *work)
 {
-	struct rchan_buf *buf = container_of(work, struct rchan_buf, wakeup_work);
+	struct rchan_buf *buf;
+
+	buf = container_of(work, struct rchan_buf, wakeup_work);
 	wake_up_interruptible(&buf->read_wait);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup.patch
ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch
hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0-fix.patch
fs-use-mapping_set_error-instead-of-opencoded-set_bit-fix.patch

