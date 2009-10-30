From: akpm@linux-foundation.org
Subject: [merged] checkpatch-possible-types-prevent-illegal-modifiers-being-added.patch removed from -mm tree
Date: Fri, 30 Oct 2009 13:52:09 -0700
Message-ID: <200910302052.n9UKq9Le014592@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43711 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932621AbZJ3Uwe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 16:52:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: possible types -- prevent illegal modifiers being added
has been removed from the -mm tree.  Its filename was
     checkpatch-possible-types-prevent-illegal-modifiers-being-added.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

