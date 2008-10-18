From: akpm@linux-foundation.org
Subject: - checkpatch-do-is-not-a-possible-type.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:13:56 -0700
Message-ID: <200810182313.m9INDuWu028294@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51329 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751479AbYJRXOE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:14:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: do is not a possible type
has been removed from the -mm tree.  Its filename was
     checkpatch-do-is-not-a-possible-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: do is not a possible type
From: Andy Whitcroft <apw@shadowen.org>

A do without braces '{' may trigger a false possible type 'do' and then
this may be interpreted as an external definition of foo():

	do
		foo();
	while (bar);

Add do to the type exclusions.  Fix up tests so we can check for them.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-do-is-not-a-possible-type scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-do-is-not-a-possible-type
+++ a/scripts/checkpatch.pl
@@ -913,12 +913,22 @@ sub annotate_values {
 sub possible {
 	my ($possible, $line) = @_;
 
-	print "CHECK<$possible> ($line)\n" if ($dbg_possible > 1);
-	if ($possible !~ /^(?:$Modifier|$Storage|$Type|DEFINE_\S+)$/ &&
-	    $possible ne 'goto' && $possible ne 'return' &&
-	    $possible ne 'case' && $possible ne 'else' &&
-	    $possible ne 'asm' && $possible ne '__asm__' &&
-	    $possible !~ /^(typedef|struct|enum)\b/) {
+	print "CHECK<$possible> ($line)\n" if ($dbg_possible > 2);
+	if ($possible !~ /(?:
+		^(?:
+			$Modifier|
+			$Storage|
+			$Type|
+			DEFINE_\S+|
+			goto|
+			return|
+			case|
+			else|
+			asm|__asm__|
+			do
+		)$|
+		^(?:typedef|struct|enum)\b
+	    )/x) {
 		# Check for modifiers.
 		$possible =~ s/\s*$Storage\s*//g;
 		$possible =~ s/\s*$Sparse\s*//g;
@@ -936,6 +946,8 @@ sub possible {
 			push(@typeList, $possible);
 		}
 		build_types();
+	} else {
+		warn "NOTPOSS: $possible ($line)\n" if ($dbg_possible > 1);
 	}
 }
 
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch

