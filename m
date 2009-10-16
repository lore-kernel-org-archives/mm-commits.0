From: akpm@linux-foundation.org
Subject: + checkpatch-possible-types-prevent-illegal-modifiers-being-added.patch added to -mm tree
Date: Fri, 16 Oct 2009 14:06:45 -0700
Message-ID: <200910162106.n9GL6jib004405@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751305AbZJPVGo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Oct 2009 17:06:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com


The patch titled
     checkpatch: possible types -- prevent illegal modifiers being added
has been added to the -mm tree.  Its filename is
     checkpatch-possible-types-prevent-illegal-modifiers-being-added.patch

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
Subject: checkpatch: possible types -- prevent illegal modifiers being added
From: Andy Whitcroft <apw@canonical.com>

Prevent known non types being detected as modifiers.  Ensure we do not
look at any type which starts with a keyword.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN scripts/checkpatch.pl~checkpatch-possible-types-prevent-illegal-modifiers-being-added scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-possible-types-prevent-illegal-modifiers-being-added
+++ a/scripts/checkpatch.pl
@@ -997,23 +997,25 @@ sub annotate_values {
 
 sub possible {
 	my ($possible, $line) = @_;
-
-	print "CHECK<$possible> ($line)\n" if ($dbg_possible > 2);
-	if ($possible !~ /(?:
+	my $notPermitted = qr{(?:
 		^(?:
 			$Modifier|
 			$Storage|
 			$Type|
-			DEFINE_\S+|
+			DEFINE_\S+
+		)$|
+		^(?:
 			goto|
 			return|
 			case|
 			else|
 			asm|__asm__|
 			do
-		)$|
+		)(?:\s|$)|
 		^(?:typedef|struct|enum)\b
-	    )/x) {
+	    )}x;
+	warn "CHECK<$possible> ($line)\n" if ($dbg_possible > 2);
+	if ($possible !~ $notPermitted) {
 		# Check for modifiers.
 		$possible =~ s/\s*$Storage\s*//g;
 		$possible =~ s/\s*$Sparse\s*//g;
@@ -1022,8 +1024,10 @@ sub possible {
 		} elsif ($possible =~ /\s/) {
 			$possible =~ s/\s*$Type\s*//g;
 			for my $modifier (split(' ', $possible)) {
-				warn "MODIFIER: $modifier ($possible) ($line)\n" if ($dbg_possible);
-				push(@modifierList, $modifier);
+				if ($modifier !~ $notPermitted) {
+					warn "MODIFIER: $modifier ($possible) ($line)\n" if ($dbg_possible);
+					push(@modifierList, $modifier);
+				}
 			}
 
 		} else {
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

