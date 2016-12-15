From: akpm@linux-foundation.org
Subject: [merged] radix-tree-test-suite-delete-unused-rcupdatec.patch
 removed from -mm tree
Date: Thu, 15 Dec 2016 10:49:32 -0800
Message-ID: <5852e5bc.tirZCNDOke/E7Q1H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50296 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754318AbcLOStd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:49:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix tree test suite: delete unused rcupdate.c
has been removed from the -mm tree.  Its filename was
     radix-tree-test-suite-delete-unused-rcupdatec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: radix tree test suite: delete unused rcupdate.c

This file was used to implement call_rcu() before liburcu implemented that
function.  It hasn't even been compiled since before the test suite was
added to the kernel.  Remove it to reduce confusion.

Link: http://lkml.kernel.org/r/1481667692-14500-5-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/rcupdate.c |   86 --------------------------
 1 file changed, 86 deletions(-)

diff -puN tools/testing/radix-tree/rcupdate.c~radix-tree-test-suite-delete-unused-rcupdatec /dev/null
--- a/tools/testing/radix-tree/rcupdate.c
+++ /dev/null
@@ -1,86 +0,0 @@
-#include <linux/rcupdate.h>
-#include <pthread.h>
-#include <stdio.h>
-#include <assert.h>
-
-static pthread_mutex_t rculock = PTHREAD_MUTEX_INITIALIZER;
-static struct rcu_head *rcuhead_global = NULL;
-static __thread int nr_rcuhead = 0;
-static __thread struct rcu_head *rcuhead = NULL;
-static __thread struct rcu_head *rcutail = NULL;
-
-static pthread_cond_t rcu_worker_cond = PTHREAD_COND_INITIALIZER;
-
-/* switch to urcu implementation when it is merged. */
-void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *head))
-{
-	head->func = func;
-	head->next = rcuhead;
-	rcuhead = head;
-	if (!rcutail)
-		rcutail = head;
-	nr_rcuhead++;
-	if (nr_rcuhead >= 1000) {
-		int signal = 0;
-
-		pthread_mutex_lock(&rculock);
-		if (!rcuhead_global)
-			signal = 1;
-		rcutail->next = rcuhead_global;
-		rcuhead_global = head;
-		pthread_mutex_unlock(&rculock);
-
-		nr_rcuhead = 0;
-		rcuhead = NULL;
-		rcutail = NULL;
-
-		if (signal) {
-			pthread_cond_signal(&rcu_worker_cond);
-		}
-	}
-}
-
-static void *rcu_worker(void *arg)
-{
-	struct rcu_head *r;
-
-	rcupdate_thread_init();
-
-	while (1) {
-		pthread_mutex_lock(&rculock);
-		while (!rcuhead_global) {
-			pthread_cond_wait(&rcu_worker_cond, &rculock);
-		}
-		r = rcuhead_global;
-		rcuhead_global = NULL;
-
-		pthread_mutex_unlock(&rculock);
-
-		synchronize_rcu();
-
-		while (r) {
-			struct rcu_head *tmp = r->next;
-			r->func(r);
-			r = tmp;
-		}
-	}
-
-	rcupdate_thread_exit();
-
-	return NULL;
-}
-
-static pthread_t worker_thread;
-void rcupdate_init(void)
-{
-	pthread_create(&worker_thread, NULL, rcu_worker, NULL);
-}
