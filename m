From: akpm@linux-foundation.org
Subject: [merged] checkpatch-fix-false-errors-due-to-macro-concatenation.patch removed from -mm tree
Date: Fri, 30 Oct 2009 13:52:22 -0700
Message-ID: <200910302052.n9UKqMqq015117@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932652AbZJ3Uww (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 16:52:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, dwalker@fifo99.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: fix false errors due to macro concatenation
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-false-errors-due-to-macro-concatenation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: fix false errors due to macro concatenation
From: Andy Whitcroft <apw@canonical.com>

The macro concatenation (##) sequence can cause false errors when checking
macro's.  Checkpatch doesn't currently know about the operator.

For example this line,

+ 	entry = (struct ftrace_raw_##call *)raw_data;                   \

is correct but it produces the following error,

ERROR: need consistent spacing around '*' (ctx:WxB)
+       entry = (struct ftrace_raw_##call *)raw_data;\
                                          ^

The line above doesn't have any spacing problems, and if you remove the
macro concatenation sequence checkpatch doesn't give any errors.

Extend identifier handling to include ## concatenation within the
definition of an identifier.

Reported-by: Daniel Walker <dwalker@fifo99.com>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN scripts/checkpatch.pl~checkpatch-fix-false-errors-due-to-macro-concatenation scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-false-errors-due-to-macro-concatenation
+++ a/scripts/checkpatch.pl
@@ -130,7 +130,10 @@ if ($tree) {
 
 my $emitted_corrupt = 0;
 
-our $Ident       = qr{[A-Za-z_][A-Za-z\d_]*};
+our $Ident	= qr{
+			[A-Za-z_][A-Za-z\d_]*
+			(?:\s*\#\#\s*[A-Za-z_][A-Za-z\d_]*)*
+		}x;
 our $Storage	= qr{extern|static|asmlinkage};
 our $Sparse	= qr{
 			__user|
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

