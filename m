From: akpm@linux-foundation.org
Subject: - kernel-doc-strip-c99-comments.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:02:06 -0700
Message-ID: <200707192002.l6JK26C7019626@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50771 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761680AbXGSUQm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     kernel-doc: strip C99 comments
has been removed from the -mm tree.  Its filename was
     kernel-doc-strip-c99-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-acpi.patch
git-alsa.patch
git-mtd.patch
aha152x-in-debug-mode.patch
git-unionfs.patch
git-ipwireless_cs.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
profile-likely-unlikely-macros.patch
