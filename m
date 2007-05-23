From: akpm@linux-foundation.org
Subject: + kernel-doc-fix-unnamed-struct-union-warning.patch added to -mm tree
Date: Wed, 23 May 2007 10:53:36 -0700
Message-ID: <200705231753.l4NHrZlk028510@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46119 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756549AbXEWRxi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2007 13:53:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     kernel-doc: fix unnamed struct/union warning
has been added to the -mm tree.  Its filename is
     kernel-doc-fix-unnamed-struct-union-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel-doc: fix unnamed struct/union warning
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warning:
Warning(linux-2.6.22-rc2-git2/include/linux/skbuff.h:316): No description found for parameter '}'

which is caused by nested anonymous structs/unions ending with:
  };
};

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN scripts/kernel-doc~kernel-doc-fix-unnamed-struct-union-warning scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-fix-unnamed-struct-union-warning
+++ a/scripts/kernel-doc
@@ -154,6 +154,7 @@ use strict;
 
 my $errors = 0;
 my $warnings = 0;
+my $anon_struct_union = 0;
 
 # match expressions used to find embedded type information
 my $type_constant = '\%([-_\w]+)';
@@ -1510,8 +1511,13 @@ sub push_parameter($$$) {
 	my $param = shift;
 	my $type = shift;
 	my $file = shift;
-	my $anon = 0;
 
+	if (($anon_struct_union == 1) && ($type eq "") &&
+	    ($param eq "}")) {
+		return;		# ignore the ending }; from anon. struct/union
+	}
+
+	$anon_struct_union = 0;
 	my $param_name = $param;
 	$param_name =~ s/\[.*//;
 
@@ -1530,16 +1536,16 @@ sub push_parameter($$$) {
 	# handle unnamed (anonymous) union or struct:
 	{
 		$type = $param;
-		$param = "{unnamed_" . $param. "}";
+		$param = "{unnamed_" . $param . "}";
 		$parameterdescs{$param} = "anonymous\n";
-		$anon = 1;
+		$anon_struct_union = 1;
 	}
 
 	# warn if parameter has no description
 	# (but ignore ones starting with # as these are not parameters
 	# but inline preprocessor statements);
 	# also ignore unnamed structs/unions;
-	if (!$anon) {
+	if (!$anon_struct_union) {
 	if (!defined $parameterdescs{$param_name} && $param_name !~ /^#/) {
 
 	    $parameterdescs{$param_name} = $undescribed;
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
