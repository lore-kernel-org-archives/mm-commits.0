From: akpm@linux-foundation.org
Subject: + kernel-doc-process-functions-not-doc.patch added to -mm tree
Date: Wed, 24 Oct 2007 21:18:30 -0700
Message-ID: <200710250418.l9P4IUV8031382@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43458 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752666AbXJYETQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Oct 2007 00:19:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johannes@sipsolutions.net, randy.dunlap@oracle.com, rpjday@mindspring.com, sam@ravnborg.org


The patch titled
     kernel-doc: process functions, not DOC:
has been added to the -mm tree.  Its filename is
     kernel-doc-process-functions-not-doc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel-doc: process functions, not DOC:
From: Johannes Berg <johannes@sipsolutions.net>

This flag is necessary for the next patch for docproc to output only the
functions and not DOC: sections when a function list is requested.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN scripts/kernel-doc~kernel-doc-process-functions-not-doc scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-process-functions-not-doc
+++ a/scripts/kernel-doc
@@ -46,13 +46,16 @@ use strict;
 # Note: This only supports 'c'.
 
 # usage:
-# kernel-doc [ -docbook | -html | -text | -man ]
+# kernel-doc [ -docbook | -html | -text | -man ] [ -no-doc-sections ]
 #           [ -function funcname [ -function funcname ...] ] c file(s)s > outputfile
 # or
 #           [ -nofunction funcname [ -function funcname ...] ] c file(s)s > outputfile
 #
 #  Set output format using one of -docbook -html -text or -man.  Default is man.
 #
+#  -no-doc-sections
+#	Do not output DOC: sections
+#
 #  -function funcname
 #	If set, then only generate documentation for the given function(s) or
 #	DOC: section titles.  All other functions and DOC: sections are ignored.
@@ -211,7 +214,7 @@ my $blankline_text = "";
 
 
 sub usage {
-    print "Usage: $0 [ -v ] [ -docbook | -html | -text | -man ]\n";
+    print "Usage: $0 [ -v ] [ -docbook | -html | -text | -man ] [ -no-doc-sections ]\n";
     print "         [ -function funcname [ -function funcname ...] ]\n";
     print "         [ -nofunction funcname [ -nofunction funcname ...] ]\n";
     print "         c source file(s) > outputfile\n";
@@ -225,6 +228,7 @@ if ($#ARGV==-1) {
 
 my $verbose = 0;
 my $output_mode = "man";
+my $no_doc_sections = 0;
 my %highlights = %highlights_man;
 my $blankline = $blankline_man;
 my $modulename = "Kernel API";
@@ -329,6 +333,8 @@ while ($ARGV[0] =~ m/^-(.*)/) {
 	usage();
     } elsif ($cmd eq '-filelist') {
 	    $filelist = shift @ARGV;
+    } elsif ($cmd eq '-no-doc-sections') {
+	    $no_doc_sections = 1;
     }
 }
 
@@ -380,6 +386,10 @@ sub dump_doc_section {
     my $name = shift;
     my $contents = join "\n", @_;
 
+    if ($no_doc_sections) {
+	return;
+    }
+
     if (($function_only == 0) ||
 	( $function_only == 1 && defined($function_table{$name})) ||
 	( $function_only == 2 && !defined($function_table{$name})))
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
