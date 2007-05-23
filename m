From: akpm@linux-foundation.org
Subject: + kernel-doc-strip-c99-comments.patch added to -mm tree
Date: Wed, 23 May 2007 10:53:38 -0700
Message-ID: <200705231753.l4NHrbPN028513@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57455 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758065AbXEWRxk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2007 13:53:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     kernel-doc: strip C99 comments
has been added to the -mm tree.  Its filename is
     kernel-doc-strip-c99-comments.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel-doc: strip C99 comments
From: Randy Dunlap <randy.dunlap@oracle.com>

Strip C99-style comments from the input stream.
/*...*/ comments are already stripped.
C99 comments confuse the kernel-doc script.

Also update some comments.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN scripts/kernel-doc~kernel-doc-strip-c99-comments scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-strip-c99-comments
+++ a/scripts/kernel-doc
@@ -719,6 +719,7 @@ sub output_struct_xml(%) {
 	    # pointer-to-function
 	    print "  $1 $parameter) ($2);\n";
 	} elsif ($type =~ m/^(.*?)\s*(:.*)/) {
+	    # bitfield
 	    print "  $1 $parameter$2;\n";
 	} else {
 	    print "  ".$type." ".$parameter.";\n";
@@ -1261,6 +1262,7 @@ sub output_struct_text(%) {
 	    # pointer-to-function
 	    print "\t$1 $parameter) ($2);\n";
 	} elsif ($type =~ m/^(.*?)\s*(:.*)/) {
+	    # bitfield
 	    print "\t$1 $parameter$2;\n";
 	} else {
 	    print "\t".$type." ".$parameter.";\n";
@@ -1697,6 +1699,8 @@ sub process_state3_function($$) {
     my $x = shift;
     my $file = shift;
 
+    $x =~ s@\/\/.*$@@gos; # strip C99-style comments to end of line
+
     if ($x =~ m#\s*/\*\s+MACDOC\s*#io || ($x =~ /^#/ && $x !~ /^#define/)) {
 	# do nothing
     }
@@ -1719,6 +1723,8 @@ sub process_state3_type($$) {
     $x =~ s@[\r\n]+@ @gos; # strip newlines/cr's.
     $x =~ s@^\s+@@gos; # strip leading spaces
     $x =~ s@\s+$@@gos; # strip trailing spaces
+    $x =~ s@\/\/.*$@@gos; # strip C99-style comments to end of line
+
     if ($x =~ /^#/) {
 	# To distinguish preprocessor directive from regular declaration later.
 	$x .= ";";
@@ -1802,7 +1808,7 @@ sub process_file($) {
 
 		$state = 2;
 		if (/-(.*)/) {
-		    # strip leading/trailing/multiple spaces #RDD:T:
+		    # strip leading/trailing/multiple spaces
 		    $descr= $1;
 		    $descr =~ s/^\s*//;
 		    $descr =~ s/\s*$//;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
romfs-printk-format-warnings.patch
add-pci_try_set_mwi.patch
git-unionfs.patch
add-pci_try_set_mwi-prism54pci.patch
git-ipwireless_cs.patch
documentation-fix-the-explanation-of-kconfig-files.patch
update-dontdiff-file.patch
doc-clocksources.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
add-notime-boot-option.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
profile-likely-unlikely-macros.patch
