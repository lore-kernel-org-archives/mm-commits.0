From: akpm@linux-foundation.org
Subject: + radix-tree-test-suite-track-preempt_count.patch added to -mm
 tree
Date: Tue, 06 Dec 2016 12:50:14 -0800
Message-ID: <58472486.xPBGxmilmVrVGUPX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36860 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751905AbcLFUto (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Dec 2016 15:49:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@infradead.org, kirill.shutemov@linux.intel.com, koct9i@gmail.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix tree test suite: track preempt_count
has been added to the -mm tree.  Its filename is
     radix-tree-test-suite-track-preempt_count.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-test-suite-track-preempt_count.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-test-suite-track-preempt_count.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from willy@infradead.org are

radix-tree-test-suite-track-preempt_count.patch
radix-tree-test-suite-free-preallocated-nodes.patch
radix-tree-test-suite-make-runs-more-reproducible.patch
radix-tree-move-rcu_head-into-a-union-with-private_list.patch
radix-tree-improve-dump-output.patch

