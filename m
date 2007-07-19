From: akpm@linux-foundation.org
Subject: - kernel-doc-fix-unnamed-struct-union-warning.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:02:04 -0700
Message-ID: <200707192002.l6JK24Cm019623@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39261 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761685AbXGSUQm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     kernel-doc: fix unnamed struct/union warning
has been removed from the -mm tree.  Its filename was
     kernel-doc-fix-unnamed-struct-union-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-acpi.patch
git-alsa.patch
git-mtd.patch
aha152x-in-debug-mode.patch
git-unionfs.patch
git-ipwireless_cs.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
profile-likely-unlikely-macros.patch
