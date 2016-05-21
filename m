From: akpm@linux-foundation.org
Subject: [patch 103/162] radix tree test suite: keep regression test runs
 short
Date: Fri, 20 May 2016 17:01:45 -0700
Message-ID: <573fa569.c5l07/6eOe52yME1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52913 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbcEUABq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:01:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ross.zwisler@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, willy@linux.intel.com

From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: radix tree test suite: keep regression test runs short

Currently the full suite of regression tests take upwards of 30 minutes to
run on my development machine.  The vast majority of this time is taken by
the big_gang_check() and copy_tag_check() tests, which each run their
tests through thousands of iterations...does this have value?

Without big_gang_check() and copy_tag_check(), the test suite runs in
around 15 seconds on my box.

Honestly the first time I ever ran through the entire test suite was to
gather the timings for this email - it simply takes too long to be useful
on a normal basis.

Instead, hide the excessive iterations through big_gang_check() and
copy_tag_check() tests behind an '-l' flag (for "long run") in case they
are still useful, but allow the regression test suite to complete in a
reasonable amount of time.  We still run each of these tests a few times
(3 at present) to try and keep the test coverage.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/main.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff -puN tools/testing/radix-tree/main.c~radix-tree-test-suite-keep-regression-test-runs-short tools/testing/radix-tree/main.c
--- a/tools/testing/radix-tree/main.c~radix-tree-test-suite-keep-regression-test-runs-short
+++ a/tools/testing/radix-tree/main.c
@@ -61,11 +61,11 @@ void __big_gang_check(void)
 	} while (!wrapped);
 }
 
-void big_gang_check(void)
+void big_gang_check(bool long_run)
 {
 	int i;
 
-	for (i = 0; i < 1000; i++) {
+	for (i = 0; i < (long_run ? 1000 : 3); i++) {
 		__big_gang_check();
 		srand(time(0));
 		printf("%d ", i);
@@ -270,7 +270,7 @@ static void locate_check(void)
 	item_kill_tree(&tree);
 }
 
-static void single_thread_tests(void)
+static void single_thread_tests(bool long_run)
 {
 	int i;
 
@@ -285,9 +285,9 @@ static void single_thread_tests(void)
 	printf("after add_and_check: %d allocated\n", nr_allocated);
 	dynamic_height_check();
 	printf("after dynamic_height_check: %d allocated\n", nr_allocated);
-	big_gang_check();
+	big_gang_check(long_run);
 	printf("after big_gang_check: %d allocated\n", nr_allocated);
-	for (i = 0; i < 2000; i++) {
+	for (i = 0; i < (long_run ? 2000 : 3); i++) {
 		copy_tag_check();
 		printf("%d ", i);
 		fflush(stdout);
@@ -295,15 +295,23 @@ static void single_thread_tests(void)
 	printf("after copy_tag_check: %d allocated\n", nr_allocated);
 }
 
-int main(void)
+int main(int argc, char **argv)
 {
+	bool long_run = false;
+	int opt;
+
+	while ((opt = getopt(argc, argv, "l")) != -1) {
+		if (opt == 'l')
+			long_run = true;
+	}
+
 	rcu_register_thread();
 	radix_tree_init();
 
 	regression1_test();
 	regression2_test();
 	regression3_test();
-	single_thread_tests();
+	single_thread_tests(long_run);
 
 	sleep(1);
 	printf("after sleep(1): %d allocated\n", nr_allocated);
_
