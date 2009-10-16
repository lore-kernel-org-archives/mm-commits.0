From: akpm@linux-foundation.org
Subject: + checkpatch-fix-__attribute__-matching.patch added to -mm tree
Date: Fri, 16 Oct 2009 14:07:02 -0700
Message-ID: <200910162107.n9GL72v6004960@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752308AbZJPVHA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Oct 2009 17:07:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com, dwalker@fifo99.com


The patch titled
     checkpatch: fix __attribute__ matching
has been added to the -mm tree.  Its filename is
     checkpatch-fix-__attribute__-matching.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

checkpatch-possible-types-prevent-illegal-modifiers-being-added.patch
checkpatch-correctly-stop-scanning-at-the-bottom-of-a-hunk.patch
checkpatch-update-copyright-dates.patch
checkpatch-fix-false-errors-due-to-macro-concatenation.patch
checkpatch-fix-__attribute__-matching.patch
checkpatch-fix-false-export_symbol-warning.patch
checkpatch-version-030.patch
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

