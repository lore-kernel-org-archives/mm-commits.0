From: akpm@linux-foundation.org
Subject: [patch 007/102] radix-tree tests: add iteration test
Date: Tue, 11 Oct 2016 13:51:21 -0700
Message-ID: <57fd50c9.rWTyzhrGRa2bR1dv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37874 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751993AbcJKUwf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:52:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ross.zwisler@linux.intel.com, aryabinin@virtuozzo.com, dvyukov@google.com, koct9i@gmail.com, shuahkh@osg.samsung.com

From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: radix-tree tests: add iteration test

There are four cases I can see where we could end up with a NULL 'slot' in
radix_tree_next_slot().  This unit test exercises all four of them, making
sure that if in the future we have an unsafe path through
radix_tree_next_slot(), we'll catch it.

Here are details on the four cases:

1) radix_tree_iter_retry() via a non-tagged iteration like
radix_tree_for_each_slot().  In this case we currently aren't seeing a bug
because radix_tree_iter_retry() sets

    iter->next_index = iter->index;

which means that in in the else case in radix_tree_next_slot(), 'count' is
zero, so we skip over the while() loop and effectively just return NULL
without ever dereferencing 'slot'.

2) radix_tree_iter_retry() via tagged iteration like
radix_tree_for_each_tagged().  This case was giving us NULL pointer
dereferences in testing, and was fixed with this commit:

commit 3cb9185c6730 ("radix-tree: fix radix_tree_iter_retry() for tagged
iterators.")

This fix doesn't explicitly check for 'slot' being NULL, though, it works
around the NULL pointer dereference by instead zeroing iter->tags in
radix_tree_iter_retry(), which makes us bail out of the if() case in
radix_tree_next_slot() before we dereference 'slot'.

3) radix_tree_iter_next() via via a non-tagged iteration like
radix_tree_for_each_slot().  This currently happens in shmem_tag_pins()
and shmem_partial_swap_usage().

As with non-tagged iteration, 'count' in the else case of
radix_tree_next_slot() is zero, so we skip over the while() loop and
effectively just return NULL without ever dereferencing 'slot'.

4) radix_tree_iter_next() via tagged iteration like
radix_tree_for_each_tagged().  This happens in shmem_wait_for_pins().

radix_tree_iter_next() zeros out iter->tags, so we end up exiting
radix_tree_next_slot() here:

    if (flags & RADIX_TREE_ITER_TAGGED) {
	    void *canon = slot;

	    iter->tags >>= 1;
	    if (unlikely(!iter->tags))
		    return NULL;

Link: http://lkml.kernel.org/r/20160815194237.25967-3-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/Makefile          |    3 
 tools/testing/radix-tree/iteration_check.c |  180 +++++++++++++++++++
 tools/testing/radix-tree/main.c            |    1 
 tools/testing/radix-tree/test.h            |    1 
 4 files changed, 184 insertions(+), 1 deletion(-)

diff -puN tools/testing/radix-tree/Makefile~radix-tree-tests-add-iteration-test tools/testing/radix-tree/Makefile
--- a/tools/testing/radix-tree/Makefile~radix-tree-tests-add-iteration-test
+++ a/tools/testing/radix-tree/Makefile
@@ -3,7 +3,8 @@ CFLAGS += -I. -g -O2 -Wall -D_LGPL_SOURC
 LDFLAGS += -lpthread -lurcu
 TARGETS = main
 OFILES = main.o radix-tree.o linux.o test.o tag_check.o find_next_bit.o \
-	 regression1.o regression2.o regression3.o multiorder.o
+	 regression1.o regression2.o regression3.o multiorder.o \
+	 iteration_check.o
 
 targets: $(TARGETS)
 
diff -puN /dev/null tools/testing/radix-tree/iteration_check.c
--- /dev/null
+++ a/tools/testing/radix-tree/iteration_check.c
@@ -0,0 +1,180 @@
+/*
+ * iteration_check.c: test races having to do with radix tree iteration
+ * Copyright (c) 2016 Intel Corporation
+ * Author: Ross Zwisler <ross.zwisler@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+#include <linux/radix-tree.h>
+#include <pthread.h>
+#include "test.h"
+
+#define NUM_THREADS 4
+#define TAG 0
+static pthread_mutex_t tree_lock = PTHREAD_MUTEX_INITIALIZER;
+static pthread_t threads[NUM_THREADS];
+RADIX_TREE(tree, GFP_KERNEL);
+bool test_complete;
+
+/* relentlessly fill the tree with tagged entries */
+static void *add_entries_fn(void *arg)
+{
+	int pgoff;
+
+	while (!test_complete) {
+		for (pgoff = 0; pgoff < 100; pgoff++) {
+			pthread_mutex_lock(&tree_lock);
+			if (item_insert(&tree, pgoff) == 0)
+				item_tag_set(&tree, pgoff, TAG);
+			pthread_mutex_unlock(&tree_lock);
+		}
+	}
+
+	return NULL;
+}
+
+/*
+ * Iterate over the tagged entries, doing a radix_tree_iter_retry() as we find
+ * things that have been removed and randomly resetting our iteration to the
+ * next chunk with radix_tree_iter_next().  Both radix_tree_iter_retry() and
+ * radix_tree_iter_next() cause radix_tree_next_slot() to be called with a
+ * NULL 'slot' variable.
+ */
+static void *tagged_iteration_fn(void *arg)
+{
+	struct radix_tree_iter iter;
+	void **slot;
+
+	while (!test_complete) {
+		rcu_read_lock();
+		radix_tree_for_each_tagged(slot, &tree, &iter, 0, TAG) {
+			void *entry;
+			int i;
+
+			/* busy wait to let removals happen */
+			for (i = 0; i < 1000000; i++)
+				;
+
+			entry = radix_tree_deref_slot(slot);
+			if (unlikely(!entry))
+				continue;
+
+			if (radix_tree_deref_retry(entry)) {
+				slot = radix_tree_iter_retry(&iter);
+				continue;
+			}
+
+			if (rand() % 50 == 0)
+				slot = radix_tree_iter_next(&iter);
+		}
+		rcu_read_unlock();
+	}
+
+	return NULL;
+}
+
+/*
+ * Iterate over the entries, doing a radix_tree_iter_retry() as we find things
+ * that have been removed and randomly resetting our iteration to the next
+ * chunk with radix_tree_iter_next().  Both radix_tree_iter_retry() and
+ * radix_tree_iter_next() cause radix_tree_next_slot() to be called with a
+ * NULL 'slot' variable.
+ */
+static void *untagged_iteration_fn(void *arg)
+{
+	struct radix_tree_iter iter;
+	void **slot;
+
+	while (!test_complete) {
+		rcu_read_lock();
+		radix_tree_for_each_slot(slot, &tree, &iter, 0) {
+			void *entry;
+			int i;
+
+			/* busy wait to let removals happen */
+			for (i = 0; i < 1000000; i++)
+				;
+
+			entry = radix_tree_deref_slot(slot);
+			if (unlikely(!entry))
+				continue;
+
+			if (radix_tree_deref_retry(entry)) {
+				slot = radix_tree_iter_retry(&iter);
+				continue;
+			}
+
+			if (rand() % 50 == 0)
+				slot = radix_tree_iter_next(&iter);
+		}
+		rcu_read_unlock();
+	}
+
+	return NULL;
+}
+
+/*
+ * Randomly remove entries to help induce radix_tree_iter_retry() calls in the
+ * two iteration functions.
+ */
+static void *remove_entries_fn(void *arg)
+{
+	while (!test_complete) {
+		int pgoff;
+
+		pgoff = rand() % 100;
+
+		pthread_mutex_lock(&tree_lock);
+		item_delete(&tree, pgoff);
+		pthread_mutex_unlock(&tree_lock);
+	}
+
+	return NULL;
+}
+
+/* This is a unit test for a bug found by the syzkaller tester */
+void iteration_test(void)
+{
+	int i;
+
+	printf("Running iteration tests for 10 seconds\n");
+
+	srand(time(0));
+	test_complete = false;
+
+	if (pthread_create(&threads[0], NULL, tagged_iteration_fn, NULL)) {
+		perror("pthread_create");
+		exit(1);
+	}
+	if (pthread_create(&threads[1], NULL, untagged_iteration_fn, NULL)) {
+		perror("pthread_create");
+		exit(1);
+	}
+	if (pthread_create(&threads[2], NULL, add_entries_fn, NULL)) {
+		perror("pthread_create");
+		exit(1);
+	}
+	if (pthread_create(&threads[3], NULL, remove_entries_fn, NULL)) {
+		perror("pthread_create");
+		exit(1);
+	}
+
+	sleep(10);
+	test_complete = true;
+
+	for (i = 0; i < NUM_THREADS; i++) {
+		if (pthread_join(threads[i], NULL)) {
+			perror("pthread_join");
+			exit(1);
+		}
+	}
+
+	item_kill_tree(&tree);
+}
diff -puN tools/testing/radix-tree/main.c~radix-tree-tests-add-iteration-test tools/testing/radix-tree/main.c
--- a/tools/testing/radix-tree/main.c~radix-tree-tests-add-iteration-test
+++ a/tools/testing/radix-tree/main.c
@@ -332,6 +332,7 @@ int main(int argc, char **argv)
 	regression1_test();
 	regression2_test();
 	regression3_test();
+	iteration_test();
 	single_thread_tests(long_run);
 
 	sleep(1);
diff -puN tools/testing/radix-tree/test.h~radix-tree-tests-add-iteration-test tools/testing/radix-tree/test.h
--- a/tools/testing/radix-tree/test.h~radix-tree-tests-add-iteration-test
+++ a/tools/testing/radix-tree/test.h
@@ -27,6 +27,7 @@ void item_kill_tree(struct radix_tree_ro
 
 void tag_check(void);
 void multiorder_checks(void);
+void iteration_test(void);
 
 struct item *
 item_tag_set(struct radix_tree_root *root, unsigned long index, int tag);
_
