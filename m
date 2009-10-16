From: akpm@linux-foundation.org
Subject: + checkpatch-fix-false-errors-due-to-macro-concatenation.patch added to -mm tree
Date: Fri, 16 Oct 2009 14:06:56 -0700
Message-ID: <200910162106.n9GL6vlr004792@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751687AbZJPVG4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Oct 2009 17:06:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com, dwalker@fifo99.com


The patch titled
     checkpatch: fix false errors due to macro concatenation
has been added to the -mm tree.  Its filename is
     checkpatch-fix-false-errors-due-to-macro-concatenation.patch

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

