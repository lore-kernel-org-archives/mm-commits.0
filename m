From: akpm@linux-foundation.org
Subject: - kernel-doc-fix-doc-blocks-and-html.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:04:25 -0700
Message-ID: <200710180704.l9I74PAj031550@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53641 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762127AbXJRH1Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:27:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, johannes@sipsolutions.net, mm-commits@vger.kernel.org


The patch titled
     kernel-doc: fix doc blocks and html
has been removed from the -mm tree.  Its filename was
     kernel-doc-fix-doc-blocks-and-html.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kernel-doc: fix doc blocks and html
From: Randy Dunlap <randy.dunlap@oracle.com>

Johannes Berg reports (Thanks!) that &struct names are not highlighted in
html output format when they are inside a DOC: block.

DOC: blocks were not escaped thru xml_escape() like other kernel-doc
comments were.  Fixed that.

However, that left a problem with <p> ($blankline_html) being processed
thru xml_escape(), converting it to &lt;p&gt;, which isn't good for the
generated html output (the <p> should remain unchanged), so this patch also
introduces the notion of "local" kernel-doc meta-characters
('\\\\mnemonic:'), which are converted to html just before writing the
stream to its output file.

Please report any problems that you (anyone) see in "highlighting" in any
output mode (text, man, html, xml).

Also update copyright to include me.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |   41 ++++++++++++++++++++++++++++++++---------
 1 file changed, 32 insertions(+), 9 deletions(-)

diff -puN scripts/kernel-doc~kernel-doc-fix-doc-blocks-and-html scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-fix-doc-blocks-and-html
+++ a/scripts/kernel-doc
@@ -5,6 +5,7 @@ use strict;
 ## Copyright (c) 1998 Michael Zucchi, All Rights Reserved        ##
 ## Copyright (C) 2000, 1  Tim Waugh <twaugh@redhat.com>          ##
 ## Copyright (C) 2001  Simon Huggins                             ##
+## Copyright (C) 2005-2007  Randy Dunlap                         ##
 ## 								 ##
 ## #define enhancements by Armin Kuster <akuster@mvista.com>	 ##
 ## Copyright (c) 2000 MontaVista Software, Inc.			 ##
@@ -161,7 +162,7 @@ my $type_constant = '\%([-_\w]+)';
 my $type_func = '(\w+)\(\)';
 my $type_param = '\@(\w+)';
 my $type_struct = '\&((struct\s*)*[_\w]+)';
-my $type_struct_xml = '\\\amp;((struct\s*)*[_\w]+)';
+my $type_struct_xml = '\\&amp;((struct\s*)*[_\w]+)';
 my $type_env = '(\$\w+)';
 
 # Output conversion substitutions.
@@ -173,7 +174,9 @@ my %highlights_html = ( $type_constant, 
 			$type_struct_xml, "<i>\$1</i>",
 			$type_env, "<b><i>\$1</i></b>",
 			$type_param, "<tt><b>\$1</b></tt>" );
-my $blankline_html = "<p>";
+my $local_lt = "\\\\\\\\lt:";
+my $local_gt = "\\\\\\\\gt:";
+my $blankline_html = $local_lt . "p" . $local_gt;	# was "<p>"
 
 # XML, docbook format
 my %highlights_xml = ( "([^=])\\\"([^\\\"<]+)\\\"", "\$1<quote>\$2</quote>",
@@ -391,17 +394,19 @@ sub output_highlight {
 #	confess "output_highlight got called with no args?\n";
 #   }
 
+    if ($output_mode eq "html") {
+	$contents = local_unescape($contents);
+	# convert data read & converted thru xml_escape() into &xyz; format:
+	$contents =~ s/\\\\\\/&/g;
+    }
 #   print STDERR "contents b4:$contents\n";
     eval $dohighlight;
     die $@ if $@;
-    if ($output_mode eq "html") {
-	$contents =~ s/\\\\//;
-    }
 #   print STDERR "contents af:$contents\n";
 
     foreach $line (split "\n", $contents) {
 	if ($line eq ""){
-	    print $lineprefix, $blankline;
+	    print $lineprefix, local_unescape($blankline);
 	} else {
 	    $line =~ s/\\\\\\/\&/g;
 	    if ($output_mode eq "man" && substr($line, 0, 1) eq ".") {
@@ -1752,7 +1757,13 @@ sub process_state3_type($$) {
     }
 }
 
-# replace <, >, and &
+# xml_escape: replace <, >, and & in the text stream;
+#
+# however, formatting controls that are generated internally/locally in the
+# kernel-doc script are not escaped here; instead, they begin life like
+# $blankline_html (4 of '\' followed by a mnemonic + ':'), then these strings
+# are converted to their mnemonic-expected output, without the 4 * '\' & ':',
+# just before actual output; (this is done by local_unescape())
 sub xml_escape($) {
 	my $text = shift;
 	if (($output_mode eq "text") || ($output_mode eq "man")) {
@@ -1764,6 +1775,18 @@ sub xml_escape($) {
 	return $text;
 }
 
+# convert local escape strings to html
+# local escape strings look like:  '\\\\menmonic:' (that's 4 backslashes)
+sub local_unescape($) {
+	my $text = shift;
+	if (($output_mode eq "text") || ($output_mode eq "man")) {
+		return $text;
+	}
+	$text =~ s/\\\\\\\\lt:/</g;
+	$text =~ s/\\\\\\\\gt:/>/g;
+	return $text;
+}
+
 sub process_file($) {
     my $file;
     my $identifier;
@@ -1903,7 +1926,7 @@ sub process_file($) {
 	} elsif ($state == 4) {
 		# Documentation block
 		if (/$doc_block/) {
-			dump_section($section, $contents);
+			dump_section($section, xml_escape($contents));
 			output_intro({'sectionlist' => \@sectionlist,
 				      'sections' => \%sections });
 			$contents = "";
@@ -1923,7 +1946,7 @@ sub process_file($) {
 		}
 		elsif (/$doc_end/)
 		{
-			dump_section($section, $contents);
+			dump_section($section, xml_escape($contents));
 			output_intro({'sectionlist' => \@sectionlist,
 				      'sections' => \%sections });
 			$contents = "";
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
fix-auditscc-kernel-doc.patch
comment-typo-in-scripts-kconfig-makefile.patch
git-unionfs.patch
git-watchdog.patch
git-ipwireless_cs.patch
hook-up-group-scheduler-with-control-groups.patch
hook-up-group-scheduler-with-control-groups-fix.patch
combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch
add-samples-subdir.patch
i-oat-cleanup-pci-issues.patch
profile-likely-unlikely-macros.patch
