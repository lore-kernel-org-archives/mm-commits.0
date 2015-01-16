From: akpm@linux-foundation.org
Subject: + jbd-drop-jbd_enosys-debug.patch added to -mm tree
Date: Thu, 15 Jan 2015 16:26:55 -0800
Message-ID: <54b85acf.Jwbi1lQettiF7ziN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60778 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbbAPA1K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jan 2015 19:27:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: jbd: drop jbd_ENOSYS debug
has been added to the -mm tree.  Its filename is
     jbd-drop-jbd_enosys-debug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/jbd-drop-jbd_enosys-debug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/jbd-drop-jbd_enosys-debug.patch

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
