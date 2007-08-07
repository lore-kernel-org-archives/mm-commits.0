From: akpm@linux-foundation.org
Subject: + update-checkpatchpl-to-version-009.patch added to -mm tree
Date: Tue, 07 Aug 2007 12:34:12 -0700
Message-ID: <200708071934.l77JYCSS000471@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41683 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755065AbXHGTez (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 15:34:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org


The patch titled
     update checkpatch.pl to version 0.09
has been added to the -mm tree.  Its filename is
     update-checkpatchpl-to-version-009.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: update checkpatch.pl to version 0.09
From: Andy Whitcroft <apw@shadowen.org>

This version brings a number of new checks, and a number of bug
fixes.  Of note:

  - checks for spacing on round and square bracket combinations
  - loosening of the single statement brace checks, to allow
    them when they contain comments or where other blocks in a
    compound statement have them.
  - parks the multple declaration support
  - allows architecture defines in architecture specific headers

Andy Whitcroft (21):
      Version: 0.09
      loosen single statement brace checks
      fix up multiple declaration to avoid function arguments
      add some function space parenthesis check exceptions
      handle EXPORT_'s with parentheses in their names
      clean up some warnings in multi-line macro bracketing support
      park the multiple declaration checks
      make block brace checks count comments as a statement
      __volatile__ and __extension__ are not functions
      allow architecture specific defined within architecture includes
      check spacing on square brackets
      check spacing on parentheses
      ensure we apply checks to the part before start comment
      check #ifdef conditional spacing
      handle __init_refok and __must_check
      add noinline to inline checks
      prevent email addresses from tripping spacing checks
      handle typed initialiser spacing
      handle line contination as end of line
      add bool to the type matcher
      refine EXPORT_SYMBOL checks to handle pointers

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |  102 +++++++++++++++++++++++++++-------------
 1 files changed, 71 insertions(+), 31 deletions(-)

diff -puN scripts/checkpatch.pl~update-checkpatchpl-to-version-009 scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~update-checkpatchpl-to-version-009
+++ a/scripts/checkpatch.pl
@@ -9,7 +9,7 @@ use strict;
 my $P = $0;
 $P =~ s@.*/@@g;
 
-my $V = '0.08';
+my $V = '0.09';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -311,7 +311,7 @@ sub process {
 
 	my $Ident	= qr{[A-Za-z\d_]+};
 	my $Storage	= qr{extern|static};
-	my $Sparse	= qr{__user|__kernel|__force|__iomem};
+	my $Sparse	= qr{__user|__kernel|__force|__iomem|__must_check|__init_refok};
 	my $NonptrType	= qr{
 				\b
 				(?:const\s+)?
@@ -325,6 +325,7 @@ sub process {
 					unsigned|
 					float|
 					double|
+					bool|
 					long\s+int|
 					long\s+long|
 					long\s+long\s+int|
@@ -340,7 +341,8 @@ sub process {
 			  }x;
 	my $Type	= qr{
 				\b$NonptrType\b
-				(?:\s*\*+\s*const|\s*\*+)?
+				(?:\s*\*+\s*const|\s*\*+|(?:\s*\[\s*\])+)?
+				(?:\s+$Sparse)*
 			  }x;
 	my $Declare	= qr{(?:$Storage\s+)?$Type};
 	my $Attribute	= qr{const|__read_mostly|__init|__initdata|__meminit};
@@ -494,16 +496,15 @@ sub process {
 			ERROR("use tabs not spaces\n" . $herevet);
 		}
 
-		#
-		# The rest of our checks refer specifically to C style
-		# only apply those _outside_ comments.
-		#
-		next if ($in_comment);
-
 # Remove comments from the line before processing.
-		$line =~ s@/\*.*\*/@@g;
-		$line =~ s@/\*.*@@;
-		$line =~ s@.*\*/@@;
+		my $comment_edge = ($line =~ s@/\*.*\*/@@g) +
+				   ($line =~ s@/\*.*@@) +
+				   ($line =~ s@^(.).*\*/@$1@);
+
+# The rest of our checks refer specifically to C style
+# only apply those _outside_ comments.  Only skip
+# lines in the middle of comments.
+		next if (!$comment_edge && $in_comment);
 
 # Standardise the strings and chars within the input to simplify matching.
 		$line = sanitise_line($line);
@@ -599,7 +600,7 @@ sub process {
 			if (($prevline !~ /^}/) &&
 			   ($prevline !~ /^\+}/) &&
 			   ($prevline !~ /^ }/) &&
-			   ($prevline !~ /\s$name(?:\s+$Attribute)?\s*(?:;|=)/)) {
+			   ($prevline !~ /\b\Q$name\E(?:\s+$Attribute)?\s*(?:;|=)/)) {
 				WARN("EXPORT_SYMBOL(foo); should immediately follow its function/variable\n" . $herecurr);
 			}
 		}
@@ -680,9 +681,9 @@ sub process {
 
 # check for spaces between functions and their parentheses.
 		if ($line =~ /($Ident)\s+\(/ &&
-		    $1 !~ /^(?:if|for|while|switch|return|volatile)$/ &&
+		    $1 !~ /^(?:if|for|while|switch|return|volatile|__volatile__|__attribute__|format|__extension__|Copyright)$/ &&
 		    $line !~ /$Type\s+\(/ && $line !~ /^.\#\s*define\b/) {
-			ERROR("no space between function name and open parenthesis '('\n" . $herecurr);
+			WARN("no space between function name and open parenthesis '('\n" . $herecurr);
 		}
 # Check operator spacing.
 		# Note we expand the line with the leading + as the real
@@ -712,6 +713,7 @@ sub process {
 					$c = 'W' if ($elements[$n + 2] =~ /^\s/);
 					$c = 'B' if ($elements[$n + 2] =~ /^(\)|\]|;)/);
 					$c = 'O' if ($elements[$n + 2] eq '');
+					$c = 'E' if ($elements[$n + 2] =~ /\s*\\$/);
 				} else {
 					$c = 'E';
 				}
@@ -812,7 +814,11 @@ sub process {
 
 				# All the others need spaces both sides.
 				} elsif ($ctx !~ /[EW]x[WE]/) {
-					ERROR("need spaces around that '$op' $at\n" . $hereptr);
+					# Ignore email addresses <foo@bar>
+					if (!($op eq '<' && $cb =~ /$;\S+\@\S+>/) &&
+					    !($op eq '>' && $cb =~ /<\S+\@\S+$;/)) {
+						ERROR("need spaces around that '$op' $at\n" . $hereptr);
+					}
 				}
 				$off += length($elements[$n + 1]);
 			}
@@ -823,15 +829,24 @@ sub process {
 			WARN("multiple assignments should be avoided\n" . $herecurr);
 		}
 
-# check for multiple declarations, allowing for a function declaration
-# continuation.
-		if ($line =~ /^.\s*$Type\s+$Ident(?:\s*=[^,{]*)?\s*,\s*$Ident.*/ &&
-		    $line !~ /^.\s*$Type\s+$Ident(?:\s*=[^,{]*)?\s*,\s*$Type\s*$Ident.*/) {
-			WARN("declaring multiple variables together should be avoided\n" . $herecurr);
-		}
+## # check for multiple declarations, allowing for a function declaration
+## # continuation.
+## 		if ($line =~ /^.\s*$Type\s+$Ident(?:\s*=[^,{]*)?\s*,\s*$Ident.*/ &&
+## 		    $line !~ /^.\s*$Type\s+$Ident(?:\s*=[^,{]*)?\s*,\s*$Type\s*$Ident.*/) {
+## 
+## 			# Remove any bracketed sections to ensure we do not
+## 			# falsly report the parameters of functions.
+## 			my $ln = $line;
+## 			while ($ln =~ s/\([^\(\)]*\)//g) {
+## 			}
+## 			if ($ln =~ /,/) {
+## 				WARN("declaring multiple variables together should be avoided\n" . $herecurr);
+## 			}
+## 		}
 
 #need space before brace following if, while, etc
-		if ($line =~ /\(.*\){/ || $line =~ /do{/) {
+		if (($line =~ /\(.*\){/ && $line !~ /\($Type\){/) ||
+		    $line =~ /do{/) {
 			ERROR("need a space before the open brace '{'\n" . $herecurr);
 		}
 
@@ -841,6 +856,22 @@ sub process {
 			ERROR("need a space after that close brace '}'\n" . $herecurr);
 		}
 
+# check spacing on square brackets
+		if ($line =~ /\[\s/ && $line !~ /\[\s*$/) {
+			ERROR("no space after that open square bracket '['\n" . $herecurr);
+		}
+		if ($line =~ /\s\]/) {
+			ERROR("no space before that close square bracket ']'\n" . $herecurr);
+		}
+
+# check spacing on paretheses
+		if ($line =~ /\(\s/ && $line !~ /\(\s*$/) {
+			ERROR("no space after that open parenthesis '('\n" . $herecurr);
+		}
+		if ($line =~ /\s\)/) {
+			ERROR("no space before that close parenthesis ')'\n" . $herecurr);
+		}
+
 #goto labels aren't indented, allow a single space however
 		if ($line=~/^.\s+[A-Za-z\d_]+:(?![0-9]+)/ and
 		   !($line=~/^. [A-Za-z\d_]+:/) and !($line=~/^.\s+default:/)) {
@@ -910,7 +941,7 @@ sub process {
 			# grabbing the statement after the identifier
 			$prevline =~ m{^(.#\s*define\s*$Ident(?:\([^\)]*\))?\s*)(.*)\\\s*$};
 			##print "1<$1> 2<$2>\n";
-			if ($2 ne '') {
+			if (defined $2 && $2 ne '') {
 				$off = length($1);
 				$ln--;
 				$cnt++;
@@ -950,8 +981,10 @@ sub process {
 				my ($lvl, @block) = ctx_block_level($nr, $cnt);
 
 				my $stmt = join(' ', @block);
-				$stmt =~ s/^[^{]*{//;
-				$stmt =~ s/}[^}]*$//;
+				$stmt =~ s/(^[^{]*){//;
+				my $before = $1;
+				$stmt =~ s/}([^}]*$)//;
+				my $after = $1;
 
 				#print "block<" . join(' ', @block) . "><" . scalar(@block) . ">\n";
 				#print "stmt<$stmt>\n\n";
@@ -963,12 +996,14 @@ sub process {
 				# Also nested if's often require braces to
 				# disambiguate the else binding so shhh there.
 				my @semi = ($stmt =~ /;/g);
+				push(@semi, "/**/") if ($stmt =~ m@/\*@);
 				##print "semi<" . scalar(@semi) . ">\n";
 				if ($lvl == 0 && scalar(@semi) < 2 &&
-				    $stmt !~ /{/ && $stmt !~ /\bif\b/) {
+				    $stmt !~ /{/ && $stmt !~ /\bif\b/ &&
+				    $before !~ /}/ && $after !~ /{/) {
 				    	my $herectx = "$here\n" . join("\n", @control, @block[1 .. $#block]) . "\n";
 				    	shift(@block);
-					ERROR("braces {} are not necessary for single statement blocks\n" . $herectx);
+					WARN("braces {} are not necessary for single statement blocks\n" . $herectx);
 				}
 			}
 		}
@@ -1013,6 +1048,11 @@ sub process {
 #			$clean = 0;
 #		}
 
+# warn about spacing in #ifdefs
+		if ($line =~ /^.#\s*(ifdef|ifndef|elif)\s\s+/) {
+			ERROR("exactly one space required after that #$1\n" . $herecurr);
+		}
+
 # check for spinlock_t definitions without a comment.
 		if ($line =~ /^.\s*(struct\s+mutex|spinlock_t)\s+\S+;/) {
 			my $which = $1;
@@ -1027,14 +1067,14 @@ sub process {
 			}
 		}
 # check of hardware specific defines
-		if ($line =~ m@^.#\s*if.*\b(__i386__|__powerpc64__|__sun__|__s390x__)\b@) {
+		if ($line =~ m@^.#\s*if.*\b(__i386__|__powerpc64__|__sun__|__s390x__)\b@ && $realfile !~ m@include/asm-@) {
 			CHK("architecture specific defines should be avoided\n" .  $herecurr);
 		}
 
 # check the location of the inline attribute, that it is between
 # storage class and type.
-		if ($line =~ /$Type\s+(?:inline|__always_inline)\b/ ||
-		    $line =~ /\b(?:inline|always_inline)\s+$Storage/) {
+		if ($line =~ /$Type\s+(?:inline|__always_inline|noinline)\b/ ||
+		    $line =~ /\b(?:inline|__always_inline|noinline)\s+$Storage/) {
 			ERROR("inline keyword should sit between storage class and type\n" . $herecurr);
 		}
 
_

Patches currently in -mm which might be from apw@shadowen.org are

update-checkpatchpl-to-version-009.patch
x86_64-get-mp_bus_to_node-as-early-v2.patch
x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch
try-parent-numa_node-at-first-before-using-default-v2.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
pci-device-ensure-sysdata-initialised-v4.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static-fix.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-for-sparsemem-fix.patch
generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch
generic-virtual-memmap-support-for-sparsemem-simplify-initialisation-code-and-reduce-duplication.patch
generic-virtual-memmap-support-for-sparsemem-pull-out-the-vmemmap-code-into-its-own-file.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
sparc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function.patch
ensure-we-count-pages-transitioning-inactive-via-clear_active_flags.patch
wait-for-page-writeback-when-directly-reclaiming-contiguous-areas.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-a-configure-option-to-group-pages-by-mobility.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
page-owner-tracking-leak-detector.patch
