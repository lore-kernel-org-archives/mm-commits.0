From: akpm@linux-foundation.org
Subject: [patch 084/114] radix tree test suite: make runs more
 reproducible
Date: Wed, 14 Dec 2016 15:08:08 -0800
Message-ID: <5851d0d8.m9tKdkjxxeA4NNJr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35260 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753350AbcLNXIJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:08:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, willy@infradead.org, kirill.shutemov@linux.intel.com, koct9i@gmail.com, mawilcox@microsoft.com, ross.zwisler@linux.intel.com

From: Matthew Wilcox <willy@infradead.org>
Subject: radix tree test suite: make runs more reproducible

Instead of reseeding the random number generator every time around the
loop in big_gang_check(), seed it at the beginning of execution.  Use
rand_r() and an independent base seed for each thread in iteration_test()
so they don't stomp all over each others state.  Since this particular
test depends on the kernel scheduler, the iteration test can't be
reproduced based purely on the random seed, but at least it won't pollute
the other tests.

Print the seed, and allow the seed to be specified so that a run which
hits a problem can be reproduced.

Link: http://lkml.kernel.org/r/1480369871-5271-41-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/iteration_check.c |   11 +++++++----
 tools/testing/radix-tree/main.c            |    9 +++++++--
 2 files changed, 14 insertions(+), 6 deletions(-)

diff -puN tools/testing/radix-tree/iteration_check.c~radix-tree-test-suite-make-runs-more-reproducible tools/testing/radix-tree/iteration_check.c
--- a/tools/testing/radix-tree/iteration_check.c~radix-tree-test-suite-make-runs-more-reproducible
+++ a/tools/testing/radix-tree/iteration_check.c
@@ -20,6 +20,7 @@
 #define TAG 0
 static pthread_mutex_t tree_lock = PTHREAD_MUTEX_INITIALIZER;
 static pthread_t threads[NUM_THREADS];
+static unsigned int seeds[3];
 RADIX_TREE(tree, GFP_KERNEL);
 bool test_complete;
 
@@ -71,7 +72,7 @@ static void *tagged_iteration_fn(void *a
 				continue;
 			}
 
-			if (rand() % 50 == 0)
+			if (rand_r(&seeds[0]) % 50 == 0)
 				slot = radix_tree_iter_next(&iter);
 		}
 		rcu_read_unlock();
@@ -111,7 +112,7 @@ static void *untagged_iteration_fn(void
 				continue;
 			}
 
-			if (rand() % 50 == 0)
+			if (rand_r(&seeds[1]) % 50 == 0)
 				slot = radix_tree_iter_next(&iter);
 		}
 		rcu_read_unlock();
@@ -129,7 +130,7 @@ static void *remove_entries_fn(void *arg
 	while (!test_complete) {
 		int pgoff;
 
-		pgoff = rand() % 100;
+		pgoff = rand_r(&seeds[2]) % 100;
 
 		pthread_mutex_lock(&tree_lock);
 		item_delete(&tree, pgoff);
@@ -146,9 +147,11 @@ void iteration_test(void)
 
 	printf("Running iteration tests for 10 seconds\n");
 
-	srand(time(0));
 	test_complete = false;
 
+	for (i = 0; i < 3; i++)
+		seeds[i] = rand();
+
 	if (pthread_create(&threads[0], NULL, tagged_iteration_fn, NULL)) {
 		perror("pthread_create");
 		exit(1);
diff -puN tools/testing/radix-tree/main.c~radix-tree-test-suite-make-runs-more-reproducible tools/testing/radix-tree/main.c
--- a/tools/testing/radix-tree/main.c~radix-tree-test-suite-make-runs-more-reproducible
+++ a/tools/testing/radix-tree/main.c
@@ -67,7 +67,6 @@ void big_gang_check(bool long_run)
 
 	for (i = 0; i < (long_run ? 1000 : 3); i++) {
 		__big_gang_check();
-		srand(time(0));
 		printf("%d ", i);
 		fflush(stdout);
 	}
@@ -329,12 +328,18 @@ int main(int argc, char **argv)
 {
 	bool long_run = false;
 	int opt;
+	unsigned int seed = time(NULL);
 
-	while ((opt = getopt(argc, argv, "l")) != -1) {
+	while ((opt = getopt(argc, argv, "ls:")) != -1) {
 		if (opt == 'l')
 			long_run = true;
+		else if (opt == 's')
+			seed = strtoul(optarg, NULL, 0);
 	}
 
+	printf("random seed %u\n", seed);
+	srand(seed);
+
 	rcu_register_thread();
 	radix_tree_init();
 
_
