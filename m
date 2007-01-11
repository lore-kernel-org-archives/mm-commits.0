From: akpm@osdl.org
Subject: + kernel-doc-fix-some-odd-spacing-issues.patch added to -mm tree
Date: Wed, 10 Jan 2007 16:54:28 -0800
Message-ID: <200701110054.l0B0sS0q013007@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41877 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965289AbXAKAyc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 19:54:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     kernel-doc: fix some odd spacing issues
has been added to the -mm tree.  Its filename is
     kernel-doc-fix-some-odd-spacing-issues.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 scripts/kernel-doc |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

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

git-alsa.patch
qconf-immediately-update-integer-and-string-values-in-xconfig-display-take-2.patch
git-mtd.patch
parisc-fix-module_param-iommu-permission.patch
git-scsi-rc-fixes.patch
megaraid-fix-kernel-doc.patch
math-emu-setcc-avoid-gcc-extension.patch
kernel-doc-allow-a-little-whitespace.patch
sysrq-showblockedtasks-is-sysrq-w.patch
sysrq-alphabetize-command-keys-doc.patch
kernel-doc-allow-more-whitespace.patch
discuss-a-couple-common-errors-in-kernel-doc-usage.patch
megaraid-more-kernel-doc-fixes.patch
docbook-add-edd-firmware-interfaces.patch
kernel-doc-fix-some-odd-spacing-issues.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
