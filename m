From: akpm@linux-foundation.org
Subject: [merged] radix-tree-test-suite-free-preallocated-nodes.patch
 removed from -mm tree
Date: Thu, 15 Dec 2016 10:48:11 -0800
Message-ID: <5852e56b.SBmzm9V2s0stRNwu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49126 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932852AbcLOSsM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:48:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@infradead.org, kirill.shutemov@linux.intel.com, koct9i@gmail.com, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix tree test suite: free preallocated nodes
has been removed from the -mm tree.  Its filename was
     radix-tree-test-suite-free-preallocated-nodes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: radix tree test suite: free preallocated nodes

It can be a source of mild concern when the test suite shows that we're
leaking nodes.  While poring over the source code looking for leaks can
lead to some fascinating bugs being discovered, sometimes the leak is
simply that these nodes were preallocated and are sitting on the per-CPU
list.  Free them by calling the CPU dead callback.

Link: http://lkml.kernel.org/r/1480369871-5271-40-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/main.c |    3 +++
 tools/testing/radix-tree/test.h |    1 +
 2 files changed, 4 insertions(+)

diff -puN tools/testing/radix-tree/main.c~radix-tree-test-suite-free-preallocated-nodes tools/testing/radix-tree/main.c
--- a/tools/testing/radix-tree/main.c~radix-tree-test-suite-free-preallocated-nodes
+++ a/tools/testing/radix-tree/main.c
@@ -344,6 +344,9 @@ int main(int argc, char **argv)
 	iteration_test();
 	single_thread_tests(long_run);
 
+	/* Free any remaining preallocated nodes */
+	radix_tree_cpu_dead(0);
+
 	sleep(1);
 	printf("after sleep(1): %d allocated, preempt %d\n",
 		nr_allocated, preempt_count);
diff -puN tools/testing/radix-tree/test.h~radix-tree-test-suite-free-preallocated-nodes tools/testing/radix-tree/test.h
--- a/tools/testing/radix-tree/test.h~radix-tree-test-suite-free-preallocated-nodes
+++ a/tools/testing/radix-tree/test.h
@@ -44,3 +44,4 @@ void radix_tree_dump(struct radix_tree_r
 int root_tag_get(struct radix_tree_root *root, unsigned int tag);
 unsigned long node_maxindex(struct radix_tree_node *);
 unsigned long shift_maxindex(unsigned int shift);
+int radix_tree_cpu_dead(unsigned int cpu);
_

Patches currently in -mm which might be from willy@infradead.org are


