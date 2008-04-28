From: akpm@linux-foundation.org
Subject: - kernel-doc-detect-prevent-duplicate-doc-section-names.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:01:53 -0700
Message-ID: <200804282201.m3SM1snZ018904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46067 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965832AbYD1WCq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 18:02:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     kernel-doc: detect/prevent duplicate doc section names
has been removed from the -mm tree.  Its filename was
     kernel-doc-detect-prevent-duplicate-doc-section-names.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel-doc: detect/prevent duplicate doc section names
From: Randy Dunlap <randy.dunlap@oracle.com>

I saw this problem recently.  With this kernel-doc:

 * Note: some important info
 *
 * Note: other important info

kernel-doc uses the "section name" (preceding the ':', like "Note") as a hash
key for storing the descriptive text ("blah important info").  It is (was)
possible to have duplicate (colliding) section names, without any kind of
warning or error.

kernel-doc happily used the latter descriptive text for all instances of
printing the <section-name> descriptive text and the former important info
was lost.

One way to "fix" this is to modify the kernel-doc comments, e.g.:

 * Note1: foo bar
 *
 * Note.2: blah zay

For now, kernel-doc will signal an error when it sees colliding section names
like this.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff -puN scripts/kernel-doc~kernel-doc-detect-prevent-duplicate-doc-section-names scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-detect-prevent-duplicate-doc-section-names
+++ a/scripts/kernel-doc
@@ -5,7 +5,7 @@ use strict;
 ## Copyright (c) 1998 Michael Zucchi, All Rights Reserved        ##
 ## Copyright (C) 2000, 1  Tim Waugh <twaugh@redhat.com>          ##
 ## Copyright (C) 2001  Simon Huggins                             ##
-## Copyright (C) 2005-2007  Randy Dunlap                         ##
+## Copyright (C) 2005-2008  Randy Dunlap                         ##
 ## 								 ##
 ## #define enhancements by Armin Kuster <akuster@mvista.com>	 ##
 ## Copyright (c) 2000 MontaVista Software, Inc.			 ##
@@ -366,6 +366,7 @@ foreach my $pattern (keys %highlights) {
 # dumps section contents to arrays/hashes intended for that purpose.
 #
 sub dump_section {
+    my $file = shift;
     my $name = shift;
     my $contents = join "\n", @_;
 
@@ -379,6 +380,10 @@ sub dump_section {
 	$parameterdescs{$name} = $contents;
     } else {
 #	print STDERR "other section '$name' = '$contents'\n";
+	if (defined($sections{$name}) && ($sections{$name} ne "")) {
+		print STDERR "Error(${file}:$.): duplicate section name '$name'\n";
+		++$errors;
+	}
 	$sections{$name} = $contents;
 	push @sectionlist, $name;
     }
@@ -388,6 +393,7 @@ sub dump_section {
 # dump DOC: section after checking that it should go out
 #
 sub dump_doc_section {
+    my $file = shift;
     my $name = shift;
     my $contents = join "\n", @_;
 
@@ -399,7 +405,7 @@ sub dump_doc_section {
 	( $function_only == 1 && defined($function_table{$name})) ||
 	( $function_only == 2 && !defined($function_table{$name})))
     {
-	dump_section $name, $contents;
+	dump_section($file, $name, $contents);
 	output_blockhead({'sectionlist' => \@sectionlist,
 			  'sections' => \%sections,
 			  'module' => $modulename,
@@ -1923,7 +1929,7 @@ sub process_file($) {
 			print STDERR "Warning(${file}:$.): contents before sections\n";
 			++$warnings;
 		    }
-		    dump_section($section, xml_escape($contents));
+		    dump_section($file, $section, xml_escape($contents));
 		    $section = $section_default;
 		}
 
@@ -1940,7 +1946,7 @@ sub process_file($) {
 	    } elsif (/$doc_end/) {
 
 		if ($contents ne "") {
-		    dump_section($section, xml_escape($contents));
+		    dump_section($file, $section, xml_escape($contents));
 		    $section = $section_default;
 		    $contents = "";
 		}
@@ -1954,7 +1960,7 @@ sub process_file($) {
 		# @parameter line to signify start of description
 		if ($1 eq "" &&
 			($section =~ m/^@/ || $section eq $section_context)) {
-		    dump_section($section, xml_escape($contents));
+		    dump_section($file, $section, xml_escape($contents));
 		    $section = $section_default;
 		    $contents = "";
 		} else {
@@ -1974,7 +1980,7 @@ sub process_file($) {
 	} elsif ($state == 4) {
 		# Documentation block
 		if (/$doc_block/) {
-			dump_doc_section($section, xml_escape($contents));
+			dump_doc_section($file, $section, xml_escape($contents));
 			$contents = "";
 			$function = "";
 			%constants = ();
@@ -1992,7 +1998,7 @@ sub process_file($) {
 		}
 		elsif (/$doc_end/)
 		{
-			dump_doc_section($section, xml_escape($contents));
+			dump_doc_section($file, $section, xml_escape($contents));
 			$contents = "";
 			$function = "";
 			%constants = ();
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
rapidio-fix-docbook-references.patch
rapidio-fix-kernel-doc-problems.patch
git-kvm.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-ocfs2.patch
git-unionfs.patch
let-log_buf_shift-default-to-17.patch
sysrq-add-show-backtrace-on-all-cpus-function.patch
isolate-ratelimit-from-printkc-for-other-use-update.patch
docbook-some-kernel-locking-fixes.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
jbd2-fix-kernel-doc-notation.patch
dma-add-dma_map_attrs-interfaces.patch
dma-document-dma_map_attrs-interfaces.patch
dma-ia64-update-ia64-machvecs-swiotlbc.patch
ib-expand-ib_umem_get-prototype.patch
doc-fix-dma-api-function-parameters.patch
basic-braille-screen-reader-support-makefile-fix.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
infrastructure-to-debug-dynamic-objects.patch
debugobjects-add-documentation.patch
debugobjects-add-timer-specific-object-debugging-code.patch
add-hrtimer-specific-debugobjects-code.patch
profile-likely-unlikely-macros.patch

