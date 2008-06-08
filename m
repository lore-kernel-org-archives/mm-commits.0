From: akpm@linux-foundation.org
Subject: - ipc-restore-msgpool-original-value.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:48:37 -0700
Message-ID: <200806081948.m58Jmb5k017519@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754484AbYFHTtN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:49:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Nadia.Derbey@bull.net, manfred@colorfullife.com, mtk.manpages@googlemail.com, peifferp@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ipc: restore MSGPOOL original value
has been removed from the -mm tree.  Its filename was
     ipc-restore-msgpool-original-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc: restore MSGPOOL original value
From: Nadia Derbey <Nadia.Derbey@bull.net>

When posting:

	[PATCH 1/8] Scaling msgmni to the amount of lowmem

(see http://article.gmane.org/gmane.linux.kernel/637849/) I changed the
MSGPOOL value to make it fit what is said in the man pages (i.e.  a size
in bytes).

But Michael Kerrisk rightly complained that this change could affect the
ABI.  So I'm posting this patch to make MSGPOOL expressed back in Kbytes. 
Michael, on his side, has fixed the man page.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Pierre Peiffer <peifferp@gmail.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Acked-by: Michael Kerrisk <mtk.manpages@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/msg.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/msg.h~ipc-restore-msgpool-original-value include/linux/msg.h
--- a/include/linux/msg.h~ipc-restore-msgpool-original-value
+++ a/include/linux/msg.h
@@ -64,11 +64,11 @@ struct msginfo {
 #define MSGMNB 16384   /* <= INT_MAX */   /* default max size of a message queue */
 
 /* unused */
-#define MSGPOOL (MSGMNI * MSGMNB) /* size in bytes of message pool */
+#define MSGPOOL (MSGMNI * MSGMNB / 1024) /* size in kbytes of message pool */
 #define MSGTQL  MSGMNB            /* number of system message headers */
 #define MSGMAP  MSGMNB            /* number of entries in message map */
 #define MSGSSZ  16                /* message segment size */
-#define __MSGSEG (MSGPOOL / MSGSSZ) /* max no. of segments */
+#define __MSGSEG ((MSGPOOL * 1024) / MSGSSZ) /* max no. of segments */
 #define MSGSEG (__MSGSEG <= 0xffff ? __MSGSEG : 0xffff)
 
 #ifdef __KERNEL__
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

origin.patch
idr-change-the-idr-structure.patch
idr-rename-some-of-the-idr-apis-internal-routines.patch
idr-fix-a-printk-call.patch
idr-error-checking-factorization.patch
idr-make-idr_get_new-rcu-safe.patch
idr-make-idr_get_new-rcu-safe-fix.patch
idr-make-idr_find-rcu-safe.patch
idr-make-idr_remove-rcu-safe.patch
ipc-call-idr_find-without-locking-in-ipc_lock.patch
ipc-get-rid-of-ipc_lock_down.patch
ipc-semc-convert-undo-structures-to-struct-list_head.patch
ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-remove-unused-entries-from-struct-sem_queue.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-rewrite-undo-list-locking.patch
ipc-semc-rewrite-undo-list-locking-checkpatch-fixes.patch
ipc-use-simple_read_from_buffer.patch

