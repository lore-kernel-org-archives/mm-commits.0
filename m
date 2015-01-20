From: akpm@linux-foundation.org
Subject: [merged] jbd-drop-jbd_enosys-debug.patch removed from -mm tree
Date: Tue, 20 Jan 2015 13:31:56 -0800
Message-ID: <54bec94c.7AfXPCvCn4pGnDa4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47617 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbbATVb6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Jan 2015 16:31:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: jbd: drop jbd_ENOSYS debug
has been removed from the -mm tree.  Its filename was
     jbd-drop-jbd_enosys-debug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: jbd: drop jbd_ENOSYS debug

A quick search shows that there are no users, drop the macro for both jbd
and jbd2.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/jbd.h  |    9 ---------
 include/linux/jbd2.h |    9 ---------
 2 files changed, 18 deletions(-)

diff -puN include/linux/jbd.h~jbd-drop-jbd_enosys-debug include/linux/jbd.h
--- a/include/linux/jbd.h~jbd-drop-jbd_enosys-debug
+++ a/include/linux/jbd.h
@@ -956,15 +956,6 @@ void __log_wait_for_space(journal_t *jou
 extern void	__journal_drop_transaction(journal_t *, transaction_t *);
 extern int	cleanup_journal_tail(journal_t *);
 
-/* Debugging code only: */
-
-#define jbd_ENOSYS() \
-do {								           \
-	printk (KERN_ERR "JBD unimplemented function %s\n", __func__); \
-	current->state = TASK_UNINTERRUPTIBLE;			           \
-	schedule();						           \
-} while (1)
-
 /*
  * is_journal_abort
  *
diff -puN include/linux/jbd2.h~jbd-drop-jbd_enosys-debug include/linux/jbd2.h
--- a/include/linux/jbd2.h~jbd-drop-jbd_enosys-debug
+++ a/include/linux/jbd2.h
@@ -1251,15 +1251,6 @@ void __jbd2_log_wait_for_space(journal_t
 extern void __jbd2_journal_drop_transaction(journal_t *, transaction_t *);
 extern int jbd2_cleanup_journal_tail(journal_t *);
 
-/* Debugging code only: */
-
-#define jbd_ENOSYS() \
-do {								           \
-	printk (KERN_ERR "JBD unimplemented function %s\n", __func__); \
-	current->state = TASK_UNINTERRUPTIBLE;			           \
-	schedule();						           \
-} while (1)
