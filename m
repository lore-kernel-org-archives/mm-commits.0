From: akpm@linux-foundation.org
Subject: + checkpatch-add-checks-for-question-mark-and-colon-spacing.patch added to -mm tree
Date: Wed, 02 Jul 2008 11:10:54 -0700
Message-ID: <200807021810.m62IAsoE029249@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752331AbYGBSLF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 14:11:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org


The patch titled
     checkpatch: add checks for question mark and colon spacing
has been added to the -mm tree.  Its filename is
     checkpatch-add-checks-for-question-mark-and-colon-spacing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: add checks for question mark and colon spacing
From: Andy Whitcroft <apw@shadowen.org>

Add checks for the question mark colon operator spacing, and also check
the other uses of colon.  Colon means a number of things:

 - it introduces the else part of the ?: operator,
 - it terminates a goto label,
 - it terminates the case value,
 - it separates the identifier from the bit size on bit fields, and
 - it is used to introduce option types in asm().

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   81 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 72 insertions(+), 9 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-checks-for-question-mark-and-colon-spacing scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-checks-for-question-mark-and-colon-spacing
+++ a/scripts/checkpatch.pl
@@ -689,17 +689,20 @@ sub cat_vet {
 my $av_preprocessor = 0;
 my $av_pending;
 my @av_paren_type;
+my $av_pend_colon;
 
 sub annotate_reset {
 	$av_preprocessor = 0;
 	$av_pending = '_';
 	@av_paren_type = ('E');
+	$av_pend_colon = 'O';
 }
 
 sub annotate_values {
 	my ($stream, $type) = @_;
 
 	my $res;
+	my $var = '_' x length($stream);
 	my $cur = $stream;
 
 	print "$stream\n" if ($dbg_values > 1);
@@ -784,7 +787,12 @@ sub annotate_values {
 			$av_pending = 'N';
 			$type = 'N';
 
-		} elsif ($cur =~/^(return|case|else|goto)/o) {
+		} elsif ($cur =~/^(case)/o) {
+			print "CASE($1)\n" if ($dbg_values > 1);
+			$av_pend_colon = 'C';
+			$type = 'N';
+
+		} elsif ($cur =~/^(return|else|goto)/o) {
 			print "KEYWORD($1)\n" if ($dbg_values > 1);
 			$type = 'N';
 
@@ -809,6 +817,15 @@ sub annotate_values {
 			$type = 'V';
 			$av_pending = 'V';
 
+		} elsif ($cur =~ /^($Ident\s*):/) {
+			if ($type eq 'E') {
+				$av_pend_colon = 'L';
+			} elsif ($type eq 'T') {
+				$av_pend_colon = 'B';
+			}
+			print "IDENT_COLON($1,$type>$av_pend_colon)\n" if ($dbg_values > 1);
+			$type = 'V';
+
 		} elsif ($cur =~ /^($Ident|$Constant)/o) {
 			print "IDENT($1)\n" if ($dbg_values > 1);
 			$type = 'V';
@@ -820,8 +837,24 @@ sub annotate_values {
 		} elsif ($cur =~/^(;|{|})/) {
 			print "END($1)\n" if ($dbg_values > 1);
 			$type = 'E';
+			$av_pend_colon = 'O';
 
-		} elsif ($cur =~ /^(;|\?|:|\[)/o) {
+		} elsif ($cur =~ /^(\?)/o) {
+			print "QUESTION($1)\n" if ($dbg_values > 1);
+			$type = 'N';
+
+		} elsif ($cur =~ /^(:)/o) {
+			print "COLON($1,$av_pend_colon)\n" if ($dbg_values > 1);
+
+			substr($var, length($res), 1, $av_pend_colon);
+			if ($av_pend_colon eq 'C' || $av_pend_colon eq 'L') {
+				$type = 'E';
+			} else {
+				$type = 'N';
+			}
+			$av_pend_colon = 'O';
+
+		} elsif ($cur =~ /^(;|\[)/o) {
 			print "CLOSE($1)\n" if ($dbg_values > 1);
 			$type = 'N';
 
@@ -840,7 +873,7 @@ sub annotate_values {
 		}
 	}
 
-	return $res;
+	return ($res, $var);
 }
 
 sub possible {
@@ -1294,12 +1327,14 @@ sub process {
 
 		# Track the 'values' across context and added lines.
 		my $opline = $line; $opline =~ s/^./ /;
-		my $curr_values = annotate_values($opline . "\n", $prev_values);
+		my ($curr_values, $curr_vars) =
+				annotate_values($opline . "\n", $prev_values);
 		$curr_values = $prev_values . $curr_values;
 		if ($dbg_values) {
 			my $outline = $opline; $outline =~ s/\t/ /g;
 			print "$linenr > .$outline\n";
 			print "$linenr > $curr_values\n";
+			print "$linenr >  $curr_vars\n";
 		}
 		$prev_values = substr($curr_values, -1);
 
@@ -1490,7 +1525,8 @@ sub process {
 				<<=|>>=|<=|>=|==|!=|
 				\+=|-=|\*=|\/=|%=|\^=|\|=|&=|
 				=>|->|<<|>>|<|>|=|!|~|
-				&&|\|\||,|\^|\+\+|--|&|\||\+|-|\*|\/|%
+				&&|\|\||,|\^|\+\+|--|&|\||\+|-|\*|\/|%|
+				\?|:
 			}x;
 			my @elements = split(/($ops|;)/, $opline);
 			my $off = 0;
@@ -1554,6 +1590,9 @@ sub process {
 				#	print "UNARY: <$op_left$op_type $is_unary $a:$op:$c> <$ca:$op:$cc> <$unary_ctx>\n";
 				#}
 
+				# Get the full operator variant.
+				my $opv = $op . substr($curr_vars, $off, 1);
+
 				# Ignore operators passed as parameters.
 				if ($op_type ne 'V' &&
 				    $ca =~ /\s$/ && $cc =~ /^\s*,/) {
@@ -1571,8 +1610,10 @@ sub process {
 				# // is a comment
 				} elsif ($op eq '//') {
 
-				# -> should have no spaces
-				} elsif ($op eq '->') {
+				# No spaces for:
+				#   ->
+				#   :   when part of a bitfield
+				} elsif ($op eq '->' || $opv eq ':B') {
 					if ($ctx =~ /Wx.|.xW/) {
 						ERROR("spaces prohibited around that '$op' $at\n" . $hereptr);
 					}
@@ -1628,11 +1669,33 @@ sub process {
 							$hereptr);
 					}
 
+				# A colon needs no spaces before when it is
+				# terminating a case value or a label.
+				} elsif ($opv eq ':C' || $opv eq ':L') {
+					if ($ctx =~ /Wx./) {
+						ERROR("space prohibited before that '$op' $at\n" . $hereptr);
+					}
+
 				# All the others need spaces both sides.
 				} elsif ($ctx !~ /[EWC]x[CWE]/) {
+					my $ok = 0;
+
 					# Ignore email addresses <foo@bar>
-					if (!($op eq '<' && $cb =~ /$;\S+\@\S+>/) &&
-					    !($op eq '>' && $cb =~ /<\S+\@\S+$;/)) {
+					if (($op eq '<' &&
+					     $cc =~ /^\S+\@\S+>/) ||
+					    ($op eq '>' &&
+					     $ca =~ /<\S+\@\S+$/))
+					{
+					    	$ok = 1;
+					}
+
+					# Ignore ?:
+					if (($opv eq ':O' && $ca =~ /\?$/) ||
+					    ($op eq '?' && $cc =~ /^:/)) {
+					    	$ok = 1;
+					}
+
+					if ($ok == 0) {
 						ERROR("spaces required around that '$op' $at\n" . $hereptr);
 					}
 				}
_

Patches currently in -mm which might be from apw@shadowen.org are

linux-next.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation-fix.patch
mm-verify-the-page-links-and-memory-model.patch
mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch
mm-print-out-the-zonelists-on-request-for-manual-verification.patch
add-a-helper-function-to-test-if-an-object-is-on-the-stack.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
buddy-clarify-comments-describing-buddy-merge.patch
page-flags-record-page-flag-overlays-explicitly.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
hugetlb-move-hugetlb_acct_memory.patch
hugetlb-reserve-huge-pages-for-reliable-map_private-hugetlbfs-mappings-until-fork.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-fix.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-build-fix.patch
huge-page-private-reservation-review-cleanups.patch
huge-page-private-reservation-review-cleanups-fix.patch
mm-record-map_noreserve-status-on-vmas-and-fix-small-page-mprotect-reservations.patch
hugetlb-move-reservation-region-support-earlier.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch
hugetlb-reservations-move-region-tracking-earlier.patch
hugetlb-reservations-fix-hugetlb-map_private-reservations-across-vma-splits-v2.patch
hugetlb-reservations-fix-hugetlb-map_private-reservations-across-vma-splits-v2-fix.patch
hugetlb-fix-race-when-reading-proc-meminfo.patch
memory-hotplugallocate-usemap-on-the-section-with-pgdat-take-4.patch
memory-hotplug-small-fixes-to-bootmem-freeing-for-memory-hotremove.patch
memory-hotplug-dont-calculate-vm_total_pages-twice-when-rebuilding-zonelists-in-online_pages.patch
checkpatch-version-020.patch
checkpatch-return-is-not-a-function-parentheses-for-casts-are-ok-too.patch
checkpatch-types-some-types-may-also-be-identifiers.patch
checkpatch-add-a-checkpatch-warning-for-new-uses-of-__initcall.patch
checkpatch-possible-types-__asm__-is-never-a-type.patch
checkpatch-comment-detection-ignore-macro-continuation-when-detecting-associated-comments.patch
checkpatch-types-unary-goto-introduces-unary-context.patch
checkpatch-macros-fix-statement-counting-block-end-detection.patch
checkpatch-trailing-statement-indent-fix-end-of-statement-location.patch
checkpatch-allow-printk-strings-to-exceed-80-characters-to-maintain-their-searchability.patch
checkpatch-switch-report-trailing-statements-on-case-and-default.patch
checkpatch-check-spacing-for-square-brackets.patch
checkpatch-toughen-trailing-if-statement-checks-and-extend-them-to-while-and-for.patch
checkpatch-condition-loop-indent-checks.patch
checkpatch-usb_free_urb-can-take-null.patch
checkpatch-correct-spelling-in-kfree-checks.patch
checkpatch-allow-for-type-modifiers-on-multiple-declarations.patch
checkpatch-improve-type-matcher-debug.patch
checkpatch-possible-modifiers-are-not-being-correctly-matched.patch
checkpatch-macro-complexity-checks-are-meaningless-in-linker-scripts.patch
checkpatch-handle-return-types-of-pointers-to-functions.patch
checkpatch-possible-types-known-modifiers-cannot-be-types.patch
checkpatch-possible-modifiers-handle-multiple-modifiers-and-trailing.patch
checkpatch-add-checks-for-question-mark-and-colon-spacing.patch
checkpatch-variants-move-the-main-unary-binary-operators-to-use-variants.patch
checkpatch-complex-macros-need-to-ignore-comments.patch
checkpatch-types-cannot-start-mid-word-for-pointer-tests.patch
checkpatch-version-021.patch
x86-implement-pte_special.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
page-owner-tracking-leak-detector.patch

