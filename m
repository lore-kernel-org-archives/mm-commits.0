From: akpm@osdl.org
Subject: - user-of-the-jiffies-rounding-code-jbd.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:55:34 -0800
Message-ID: <200612130655.kBD6tYqg030652@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57791 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965024AbWLMGzg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:55:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     user of the jiffies rounding code: JBD
has been removed from the -mm tree.  Its filename was
     user-of-the-jiffies-rounding-code-jbd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: user of the jiffies rounding code: JBD
From: Arjan van de Ven <arjan@linux.intel.com>

This patch introduces a user: of the round_jiffies() function; the "5 second"
ext3/jbd wakeup.

While "every 5 seconds" doesn't sound as a problem, there can be many of these
(and these timers do add up over all the kernel).  The "5 second" wakeup isn't
really timing sensitive; in addition even with rounding it'll still happen
every 5 seconds (with the exception of the very first time, which is likely to
be rounded up to somewhere closer to 6 seconds)

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/jbd/transaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/jbd/transaction.c~user-of-the-jiffies-rounding-code-jbd fs/jbd/transaction.c
--- a/fs/jbd/transaction.c~user-of-the-jiffies-rounding-code-jbd
+++ a/fs/jbd/transaction.c
@@ -55,7 +55,7 @@ get_transaction(journal_t *journal, tran
 	spin_lock_init(&transaction->t_handle_lock);
 
 	/* Set up the commit timer for the new transaction. */
-	journal->j_commit_timer.expires = transaction->t_expires;
+	journal->j_commit_timer.expires = round_jiffies(transaction->t_expires);
 	add_timer(&journal->j_commit_timer);
 
 	J_ASSERT(journal->j_running_transaction == NULL);
_

Patches currently in -mm which might be from arjan@linux.intel.com are

origin.patch
user-of-the-jiffies-rounding-patch-ata-subsystem.patch
user-of-the-jiffies-rounding-code-networking.patch

