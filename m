From: akpm@osdl.org
Subject: + fsaio-routines-to-initialize-and-test-a-wait-bit-key.patch added to -mm tree
Date: Thu, 28 Dec 2006 14:53:54 -0800
Message-ID: <200612282253.kBSMrs2r015359@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:39210 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965034AbWL1Wyt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Dec 2006 17:54:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: suparna@in.ibm.com, bcrl@kvack.org, drepper@redhat.com, hch@lst.de, mingo@elte.hu, zach.brown@oracle.com


The patch titled
     fsaio: routines to initialize and test a wait bit key
has been added to the -mm tree.  Its filename is
     fsaio-routines-to-initialize-and-test-a-wait-bit-key.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fsaio: routines to initialize and test a wait bit key
From: Suparna Bhattacharya <suparna@in.ibm.com>

init_wait_bit_key() initializes the key field in an already allocated wait bit
structure, useful for async wait bit support.  Also separate out the wait bit
test to a common routine which can be used by different kinds of wakeup
callbacks.

Signed-off-by: Suparna Bhattacharya <suparna@in.ibm.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/wait.h |   24 ++++++++++++++++++++++++
 kernel/wait.c        |   11 ++---------
 2 files changed, 26 insertions(+), 9 deletions(-)

diff -puN include/linux/wait.h~fsaio-routines-to-initialize-and-test-a-wait-bit-key include/linux/wait.h
--- a/include/linux/wait.h~fsaio-routines-to-initialize-and-test-a-wait-bit-key
+++ a/include/linux/wait.h
@@ -108,6 +108,17 @@ static inline int waitqueue_active(wait_
 	return !list_empty(&q->task_list);
 }
 
+static inline int test_wait_bit_key(wait_queue_t *wait,
+				struct wait_bit_key *key)
+{
+	struct wait_bit_queue *wait_bit
+		= container_of(wait, struct wait_bit_queue, wait);
+
+	return (wait_bit->key.flags == key->flags &&
+			wait_bit->key.bit_nr == key->bit_nr &&
+			!test_bit(key->bit_nr, key->flags));
+}
+
 /*
  * Used to distinguish between sync and async io wait context:
  * sync i/o typically specifies a NULL wait queue entry or a wait
@@ -416,6 +427,19 @@ int wake_bit_function(wait_queue_t *wait
 		INIT_LIST_HEAD(&(wait)->task_list);			\
 	} while (0)
 
+#define init_wait_bit_key(waitbit, word, bit)				\
+	do {								\
+		(waitbit)->key.flags = word;				\
+		(waitbit)->key.bit_nr = bit;				\
+	} while (0)
+
+#define init_wait_bit_task(waitbit, tsk)				\
+	do {								\
+		(waitbit)->wait.private = tsk;				\
+		(waitbit)->wait.func = wake_bit_function;		\
+		INIT_LIST_HEAD(&(waitbit)->wait.task_list);		\
+	} while (0)
+
 /**
  * wait_on_bit - wait for a bit to be cleared
  * @word: the word being waited on, a kernel virtual address
diff -puN kernel/wait.c~fsaio-routines-to-initialize-and-test-a-wait-bit-key kernel/wait.c
--- a/kernel/wait.c~fsaio-routines-to-initialize-and-test-a-wait-bit-key
+++ a/kernel/wait.c
@@ -139,16 +139,9 @@ EXPORT_SYMBOL(autoremove_wake_function);
 
 int wake_bit_function(wait_queue_t *wait, unsigned mode, int sync, void *arg)
 {
-	struct wait_bit_key *key = arg;
-	struct wait_bit_queue *wait_bit
-		= container_of(wait, struct wait_bit_queue, wait);
-
-	if (wait_bit->key.flags != key->flags ||
-			wait_bit->key.bit_nr != key->bit_nr ||
-			test_bit(key->bit_nr, key->flags))
+	if (!test_wait_bit_key(wait, arg))
 		return 0;
-	else
-		return autoremove_wake_function(wait, mode, sync, key);
+	return autoremove_wake_function(wait, mode, sync, arg);
 }
 EXPORT_SYMBOL(wake_bit_function);
 
_

Patches currently in -mm which might be from suparna@in.ibm.com are

fix-lock-inversion-aio_kick_handler.patch
fsaio-add-a-wait-queue-parameter-to-the-wait_bit-action-routine.patch
fsaio-rename-__lock_page-to-lock_page_slow.patch
fsaio-routines-to-initialize-and-test-a-wait-bit-key.patch
fsaio-add-a-default-io-wait-bit-field-in-task-struct.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio.patch
fsaio-enable-asynchronous-wait-page-and-lock-page.patch
fsaio-filesystem-aio-read.patch
fsaio-aio-o_sync-filesystem-write.patch

