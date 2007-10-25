From: akpm@linux-foundation.org
Subject: + kernel-doc-single-doc-selection.patch added to -mm tree
Date: Wed, 24 Oct 2007 21:18:28 -0700
Message-ID: <200710250418.l9P4IShQ031379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59301 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752666AbXJYETP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Oct 2007 00:19:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johannes@sipsolutions.net, randy.dunlap@oracle.com, rpjday@mindspring.com, sam@ravnborg.org


The patch titled
     kernel-doc: single DOC: selection
has been added to the -mm tree.  Its filename is
     kernel-doc-single-doc-selection.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel-doc: single DOC: selection
From: Johannes Berg <johannes@sipsolutions.net>

Currently, DOC: sections are always output even if only a single function is
requested, fix this and also make it possible to just output a single DOC:
section by giving its title as the function name to output.

Also fixes docbook XML well-formedness for sections with examples.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |   63 +++++++++++++++++++++++++++++--------------
 1 file changed, 43 insertions(+), 20 deletions(-)

diff -puN scripts/kernel-doc~kernel-doc-single-doc-selection scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-single-doc-selection
+++ a/scripts/kernel-doc
@@ -54,13 +54,13 @@ use strict;
 #  Set output format using one of -docbook -html -text or -man.  Default is man.
 #
 #  -function funcname
-#	If set, then only generate documentation for the given function(s).  All
-#	other functions are ignored.
+#	If set, then only generate documentation for the given function(s) or
+#	DOC: section titles.  All other functions and DOC: sections are ignored.
 #
 #  -nofunction funcname
-#	If set, then only generate documentation for the other function(s).
-#	Cannot be used together with -function
-#	(yes, that's a bug -- perl hackers can fix it 8))
+#	If set, then only generate documentation for the other function(s)/DOC:
+#	sections. Cannot be used together with -function (yes, that's a bug --
+#	perl hackers can fix it 8))
 #
 #  c files - list of 'c' files to process
 #
@@ -374,6 +374,25 @@ sub dump_section {
 }
 
 ##
+# dump DOC: section after checking that it should go out
+#
+sub dump_doc_section {
+    my $name = shift;
+    my $contents = join "\n", @_;
+
+    if (($function_only == 0) ||
+	( $function_only == 1 && defined($function_table{$name})) ||
+	( $function_only == 2 && !defined($function_table{$name})))
+    {
+	dump_section $name, $contents;
+	output_blockhead({'sectionlist' => \@sectionlist,
+			  'sections' => \%sections,
+			  'module' => $modulename,
+			  'content-only' => ($function_only != 0), });
+    }
+}
+
+##
 # output function
 #
 # parameterdescs, a hash.
@@ -564,8 +583,8 @@ sub output_function_html(%) {
     print "<hr>\n";
 }
 
-# output intro in html
-sub output_intro_html(%) {
+# output DOC: block header in html
+sub output_blockhead_html(%) {
     my %args = %{$_[0]};
     my ($parameter, $section);
     my $count;
@@ -871,7 +890,7 @@ sub output_typedef_xml(%) {
 }
 
 # output in XML DocBook
-sub output_intro_xml(%) {
+sub output_blockhead_xml(%) {
     my %args = %{$_[0]};
     my ($parameter, $section);
     my $count;
@@ -882,15 +901,23 @@ sub output_intro_xml(%) {
     # print out each section
     $lineprefix="   ";
     foreach $section (@{$args{'sectionlist'}}) {
-	print "<refsect1>\n <title>$section</title>\n <para>\n";
+    	if (!$args{'content-only'}) {
+		print "<refsect1>\n <title>$section</title>\n";
+	}
 	if ($section =~ m/EXAMPLE/i) {
 	    print "<example><para>\n";
+	} else {
+	    print "<para>\n";
 	}
 	output_highlight($args{'sections'}{$section});
 	if ($section =~ m/EXAMPLE/i) {
 	    print "</para></example>\n";
+	} else {
+	    print "</para>";
+	}
+	if (!$args{'content-only'}) {
+		print "\n</refsect1>\n";
 	}
-	print " </para>\n</refsect1>\n";
     }
 
     print "\n\n";
@@ -1137,7 +1164,7 @@ sub output_typedef_man(%) {
     }
 }
 
-sub output_intro_man(%) {
+sub output_blockhead_man(%) {
     my %args = %{$_[0]};
     my ($parameter, $section);
     my $count;
@@ -1294,7 +1321,7 @@ sub output_struct_text(%) {
     output_section_text(@_);
 }
 
-sub output_intro_text(%) {
+sub output_blockhead_text(%) {
     my %args = %{$_[0]};
     my ($parameter, $section);
 
@@ -1325,9 +1352,9 @@ sub output_declaration {
 
 ##
 # generic output function - calls the right one based on current output mode.
-sub output_intro {
+sub output_blockhead {
     no strict 'refs';
-    my $func = "output_intro_".$output_mode;
+    my $func = "output_blockhead_".$output_mode;
     &$func(@_);
     $section_counter++;
 }
@@ -1926,9 +1953,7 @@ sub process_file($) {
 	} elsif ($state == 4) {
 		# Documentation block
 		if (/$doc_block/) {
-			dump_section($section, xml_escape($contents));
-			output_intro({'sectionlist' => \@sectionlist,
-				      'sections' => \%sections });
+			dump_doc_section($section, xml_escape($contents));
 			$contents = "";
 			$function = "";
 			%constants = ();
@@ -1946,9 +1971,7 @@ sub process_file($) {
 		}
 		elsif (/$doc_end/)
 		{
-			dump_section($section, xml_escape($contents));
-			output_intro({'sectionlist' => \@sectionlist,
-				      'sections' => \%sections });
+			dump_doc_section($section, xml_escape($contents));
 			$contents = "";
 			$function = "";
 			%constants = ();
_

Patches currently in -mm which might be from johannes@sipsolutions.net are

fix-appletouch-geyser-1-breakage.patch
fix-appletouch-geyser-1-breakage-checkpatch-fixes.patch
git-wireless.patch
kernel-doc-fix-xml-output-mode.patch
kernel-doc-init-kernel-version.patch
kernel-doc-single-doc-selection.patch
kernel-doc-process-functions-not-doc.patch
kernel-doc-use-no-doc-option.patch
kernel-doc-new-p-directive-for-doc-sections.patch
