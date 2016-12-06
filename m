From: akpm@linux-foundation.org
Subject: + radix-tree-test-suite-iteration-test-misuses-rcu.patch added to -mm tree
Date: Tue, 06 Dec 2016 12:50:20 -0800
Message-ID: <5847248c.+PsA7K9gmLEYy9/w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36886 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751905AbcLFUtu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Dec 2016 15:49:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix tree test suite: iteration test misuses RCU
has been added to the -mm tree.  Its filename is
     radix-tree-test-suite-iteration-test-misuses-rcu.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-test-suite-iteration-test-misuses-rcu.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-test-suite-iteration-test-misuses-rcu.patch

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
Subject: radix tree test suite: iteration test misuses RCU

Each thread needs to register itself with RCU, otherwise the reading
thread's read lock has no effect and the freeing thread will free the
memory in the tree without waiting for the read lock to be dropped.

Link: http://lkml.kernel.org/r/1480369871-5271-42-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/iteration_check.c |   28 +++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff -puN tools/testing/radix-tree/iteration_check.c~radix-tree-test-suite-iteration-test-misuses-rcu tools/testing/radix-tree/iteration_check.c
--- a/tools/testing/radix-tree/iteration_check.c~radix-tree-test-suite-iteration-test-misuses-rcu
+++ a/tools/testing/radix-tree/iteration_check.c
@@ -29,6 +29,8 @@ static void *add_entries_fn(void *arg)
 {
 	int pgoff;
 
+	rcu_register_thread();
+
 	while (!test_complete) {
 		for (pgoff = 0; pgoff < 100; pgoff++) {
 			pthread_mutex_lock(&tree_lock);
@@ -38,6 +40,8 @@ static void *add_entries_fn(void *arg)
 		}
 	}
 
+	rcu_unregister_thread();
+
 	return NULL;
 }
 
@@ -53,6 +57,8 @@ static void *tagged_iteration_fn(void *a
 	struct radix_tree_iter iter;
 	void **slot;
 
+	rcu_register_thread();
+
 	while (!test_complete) {
 		rcu_read_lock();
 		radix_tree_for_each_tagged(slot, &tree, &iter, 0, TAG) {
@@ -72,12 +78,18 @@ static void *tagged_iteration_fn(void *a
 				continue;
 			}
 
-			if (rand_r(&seeds[0]) % 50 == 0)
+			if (rand_r(&seeds[0]) % 50 == 0) {
 				slot = radix_tree_iter_next(&iter);
+				rcu_read_unlock();
+				rcu_barrier();
+				rcu_read_lock();
+			}
 		}
 		rcu_read_unlock();
 	}
 
+	rcu_unregister_thread();
+
 	return NULL;
 }
 
@@ -93,6 +105,8 @@ static void *untagged_iteration_fn(void
 	struct radix_tree_iter iter;
 	void **slot;
 
+	rcu_register_thread();
+
 	while (!test_complete) {
 		rcu_read_lock();
 		radix_tree_for_each_slot(slot, &tree, &iter, 0) {
@@ -112,12 +126,18 @@ static void *untagged_iteration_fn(void
 				continue;
 			}
 
-			if (rand_r(&seeds[1]) % 50 == 0)
+			if (rand_r(&seeds[1]) % 50 == 0) {
 				slot = radix_tree_iter_next(&iter);
+				rcu_read_unlock();
+				rcu_barrier();
+				rcu_read_lock();
+			}
 		}
 		rcu_read_unlock();
 	}
 
+	rcu_unregister_thread();
+
 	return NULL;
 }
 
@@ -127,6 +147,8 @@ static void *untagged_iteration_fn(void
  */
 static void *remove_entries_fn(void *arg)
 {
+	rcu_register_thread();
+
 	while (!test_complete) {
 		int pgoff;
 
@@ -137,6 +159,8 @@ static void *remove_entries_fn(void *arg
 		pthread_mutex_unlock(&tree_lock);
 	}
 
+	rcu_unregister_thread();
+
 	return NULL;
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

