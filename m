From: akpm@linux-foundation.org
Subject: + checkpatch-fix-false-export_symbol-warning.patch added to -mm tree
Date: Fri, 16 Oct 2009 14:07:05 -0700
Message-ID: <200910162107.n9GL75KP005096@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751326AbZJPVHV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Oct 2009 17:07:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com, dwalker@fifo99.com, mingo@elte.hu, paulmck@linux.vnet.ibm.com


The patch titled
     checkpatch: fix false EXPORT_SYMBOL warning
has been added to the -mm tree.  Its filename is
     checkpatch-fix-false-export_symbol-warning.patch

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
Subject: checkpatch: fix false EXPORT_SYMBOL warning
From: Andy Whitcroft <apw@canonical.com>

Ingo reported that the following lines triggered a false warning,

static struct lock_class_key rcu_lock_key;
struct lockdep_map rcu_lock_map =
        STATIC_LOCKDEP_MAP_INIT("rcu_read_lock", &rcu_lock_key);
EXPORT_SYMBOL_GPL(rcu_lock_map);

from kernel/rcutree.c , and the false warning looked like this,

WARNING: EXPORT_SYMBOL(foo); should immediately follow its
function/variable
+EXPORT_SYMBOL_GPL(rcu_lock_map);

We actually should be checking the statement before the EXPORT_* for a
mention of the exported object, and complain where it is not there.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reported-by: Daniel Walker <dwalker@fifo99.com>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN scripts/checkpatch.pl~checkpatch-fix-false-export_symbol-warning scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-false-export_symbol-warning
+++ a/scripts/checkpatch.pl
@@ -1145,6 +1145,7 @@ sub process {
 	# suppression flags
 	my %suppress_ifbraces;
 	my %suppress_whiletrailers;
+	my %suppress_export;
 
 	# Pre-scan the patch sanitizing the lines.
 	# Pre-scan the patch looking for any __setup documentation.
@@ -1253,6 +1254,7 @@ sub process {
 
 			%suppress_ifbraces = ();
 			%suppress_whiletrailers = ();
+			%suppress_export = ();
 			next;
 
 # track the line number as we move through the hunk, note that
@@ -1428,13 +1430,22 @@ sub process {
 		}
 
 # Check for potential 'bare' types
-		my ($stat, $cond, $line_nr_next, $remain_next, $off_next);
+		my ($stat, $cond, $line_nr_next, $remain_next, $off_next,
+		    $realline_next);
 		if ($realcnt && $line =~ /.\s*\S/) {
 			($stat, $cond, $line_nr_next, $remain_next, $off_next) =
 				ctx_statement_block($linenr, $realcnt, 0);
 			$stat =~ s/\n./\n /g;
 			$cond =~ s/\n./\n /g;
 
+			# Find the real next line.
+			$realline_next = $line_nr_next;
+			if (defined $realline_next &&
+			    (!defined $lines[$realline_next - 1] ||
+			     substr($lines[$realline_next - 1], $off_next) =~ /^\s*$/)) {
+				$realline_next++;
+			}
+
 			my $s = $stat;
 			$s =~ s/{.*$//s;
 
@@ -1695,21 +1706,40 @@ sub process {
 		$line =~ s@//.*@@;
 		$opline =~ s@//.*@@;
 
-#EXPORT_SYMBOL should immediately follow its function closing }.
-		if (($line =~ /EXPORT_SYMBOL.*\((.*)\)/) ||
-		    ($line =~ /EXPORT_UNUSED_SYMBOL.*\((.*)\)/)) {
+# EXPORT_SYMBOL should immediately follow the thing it is exporting, consider
+# the whole statement.
+#print "APW <$lines[$realline_next - 1]>\n";
+		if (defined $realline_next &&
+		    exists $lines[$realline_next - 1] &&
+		    !defined $suppress_export{$realline_next} &&
+		    ($lines[$realline_next - 1] =~ /EXPORT_SYMBOL.*\((.*)\)/ ||
+		     $lines[$realline_next - 1] =~ /EXPORT_UNUSED_SYMBOL.*\((.*)\)/)) {
 			my $name = $1;
-			if ($prevline !~ /(?:
-				^.}|
+			if ($stat !~ /(?:
+				\n.}\s*$|
 				^.DEFINE_$Ident\(\Q$name\E\)|
 				^.DECLARE_$Ident\(\Q$name\E\)|
 				^.LIST_HEAD\(\Q$name\E\)|
-				^.$Type\s*\(\s*\*\s*\Q$name\E\s*\)\s*\(|
-				\b\Q$name\E(?:\s+$Attribute)?\s*(?:;|=|\[)
+				^.(?:$Storage\s+)?$Type\s*\(\s*\*\s*\Q$name\E\s*\)\s*\(|
+				\b\Q$name\E(?:\s+$Attribute)*\s*(?:;|=|\[|\()
 			    )/x) {
-				WARN("EXPORT_SYMBOL(foo); should immediately follow its function/variable\n" . $herecurr);
+#print "FOO A<$lines[$realline_next - 1]> stat<$stat> name<$name>\n";
+				$suppress_export{$realline_next} = 2;
+			} else {
+				$suppress_export{$realline_next} = 1;
 			}
 		}
+		if (!defined $suppress_export{$linenr} &&
+		    $prevline =~ /^.\s*$/ &&
+                    ($line =~ /EXPORT_SYMBOL.*\((.*)\)/ ||
+		     $line =~ /EXPORT_UNUSED_SYMBOL.*\((.*)\)/)) {
+#print "FOO B <$lines[$linenr - 1]>\n";
+			$suppress_export{$linenr} = 2;
+		}
+		if (defined $suppress_export{$linenr} &&
+		    $suppress_export{$linenr} == 2) {
+			WARN("EXPORT_SYMBOL(foo); should immediately follow its function/variable\n" . $herecurr);
+		}
 
 # check for external initialisers.
 		if ($line =~ /^.$Type\s*$Ident\s*(?:\s+$Modifier)*\s*=\s*(0|NULL|false)\s*;/) {
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

