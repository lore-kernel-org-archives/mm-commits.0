From: akpm@linux-foundation.org
Subject: + radix-tree-test-suite-use-rcu_barrier.patch added to -mm tree
Date: Tue, 06 Dec 2016 12:50:25 -0800
Message-ID: <58472491.gNwb1kFpCscT7hQ7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36904 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751905AbcLFUtz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Dec 2016 15:49:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix tree test suite: use rcu_barrier
has been added to the -mm tree.  Its filename is
     radix-tree-test-suite-use-rcu_barrier.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-test-suite-use-rcu_barrier.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-test-suite-use-rcu_barrier.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: radix tree test suite: use rcu_barrier

Calling rcu_barrier() allows all of the rcu-freed memory to be actually
returned to the pool, and allows nr_allocated to return to 0.  As well as
allowing diffs between runs to be more useful, it also lets us pinpoint
leaks more effectively.

Link: http://lkml.kernel.org/r/1480369871-5271-44-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/main.c      |   12 ++++++++++--
 tools/testing/radix-tree/tag_check.c |    5 +++++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff -puN tools/testing/radix-tree/main.c~radix-tree-test-suite-use-rcu_barrier tools/testing/radix-tree/main.c
--- a/tools/testing/radix-tree/main.c~radix-tree-test-suite-use-rcu_barrier
+++ a/tools/testing/radix-tree/main.c
@@ -295,24 +295,31 @@ static void single_thread_tests(bool lon
 	printf("starting single_thread_tests: %d allocated, preempt %d\n",
 		nr_allocated, preempt_count);
 	multiorder_checks();
+	rcu_barrier();
 	printf("after multiorder_check: %d allocated, preempt %d\n",
 		nr_allocated, preempt_count);
 	locate_check();
+	rcu_barrier();
 	printf("after locate_check: %d allocated, preempt %d\n",
 		nr_allocated, preempt_count);
 	tag_check();
+	rcu_barrier();
 	printf("after tag_check: %d allocated, preempt %d\n",
 		nr_allocated, preempt_count);
 	gang_check();
+	rcu_barrier();
 	printf("after gang_check: %d allocated, preempt %d\n",
 		nr_allocated, preempt_count);
 	add_and_check();
+	rcu_barrier();
 	printf("after add_and_check: %d allocated, preempt %d\n",
 		nr_allocated, preempt_count);
 	dynamic_height_check();
+	rcu_barrier();
 	printf("after dynamic_height_check: %d allocated, preempt %d\n",
 		nr_allocated, preempt_count);
 	big_gang_check(long_run);
+	rcu_barrier();
 	printf("after big_gang_check: %d allocated, preempt %d\n",
 		nr_allocated, preempt_count);
 	for (i = 0; i < (long_run ? 2000 : 3); i++) {
@@ -320,6 +327,7 @@ static void single_thread_tests(bool lon
 		printf("%d ", i);
 		fflush(stdout);
 	}
+	rcu_barrier();
 	printf("after copy_tag_check: %d allocated, preempt %d\n",
 		nr_allocated, preempt_count);
 }
@@ -354,8 +362,8 @@ int main(int argc, char **argv)
 
 	benchmark();
 
-	sleep(1);
-	printf("after sleep(1): %d allocated, preempt %d\n",
+	rcu_barrier();
+	printf("after rcu_barrier: %d allocated, preempt %d\n",
 		nr_allocated, preempt_count);
 	rcu_unregister_thread();
 
diff -puN tools/testing/radix-tree/tag_check.c~radix-tree-test-suite-use-rcu_barrier tools/testing/radix-tree/tag_check.c
--- a/tools/testing/radix-tree/tag_check.c~radix-tree-test-suite-use-rcu_barrier
+++ a/tools/testing/radix-tree/tag_check.c
@@ -51,6 +51,7 @@ void simple_checks(void)
 	verify_tag_consistency(&tree, 1);
 	printf("before item_kill_tree: %d allocated\n", nr_allocated);
 	item_kill_tree(&tree);
+	rcu_barrier();
 	printf("after item_kill_tree: %d allocated\n", nr_allocated);
 }
 
@@ -331,12 +332,16 @@ void tag_check(void)
 	single_check();
 	extend_checks();
 	contract_checks();
+	rcu_barrier();
 	printf("after extend_checks: %d allocated\n", nr_allocated);
 	__leak_check();
 	leak_check();
+	rcu_barrier();
 	printf("after leak_check: %d allocated\n", nr_allocated);
 	simple_checks();
+	rcu_barrier();
 	printf("after simple_checks: %d allocated\n", nr_allocated);
 	thrash_tags();
+	rcu_barrier();
 	printf("after thrash_tags: %d allocated\n", nr_allocated);
 }
_

Patches currently in -mm which might be from mawilcox@microsoft.com are

radix-tree-test-suite-fix-compilation.patch
radix-tree-test-suite-iteration-test-misuses-rcu.patch
radix-tree-test-suite-use-rcu_barrier.patch
radix-tree-test-suite-handle-exceptional-entries.patch
radix-tree-test-suite-record-order-in-each-item.patch
btrfs-fix-race-in-btrfs_free_dummy_fs_info.patch
radix-tree-improve-multiorder-iterators.patch
radix-tree-delete-radix_tree_locate_item.patch
radix-tree-delete-radix_tree_range_tag_if_tagged.patch
radix-tree-fix-replacement-for-multiorder-entries.patch
radix-tree-test-suite-check-multiorder-iteration.patch
tpm-use-idr_find-not-idr_find_slowpath.patch
rxrpc-abstract-away-knowledge-of-idr-internals.patch

