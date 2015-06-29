From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-make-types-found-in-a-source-file-patch-local.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:48:32 -0700
Message-ID: <5591af20.uCqUb3SWbkrcMIsJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50952 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbbF2Usd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:48:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexinbeijing@gmail.com, apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: make types found in a source file/patch local
has been removed from the -mm tree.  Its filename was
     checkpatch-make-types-found-in-a-source-file-patch-local.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Dowad <alexinbeijing@gmail.com>
Subject: checkpatch: make types found in a source file/patch local

checkpatch uses various cues in its input patches and files to discover
the names of user-defined types and modifiers.  It then uses that
information when processing expressions to discover potential style
issues.

Unfortunately, in rare cases, this means that checkpatch may give
different results if you run it on several input files in one execution,
or one by one!

The reason is that it may identify a type (or something that looks like a
type) in one file, and then carry this information over when processing a
different file.

For example, drivers/staging/media/bcm2048/radio-bcm2048.c contains this
line (in a macro):

	size value;

and drivers/staging/media/davinci_vpfe/vpfe_video.c has this line:

	while (size * *nbuffers > vpfe_dev->video_limit)

If checkpatch processes these 2 files in a single command like:
	./scripts/checkpatch.pl -f $file1 $file2
the (spurious) "size" type detected in the first file will cause it to flag
the second file for improper use of the pointer dereference operator.

To fix this, store types and modifiers found in a file in separate arrays
from built-in ones, and reset the arrays of types and modifiers found in
files at the beginning of each new source file.

Signed-off-by: Alex Dowad <alexinbeijing@gmail.com>
Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-make-types-found-in-a-source-file-patch-local scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-make-types-found-in-a-source-file-patch-local
+++ a/scripts/checkpatch.pl
@@ -423,6 +423,7 @@ our @typeList = (
 	qr{${Ident}_handler_fn},
 	@typeListMisordered,
 );
+our @typeListFile = ();
 our @typeListWithAttr = (
 	@typeList,
 	qr{struct\s+$InitAttribute\s+$Ident},
@@ -432,6 +433,7 @@ our @typeListWithAttr = (
 our @modifierList = (
 	qr{fastcall},
 );
+our @modifierListFile = ();
 
 our @mode_permission_funcs = (
 	["module_param", 3],
@@ -515,8 +517,8 @@ if ($codespell) {
 $misspellings = join("|", sort keys %spelling_fix) if keys %spelling_fix;
 
 sub build_types {
-	my $mods = "(?x:  \n" . join("|\n  ", @modifierList) . "\n)";
-	my $all = "(?x:  \n" . join("|\n  ", @typeList) . "\n)";
+	my $mods = "(?x:  \n" . join("|\n  ", (@modifierList, @modifierListFile)) . "\n)";
+	my $all = "(?x:  \n" . join("|\n  ", (@typeList, @typeListFile)) . "\n)";
 	my $Misordered = "(?x:  \n" . join("|\n  ", @typeListMisordered) . "\n)";
 	my $allWithAttr = "(?x:  \n" . join("|\n  ", @typeListWithAttr) . "\n)";
 	$Modifier	= qr{(?:$Attribute|$Sparse|$mods)};
@@ -748,6 +750,9 @@ for my $filename (@ARGV) {
 	@fixed_inserted = ();
 	@fixed_deleted = ();
 	$fixlinenr = -1;
+	@modifierListFile = ();
+	@typeListFile = ();
+	build_types();
 }
 
 exit($exit);
@@ -1612,13 +1617,13 @@ sub possible {
 			for my $modifier (split(' ', $possible)) {
 				if ($modifier !~ $notPermitted) {
 					warn "MODIFIER: $modifier ($possible) ($line)\n" if ($dbg_possible);
-					push(@modifierList, $modifier);
+					push(@modifierListFile, $modifier);
 				}
 			}
 
 		} else {
 			warn "POSSIBLE: $possible ($line)\n" if ($dbg_possible);
-			push(@typeList, $possible);
+			push(@typeListFile, $possible);
 		}
 		build_types();
 	} else {
_

Patches currently in -mm which might be from alexinbeijing@gmail.com are

origin.patch

