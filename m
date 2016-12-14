From: akpm@linux-foundation.org
Subject: [patch 082/114] radix tree test suite: track preempt_count
Date: Wed, 14 Dec 2016 15:08:02 -0800
Message-ID: <5851d0d2.YcAilfsInmIFG7LQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35232 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753108AbcLNXID (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:08:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, willy@infradead.org, kirill.shutemov@linux.intel.com, koct9i@gmail.com, mawilcox@microsoft.com, ross.zwisler@linux.intel.com

From: Matthew Wilcox <willy@infradead.org>
Subject: radix tree test suite: track preempt_count

Rather than simply NOP out preempt_enable() and preempt_disable(), keep
track of preempt_count and display it regularly in case either the test
suite or the code under test is forgetting to balance the enables &
disables.  Only found a test-case that was forgetting to re-enable
preemption, but it's a possibility worth checking.

Link: http://lkml.kernel.org/r/1480369871-5271-39-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/linux.c         |    1 
 tools/testing/radix-tree/linux/preempt.h |    6 ++--
 tools/testing/radix-tree/main.c          |   30 ++++++++++++++-------
 3 files changed, 24 insertions(+), 13 deletions(-)

diff -puN tools/testing/radix-tree/linux.c~radix-tree-test-suite-track-preempt_count tools/testing/radix-tree/linux.c
--- a/tools/testing/radix-tree/linux.c~radix-tree-test-suite-track-preempt_count
+++ a/tools/testing/radix-tree/linux.c
@@ -9,6 +9,7 @@
 #include <urcu/uatomic.h>
 
 int nr_allocated;
+int preempt_count;
 
 void *mempool_alloc(mempool_t *pool, int gfp_mask)
 {
diff -puN tools/testing/radix-tree/linux/preempt.h~radix-tree-test-suite-track-preempt_count tools/testing/radix-tree/linux/preempt.h
--- a/tools/testing/radix-tree/linux/preempt.h~radix-tree-test-suite-track-preempt_count
+++ a/tools/testing/radix-tree/linux/preempt.h
@@ -1,4 +1,4 @@
-/* */
+extern int preempt_count;
 
-#define preempt_disable() do { } while (0)
-#define preempt_enable() do { } while (0)
+#define preempt_disable()	uatomic_inc(&preempt_count)
+#define preempt_enable()	uatomic_dec(&preempt_count)
diff -puN tools/testing/radix-tree/main.c~radix-tree-test-suite-track-preempt_count tools/testing/radix-tree/main.c
--- a/tools/testing/radix-tree/main.c~radix-tree-test-suite-track-preempt_count
+++ a/tools/testing/radix-tree/main.c
@@ -293,27 +293,36 @@ static void single_thread_tests(bool lon
 {
 	int i;
 
-	printf("starting single_thread_tests: %d allocated\n", nr_allocated);
+	printf("starting single_thread_tests: %d allocated, preempt %d\n",
+		nr_allocated, preempt_count);
 	multiorder_checks();
-	printf("after multiorder_check: %d allocated\n", nr_allocated);
+	printf("after multiorder_check: %d allocated, preempt %d\n",
+		nr_allocated, preempt_count);
 	locate_check();
-	printf("after locate_check: %d allocated\n", nr_allocated);
+	printf("after locate_check: %d allocated, preempt %d\n",
+		nr_allocated, preempt_count);
 	tag_check();
-	printf("after tag_check: %d allocated\n", nr_allocated);
+	printf("after tag_check: %d allocated, preempt %d\n",
+		nr_allocated, preempt_count);
 	gang_check();
-	printf("after gang_check: %d allocated\n", nr_allocated);
+	printf("after gang_check: %d allocated, preempt %d\n",
+		nr_allocated, preempt_count);
 	add_and_check();
-	printf("after add_and_check: %d allocated\n", nr_allocated);
+	printf("after add_and_check: %d allocated, preempt %d\n",
+		nr_allocated, preempt_count);
 	dynamic_height_check();
-	printf("after dynamic_height_check: %d allocated\n", nr_allocated);
+	printf("after dynamic_height_check: %d allocated, preempt %d\n",
+		nr_allocated, preempt_count);
 	big_gang_check(long_run);
-	printf("after big_gang_check: %d allocated\n", nr_allocated);
+	printf("after big_gang_check: %d allocated, preempt %d\n",
+		nr_allocated, preempt_count);
 	for (i = 0; i < (long_run ? 2000 : 3); i++) {
 		copy_tag_check();
 		printf("%d ", i);
 		fflush(stdout);
 	}
-	printf("after copy_tag_check: %d allocated\n", nr_allocated);
+	printf("after copy_tag_check: %d allocated, preempt %d\n",
+		nr_allocated, preempt_count);
 }
 
 int main(int argc, char **argv)
@@ -336,7 +345,8 @@ int main(int argc, char **argv)
 	single_thread_tests(long_run);
 
 	sleep(1);
-	printf("after sleep(1): %d allocated\n", nr_allocated);
+	printf("after sleep(1): %d allocated, preempt %d\n",
+		nr_allocated, preempt_count);
 	rcu_unregister_thread();
 
 	exit(0);
_
