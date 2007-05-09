From: akpm@linux-foundation.org
Subject: - kernel-doc-html-mode-struct-highlights.patch removed from -mm tree
Date: Tue, 08 May 2007 19:49:58 -0700
Message-ID: <200705090249.l492nwPB009288@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969994AbXEICuv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:50:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, johannes@sipsolutions.net, mm-commits@vger.kernel.org


The patch titled
     kernel-doc: html mode struct highlights
has been removed from the -mm tree.  Its filename was
     kernel-doc-html-mode-struct-highlights.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 15 insertions(+), 6 deletions(-)

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

origin.patch
krealloc-fix-kerneldoc-comments.patch
git-acpi.patch
git-ieee1394.patch
romfs-printk-format-warnings.patch
add-pci_try_set_mwi.patch
git-unionfs.patch
git-ipwireless_cs.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-doc-fix.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
lib-hexdump.patch
lib-hexdump-fix.patch
lib-hexdump-update-on-feedback.patch
doc-what-a-patch-series-is.patch
kernel-doc-small-kernel-doc-optimization.patch
profile-likely-unlikely-macros.patch
