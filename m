From: akpm@linux-foundation.org
Subject: + checkpatch-variants-move-the-main-unary-binary-operators-to-use-variants.patch added to -mm tree
Date: Wed, 02 Jul 2008 11:10:56 -0700
Message-ID: <200807021810.m62IAuVM029252@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752329AbYGBSLF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 14:11:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org


The patch titled
     checkpatch: variants -- move the main unary/binary operators to use variants
has been added to the -mm tree.  Its filename is
     checkpatch-variants-move-the-main-unary-binary-operators-to-use-variants.patch

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
Subject: checkpatch: variants -- move the main unary/binary operators to use variants
From: Andy Whitcroft <apw@shadowen.org>

Now that we have a variants system, move to using that to carry the
unary/binary designation for +, -, &, and *.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-variants-move-the-main-unary-binary-operators-to-use-variants scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-variants-move-the-main-unary-binary-operators-to-use-variants
+++ a/scripts/checkpatch.pl
@@ -858,6 +858,19 @@ sub annotate_values {
 			print "CLOSE($1)\n" if ($dbg_values > 1);
 			$type = 'N';
 
+		} elsif ($cur =~ /^(-(?![->])|\+(?!\+)|\*|\&(?!\&))/o) {
+			my $variant;
+
+			print "OPV($1)\n" if ($dbg_values > 1);
+			if ($type eq 'V') {
+				$variant = 'B';
+			} else {
+				$variant = 'U';
+			}
+
+			substr($var, length($res), 1, $variant);
+			$type = 'N';
+
 		} elsif ($cur =~ /^($Operators)/o) {
 			print "OP($1)\n" if ($dbg_values > 1);
 			if ($1 ne '++' && $1 ne '--') {
@@ -1573,22 +1586,8 @@ sub process {
 				my $ptr = substr($blank, 0, $off) . "^";
 				my $hereptr = "$hereline$ptr\n";
 
-				# Classify operators into binary, unary, or
-				# definitions (* only) where they have more
-				# than one mode.
+				# Pull out the value of this operator.
 				my $op_type = substr($curr_values, $off + 1, 1);
-				my $op_left = substr($curr_values, $off, 1);
-				my $is_unary;
-				if ($op_type eq 'T') {
-					$is_unary = 2;
-				} elsif ($op_left eq 'V') {
-					$is_unary = 0;
-				} else {
-					$is_unary = 1;
-				}
-				#if ($op eq '-' || $op eq '&' || $op eq '*') {
-				#	print "UNARY: <$op_left$op_type $is_unary $a:$op:$c> <$ca:$op:$cc> <$unary_ctx>\n";
-				#}
 
 				# Get the full operator variant.
 				my $opv = $op . substr($curr_vars, $off, 1);
@@ -1625,18 +1624,19 @@ sub process {
 					}
 
 				# '*' as part of a type definition -- reported already.
-				} elsif ($op eq '*' && $is_unary == 2) {
+				} elsif ($opv eq '*_') {
 					#warn "'*' is part of type\n";
 
 				# unary operators should have a space before and
 				# none after.  May be left adjacent to another
 				# unary operator, or a cast
 				} elsif ($op eq '!' || $op eq '~' ||
-				         ($is_unary && ($op eq '*' || $op eq '-' || $op eq '&'))) {
+					 $opv eq '*U' || $opv eq '-U' ||
+					 $opv eq '&U') {
 					if ($ctx !~ /[WEBC]x./ && $ca !~ /(?:\)|!|~|\*|-|\&|\||\+\+|\-\-|\{)$/) {
 						ERROR("space required before that '$op' $at\n" . $hereptr);
 					}
-					if ($op  eq '*' && $cc =~/\s*const\b/) {
+					if ($op eq '*' && $cc =~/\s*const\b/) {
 						# A unary '*' may be const
 
 					} elsif ($ctx =~ /.xW/) {
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

