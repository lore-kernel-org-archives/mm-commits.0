From: akpm@linux-foundation.org
Subject: - sparse-pointer-use-of-zero-as-null-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 18 Oct 2007 01:57:04 -0700
Message-ID: <200710180857.l9I8v4qs003128@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49182 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932691AbXJRI6L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 04:58:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@suse.de, arnd@arndb.de, davidel@xmailserver.org, jeff@garzik.org, mpm@selenic.com, raven@themaw.net, sds@tycho.nsa.gov, shemminger@linux-foundation.org


The patch titled
     sparse-pointer-use-of-zero-as-null-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     sparse-pointer-use-of-zero-as-null-checkpatch-fixes.patch

This patch was dropped because it was folded into sparse-pointer-use-of-zero-as-null.patch

------------------------------------------------------
Subject: sparse-pointer-use-of-zero-as-null-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: do not use assignment in if condition
#50: FILE: drivers/base/dmapool.c:369:
+	if ((page = pool_find_page (pool, dma)) == NULL) {

ERROR: no space after that open parenthesis '('
#74: FILE: fs/autofs/waitq.c:185:
+	for ( wql = &sbi->queues; (wq = *wql) != NULL; wql = &wq->next ) {

ERROR: no space before that close parenthesis ')'
#74: FILE: fs/autofs/waitq.c:185:
+	for ( wql = &sbi->queues; (wq = *wql) != NULL; wql = &wq->next ) {

WARNING: line over 80 characters
#155: FILE: fs/jbd/journal.c:232:
+		wait_event(journal->j_wait_done_commit, journal->j_task == NULL);

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Cc: Andi Kleen <ak@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Ian Kent <raven@themaw.net>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/dmapool.c |    2 +-
 fs/autofs/waitq.c      |    2 +-
 fs/jbd/journal.c       |    3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/base/dmapool.c~sparse-pointer-use-of-zero-as-null-checkpatch-fixes drivers/base/dmapool.c
--- a/drivers/base/dmapool.c~sparse-pointer-use-of-zero-as-null-checkpatch-fixes
+++ a/drivers/base/dmapool.c
@@ -366,7 +366,7 @@ dma_pool_free (struct dma_pool *pool, vo
 	unsigned long		flags;
 	int			map, block;
 
-	if ((page = pool_find_page (pool, dma)) == NULL) {
+	if ((page = pool_find_page(pool, dma)) == NULL) {
 		if (pool->dev)
 			dev_err(pool->dev, "dma_pool_free %s, %p/%lx (bad dma)\n",
 				pool->name, vaddr, (unsigned long) dma);
diff -puN fs/autofs/waitq.c~sparse-pointer-use-of-zero-as-null-checkpatch-fixes fs/autofs/waitq.c
--- a/fs/autofs/waitq.c~sparse-pointer-use-of-zero-as-null-checkpatch-fixes
+++ a/fs/autofs/waitq.c
@@ -182,7 +182,7 @@ int autofs_wait_release(struct autofs_sb
 {
 	struct autofs_wait_queue *wq, **wql;
 
-	for ( wql = &sbi->queues; (wq = *wql) != NULL; wql = &wq->next ) {
+	for (wql = &sbi->queues; (wq = *wql) != NULL; wql = &wq->next) {
 		if ( wq->wait_queue_token == wait_queue_token )
 			break;
 	}
diff -puN fs/jbd/journal.c~sparse-pointer-use-of-zero-as-null-checkpatch-fixes fs/jbd/journal.c
--- a/fs/jbd/journal.c~sparse-pointer-use-of-zero-as-null-checkpatch-fixes
+++ a/fs/jbd/journal.c
@@ -230,7 +230,8 @@ static void journal_kill_thread(journal_
 	while (journal->j_task) {
 		wake_up(&journal->j_wait_commit);
 		spin_unlock(&journal->j_state_lock);
-		wait_event(journal->j_wait_done_commit, journal->j_task == NULL);
+		wait_event(journal->j_wait_done_commit,
+				journal->j_task == NULL);
 		spin_lock(&journal->j_state_lock);
 	}
 	spin_unlock(&journal->j_state_lock);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
stop-using-dma_xxbit_mask.patch
fuse-fix-race-between-getattr-and-write.patch
fuse-add-file-handle-to-getattr-operation.patch
sparse-pointer-use-of-zero-as-null.patch
sparse-pointer-use-of-zero-as-null-checkpatch-fixes.patch
i-oat-tighten-descriptor-setup-performance-fix.patch
i-oat-add-completion-callback-for-async_tx-interface-use-fix.patch
i-oat-add-completion-callback-for-async_tx-interface-use-fix-fix.patch
