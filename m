From: akpm@linux-foundation.org
Subject: - kernel-doc-fix-some-odd-spacing-issues.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:53:58 -0800
Message-ID: <200702112253.l1BMrwJm016158@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60442 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932848AbXBKWyK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:54:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     kernel-doc: fix some odd spacing issues
has been removed from the -mm tree.  Its filename was
     kernel-doc-fix-some-odd-spacing-issues.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kernel-doc: fix some odd spacing issues
From: Randy Dunlap <randy.dunlap@oracle.com>

- in man and text mode output, if the function return type is empty (like it
  is for macros), don't print the return type and a following space; this
  fixes an output malalignment;

- in the function short description, strip leading, trailing, and multiple
  embedded spaces (to one space); this makes function name/description output
  spacing consistent;

- fix a comment typo;

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff -puN scripts/kernel-doc~kernel-doc-fix-some-odd-spacing-issues scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-fix-some-odd-spacing-issues
+++ a/scripts/kernel-doc
@@ -365,7 +365,7 @@ sub dump_section {
 #  parameterlist => @list of parameters
 #  parameterdescs => %parameter descriptions
 #  sectionlist => @list of sections
-#  sections => %descriont descriptions
+#  sections => %section descriptions
 #
 
 sub output_highlight {
@@ -953,7 +953,11 @@ sub output_function_man(%) {
     print $args{'function'}." \\- ".$args{'purpose'}."\n";
 
     print ".SH SYNOPSIS\n";
-    print ".B \"".$args{'functiontype'}."\" ".$args{'function'}."\n";
+    if ($args{'functiontype'} ne "") {
+	print ".B \"".$args{'functiontype'}."\" ".$args{'function'}."\n";
+    } else {
+	print ".B \"".$args{'function'}."\n";
+    }
     $count = 0;
     my $parenth = "(";
     my $post = ",";
@@ -1118,13 +1122,19 @@ sub output_intro_man(%) {
 sub output_function_text(%) {
     my %args = %{$_[0]};
     my ($parameter, $section);
+    my $start;
 
     print "Name:\n\n";
     print $args{'function'}." - ".$args{'purpose'}."\n";
 
     print "\nSynopsis:\n\n";
-    my $start=$args{'functiontype'}." ".$args{'function'}." (";
+    if ($args{'functiontype'} ne "") {
+	$start = $args{'functiontype'}." ".$args{'function'}." (";
+    } else {
+	$start = $args{'function'}." (";
+    }
     print $start;
+
     my $count = 0;
     foreach my $parameter (@{$args{'parameterlist'}}) {
 	$type = $args{'parametertypes'}{$parameter};
@@ -1710,6 +1720,7 @@ sub process_file($) {
     my $file;
     my $identifier;
     my $func;
+    my $descr;
     my $initial_section_counter = $section_counter;
 
     if (defined($ENV{'SRCTREE'})) {
@@ -1753,7 +1764,12 @@ sub process_file($) {
 
 		$state = 2;
 		if (/-(.*)/) {
-		    $declaration_purpose = xml_escape($1);
+		    # strip leading/trailing/multiple spaces #RDD:T:
+		    $descr= $1;
+		    $descr =~ s/^\s*//;
+		    $descr =~ s/\s*$//;
+		    $descr =~ s/\s+/ /;
+		    $declaration_purpose = xml_escape($descr);
 		} else {
 		    $declaration_purpose = "";
 		}
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-drm.patch
qconf-immediately-update-integer-and-string-values-in-xconfig-display-take-2.patch
git-mtd.patch
git-netdev-all.patch
phy-layer-add-kernel-doc-docbook.patch
parisc-fix-module_param-iommu-permission.patch
ueagle-atmc-needs-schedh.patch
com20020-build-fix.patch
drivers-telephony-ixj-convert-to-generic-boolean.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
