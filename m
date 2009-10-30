From: akpm@linux-foundation.org
Subject: [merged] checkpatch-fix-__attribute__-matching.patch removed from -mm tree
Date: Fri, 30 Oct 2009 13:52:27 -0700
Message-ID: <200910302052.n9UKqRLv015428@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42337 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932656AbZJ3Uw7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 16:52:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, dwalker@fifo99.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: fix __attribute__ matching
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-__attribute__-matching.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: fix __attribute__ matching
From: Andy Whitcroft <apw@canonical.com>

In the following code,

union thread_union init_thread_union
	__attribute__((__section__(".data.init_task"))) =
		{ INIT_THREAD_INFO(init_task) };

There is a non-conforming declaration. It should really be like the
following,

union thread_union init_thread_union
	__attribute__((__section__(".data.init_task"))) = {
		INIT_THREAD_INFO(init_task)
};

However, checkpatch doesn't catch this right now because it doesn't
correctly evaluate the "__attribute__".

It is not at all clear that we care what preceeds an assignment style
attribute when we find the open brace.  Relax the test so we do not need
to check the __attribute__.

Reported-by: Daniel Walker <dwalker@fifo99.com>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN scripts/checkpatch.pl~checkpatch-fix-__attribute__-matching scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-__attribute__-matching
+++ a/scripts/checkpatch.pl
@@ -1669,8 +1669,8 @@ sub process {
 		}
 
 # check for initialisation to aggregates open brace on the next line
-		if ($prevline =~ /$Declare\s*$Ident\s*=\s*$/ &&
-		    $line =~ /^.\s*{/) {
+		if ($line =~ /^.\s*{/ &&
+		    $prevline =~ /(?:^|[^=])=\s*$/) {
 			ERROR("that open brace { should be on the previous line\n" . $hereprev);
 		}
 
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch
nodemask-make-nodemask_alloc-more-general.patch
hugetlb-rework-hstate_next_node_-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions-fix.patch
hugetlb-factor-init_nodemask_of_node.patch
hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy.patch
hugetlb-add-generic-definition-of-numa_no_node.patch
hugetlb-add-per-node-hstate-attributes.patch
hugetlb-update-hugetlb-documentation-for-numa-controls.patch
hugetlb-use-only-nodes-with-memory-for-huge-pages.patch
mm-clear-node-in-n_high_memory-and-stop-kswapd-when-all-memory-is-offlined.patch
hugetlb-handle-memory-hot-plug-events.patch
hugetlb-offload-per-node-attribute-registrations.patch
mm-add-gfp-flags-for-nodemask_alloc-slab-allocations.patch
checkpatch-trivial-fix-for-trailing-statements-check.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch

