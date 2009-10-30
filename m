From: akpm@linux-foundation.org
Subject: [merged] checkpatch-correctly-stop-scanning-at-the-bottom-of-a-hunk.patch removed from -mm tree
Date: Fri, 30 Oct 2009 13:52:13 -0700
Message-ID: <200910302052.n9UKqDSY014814@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41617 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932627AbZJ3Uwn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 16:52:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: correctly stop scanning at the bottom of a hunk
has been removed from the -mm tree.  Its filename was
     checkpatch-correctly-stop-scanning-at-the-bottom-of-a-hunk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: correctly stop scanning at the bottom of a hunk
From: Andy Whitcroft <apw@canonical.com>

We are allowing context scanning checks to apply against the first line of
context outside at the end of the hunk.  This can lead to false matches to
patch names leading to various perl warnings.  Correctly stop at the
bottom of the hunk.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN scripts/checkpatch.pl~checkpatch-correctly-stop-scanning-at-the-bottom-of-a-hunk scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-correctly-stop-scanning-at-the-bottom-of-a-hunk
+++ a/scripts/checkpatch.pl
@@ -1234,7 +1234,6 @@ sub process {
 		$linenr++;
 
 		my $rawline = $rawlines[$linenr - 1];
-		my $hunk_line = ($realcnt != 0);
 
 #extract the line range in the file after the patch is applied
 		if ($line=~/^\@\@ -\d+(?:,\d+)? \+(\d+)(,(\d+))? \@\@/) {
@@ -1274,6 +1273,8 @@ sub process {
 			$realcnt--;
 		}
 
+		my $hunk_line = ($realcnt != 0);
+
 #make up the handle for any error we report on this line
 		$prefix = "$filename:$realline: " if ($emacs && $file);
 		$prefix = "$filename:$linenr: " if ($emacs && !$file);
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

