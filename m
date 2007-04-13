From: akpm@linux-foundation.org
Subject: + kernel-doc-html-mode-struct-highlights.patch added to -mm tree
Date: Fri, 13 Apr 2007 11:43:04 -0700
Message-ID: <200704131843.l3DIh4Oj006654@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45665 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132AbXDMSng (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 14:43:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, johannes@sipsolutions.net


The patch titled
     kernel-doc: html mode struct highlights
has been added to the -mm tree.  Its filename is
     kernel-doc-html-mode-struct-highlights.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel-doc: html mode struct highlights
From: Randy Dunlap <randy.dunlap@oracle.com>

Johannes Berg reported that struct names are not highlighted
(bold, italic, etc.) in html kernel-doc output.  (Also not in
text-mode output, but I don't see that changing.)

This patch adds the following:
- highlight struct names in html output mode
- highlight environment var. names in html output mode
- indent struct fields in the original struct layout

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff -puN scripts/kernel-doc~kernel-doc-html-mode-struct-highlights scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-html-mode-struct-highlights
+++ a/scripts/kernel-doc
@@ -159,7 +159,8 @@ my $warnings = 0;
 my $type_constant = '\%([-_\w]+)';
 my $type_func = '(\w+)\(\)';
 my $type_param = '\@(\w+)';
-my $type_struct = '\&((struct\s*)?[_\w]+)';
+my $type_struct = '\&((struct\s*)*[_\w]+)';
+my $type_struct_xml = '\\\amp;((struct\s*)*[_\w]+)';
 my $type_env = '(\$\w+)';
 
 # Output conversion substitutions.
@@ -168,7 +169,8 @@ my $type_env = '(\$\w+)';
 # these work fairly well
 my %highlights_html = ( $type_constant, "<i>\$1</i>",
 			$type_func, "<b>\$1</b>",
-			$type_struct, "<i>\$1</i>",
+			$type_struct_xml, "<i>\$1</i>",
+			$type_env, "<b><i>\$1</i></b>",
 			$type_param, "<tt><b>\$1</b></tt>" );
 my $blankline_html = "<p>";
 
@@ -331,7 +333,7 @@ while ($ARGV[0] =~ m/^-(.*)/) {
 # using the s// operator.
 my $dohighlight = "";
 foreach my $pattern (keys %highlights) {
-#    print "scanning pattern $pattern ($highlights{$pattern})\n";
+#   print STDERR "scanning pattern:$pattern, highlight:($highlights{$pattern})\n";
     $dohighlight .=  "\$contents =~ s:$pattern:$highlights{$pattern}:gs;\n";
 }
 
@@ -378,8 +380,14 @@ sub output_highlight {
 #	confess "output_highlight got called with no args?\n";
 #   }
 
+#   print STDERR "contents b4:$contents\n";
     eval $dohighlight;
     die $@ if $@;
+    if ($output_mode eq "html") {
+	$contents =~ s/\\\\//;
+    }
+#   print STDERR "contents af:$contents\n";
+
     foreach $line (split "\n", $contents) {
 	if ($line eq ""){
 	    print $lineprefix, $blankline;
@@ -466,11 +474,12 @@ sub output_struct_html(%) {
 	$type = $args{'parametertypes'}{$parameter};
 	if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
 	    # pointer-to-function
-	    print " <i>$1</i><b>$parameter</b>) <i>($2)</i>;<br>\n";
+	    print "&nbsp; &nbsp; <i>$1</i><b>$parameter</b>) <i>($2)</i>;<br>\n";
 	} elsif ($type =~ m/^(.*?)\s*(:.*)/) {
-	    print " <i>$1</i> <b>$parameter</b>$2;<br>\n";
+	    # bitfield
+	    print "&nbsp; &nbsp; <i>$1</i> <b>$parameter</b>$2;<br>\n";
 	} else {
-	    print " <i>$type</i> <b>$parameter</b>;<br>\n";
+	    print "&nbsp; &nbsp; <i>$type</i> <b>$parameter</b>;<br>\n";
 	}
     }
     print "};<br>\n";
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

fix-kernel-oops-with-badly-formatted-module-option.patch
git-acpi.patch
git-drm.patch
git-ieee1394.patch
romfs-printk-format-warnings.patch
git-netdev-all.patch
8250_pci-fix-pci-must_checks.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
fix-mtrr-sections.patch
scripts-kernel-doc-whitespace-cleanup.patch
reiserfs-proc-support-requires-proc_fs.patch
kprobes-fix-sparse-null-warning.patch
header-cleaning-dont-include-smp_lockh-when-not-used.patch
expose-range-checking-functions-from-arch-specific.patch
parport_serial-fix-pci-must_checks.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
kernel-doc-handle-arrays-with-arithmetic-expressions-as.patch
generate-main-index-page-when-building-htmldocs.patch
alphabetically-sorted-entries-in.patch
kernel-doc-html-mode-struct-highlights.patch
ext4-use-null-for-pointers.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
s3fb-fix-pci-must_checks.patch
profile-likely-unlikely-macros.patch
